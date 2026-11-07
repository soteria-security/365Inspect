<#
Validates that bulleted and numbered lists inside the rendered Description,
Remediation, and User Impact fields will render correctly in the Soteria-branded
HTML report.

Run from the repo root:
    .\Validate-ReportListRendering.ps1

To also assert against a generated report rather than only the template:
    .\Validate-ReportListRendering.ps1 -ReportPath "Mock Reports\run\Report_Soteria_Mock_x.html"

WHY THIS EXISTS

Two rules in the branded template work against lists and both have to be
countered, so a regression in either one silently breaks list rendering:

  * The global reset `* { margin: 0; padding: 0 }` zeroes list padding, which
    puts the marker at the left margin with no indent. This was the live cause
    of the reported symptom.
  * `.detail-text { white-space: pre-wrap }` preserves authored newlines so
    plain-text descriptions keep their paragraph breaks. Inside a list that
    would also render the newlines between <li> tags as real line breaks, on
    top of each item's own block break, producing a blank line between items.
    Measured 2026-09-08 on a full mock run: 14 extra breaks between consecutive
    items and 39 before a first item, from 7 finding files that author lists
    across newlines. This half is active, not theoretical.

Both are load-bearing for non-list content, so neither may be changed. The
`.detail-text ul/ol/li` block overrides them for list elements only, and must sit
AFTER the container rule so it wins on source order as well as specificity.
#>
[CmdletBinding()]
param(
    [string] $Root = $PSScriptRoot,
    [string] $ReportPath,
    [switch] $Quiet
)

$ErrorActionPreference = 'Stop'
$failures = New-Object System.Collections.Generic.List[string]
$checks = 0

function Test-Assertion {
    param([string] $Name, [bool] $Condition, [string] $Detail = '')
    $script:checks++
    if ($Condition) {
        if (-not $Quiet) { Write-Host ("  PASS  {0}" -f $Name) -ForegroundColor DarkGreen }
    }
    else {
        $msg = if ($Detail) { "{0} :: {1}" -f $Name, $Detail } else { $Name }
        $script:failures.Add($msg)
        Write-Host ("  FAIL  {0}" -f $msg) -ForegroundColor Red
    }
}

# Every template the tool can render with. Add to this list rather than creating a
# second checker if a new branded template appears.
$templates = @(Get-ChildItem -Path $Root -Filter '*SoteriaTemplate.html' -File -ErrorAction SilentlyContinue)
$nested = Join-Path $Root 'dotnet\ADInspect\Resources\templates'
if (Test-Path $nested) {
    $templates += @(Get-ChildItem -Path $nested -Filter '*SoteriaTemplate.html' -File)
}
$nested2 = Join-Path $Root 'analyzer\templates'
if (Test-Path $nested2) {
    $templates += @(Get-ChildItem -Path $nested2 -Filter '*SoteriaTemplate.html' -File)
}

if (-not $templates) {
    Write-Host 'No *SoteriaTemplate.html found; nothing to validate.' -ForegroundColor Yellow
    exit 0
}

$targets = @()
foreach ($t in $templates) { $targets += [pscustomobject]@{ Label = $t.Name; Path = $t.FullName; Kind = 'template' } }
if ($ReportPath) {
    $rp = if ([System.IO.Path]::IsPathRooted($ReportPath)) { $ReportPath } else { Join-Path $Root $ReportPath }
    if (-not (Test-Path $rp)) { throw "Report not found: $rp" }
    $targets += [pscustomobject]@{ Label = (Split-Path $rp -Leaf); Path = $rp; Kind = 'generated report' }
}

