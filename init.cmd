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

    set /a f=%fore% + 30
    set /a t=%back% + 30
    set /a b=%back% + 40

    set i=%PL_I%
    if defined var if defined cmd (
        if defined PL_P[%i%] (
            set /a i+=1
        )
    )

    if not defined PL_P[0] (
        if defined text (
            set "p=$E[%f%;%b%m%text%$E[%t%;"
        ) else (
            set "p=$E[%t%;"
        )
    ) else (
        if defined text (
            set "p=!PL_P[%i%]!%b%m%~1$E[%f%m%text%$E[%t%;"
        ) else (
            set "p=!PL_P[%i%]!%b%m%~1$E[%t%;"
        )
    )

    if defined var if defined cmd (
        set /a i+=1
    )

    ( endlocal
        set "PL_P[%i%]=%p%"
        set "PL_V[%i%]=%var%"
        set "PL_C[%i%]=%cmd%"
        set PL_I=%i%
    )
    goto :eof

:color ([value]) -> fore, back
    if "%1" == "" goto :eof
    set back=%1
    if "%back:~1,1%" == "+" (
        set fore=6%back:~0,1%
        set back=%back:~2%
    ) else (
        set fore=%back:~0,1%
        set back=%back:~1%
    )
    if "%back:~1,1%" == "+" (
        set back=6%back:~0,1%
    ) else (
        set back=%back:~0,1%
    )
    goto :eof
