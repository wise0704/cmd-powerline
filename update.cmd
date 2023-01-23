@echo off
setlocal
set PL_GIT=
for /f %%i in ('git branch --show-current 2^>nul') do set PL_GIT=%PL_GIT_S%%%i%PL_GIT_E%
endlocal & prompt %PL_CD%%PL_GIT%%PL_END%
