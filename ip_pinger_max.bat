@echo off
for /f "skip=1 tokens=*" %%i in ('certutil -hashfile .\"%~nx0" md5') do set crytokey=%%i& GOTO Z
:Z
ECHO.FILE VERSION!%CRYTOKEY%!
ECHO.--------------------------------------------------------------------
:Y
set PREFIX_RANGE=
powershell -c "write-host -nonewline \"PREFIX_RANGE=192.168.1 \""
set /p PREFIX_RANGE=
if "%PREFIX_RANGE%"=="" set PREFIX_RANGE=192.168.1
for /f %%i in ('powershell -c "'%PREFIX_RANGE%' -match '^\d{0,1}\d{0,1}\d{0,1}[.]\d{0,1}\d{0,1}\d{0,1}\.\d{0,1}\d{0,1}\d{0,1}$'"') do set state=%%i
if "%state%"=="False"  powershell -c "write-host -nonewline TRY AGAIN!`r"&TIMEOUT 1 >nul & goto :Y
ECHO.PREFIX_RANGE=%prefix_range%
:loop
ECHO.|set /p=enter RANGE max (1-:
set /p RANGE=
if "%range%"=="" set range=20
cls
echo.Preparing ping: %prefix_range%.1-%range%
ECHO.|set /p=enter wait_time Recommended min.200 (ms):
set /p wait=
if "%wait%"=="" set wait=200
cls
ECHO.Preparing ping: %prefix_range%.1-%range%
ECHO.Pingg timeout/wait is %wait% ms
echo.-----------------------------------------------------------
echo.x             s e  n ding Pi n gs                      x  x 
Echo._______________________________
Echo.Pinging in 5 seconds...
Echo.Select Press T / O
Echo.--------------------------------
echo.T: Saves Logs, Repeat Pings
CHOICE /C TF /D F /T 5 /N /M  "O: Only Once."

IF %errorlevel%==1 ( SET WRITE_LOG=TRUE) else ( SET WRITE_LOG=FALSE)
for /f "delims=" %%a in  ('wmic os get localdatetime /value') do for /f "tokens=1,2 delims=^=." %%i in ("%%a") do set dater=%%j&
title Main Window
if "%WRITE_LOG%"=="TRUE" goto there
if "%WRITE_LOG%"=="FALSE" goto here
:here 
for /l %%i in (1,1,%RANGE%) do echo.%PREFIX_RANGE%.%%i&start cmd /c "PING -n 1 -w %wait% %PREFIX_RANGE%.%%i&&(mode 30,10&color 4A&ECHO OFF&CLS&ECHO %PREFIX_RANGE%.%%i&PAUSE >NUL)"
goto eof
:there
echo. Logging is Enabled.
for /l %%i in (1,1,%RANGE%) do cls&echo.logging is Enabled.&echo. saveD to LOGBOOK.%random%.BOOK.%dater%.txt&start cmd /c "PING -n 1 -w %wait% %PREFIX_RANGE%.%%i&&(mode 30,10&color 6B&title No Logs Kepts&ECHO OFF&CLS&title %PREFIX_RANGE%.%%i&CLS&ECHO.PLEASE WAIT&ECHO.&ECHO.DO NOT CLOSE&ECHO. Saved to LOGBOOK.%random%.BOOK.%dater%.txt&TIMEOUT %%i &powershell -c "Add-Content -Path LOGBOOK.%random%.BOOK.%dater%.txt -Value \"ip address:`t %PREFIX_RANGE%.%%i is UP\""&&echo. || echo.%prefix_range%.%%i>>LOGFAILSTATUS%random%.BOOK.%dater%.txt)"
goto loop
ENDLOCAL
SETLOCAL






:eof
