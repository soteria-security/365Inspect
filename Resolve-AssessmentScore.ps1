# SOTERIA-VERIFIED: Core PowerShell only (Where-Object, Sort-Object, [math]::Min/Round, hashtables,
# ConvertTo-Json/ConvertFrom-Json, Get-Content/Out-File). No Az/Graph/Exchange/Teams/SharePoint/PnP
# cmdlets. No Invoke-Expression or runtime evaluation of JSON-sourced strings.
#
# Assessment scoring engine: severity-weighted pass-rate model.
#
#   Score = 100 x (1 - deducted / possible)
#
#   possible = SUM weight(Impact) over scored inspectors
#              (scored = executed successfully; errored/skipped are excluded and disclosed)
#   deducted = SUM weight(runtime RiskRating) per finding, grouped by inspector,
#              capped at that inspector's possible points
#
# Weights are published in the report methodology note; every point of deduction traces to a
# specific finding. Review Required and Informational carry weight 0 (not confirmed failures);
# their inspectors stay in the denominator as passes and Review Required items are surfaced via a
# separate pending_review count. Remediated findings (retest re-injections) never deduct; they
# explain the score delta. A finding whose RiskRating is blank (inspector never resolved an
# outcome) falls back to its static Impact.
#
# Dot-sourced like Write-ErrorLog.ps1:
#   . "$PSScriptRoot\Resolve-AssessmentScore.ps1"

$script:ScoreWeights = [ordered]@{
    'Critical'        = 10.0
    'High'            = 7.5
    'Medium'          = 5.0
    'Low'             = 2.5
    'Informational'   = 0.0
    'Review Required' = 0.0
}

# Descending; the first band whose min is <= the score wins.
$script:ScoreBands = @(
    [pscustomobject]@{ min = 90; label = 'Strong' }
    [pscustomobject]@{ min = 75; label = 'Moderate' }
    [pscustomobject]@{ min = 50; label = 'Elevated risk' }
    [pscustomobject]@{ min = 0;  label = 'High risk' }
)

function Get-ScoreWeight([string]$Rating) {
    $key = "$Rating".Trim()
    if ($key -and $script:ScoreWeights.Contains($key)) { return [double]$script:ScoreWeights[$key] }
    return 0.0
}

function Get-ScoreBand([double]$Score) {
    foreach ($band in $script:ScoreBands) {
        if ($Score -ge $band.min) { return $band.label }
    }
    return $script:ScoreBands[-1].label
}

function Get-FirstServiceToken([string]$Service) {
    # Multi-service inspectors carry a comma-joined Service string; sub-scores attribute the
    # inspector to its first-listed service.
    $token = ("$Service" -split ',')[0].Trim()
    if ($token) { return $token }
    return 'Unassigned'
}

