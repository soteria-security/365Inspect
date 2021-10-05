function Inspect-ATPSafeAttachments {
	# This will throw an error if the environment under test does not have an ATP license,
	# but should still work.
	Try {
		$safe_attachment_policies = Get-SafeAttachmentPolicy
		If (!($safe_attachment_policies)) {
			return @($org_name)
		}
	} Catch {
		return @($org_name)
	}
}

return Inspect-ATPSafeAttachments