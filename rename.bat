@echo off

set LIST=list.txt

set SELF=%~n0

setlocal enabledelayedexpansion
set f=%SELF%.tmp

for %%f in (%*) do (
  set FOLPATH=%%f
)

copy NUL %f% > NUL
for /f "usebackq delims= tokens=*" %%i in (`dir %FOLPATH% /a-d /on /b "* *".pdf`) do (echo %FOLPATH%\%%i) >> %f%
for /f "tokens=*" %%i in ('type %f% ^| find /c /v ""') do set n1=%%i
for /f "tokens=*" %%i in ('type %f% ^| find /c /v ""') do set n2=%%i
if %n1% neq %n2% (
echo # of files not matched. >&2
exit /b 1
)

set /a i=0
for /f "tokens=*" %%s in (%FOLPATH%\%LIST%) do (
call :fgets s "%f%" !i!
move "!s!" "%FOLPATH%\%%s.pdf"
set /a i+=1
)

del %f% > NUL
endlocal
goto :EOF

:fgets
setlocal
set f=%~2
set i=%~3

for /f "tokens=*" %%s in ('more +%i% %f%') do (
set s=%%s
goto :BREAK
)
:BREAK
endlocal & set %~1=%s%
goto :EOF
