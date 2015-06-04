::===================================================================== 
:: Name:           KDFE.CMD 
:: 
:: Purpose:        Kernel debugger Front End. 
:: 
:: Usage:          kdfe.cmd [dump_file] [-v] 
:: 
:: Version:        1.1 
:: 
:: Technology:     Windows Command Script 
:: 
:: Requirements:   Windows 2000+ 
::                 Debugging Tools for Windows 
::                 reg.exe: 
::                     Windows XP: built-in 
::                     Windows 2000: install Windows Support Tools 
:: 
:: Authors:        Alexander Suhovey (asuhovey@gmail.com) 
::===================================================================== 
@echo off 
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION 
if "%~1"=="-debug" (echo on&set debug=1&shift /1) 
set sver=1.1 
echo. 

::========================== 
:: Variables 
::========================== 

::Kernel debugger path. Default is: 
::For version 6.8.4.0 - October 18, 2007 and older
::C:\Program Files\Debugging Tools for Windows 

::For version 6.9.3.113 - April 29, 2008 and newer
:: C:\Program Files\Debugging Tools for Windows (õ86)
set dbgpath=C:\Program Files\Debugging Tools for Windows (x86)

::Symbols and executable images folders. If folders do not contain 
:: required files, kd.exe will download them from Microsoft Symbols 
:: Server as needed. 
set smbpath=c:\symbols 
set imgpath=%smbpath% 

::Microsoft Symbols Server URL. 
set smburl=http://msdl.microsoft.com/download/symbols 
set imgurl=%smburl% 

::Windows Crash Control registry settings path. 
set ccregpath="HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" 

::Debugger parameters. 
set dbgparams=-y srv*"%smbpath:"=%"*%smburl% -i srv*"%imgpath:"=%"*%imgurl% -c 
if "%debug%"=="1" ( 
    set dbgparams=%dbgparams% "^^^!sym noisy; .reload; ^^^!analyze -v; q" 
) else ( 
     set dbgparams=%dbgparams% "^^^!analyze -v; q" 
) 

::========================== 
:: Parse arguments 
::========================== 
set dumpfile=&set v=& 
:PARSE 
set arg=%~1& 
shift /1 
if not defined arg goto NEXT 
if defined v (if defined dumpfile goto NEXT) 
if "%arg%"=="/?" (goto SYNTAX) else (if "%arg%"=="-?" goto SYNTAX) 
if "%arg%"=="-v" (set verbose=1&goto PARSE) 
if not defined dumpfile (set dumpfile="%arg%"&goto PARSE) 
:NEXT 

::========================== 
:: Checks 
::========================== 
set dbgpath=%dbgpath:"=%
for %%i in (reg.exe,"%dbgpath%\kd.exe") do ( 
    if "%%~$PATH:i"=="" ( 
        if not exist %%i ( 
            echo ERROR: Cannot find required file '%%~i' 
            goto :EOF 
        ) 
    ) 
) 

::========================== 
:: Main section 
::========================== 
set /a n=0 
if defined dumpfile ( 
    if exist !dumpfile! ( 
        for %%z in (!dumpfile!) do (set dumpfile="%%~dpnxz") 
        call :ANALYZE !dumpfile! %verbose% 
    ) else ( 
        echo ERROR: Cannot find dump file !dumpfile! 
    ) 
) else ( 
    for /f "tokens=2*" %%i in ('reg query %ccregpath% /v DumpFile 2^>^&1 ^| find "DumpFile"') do set kdump=%%j 
    for /f "tokens=2*" %%k in ('reg query %ccregpath% /v MinidumpDir 2^>^&1 ^| find "MinidumpDir"') do set minidir=%%l 
    if "!kdump!!minidir!"=="" echo ERROR: Cannot find required registry information^^!&goto :EOF 
    call :ENUMD "!kdump!" "!minidir!" 
    if !n!==0 ( 
        echo No crash dump files found with following search filter: 
        echo !kdump! 
        echo !minidir!\*.dmp 
    ) else ( 
        echo Following crash dump files found: 
        echo. 
        for /l %%n in (1,1,!n!) do (call :GETD %%n& echo %%n. !dumpfile!) 
        echo. 
        set /p foo="Which one would you like to analyze?[1-!n!] " 
        for /l %%s in (1,1,!n!) do ( 
            if !foo!==%%s ( 
                call :GETD %%s 
                call :ANALYZE !dumpfile! %verbose% 
                goto :EOF 
            ) 
        ) 
        echo. 
        echo What was that? Have some coffee and try again. 
    ) 
) 
goto :EOF 

::========================== 
:: Subroutines 
::========================== 
:ANALYZE 
pushd "%dbgpath%" 
if "%2"=="1" (kd.exe -z %1 %dbgparams% 2>&1) else ( 
    echo. 
    set /p bar="Analyzing %1, please wait..."<nul 
    for /f "delims=" %%r in ('kd.exe -z %1 %dbgparams% 2^>^&1') do ( 
        set out=%%r 
        if not "!out:PROCESS_NAME:=!"=="!out!" (set process=!out:PROCESS_NAME:  =!) 
        if not "!out:BUGCHECK_STR:=!"=="!out!" (set crashcode=!out:BUGCHECK_STR:  =!) 
        if not "!out:Debug session=!"=="!out!" (set crashdate=!out:Debug session time: =!) 
        if "!out:~0,18!"=="Probably caused by" (set guess=%%r) 
    ) 
    echo  Done.&echo. 
    if defined guess ( 
        echo. 
        echo Crash date:         !crashdate! 
        echo Stop error code:    !crashcode! 
        if defined process echo Process name:       !process! 
        echo !guess: :=:! 
    ) else ( 
        echo Didn't find the answer. Try again with '-v' switch. 
    ) 
) 
popd 
goto :EOF 

:ENUMD 
if exist %1 (set /a n+=1&set !n!=%1) 
for %%m in ("%~2\*.dmp") do (set /a n+=1&set !n!="%%m") 
goto :EOF 

:GETD 
for /f "tokens=2 delims==" %%o in ('set %1 ^| find "%1="') do (set dumpfile=%%o&goto :EOF) 
goto :EOF 

:SYNTAX 
echo. 
echo Kernel Debugger Front End v%sver% 
echo. 
echo SYNTAX: 
echo. 
echo   %~nx0 [dump_file] [-v] 
echo. 
echo   dump_file  - Crash dump file. If omitted, KDFE will search for crash 
echo                dump files in locations configured on your computer and 
echo                let you select a file to analyze. 
echo   -v         - Verbose output. By default KDFE shows only basic crash 
echo                information and debugger's guess about crash cause. 
echo                This switch will show full debugger session output. 
echo. 
echo EXAMPLES: 
echo. 
echo   %~nx0 "c:\my dumps\memory.dmp" -v 
echo. 
echo REQUIREMENTS: 
echo. 
echo   Debugging Tools for Windows 
echo. 
echo REFERENCES: 
echo. 
echo Debugging Tools for Windows: 
echo   http://www.microsoft.com/whdc/devtools/debugging/default.mspx 
echo. 
echo Windows Hang and Crash Dump Analysis webcast by Mark Russinovich: 
echo   http://msevents.microsoft.com/CUI/WebCastEventDetails.aspx?EventID=1032298075 
echo. 
echo How to read small memory dump files: 
echo   http://support.microsoft.com/kb/315263 
echo. 
echo How to Use Driver Verifier to Troubleshoot Windows Drivers: 
echo   http://support.microsoft.com/Default.aspx?kbid=244617 
goto :EOF 

::========================== 
:: End of script 
::==========================