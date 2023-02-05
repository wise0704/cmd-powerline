@echo off

echo "%cmdcmdline%" | find /i " /c " >nul && exit /b

if defined PL_I call :clear_variables

for %%i in (
    git
    cd cd..
    pushd pushd..
    popd
) do (
    doskey %%i="%~dp0update.cmd" %%i $*
)

setlocal

for /f "tokens=2 delims=:" %%i in ('chcp') do set cp=%%i
chcp 65001 >nul

if "%~1" == "" (
    call "%~dp0styles.cmd" p default
) else (
    call "%~dp0styles.cmd" p %*
)

( endlocal
    call :build_prompt "%separator%" "%margin%" "%segments%"
    chcp %cp% >nul
)

call "%~dp0update.cmd"

if exist "%~dp0header.cmd" call "%~dp0header.cmd"

exit /b

:clear_variables () -> PL_I, PL_P[], PL_V[], PL_C[]
    for /l %%i in (0,1,%PL_I%) do (
        set PL_P[%%i]=
        set PL_V[%%i]=
        set PL_C[%%i]=
    )
    set PL_I=
    goto :eof

:build_prompt ("separator", "margin", "segments") -> PL_I, PL_P[], PL_V[], PL_C[]
    set PL_I=0
    set PL_P[0]=
    set PL_V[0]=
    set PL_C[0]=

    for %%i in (%~3) do (
        call :build_segment %1 %%i
    )

    setlocal EnableDelayedExpansion
    set "p=!PL_P[%PL_I%]!49m%~1$E[39m%~2"
    endlocal & set "PL_P[%PL_I%]=%p%"

    goto :eof

:build_segment ("separator", segment) -> PL_I, PL_P[], PL_V[], PL_C[]
    setlocal EnableDelayedExpansion

    set fore=0
    set back=0
    set var=
    set cmd=
    set text=

    for /f "tokens=1,* delims=:" %%i in ("%2") do (
        if [%%i] == [%%~i] (
            call "%~dp0styles.cmd" s %%i
        ) else (
            set text=%%~i
        )
        call :color %%j
    )

    if defined var if defined cmd (
        if defined PL_P[%PL_I%] (
            set /a PL_I+=1
        )
    )
    set i=%PL_I%

    if not defined PL_P[0] (
        if defined text (
            set "p=$E[38;%fore%;48;%back%m%text%$E[38;%back%;"
        ) else (
            set "p=$E[38;%back%;"
        )
    ) else (
        if defined text (
            set "p=!PL_P[%i%]!48;%back%m%~1$E[38;%fore%m%text%$E[38;%back%;"
        ) else (
            set "p=!PL_P[%i%]!48;%back%m%~1$E[38;%back%;"
        )
    )

    if defined var if defined cmd (
        set /a PL_I+=1
    )

    ( endlocal
        set "PL_P[%i%]=%p%"
        set "PL_V[%i%]=%var%"
        set "PL_C[%i%]=%cmd%"
        set PL_I=%PL_I%
    )
    goto :eof

:color ([value]) -> fore, back
    if "%1" == "" goto :eof
    set back=%1
    if "%back:~1,1%" == "+" (
        set /a fore=%back:~0,1% + 8
        set back=%back:~2%
    ) else (
        set /a fore=0x%back:~0,1%
        set back=%back:~1%
    )
    if "%back:~1,1%" == "+" (
        set /a back=%back:~0,1% + 8
    ) else (
        set /a back=0x%back:~0,1%
    )
    set fore=5;%fore%
    set back=5;%back%
    goto :eof
