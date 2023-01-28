@echo off

if defined PL_CD if "%~1" == "" exit /b
echo "%cmdcmdline%" | find /i " /c " >nul && exit /b

for %%i in (
    git
    cd cd..
    pushd pushd..
    popd
) do (
    doskey %%i=call "%~dp0update.cmd" %%i $*
)

setlocal

for /f "delims=: tokens=2" %%i in ('chcp') do set cp=%%i
chcp 65001 >nul

if "%~1" == "" (
    call "%~dp0styles.cmd" p default
) else (
    call "%~dp0styles.cmd" p %*
)

(
    endlocal
    call :build_prompt "%separator%" "%margin%" "%segments%"
    chcp %cp% >nul
)

call "%~dp0update.cmd"

if exist "%~dp0header.cmd" call "%~dp0header.cmd"

exit /b

:build_prompt ("separator", "margin", "segments") -> PL_I, PL_P[], PL_V[], PL_C[]
    set PL_I=0
    set PL_P[0]=
    set PL_V[0]=
    set PL_C[0]=

    for %%i in (%~3) do (
        call :build_segment %1 "%%i"
    )

    setlocal EnableDelayedExpansion
    set "p=!PL_P[%PL_I%]!49m%~1$E[39m%~2"
    endlocal & set "PL_P[%PL_I%]=%p%"

    goto :eof

:build_segment ("separator", "segment") -> PL_I, PL_P[], PL_V[], PL_C[]
    setlocal EnableDelayedExpansion

    set fore=0
    set back=0
    set var=
    set cmd=
    set text=

    for /f "delims=: tokens=1,*" %%i in (%2) do (
        call "%~dp0styles.cmd" s %%i
        call :color %%j
    )

    set /a f=%fore% + 30
    set /a t=%back% + 30
    set /a b=%back% + 40

    if defined var if defined cmd (
        if defined PL_P[%PL_I%] (
            set /a PL_I=%PL_I% + 1
            set PL_P[!PL_I!]=
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
            set "p=!PL_P[%PL_I%]!%b%m%~1$E[%f%m%text%$E[%t%;"
        ) else (
            set "p=!PL_P[%PL_I%]!%b%m%~1$E[%t%;"
        )
    )

    set i=%PL_I%
    if defined var if defined cmd (
        set /a i=%PL_I% + 1
    )

    (
        endlocal
        set PL_P[%i%]=
        set "PL_P[%PL_I%]=%p%"
        set "PL_V[%PL_I%]=%var%"
        set "PL_C[%PL_I%]=%cmd%"
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
