#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$PSNativeCommandUseErrorActionPreference = $true # might be true by default


# Get current date and time
$dt = (Get-Date)
$YYYY = $dt.ToString("yyyy")
$MM = $dt.ToString("MM")
$DD = $dt.ToString("dd")
$HH = $dt.ToString("HH")
$Min = $dt.ToString("mm")
$Sec = $dt.ToString("ss")
$fullstamp = "$YYYY-$MM-$DD-$HH-$Min-$Sec"


$latestHayabusaDir = Get-ChildItem -Directory | Where-Object { $_.Name -like "hayabusa*" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Select-Object -ExpandProperty FullName
If ([string]::IsNullOrWhitespace($latestHayabusaDir)){
	Write-Host "Hayabusa not found! Enter version to download or blank to accept default."
	$defaultValue = '2.19.0'
	($defaultValue,(Read-Host "Use version: [$($defaultValue)]")) -match '\S' |% {$ver = $_}

	$folderPath = ".\hayabusa-$ver-win-x64"
	if (!(Test-Path -Path $folderPath)) {
	    New-Item -ItemType Directory -Path $folderPath
	}
	$url = "https://github.com/Yamato-Security/hayabusa/releases/download/v$ver/hayabusa-$ver-win-x64.zip"
	$zipPath = "hayabusa-$ver-win-x64.zip"
	Invoke-WebRequest -Uri $url -OutFile $zipPath
	Expand-Archive -Path $zipPath -DestinationPath $folderPath -Force
	Remove-Item -Path $zipPath -Force
}


$latestTakajoDir = Get-ChildItem -Directory | Where-Object { $_.Name -like "takajo*" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Select-Object -ExpandProperty FullName
If ([string]::IsNullOrWhitespace($latestTakajoDir)){
	Write-Host "Takajo not found! Enter version to download or blank to accept default."
	$defaultValue = '2.7.1'
	($defaultValue,(Read-Host "Use version: [$($defaultValue)]")) -match '\S' |% {$ver = $_}
	$folderPath = "."
	$url = "https://github.com/Yamato-Security/takajo/releases/download/v$ver/takajo-$ver-win-x64.zip"
	$zipPath = "takajo-$ver-win-x64.zip"
	Invoke-WebRequest -Uri $url -OutFile $zipPath
	Expand-Archive -Path $zipPath -DestinationPath $folderPath -Force
	Remove-Item -Path $zipPath -Force
}

$latestTimelineExplorerDir = Get-ChildItem -Directory | Where-Object { $_.Name -like "TimelineExplorer*" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Select-Object -ExpandProperty FullName
If ([string]::IsNullOrWhitespace($latestTimelineExplorerDir)){
	Write-Host "TimelineExplorer not found! Downloading latest."
	$folderPath = "."
	$url = "https://download.ericzimmermanstools.com/net6/TimelineExplorer.zip"
	$zipPath = "TimelineExplorer.zip"
	Invoke-WebRequest -Uri $url -OutFile $zipPath
	Expand-Archive -Path $zipPath -DestinationPath $folderPath -Force
	Remove-Item -Path $zipPath -Force

}

if (!(Test-Path -Path .\case)) {
    New-Item -ItemType Directory -Path .\case
}

if (!(Test-Path -Path .\timeline)) {
    New-Item -ItemType Directory -Path .\timeline
}

if (!(Test-Path -Path .\htmlreport)) {
    New-Item -ItemType Directory -Path .\htmlreport
}


$latestHayabusaDir = Get-ChildItem -Directory | Where-Object { $_.Name -like "hayabusa*" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Select-Object -ExpandProperty FullName
$latestHayabusaExe = Get-ChildItem -Path $latestHayabusaDir  -File | Where-Object { $_.Name -like "hayabusa*.exe" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Select-Object -ExpandProperty FullName
$latestHayabusaExe -match '\d(\.?\d{1,3}\.?\d)*'
$versionHayabusa = $matches[0]


$latestTakajoDir = Get-ChildItem -Directory | Where-Object { $_.Name -like "takajo*" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Select-Object -ExpandProperty FullName
$latestTakajoExe = Get-ChildItem -Path $latestTakajoDir  -File | Where-Object { $_.Name -like "takajo*.exe" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Select-Object -ExpandProperty FullName
$latestTakajoExe -match '\d(\.?\d{1,3}\.?\d)*'
$vesionTakajo = $matches[0]




$latestTimelineExplorerDir = Get-ChildItem -Directory | Where-Object { $_.Name -like "TimelineExplorer*" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Select-Object -ExpandProperty FullName

Write-Host @'

WELCOME TO
------------------- https://github.com/rpfilomeno/darahata
$$$$$$$\                           $$\   $$\      $$$$$$$$\       
$$  __$$\                          $$ |  $$ |     \__$$  __|      
$$ |  $$ |$$$$$$\  $$$$$$\ $$$$$$\ $$ |  $$ |$$$$$$\ $$ |$$$$$$\  
$$ |  $$ |\____$$\$$  __$$\\____$$\$$$$$$$$ |\____$$\$$ |\____$$\ 
$$ |  $$ |$$$$$$$ $$ |  \__$$$$$$$ $$  __$$ |$$$$$$$ $$ |$$$$$$$ |
$$ |  $$ $$  __$$ $$ |    $$  __$$ $$ |  $$ $$  __$$ $$ $$  __$$ |
$$$$$$$  \$$$$$$$ $$ |    \$$$$$$$ $$ |  $$ \$$$$$$$ $$ \$$$$$$$ |
\_______/ \_______\__|     \_______\__|  \__|\_______\__|\_______|
Lazy Windows event log fast forensics timeline generator and threat hunting script.
'@
Write-Host "Hayabusa v$versionHayabusa (github.com/Yamato-Security/hayabusa)"
Write-Host "Takajo v$vesionTakajo (github.com/Yamato-Security/takajo)"
Write-Host "Timeline Explorer (ericzimmerman.github.io)"


                                                                        
Do{

	$Choices = @(
	    [System.Management.Automation.Host.ChoiceDescription]::new("&Update", "fetch updated Hayabusa rules")
	    [System.Management.Automation.Host.ChoiceDescription]::new("&Scan", "use Hayabusa on live event logs on this host")
	    [System.Management.Automation.Host.ChoiceDescription]::new("&Analyze", "use Takajo fast forensics analyzer on latest scan result")
	    [System.Management.Automation.Host.ChoiceDescription]::new("&Report", "generate html report on latest scan result")
	    [System.Management.Automation.Host.ChoiceDescription]::new("&Quit", "exit this script")
	)

	$decision = $Host.UI.PromptForChoice('Options', 'Please select?', $choices, 1)

	if ($decision -eq 0) { 
		Start-Process -FilePath $latestHayabusaExe -ArgumentList "update-rules" -NoNewWindow -Wait -WorkingDirectory $latestHayabusaDir
	}

	if ($decision -eq 1) {
		Start-Process -FilePath $latestHayabusaExe -ArgumentList "csv-timeline", "-lwC", "-o", "..\timeline\$fullstamp.csv", "-p", "verbose" -NoNewWindow -Wait -WorkingDirectory $latestHayabusaDir
    	Start-Process -FilePath TimelineExplorer.exe -ArgumentList "..\timeline\$fullstamp.csv" -WorkingDirectory $latestTimelineExplorerDir
	}

	if ($decision -eq 2) {
		if (-not(Test-Path -path ".\timeline\$fullstamp.jsonl")) {
			Start-Process -FilePath $latestHayabusaExe -ArgumentList "json-timeline", "-lwLC", "-o", "..\timeline\$fullstamp.jsonl", "-p", "verbose" -NoNewWindow -Wait -WorkingDirectory $latestHayabusaDir
		}
		Start-Process -FilePath $latestTakajoExe -ArgumentList "automagic", "-t", "..\timeline\$fullstamp.jsonl", "-o", "..\case\$fullstamp" -NoNewWindow -Wait -WorkingDirectory $latestTakajoDir
		Invoke-Item .\case\$fullstamp
	}

	if ($decision -eq 3) {
		if (-not(Test-Path -path ".\timeline\$fullstamp.jsonl")) {
			Start-Process -FilePath $latestHayabusaExe -ArgumentList "json-timeline", "-lwLC", "-o", "..\timeline\$fullstamp.jsonl", "-p", "verbose" -NoNewWindow -Wait -WorkingDirectory $latestHayabusaDir
		}
		Start-Process -FilePath $latestTakajoExe -ArgumentList "html-report", "-t", "..\timeline\$fullstamp.jsonl", "-o", "..\htmlreport\$fullstamp", "-r", "..\hayabusa-2.19.0-win-x64\rules", "--clobber" -NoNewWindow -Wait -WorkingDirectory $latestTakajoDir
		Start-Process "htmlreport\$fullstamp\index.html"

	}

} until($decision -eq 4)