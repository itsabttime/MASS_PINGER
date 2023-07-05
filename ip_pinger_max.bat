@echo off
for /f "skip=1 tokens=*" %%i in ('certutil -hashfile .\"%~nx0" md5') do set crytokey=%%i& GOTO Z
:Z
REM ECHO.FILE VERSION !%CRYTOKEY%!
echo.
:Y
set PREFIX_RANGE=
powershell -c "write-host -nonewline \"First 3 numbers of IP x.x.x \""
set /p PREFIX_RANGE=
if "%PREFIX_RANGE%"=="" set PREFIX_RANGE=192.168.1
for /f %%i in ('powershell -c "'%PREFIX_RANGE%' -match '^\d{0,1}\d{0,1}\d{0,1}[.]\d{0,1}\d{0,1}\d{0,1}\.\d{0,1}\d{0,1}\d{0,1}$'"') do set state=%%i
if "%state%"=="False"  powershell -c "write-host -nonewline TRY AGAIN!`r"&TIMEOUT 1 >nul & goto :Y
ECHO.Set! %prefix_range%
:loop
ECHO.|set /p=enter Upper limit of the Range  1-
set /p RANGE=
if "%range%"=="" set range=20
set /a range=%RANGE%
if "%range%"=="0" set range=20
powershell -c "write-host -foregroundcolor blue \"Set`!, %prefix_range%.1-%range%\""
echo.
set /p wait=Time in MilliSecond...:
if "%wait%"=="" set wait=200
set /a wait=%wait%
if "%wait%"=="0" set wait=200
powershell -c "write-host -foregroundcolor green Time is %wait% Millisconds"
echo. Press any Key to continue to ping...
PAUSE >NUL

Echo.___________________________________________________________
powershell -c "write-host -nonewline Select Press T / O   or Default Choice in "
powershell -c "write-host -foregroundcolor green 5 seconds"
Echo.___________________________________________________________
echo.T: Saves The Log.
CHOICE /C TO /D O /T 8 /N /M  "O: Only Once."

IF %errorlevel%==1 ( SET WRITE_LOG=TRUE) else ( SET WRITE_LOG=FALSE)
for /f "delims=" %%a in  ('wmic os get localdatetime /value') do for /f "tokens=1,2 delims=^=." %%i in ("%%a") do set dater=%%j
set yd=%dater:~0,4%
set md=%dater:~4,2%
set dd=%dater:~6,2%
set hd=%dater:~8,2%
set mm=%dater:~10,2%
set ss=%dater:~12,2%
title Main Window
if "%WRITE_LOG%"=="TRUE" goto there
if "%WRITE_LOG%"=="FALSE" goto here
:here 
for /l %%i in (1,1,%RANGE%) do echo.%PREFIX_RANGE%.%%i&start cmd /c "PING -n 1 -w %wait% %PREFIX_RANGE%.%%i&&(mode 35,10&color 4A&ECHO OFF&CLS&ECHO %PREFIX_RANGE%.%%i&title %PREFIX_RANGE%.%%i&PAUSE >NUL)"
goto eof
:there
echo. Logging is Enabled.
for /l %%i in (1,1,%RANGE%) do start cmd /c "PING -n 1 -w %wait% %PREFIX_RANGE%.%%i&&(mode 30,10&color 6B&title No Logs Kepts&ECHO OFF&CLS&title %PREFIX_RANGE%.%%i&CLS&ECHO.PLEASE WAIT&ECHO.&ECHO.DO NOT CLOSE&ECHO. Saved to LOGBOOK.%random%.BOOK.%dater%.txt&TIMEOUT %%i &powershell -c "Add-Content -Path LOGBOOK.%random%.BOOK.%dater%.txt -Value \"ip address:`t%PREFIX_RANGE%.%%i`t%hd%:%mm%:%ss%`t%dd%-%md%-%yd%`tUP\""&&echo. || echo.%prefix_range%.%%i>>LOGFAILSTATUS%random%.BOOK.%dater%.txt)"
echo. Will Repeat
goto loop
ENDLOCAL
SETLOCAL






:eof
