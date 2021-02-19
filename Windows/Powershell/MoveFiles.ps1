$mySource = "E:\_Source\*"
$myDestination = "E:\_Dest\"
$myFilenameTemplate = "*.txt"
Get-ChildItem -Path $mySource -Include $myFilenameTemplate -Recurse | Move-Item -Destination $myDestination