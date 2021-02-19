@echo off
@Setlocal enabledelayedexpansion

REM ============================================Set default parameters
SET dd=%date:~7,2%
SET mm=%date:~4,2%
SET yyyy=%date:~10,4%
SET hour=%time:~0,2%
SET min=%time:~3,2%

REM ==Replace Blank with 0==
SET dd=%dd: =0%
SET mm=%mm: =0%
SET yyyy=%yyyy: =0%
SET hour=%hour: =0%
SET min=%min: =0%

SET VAR_BKF_FOLDERNAME=bkf
SET VAR_RAW_FOLDERNAME=raw

SET VAR_DEST_DIR_LOCAL=D:\Backups\BP_formsrv
SET VAR_DEST_DIR_NETWORK=\\172.16.0.97\d$\Backups\BP_formsrv

REM =================================================<<ATTENTION>>=====================================================
REM     Do not use folders or file names that contains space char in VAR_SOURCE array variable,correct sample is : 
REM                              SET VAR_SOURCE=(D:\Folder1\Folder2 D:\FOLDERA\FOLDERB)
REM ===================================================================================================================
SET VAR_SOURCE=(D:\e_oracle)

REM ============================================Main
	FOR %%i in %VAR_SOURCE% do (
		SET VAR_TEMP_ADDRESS=%%i
		for %%j in (!VAR_TEMP_ADDRESS!) do SET VAR_TEMP_NAME=%%~nxj
		SET VAR_DEST_FILE_FULL="%VAR_DEST_DIR_LOCAL%\%VAR_BKF_FOLDERNAME%\full_!VAR_TEMP_NAME!_%yyyy%_%mm%.bkf"
		SET VAR_DEST_FILE_DIFF="%VAR_DEST_DIR_LOCAL%\%VAR_BKF_FOLDERNAME%\diff_!VAR_TEMP_NAME!_%yyyy%_%mm%_%dd%_on_%hour%_%min%.bkf"
		SET VAR_DEST_FILE_COPY="%VAR_DEST_DIR_NETWORK%\%VAR_RAW_FOLDERNAME%\!VAR_TEMP_NAME!\"
		
		
		IF "%~1"=="/?" (
			echo Syntax : Backup "[/full|diff]"
			echo BLANK  : dont use any parameter result to start backing up files in smar mode
			echo /full  : force program to taking full backup
			echo /diff  : force program to taking differential backup
			GOTO END
		)

		IF "%~1"=="/full" (
			echo "force full ..."
			CALL BackupFunction.bat /full !VAR_TEMP_ADDRESS! !VAR_DEST_FILE_FULL!
			CALL BackupFunction.bat /copy !VAR_TEMP_ADDRESS! !VAR_DEST_FILE_COPY!
		)

		IF "%~1"=="/diff" (
			echo "force diff ..."
			CALL BackupFunction.bat /diff !VAR_TEMP_ADDRESS! !VAR_DEST_FILE_DIFF!
			CALL BackupFunction.bat /copy !VAR_TEMP_ADDRESS! !VAR_DEST_FILE_COPY!
		)
		
		IF "%~1"=="" (
			echo "smart mode ..."
			IF NOT EXIST !VAR_DEST_FILE_FULL! (
				echo "smart full ... from " !VAR_TEMP_ADDRESS! to !VAR_DEST_FILE_FULL!
				CALL BackupFunction.bat /full !VAR_TEMP_ADDRESS! !VAR_DEST_FILE_FULL!
				CALL BackupFunction.bat /copy !VAR_TEMP_ADDRESS! !VAR_DEST_FILE_COPY!
			) ELSE (
				echo "smart diff ... from " !VAR_TEMP_ADDRESS! to !VAR_DEST_FILE_DIFF!
				CALL BackupFunction.bat /diff !VAR_TEMP_ADDRESS! !VAR_DEST_FILE_DIFF!
				CALL BackupFunction.bat /copy !VAR_TEMP_ADDRESS! !VAR_DEST_FILE_COPY!
			)
		)
	)
	
	GOTO END
REM ============================================Exit
:END
@echo on