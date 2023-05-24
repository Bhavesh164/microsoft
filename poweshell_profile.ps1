Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})
Set-PSReadLineOption -EditMode Emacs

function get_current_working_directory {(Get-Item .).FullName}
New-Alias cwd get_current_working_directory

function get_downloads_directory {Set-Location "C:\Users\Bhavesh Verma\Downloads"}
New-Alias cddl get_downloads_directory

function get_documents_directory {Set-Location "C:\Users\Bhavesh Verma\Documents"}
New-Alias cddo get_documents_directory

function get_current_directory_in_windows_terminal {wt -w 0 nt -d .}
New-Alias newt get_current_directory_in_windows_terminal

$GLOBAL:previousDir = ''
$GLOBAL:currentDir = ''
function prompt
{
    Write-Host "PS $(get-location)>"  -NoNewLine -foregroundcolor Green
    $GLOBAL:nowPath = (Get-Location).Path
    if($nowPath -ne $GLOBAL:currentDir){
        $GLOBAL:previousDir = $GLOBAL:currentDir
        $GLOBAL:currentDir = $nowPath
    }
    return ' '
}
function BackOneDir{
    cd $GLOBAL:previousDir
}
	Set-Alias cd- BackOneDir

New-Alias vim nvim
Import-Module PSReadLine
Remove-PSReadLineKeyHandler -Key RightArrow
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key RightArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key LeftArrow -Function HistorySearchForward
Function Linux-Remove-Force {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    
    # Remove the '.\' prefix from the path
    	if ($Path.StartsWith(".\")) {
        	$Path = $Path.Substring(2)
    	}
    # Remove the last backslash from the path
    	if ($Path.EndsWith("\")) {
        	$Path = $Path.Substring(0, $Path.Length - 1)
    	}
    & wsl rm -rf $Path
}

New-Alias lrm Linux-Remove-Force
function runAsAdmin
{
	powershell Start-Process powershell -Verb runAs
}

New-Alias admin runAsAdmin

function Invoke-UploadFile {
	param (
        	[string]$file
    	)
	if ([string]::IsNullOrEmpty($file)) {
        	Write-Host "Error: File argument is missing." -ForegroundColor Red
	        return
    	}
	
	if (-not (Test-Path -Path $file)) {
        	Write-Host "Error: File '$file' does not exist." -ForegroundColor Red
	        return
    	}
	
	curl.exe -F "f:1=@$file" http://ix.io
}
New-Alias ix Invoke-UploadFile

function wsl-wget {
	param(
		[string]$Path
	)
   wsl wget $Path
}

New-Alias lwget wsl-wget

function ll { 
	Get-ChildItem -Path $pwd -File 
}

function df {
    get-volume
}

function pgrep($name) {
	Get-Process $name
}

function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}
