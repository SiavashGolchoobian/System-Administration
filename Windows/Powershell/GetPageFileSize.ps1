$strComputer = "." 
$colItems = get-wmiobject -class "Win32_PageFileUsage" -namespace "root\CIMV2" -computername $strComputer 
foreach ($objItem in $colItems) { 
      write-host "Allocated Base Size (MB): " $objItem.AllocatedBaseSize 
      write-host "Caption: " $objItem.Caption 
      write-host "Current Usage: " $objItem.CurrentUsage 
      write-host "Description: " $objItem.Description 
      write-host "Installation Date: " $objItem.InstallDate 
      write-host "Name: " $objItem.Name 
      write-host "Peak Usage: " $objItem.PeakUsage 
      write-host "Status: " $objItem.Status 
      write-host "Temporary Page File: " $objItem.TempPageFile 
      write-host 
} 
