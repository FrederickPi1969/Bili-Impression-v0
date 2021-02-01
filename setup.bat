@echo off 
setlocal EnableDelayedExpansion

:: Automatic installation - underdevelopment
@REM dir > NUL || (
@REM     echo Sorry, Bili-Impression currently only supports Windows. 
@REM     exit /b
@REM )

@REM @REM set "root=%~dp0"
@REM @REM set "python=%root%PyBin\python.exe"
@REM %python% -m pip install -r requirements.txt


@REM echo. & echo. & echo.  
@REM echo Upon successful installation, you can now execute run.bat 
@REM echo (Press any key to exit...) 
@REM pause > NUL

:welcome
echo. 
echo. 
echo. 
echo. 
echo. 
echo. 
echo. 
echo. 
echo. 
echo. 
echo. 
echo. 
echo                                             Bili-Impression Configuration
echo.
echo. 
echo. 
echo. 
echo. 
echo. 
echo. 
echo. 
echo. 
echo. 
echo.
echo. 
echo.  
echo. 
echo. 

pause > NUL 
cls
set wget=%./toolkit/wget.exe% 

:: semi-manual installation

:detect_anaconda  
dir /b %USERPROFILE%  | find /i "anaconda3" > NUL && goto :conda_found
goto :conda_not_found

:conda_found 
echo Detected Anaconda3 in %USERPROFILE% 
set "PyPath=%USERPROFILE%\anaconda3\python.exe"  
goto :create_config


:conda_not_found 
cls
echo Anaconda is highly useful for python package managment.
echo However, it appears you haven't installed it yet on this PC. 

set /p opt="Would you like to install Anaconda3? [y/n]:  " 

if /i "%opt%"=="y" (
    echo. && echo. && echo.
    echo Please install anaconda3 to %USERPROFILE%
    echo Press Enter to download...
    pause > NUL
    echo downloading anaconda3 installer to %USERPROFILE%\Downloads ...
    chdir %USERPROFILE%\Downloads
    wget "https://repo.anaconda.com/archive/Anaconda3-2020.11-Windows-x86_64.exe"
    start Anaconda3-2020.11-Windows-x86_64.exe
    echo. && echo.
    cls
    echo Please rerun setup.bat 
    pasue > NUL 
    exit
    
) 


if /i "%opt%"=="n" (
    echo. && echo. && echo. 
    where python > NUL || echo There seems to be no python environment on this PC. Please install anaconda3 for your convenience. && goto :conda_not_found     
    echo Detected python environment on this PC at :
    where python 
    echo. && echo. 
    set /p PyPath="Please copy-paste one of these python.exe you would like to use: "
    echo. && echo.
    echo Python path set to "!PyPath!"
    set /p confirm="Is this correct? [y/n]" 
    if /i "!confirm!"=="y" goto :create_config 
    else goto :conda_not_found    
)

:invalid_input
cls 
pause 
goto :conda_not_found


:create_config 
echo %PyPath% > config.ini  


:install_requirments
echo. && echo. && echo. 
echo Start installing all required pakages...
echo. && echo. && echo. 
%PyPath% -m pip install -r requirements.txt 



:finish
echo. && echo. && echo. 
echo Upon successful installation of all pacakges above,
echo you can now execute run.bat
pause 
cls 
echo Configuration finished. Press any key to exit... 
endLocal
pause > NUL 


