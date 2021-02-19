@ECHO OFF
REM *************************************************************************************************
REM
REM ntfs_perm_bck.CMD - Batch file to back up ntfs permissions and transfering the backup with rsync.
REM
REM By Tevfik K. (http://itefix.no)
REM *************************************************************************************************

REM Make environment variable changes local to this batch file
SETLOCAL

REM ** CUSTOMIZE ** Specify where to find rsync and related files (C:\CWRSYNC)
SET CWRSYNCHOME=%PROGRAMFILES%\CWRSYNC

REM Set HOME variable to your windows home directory. That makes sure 
REM that ssh command creates known_hosts in a directory you have access.
SET HOME=%HOMEDRIVE%%HOMEPATH%

REM Make cwRsync home as a part of system PATH to find required DLLs
SET CWOLDPATH=%PATH%
SET PATH=%CWRSYNCHOME%;%PATH%
SET HOST=172.20.5.1
SET USER=oracle
SET SOURCE_DATA=/cygdrive/d/Backups/BP_formsrv/ntfsperms.txt
SET MIRROR_DATA=/local_backup/formsrv

icacls "D:\e_oracle\applications" /save D:\Backups\BP_formsrv\ntfsperms.txt /t /c
rsync -zvp  -e  ssh %SOURCE_DATA% %USER%@%HOST%:%MIRROR_DATA% --log-file=/cygdrive/d/rsync.txt

icacls "D:\e_oracle" /restore D:\Backups\BP_formsrv\ntfsperms.txt