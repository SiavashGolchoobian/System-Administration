@echo off
REM ============================================Set default parameters
SET VAR_CONTINUE=false
SET VAR_BACKUP_MODE=%1
SET VAR_FROM=%2
SET VAR_To=%3

REM ============================================Check input parameters
	IF "%VAR_BACKUP_MODE%"=="/?" (
		echo syntax error, use : "takebackup /full|diff|copy From_File/Folder To_File/Folder"
	)
	IF "%VAR_BACKUP_MODE%"=="/full" (
		SET VAR_CONTINUE=true
		GOTO TAKEFULL
	)
	IF "%VAR_BACKUP_MODE%"=="/diff" (
		SET VAR_CONTINUE=true
		GOTO TAKEDIFF
	)
	IF "%VAR_BACKUP_MODE%"=="/copy" (
		SET VAR_CONTINUE=true
		GOTO TAKECOPY
	)
	IF %VAR_CONTINUE%==false (
		echo syntax error, use : "takebackup /full|diff|copy From_File/Folder To_File/Folder"
	)	
GOTO END
REM ============================================Take full backup
:TAKEFULL
	echo ---------------------
	echo Taking Full Backup from %VAR_FROM% to %VAR_To%
	echo backing up files ...
	echo ---------------------

	ntbackup backup %VAR_FROM% /f %VAR_To% /d "Full Backupset" /v:yes /r:no /l:f /hc:on /m normal
	
	echo ---------------------
	echo Full Backup Taked.
	echo ---------------------
	GOTO END
REM ============================================Take differential backup
:TAKEDIFF
	echo ---------------------
	echo Taking Differential Backup from %VAR_FROM% to %VAR_To%
	echo backing up files ...
	echo ---------------------

	ntbackup backup %VAR_FROM% /f %VAR_To% /d "Diff Backup" /v:yes /r:no /l:f /hc:on /m differential

	echo ---------------------
	echo Differential Backup Taked.
	echo ---------------------
	GOTO END
REM ============================================Take copy
:TAKECOPY
	echo ---------------------
	echo Taking Copy from %VAR_FROM% to %VAR_To%
	echo copying files ...
	echo ---------------------

	xcopy /E /C /H /R /K /Y %VAR_FROM% %VAR_To%

	echo ---------------------
	echo File(s) copied.
	echo ---------------------
	GOTO END
REM ============================================Exit
:END
