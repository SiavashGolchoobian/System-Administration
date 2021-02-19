$ScriptPath = "U:\Databases\Mount_BackupDisk.script"
$FileExists = Test-Path $scriptpath
if ($FileExists -eq $True){Diskpart /s $ScriptPath}else{throw("Script file does not exist on " + $ScriptPath)}