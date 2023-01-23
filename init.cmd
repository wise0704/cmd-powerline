@echo off

if defined PL_CD if "%~1" == "" exit /b
echo "%cmdcmdline%" | find /i " /c " >nul && exit /b

doskey git=call "%~dp0update.cmd" git $*
doskey cd=call "%~dp0update.cmd" cd $*

setlocal
for /f "delims=: tokens=2" %%i in ('chcp') do set cp=%%i
chcp 65001 >nul

call "%~dp0styles.cmd" %*

set /a fore=3+6*0%bright_background%
set /a back=4+6*0%bright_background%
net session 1>nul 2>nul && set cd_back=%cd_back_admin%
(
    endlocal
    set PL_CD=$E[3%cd_fore%;%back%%cd_back%m%cd_leading%$P%cd_trailing%$E[%fore%%cd_back%
    set PL_GIT_S=;%back%%git_back%m$E[3%git_fore%m%git_leading%
    set PL_GIT_E=%git_trailing%$E[%fore%%git_back%
    set PL_END=;49m$E[0m%margin%
    chcp %cp% >nul
)

call "%~dp0update.cmd"

if exist "%~dp0header.cmd" call "%~dp0header.cmd"