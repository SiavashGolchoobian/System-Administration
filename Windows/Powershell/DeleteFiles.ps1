Param(
    [string]$LogPath="C:\ManageEngine\OpManager\tomcat\logs",
    [string]$FilePattern="localhost_access_log*.txt",
	[int]$RetainMonths=6
    )

$myPathPattern=$LogPath + "\" + $FilePattern
$myRetainMonths=(-1 * $RetainMonths)
$myTime= (Get-Date).AddMonths($myRetainMonths)
Get-ChildItem $myPathPattern | Where-Object {$_.LastWriteTime -lt $myTime} | Remove-Item -Force -ErrorAction SilentlyContinue