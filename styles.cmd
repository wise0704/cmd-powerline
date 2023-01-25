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
set separator=
set margin=$S
goto :eof

:p_compact
set segments=%segments::=-compact:%
set margin=
goto :eof

:p_stack
set segments=%segments:cwd:=cwd_stack:%
goto :eof

:p_detailed
set segments=user:02+ os:05+ %segments%
goto :eof

:p_padded
set segments=empty %segments%
goto :eof

:p_dark
set segments=%segments:+=%
goto :eof

:p_round
set separator=
goto :eof

:p_angle_b
set separator=
goto :eof

:p_angle_t
set separator=
goto :eof

:p_flames
set separator=
goto :eof

:p_pixel
set separator=
goto :eof

:p_spikes
set separator=
goto :eof

:p_newline
set margin=$_$G$S
goto :eof

:p_dollar
set margin=$_$$$S
goto :eof

rem =============================================
rem                   SEGMENTS
rem =============================================

:s_empty
goto :eof

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
set "cmd='git branch --show-current 2^>nul'"
set text=$S$S%%i$S
goto :eof

:s_compact
set text=%text:$S=%
set text=%text: =%
goto :eof



rem =============================================
rem DO NOT EDIT BELOW!!!

:select_p
call :p_default
:apply_next_profile
shift
if not "%1" == "" call :p_%1 & goto :apply_next_profile
exit /b

:select_s
set arg=%2
for %%i in (%arg:-= %) do call :s_%%i
exit /b

rem =============================================
