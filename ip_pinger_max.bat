@echo off
set PREFIX_RANGE=192.168.1
ECHO.enter RANGE max:
set /p RANGE=
ECHO.enter wait_time(ms):
set /p wait=
CHOICE /C TF /N /M "MAINTAIN LOG......... (T)RUE (F)ALSE"
IF %errorlevel%==1 ( SET WRITE_LOG=TRUE) else ( SET WRITE_LOG=FALSE)
set dater=%date%
set dater=%dater:/=%
set dater=%dater::=%
set dater=%dater:-=%
set dater=%dater:\=%

if "%WRITE_LOG%"=="TRUE" goto there
if "%WRITE_LOG%"=="FALSE" goto here
:here 
for /l %%i in (1,1,%RANGE%) do start cmd /c "PING -n 1 -w %wait% %PREFIX_RANGE%.%%i&&(mode 30,10&color 4A&ECHO OFF&CLS&ECHO %PREFIX_RANGE%.%%i&PAUSE >NUL)"
goto eof
:there
for /l %%i in (1,1,%RANGE%) do start cmd /c "PING -n 1 -w %wait% %PREFIX_RANGE%.%%i&&(mode 30,10&color 4A&ECHO OFF&CLS&title %PREFIX_RANGE%.%%i&CLS&ECHO.PLEASE WAIT&ECHO.&ECHO.DO NOT CLOSE&ECHO.&TIMEOUT 5 &powershell -c "Add-Content -Path LOG.%random%.BOOK.%dater%.txt -Value \"New line to add.%PREFIX_RANGE%.%%i is UP\"")"
:eof
PAUSE