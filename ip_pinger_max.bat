@echo off
for /f "skip=1 tokens=*" %%i in ('certutil -hashfile .\"%~nx0" md5') do set crytokey=%%i& GOTO Z
:Z
ECHO.FILE VERSION!%CRYTOKEY%!
ECHO.--------------------------------------------------------------------
:Y
set PREFIX_RANGE=
ECHO.|set /p=PREFIX_RANGE=(192.168.1/default):
set /p PREFIX_RANGE=
if "%PREFIX_RANGE%"=="" set PREFIX_RANGE=192.168.1
for /f %%i in ('powershell -c "'%PREFIX_RANGE%' -match '^\d{0,1}\d{0,1}\d{0,1}[.]\d{0,1}\d{0,1}\d{0,1}\.\d{0,1}\d{0,1}\d{0,1}$'"') do set state=%%i
if "%state%"=="False" echo. ...Try Again!!&goto :Y
:loop
ECHO.|set /p=enter RANGE max (1-:
set /p RANGE=
cls
echo.enter RANGE max:%range%
ECHO.|set /p=enter wait_time Recommended min.200 (ms):
set /p wait=
cls
ECHO.enter RANGE max (1-:%range%
ECHO.enter wait_time Recommended min.200 (ms):%wait%
echo.Pinging...&echo.&echo.&echo.&echo.
powershell -c "write-host low range is recommended. `t`t LogBook is Saved in Same Directory."
CHOICE /C TF /N /M "MAINTAIN LOG......... (T)RUE (F)ALSE"
if "%wait%"=="" set wait=200
IF %errorlevel%==1 ( SET WRITE_LOG=TRUE) else ( SET WRITE_LOG=FALSE)
for /f "delims=" %%a in  ('wmic os get localdatetime /value') do for /f "tokens=1,2 delims=^=." %%i in ("%%a") do set dater=%%j&
title Main Window
if "%WRITE_LOG%"=="TRUE" goto there
if "%WRITE_LOG%"=="FALSE" goto here
:here 
for /l %%i in (1,1,%RANGE%) do echo.!pinging! : %PREFIX_RANGE%.%%i&start cmd /c "PING -n 1 -w %wait% %PREFIX_RANGE%.%%i&&(mode 30,10&color 4A&ECHO OFF&CLS&ECHO %PREFIX_RANGE%.%%i&PAUSE >NUL)"
goto eof
:there
for /l %%i in (1,1,%RANGE%) do echo.sending to: %PREFIX_RANGE%.%%i& start cmd /c "PING -n 1 -w %wait% %PREFIX_RANGE%.%%i&&(mode 30,10&color 4A&ECHO OFF&CLS&title %PREFIX_RANGE%.%%i&CLS&ECHO.PLEASE WAIT&ECHO.&ECHO.DO NOT CLOSE&ECHO.&TIMEOUT %%i&powershell -c "Add-Content -Path LOGBOOK.%random%.BOOK.%dater%.txt -Value \"ip address:`t %PREFIX_RANGE%.%%i is UP\""&&echo. || echo.%prefix_range%.%%i>>LOGFAILSTATUS%random%.BOOK.%dater%.txt)"
goto loop
ENDLOCAL
SETLOCAL






:eof
