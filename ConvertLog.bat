@echo off

SETLOCAL EnableDelayedExpansion

set currPath=%~dp0
set month=%DATE:~3,2%
set year=%DATE:~8,2%

if "%month%" == "01" set prevMonth=12&& set /a prevYear=%year%-1
if "%month%" == "02" set prevMonth=01&& set /a prevYear=%year%
if "%month%" == "03" set prevMonth=02&& set /a prevYear=%year%
if "%month%" == "04" set prevMonth=03&& set /a prevYear=%year%
if "%month%" == "05" set prevMonth=04&& set /a prevYear=%year%
if "%month%" == "06" set prevMonth=05&& set /a prevYear=%year%
if "%month%" == "07" set prevMonth=06&& set /a prevYear=%year%
if "%month%" == "08" set prevMonth=07&& set /a prevYear=%year%
if "%month%" == "09" set prevMonth=08&& set /a prevYear=%year%
if "%month%" == "10" set prevMonth=09&& set /a prevYear=%year%
if "%month%" == "11" set prevMonth=10&& set /a prevYear=%year%
if "%month%" == "12" set prevMonth=11&& set /a prevYear=%year%

for %%m in (%month% %prevMonth%) do (
  for %%y in (%year% %prevYear%) do (
    if exist "%currPath%Log.??.%%m.20%%y.txt" (
      if not exist "%currPath%%%m%%y" mkdir "%currPath%%%m%%y"
      copy "%currPath%Log.??.%%m.20%%y.txt" "%currPath%%%m%%y\"
    )
  )
)

set logFile=%currPath%FullLog%prevMonth%%prevYear%.csv
if not exist "%logFile%" (
  echo "Date";"Time";"File";"Pages">"%logFile%"
  for %%f in ("%currPath%%prevMonth%%prevYear%\Log*.txt") do (
    for /f "usebackq tokens=*" %%l in ("%%f") do (
      set line=%%l
      if "!line:~20,31!" == "HandlePDFFile: Processing file:" (
        set dateLine=!line:~8,2!/!line:~5,2!/!line:~0,4!
        set timeLine=!line:~11,2!:!line:~14,2!:!line:~17,2!
        set fileLine=!line:~52!
      )
      if "!line:~20,21!" == "HandlePDFFile: pages:" (
        if not "!dateLine!" == "" (
          set pages=!line:~42!
          echo "!dateLine!";"!timeLine!";"!fileLine!";"!pages!">>"%logFile%"
          set dateLine=
        )
      )
    )
  )
)
