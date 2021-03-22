# The script sets the sa password and start the SQL Service
# Also it attaches additional database from the disk
# The format for attach_dbs

param(
[Parameter(Mandatory=$false)]
[string]$attach_dbs
)


# start the service
Write-Verbose "Starting SQL Server"
Restart-Service -displayname 'SQL Server (NODE)'

$attach_dbs_cleaned = $attach_dbs.TrimStart('\\').TrimEnd('\\')

$dbs = $attach_dbs_cleaned | ConvertFrom-Json

if ($null -ne $dbs -And $dbs.Length -gt 0)
{
    Write-Verbose "Attaching $($dbs.Length) database(s)"
	    
    Foreach($db in $dbs) 
    {
        if($db.saskey.length -gt 0)
        { 
            $saskey = $true 
        }
        else
        { 
            $saskey = $false 
        }
            
        $files = @();
        Foreach($file in $db.dbFiles)
        {
            $files += "(FILENAME = N'$($file)')";
            
            # check for a saskey and create one credential per blob Container                  
            if($saskey)
            {
                $blob_container = (Split-Path $file).Replace('\','/');                                         
                $sql_credential = "IF NOT EXISTS (SELECT 1 FROM SYS.CREDENTIALS WHERE NAME = '" + $blob_container + "') BEGIN CREATE CREDENTIAL [" + $blob_container + "] WITH IDENTITY='SHARED ACCESS SIGNATURE', SECRET= '" + $db.saskey + "' END;"              
            
                Write-Verbose "Invoke-Sqlcmd -Query $($sql_credential)"
                & sqlcmd -Q $sql_credential
            }
        }

        $files = $files -join ","
        $sqlcmd = "sp_detach_db ""$($db.dbName)"";CREATE DATABASE ""$($db.dbName)"" ON $($files) FOR ATTACH ;"

        Write-Verbose "Invoke-Sqlcmd -Query $($sqlcmd)"
        & sqlcmd -Q $sqlcmd
	}
}

Write-Verbose "Started SQL Server."

$lastCheck = (Get-Date).AddSeconds(-2) 
while ($true) 
{ 
    Get-EventLog -LogName Application -Source "MSSQL*" -After $lastCheck | Select-Object TimeGenerated, EntryType, Message	 
    $lastCheck = Get-Date 
    Start-Sleep -Seconds 2 
}
