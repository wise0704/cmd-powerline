@for /f "tokens=1,2,* delims=\" %%i in ("%CD%") do @(
    if "%%k" == "" (
        echo %%i\%%j
    ) else if "%%k" == "%%~nk" (
        echo %%i\%%j\%%k
    ) else (
        echo %%i\%%j\...\%%~nk
    )
)
