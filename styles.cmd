call :default
:args
if "%~1" == "" exit /b
call :%~1 2>nul
shift
goto :args

rem =============================================
rem ============= Customize below ===============
rem =============================================

:default
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
goto :eof

:compact
set cd_leading=
set cd_trailing=
set git_leading=
set git_trailing=
set margin=
goto :eof

:new_line
set margin=$_$G$S
goto :eof

:bash
set margin=$_$$$S
goto :eof

:dark
set bright_background=0
goto :eof

:color_1
rem set cd_fore=
set cd_back=4
rem set cd_back_admin=
rem set git_fore=
rem set git_back=
goto :eof

:color_2
rem set cd_fore=
rem set cd_back=
rem set cd_back_admin=
rem set git_fore=
rem set git_back=
goto :eof

:custom_1
rem set cd_fore=
rem set cd_back=
rem set cd_back_admin=
rem set git_fore=
rem set git_back=
rem set cd_leading=
rem set cd_trailing=
rem set git_leading=
rem set git_trailing=
rem set margin=
rem set bright_background=
goto :eof
