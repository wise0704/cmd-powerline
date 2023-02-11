goto :select_%1

rem =============================================
rem                   PROFILES
rem =============================================

:p_default
net session 1>nul 2>nul && (
    set segments=cwd:01+ git:03+
) || (
    set segments=cwd:06+ git:03+
)
set "separator="
set "margin=$S"
goto :eof

:p_demo2
set segments=cwd-compact:01 git-compact:03
set "separator="
set "margin="
goto :eof

:p_demo3
set segments="" cwd:04 git:03
set "separator="
set "margin=$S"
goto :eof

:p_demo4
set segments="" user:02 "" os:05 "" cwd:03 "" git:06
set "separator="
set "margin=$_$S"
goto :eof

:p_demo5
set segments="" user:05 os:03 cwd:40 git:01
set "separator=$S"
set "margin=$_$S"
goto :eof

:p_demo6
set segments="" user:03 "" os:07 "" cwd:06 "" git:02
set "separator="
set "margin=$_$$$S"
goto :eof

:p_demo7
set segments="" cwd_stack:01 git:03
set "separator=$S"
set "margin=$S"
goto :eof

:p_-user
set segments=user:02+ %segments%
goto :eof

:p_-os
set segments=os:05+ %segments%
goto :eof

:p_-pad
set segments="" %segments%
goto :eof

:p_-dark
set segments=%segments:+=%
goto :eof

:p_-sep-round
set "separator="
goto :eof

:p_-sep-angle-b
set "separator=$S"
goto :eof

:p_-sep-angle-t
set "separator=$S"
goto :eof

:p_-sep-flames
set "separator=$S"
goto :eof

:p_-sep-pixels
set "separator="
goto :eof

:p_-sep-spikes
set "separator="
goto :eof

:p_-margin-newline
set "margin=$_$G$S"
goto :eof

:p_-margin-dollar
set "margin=$_$$$S"
goto :eof

rem =============================================
rem                   SEGMENTS
rem =============================================

:s_cwd
set text=$S$P$S
goto :eof

:s_cwd_stack
set text=$S$+$P$S
goto :eof

:s_user
set text=$S%USERNAME%@%COMPUTERNAME%$S
goto :eof

:s_os
set text=$S%OS%$S
goto :eof

:s_session
set text=$S%%SESSIONNAME%%$S
goto :eof

:s_git
set var="tokens=*" %%i
set cmd='git branch 2^>nul ^| findstr /bc:"* "'
set text=$S$S%%i$S
goto :eof

rem :s_my_script
rem set var="delims=" %%i
rem set cmd='"%~dp0scripts\my_script.cmd"'
rem set text=$S%%i$S
rem goto :eof

:s_compact
set text=%text:$S=%
set text=%text: =%
goto :eof

rem =============================================
rem DO NOT EDIT BELOW!!!

:select_p
shift
if not "%1" == "" call :p_%1 & goto :select_p
exit /b

:select_s
set arg=%2
for %%i in (%arg:-= %) do call :s_%%i
exit /b

rem =============================================
