@echo off


:: Glboal varaibles 
setlocal EnableDelayedExpansion
echo Preparing environment...
chcp 936
set "sep===================================================================================================================="
set root="%~dp0" 
echo Working directory set to %root%
:: needs to be modified!
set "python=C:\Users\pixin\anaconda3\python.exe"
@REM set "python=%root%PyBin\python.exe"

echo Using %python% as python
pause
cls 

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
echo                                                  Welcome to Bili-Impression!
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


:user_query 
set query=""
set /p query="Please input a topic word: "
if %query% == "" (
    echo Please input a non-empty string ^:^) 
    goto :user_query
)


:select_order
echo %sep%
echo. & echo  [*] How would your like to order the search results?
      echo    ^|
      echo    ^|-- [1] Total Rank  
      echo    ^|
      echo    ^|-- [2] Most Click
      echo    ^|
      echo    ^|-- [3] Publication Date
      echo    ^|
      echo    ^|-- [4] Most Danmaku
      echo    ^|
      echo    ^|-- [5] Most Favortie
      echo.
echo %sep%

set /p order="Please input a number (recommended setting - 4): "


if not DEFINED order (cls && goto :select_order)

set "matched=0"
for /l %%i in (1,1,5) do (
    if !order!==%%i set "matched=1"
)
if %matched%==0 (
    cls
    goto :select_order
)


:select_subarea
cls 
echo %sep%
echo. & echo  [*] How would you specify the subarea for this query?
      echo    ^|
      echo    ^|-- [0] All Subarea (choose this if you have no clue)
      echo    ^|
      echo    ^|-- [1] Animation
      echo    ^|
      echo    ^|-- [2] Bangumi
      echo    ^|
      echo    ^|-- [3] Domestic
      echo    ^|
      echo    ^|-- [4] Music
      echo    ^|
      echo    ^|-- [5] Dance 
      echo    ^|
      echo    ^|-- [6] Game
      echo    ^|
      echo    ^|-- [7] Knowledge
      echo    ^|
      echo    ^|-- [8] Digtital Tech
      echo    ^|
      echo    ^|-- [9] Lifestyle
      echo    ^|
      echo    ^|-- [10] Food
      echo    ^|
      echo    ^|-- [11] Autotune Remix
      echo    ^|
      echo    ^|-- [12] Fashion
      echo    ^|
      echo    ^|-- [13] News
      echo    ^|
      echo    ^|-- [14] Entertainment
      echo    ^|
      echo    ^|-- [15] Television
      echo    ^|
      echo    ^|-- [16] Documentary 
      echo    ^|
      echo    ^|-- [17] Film and Movie
      echo    ^|
      echo    ^|-- [18] TV Series
      echo.
echo %sep%

set /p spec="Please choose one from above: "
if not DEFINED spec (cls && goto :select_subarea)
set "matched=0"
for /l %%i in (0,1,18) do (
    if !spec!==%%i set "matched=1"
)
if %matched%==0 (
    cls
    goto :select_subarea
)



:set_max_pages
cls
set max_pages=""
set /p max_pages="How many pages of results from bilibil would you like to consider (default 1) ? : "
if %max_pages% == "" set "max_pages=1"
if %max_pages% leq 0 (
    echo Please input a positive integer.
    goto :set_max_pages
)  

:program_begin 
echo Program start! 
mkdir corpus > NUL
echo %sep% 
echo.
%python% build_corpus.py %query% %max_pages% %order% %spec%


mkdir wordclouds > NUL
%python% wordcloud_generator.py %query% 
pause > NUL

cls
echo %sep%
echo Thank you for using Bili-Impression! 
echo Press any key to finish the program. 
pause > NUL
endLocal
exit /b