@%*

@setlocal EnableDelayedExpansion
@prompt
@for /l %%i in (0,1,%PL_I%) do @(
    if defined PL_V[%%i] (
        call :invoke_and_append %%i
    ) else (
        set "PROMPT=!PROMPT!!PL_P[%%i]!"
    )
)
@endlocal & call set "PROMPT=%PROMPT%"
@exit /b

:invoke_and_append (index) -> var, cmd, text, PROMPT
    @set "var=!PL_V[%1]!"
    @set "cmd=!PL_C[%1]!"
    @set "text=!PL_P[%1]!"
    @for /f %var% in (%cmd%) do @(
        set "PROMPT=%PROMPT%%text%"
    )
    @goto :eof
