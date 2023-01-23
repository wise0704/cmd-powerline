@echo off

if defined PL_DIR exit /b
echo "%cmdcmdline%" | find /i " /c " >nul && exit /b

set PL_DIR=%~dp0
doskey git=call "%PL_DIR%_git.bat" $*
doskey cd=call "%PL_DIR%_cd.bat" $*

setlocal
for /f "delims=: tokens=2" %%i in ('chcp') do set cp=%%i
chcp 65001 >nul

rem ========= [CUSTOMIZATION] =========
set cd_fore=0
set cd_back=6
set cd_back_admin=1
set git_fore=0
set git_back=3
set cd_leading=$S
set cd_trailing=$S
set git_leading=$S$S
set git_trailing=$S
set margin=$S
set bright_background=1
rem ===================================

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

call "%PL_DIR%update.bat"

for /f "tokens=*" %%i in ('ver') do echo %%i
echo (c) Microsoft Corporation. All rights reserved.
