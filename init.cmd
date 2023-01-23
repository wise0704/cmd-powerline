@echo off

if defined PL_CD exit /b
echo "%cmdcmdline%" | find /i " /c " >nul && exit /b

doskey git=git $* $T call "%~dp0update.cmd"
doskey cd=cd $* $T call "%~dp0update.cmd"

setlocal
for /f "delims=: tokens=2" %%i in ('chcp') do set cp=%%i
chcp 65001 >nul

call styles.cmd %*

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

if exist header.cmd call header.cmd
