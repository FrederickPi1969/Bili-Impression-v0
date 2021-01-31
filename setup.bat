@echo off 
dir > NUL || (
    echo Sorry, Bili-Impression currently only supports Windows. 
    exit /b
)

set "root=%~dp0"
set "python=%root%PyBin\python.exe"


%python% -m pip install -r requirements.txt


echo. & echo. & echo.  
echo Upon successful installation, you can now execute run.bat 
echo (Press any key to exit...) 
pause > NUL