foreach ($tgt in $targets) {
    Write-Host ("{0} [{1}]" -f $tgt.Label, $tgt.Kind) -ForegroundColor Cyan
    $s = Get-Content -Path $tgt.Path -Raw

    $containerIdx = $s.IndexOf('.detail-text {')
    $listIdx      = $s.IndexOf('.detail-text ul,')

    # 1. the scoped list rule is present
    Test-Assertion 'scoped list rule .detail-text ul/ol is present' ($listIdx -ge 0)

    # 2. it appears after the container rule, so it wins on source order too
    Test-Assertion 'list rule appears AFTER the .detail-text container rule' `
        (($listIdx -gt $containerIdx) -and ($containerIdx -ge 0)) `
        ("container@{0} list@{1}" -f $containerIdx, $listIdx)

    # 3. the container still sets its original white-space, so paragraph rendering
    #    of non-list content is unchanged. This is the regression guard against
    #    someone "fixing" spacing by removing pre-wrap.
    Test-Assertion 'container still sets white-space: pre-wrap (not widened or removed)' `
        ($s -match '\.detail-text\s*\{[^}]*white-space:\s*pre-wrap')

    # 4. the list rule resets white-space for list elements only
    Test-Assertion 'list rule sets white-space: normal on ul/ol only' `
        ($s -match '\.detail-text\s+ol\s*\{[^}]*white-space:\s*normal')

    # 5. padding-left is restored, which is what the global reset removed
    Test-Assertion 'list rule restores padding-left (counters the global reset)' `
        ($s -match '\.detail-text\s+ol\s*\{[^}]*padding-left')

    # 6. the global reset is still present and has not been narrowed to "fix" lists
    Test-Assertion 'global reset still present (fix did not widen or remove it)' `
        ($s -match '\*\s*\{[^}]*padding:\s*0')

    # 7. tight, deliberate item spacing rather than the reset's zero
    Test-Assertion 'li carries an explicit margin-bottom' `
        ($s -match '\.detail-text\s+li\s*\{[^}]*margin-bottom')

    # 8. paragraph-wrapped item bodies are neutralised
    Test-Assertion 'li > p margin is neutralised' ($s.IndexOf('.detail-text li > p') -ge 0)

    # 9. headings inside the field must not be smaller than the body text.
    #    ConvertFrom-FindingMarkdown maps a markdown heading to h(level + 2), so ###
    #    arrives as h5 and #### as h6. Unstyled, those inherit browser defaults of
    #    0.83em and 0.67em, which renders a step title smaller than its own paragraph.
    Test-Assertion 'headings inside .detail-text are styled (h3 through h6)' `
        (($s.IndexOf('.detail-text h6') -ge 0) -and ($s.IndexOf('.detail-text h3') -ge 0))
    Test-Assertion 'h6 carries an explicit font-size (browser default is smaller than body)' `
        ($s -match '\.detail-text\s+h6\s*\{[^}]*font-size')
    Test-Assertion 'heading rules appear AFTER the .detail-text container rule' `
        (($s.IndexOf('.detail-text h6') -gt $containerIdx) -and ($containerIdx -ge 0))

    # 9. no later competing list rule reintroduces the problem
    if ($listIdx -ge 0) {
        $blockEnd = $s.IndexOf('list-style-type: decimal', $listIdx)
        $tail = if ($blockEnd -ge 0) { $s.Substring($blockEnd) } else { '' }
        $competing = [regex]::Matches($tail, '\.detail-text\s+(ul|ol|li)\s*[,{]')
        Test-Assertion 'no competing .detail-text list rule after the block' `
            ($competing.Count -eq 0) ("found {0}" -f $competing.Count)
    }

    # 10. generated output only: real list elements actually reach the report.
    #     NOTE the data-island trap: findings are serialised into a <script>
    #     block, so a newline inside the markup appears in the file as a literal
    #     backslash-n and only becomes a real newline after parsing. Both forms
    #     are counted below.
    if ($tgt.Kind -eq 'generated report') {
        $liCount = ([regex]::Matches($s, '<li>')).Count
        $olCount = ([regex]::Matches($s, '<ol>')).Count + ([regex]::Matches($s, '<ul>')).Count
        Test-Assertion 'generated report contains real <ol>/<ul> with <li> children' `
            (($liCount -gt 0) -and ($olCount -gt 0)) `
            ("ol+ul={0} li={1}" -f $olCount, $liCount)

        # Mechanism B measurement. The data island stores a newline as the two
        # characters backslash-n, so a regex looking for a real newline returns a
        # false negative here. Both the between-items and before-first-item forms
        # produce the oversized gap, so both are counted.
        $escSeq     = [regex]::Escape('\n')
        $escBetween = ([regex]::Matches($s, '</li>' + $escSeq + '<li>')).Count
        $escFirst   = ([regex]::Matches($s, '<(?:ul|ol)>' + $escSeq + '<li>')).Count
        $realNl     = ([regex]::Matches($s, '</li>\s*\r?\n\s*<li>')).Count
        Write-Host ("  INFO  mechanism B instances here: {0} between items, {1} before first item, {2} unescaped" -f $escBetween, $escFirst, $realNl) -ForegroundColor DarkGray
        if (($escBetween + $escFirst + $realNl) -gt 0) {
            Write-Host '  INFO  the white-space: normal rule is what neutralises these; removing it reopens the gap symptom' -ForegroundColor DarkGray
        }
    }
    Write-Host ''
}

Write-Host ("{0} assertion(s) across {1} file(s)" -f $checks, $targets.Count)
if ($failures.Count -gt 0) {
    Write-Host ("{0} FAILURE(S):" -f $failures.Count) -ForegroundColor Red
    foreach ($f in $failures) { Write-Host ("  - {0}" -f $f) -ForegroundColor Red }
    exit 1
}
Write-Host 'All list-rendering assertions passed.' -ForegroundColor Green
Write-Host 'NOTE: this asserts CSS presence, order, and markup only. Visual appearance cannot be' -ForegroundColor Yellow
Write-Host '      confirmed without opening the report in a browser.' -ForegroundColor Yellow
exit 0