function Get-AssessmentScore {
    # Pure computation: no I/O. $InspectorRuns elements:
    #   [pscustomobject]@{ Inspector; Impact; Service; Result = 'Finding'|'Clean'|'Error'|'Skipped' }
    # $Findings are the retest-annotated findings (Status, RiskRating, Impact, InspectorScript).
    # $PreviousEntry is the last score-history entry, or $null on a first run.
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]] $InspectorRuns,
        [AllowEmptyCollection()][object[]] $Findings = @(),
        $PreviousEntry = $null
    )

    $scored = @($InspectorRuns | Where-Object { $_.Result -in @('Finding', 'Clean') })
    $errored = @($InspectorRuns | Where-Object { $_.Result -in @('Error', 'Skipped') })

    $scoredByName = @{}
    foreach ($run in $scored) { $scoredByName[$run.Inspector] = $run }

    $possible = 0.0
    foreach ($run in $scored) { $possible += Get-ScoreWeight $run.Impact }

    # Active findings deduct; Remediated re-injections only explain the delta.
    $active = @($Findings | Where-Object { $_ -and "$($_.Status)" -ne 'Remediated' })

    $pendingReview = 0
    $escalated = 0
    $licenseGated = 0
    $rawDeductions = @{}
    foreach ($f in $active) {
        # License-gated findings (tenant cannot configure the control without additional
        # licensing) are treated as Informational: no deduction, no escalation, no pending-review
        # count; they are disclosed separately via license_gated.
        if (($f.PSObject.Properties.Name -contains 'LicenseGated') -and $f.LicenseGated) {
            $licenseGated++
            continue
        }
        $rating = "$($f.RiskRating)".Trim()
        if (-not $rating) { $rating = "$($f.Impact)".Trim() }
        if ($rating -eq 'Review Required') { $pendingReview++ }

        # A finding can only deduct from an inspector inside the denominator.
        $name = "$($f.InspectorScript)"
        if (-not $scoredByName.ContainsKey($name)) { continue }
        # Contextual escalation: the assessed rating outweighs the inspector's static Impact.
        # Disclosed in the methodology note because the cap below flattens it.
        if ((Get-ScoreWeight $rating) -gt (Get-ScoreWeight $scoredByName[$name].Impact)) { $escalated++ }
        if (-not $rawDeductions.ContainsKey($name)) { $rawDeductions[$name] = 0.0 }
        $rawDeductions[$name] += Get-ScoreWeight $rating
    }

    # Cap each inspector's deduction at its own possible points; handles both an inspector that
    # emits multiple findings and an outcome RiskRating that exceeds the static Impact. The points
    # the cap removes are tracked and disclosed rather than silently dropped.
    $deducted = 0.0
    $withheld = 0.0
    $deductedByInspector = @{}
    foreach ($name in @($rawDeductions.Keys)) {
        $cap = Get-ScoreWeight $scoredByName[$name].Impact
        $d = [math]::Min($rawDeductions[$name], $cap)
        $deductedByInspector[$name] = $d
        $deducted += $d
        $withheld += ($rawDeductions[$name] - $d)
    }

    $overall = if ($possible -gt 0) { [math]::Round(100 * (1 - $deducted / $possible), 1) } else { 100.0 }

    # Per-service sub-scores: same formula filtered by the inspector's first-listed service.
    $buckets = @{}
    foreach ($run in $scored) {
        $svc = Get-FirstServiceToken $run.Service
        if (-not $buckets.ContainsKey($svc)) {
            $buckets[$svc] = @{ possible = 0.0; deducted = 0.0; inspectors = 0; findings = 0 }
        }
        $b = $buckets[$svc]
        $b.possible += Get-ScoreWeight $run.Impact
        $b.inspectors++
        if ($deductedByInspector.ContainsKey($run.Inspector)) { $b.deducted += $deductedByInspector[$run.Inspector] }
    }
    foreach ($f in $active) {
        $name = "$($f.InspectorScript)"
        if (-not $scoredByName.ContainsKey($name)) { continue }
        $buckets[(Get-FirstServiceToken $scoredByName[$name].Service)].findings++
    }
    $perService = @(foreach ($svc in $buckets.Keys) {
            $b = $buckets[$svc]
            $s = if ($b.possible -gt 0) { [math]::Round(100 * (1 - $b.deducted / $b.possible), 1) } else { 100.0 }
            [pscustomobject][ordered]@{
                service    = $svc
                score      = $s
                band       = Get-ScoreBand $s
                possible   = $b.possible
                deducted   = $b.deducted
                inspectors = $b.inspectors
                findings   = $b.findings
            }
        })
    $perService = @($perService | Sort-Object score, service)

    # Change counts over ALL findings: these decompose the delta for the report.
    $resolved = @($Findings | Where-Object { "$($_.Status)" -eq 'Remediated' }).Count
    $new = @($Findings | Where-Object { "$($_.Status)" -eq 'New' }).Count
    $changed = @($Findings | Where-Object { "$($_.Status)" -eq 'Modified' }).Count

    $previous = $null
    if ($null -ne $PreviousEntry -and ($PreviousEntry.PSObject.Properties.Name -contains 'overall') -and $null -ne $PreviousEntry.overall) {
        $prevOverall = $null
        try { $prevOverall = [double]$PreviousEntry.overall } catch { $prevOverall = $null }
        if ($null -ne $prevOverall) {
            $prevScoredCount = $null
            if ($PreviousEntry.PSObject.Properties.Name -contains 'scored_inspectors') { $prevScoredCount = $PreviousEntry.scored_inspectors }
            $previous = [pscustomobject][ordered]@{
                timestamp         = "$($PreviousEntry.timestamp)"
                overall           = $prevOverall
                delta             = [math]::Round($overall - $prevOverall, 1)
                resolved          = $resolved
                new               = $new
                changed           = $changed
                scored_inspectors = $prevScoredCount
            }
        }
    }

    return [pscustomobject][ordered]@{
        overall            = $overall
        band               = Get-ScoreBand $overall
        possible           = $possible
        deducted           = $deducted
        scored_inspectors  = $scored.Count
        errored_inspectors = @($errored | ForEach-Object { "$($_.Inspector)" })
        pending_review     = $pendingReview
        escalated_findings = $escalated
        withheld_points    = $withheld
        license_gated      = $licenseGated
        per_service        = $perService
        weights            = $script:ScoreWeights
        bands              = $script:ScoreBands
        previous           = $previous
    }
}
