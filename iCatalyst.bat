@echo off

::Lorents & Res2001 2010-2015

setlocal enabledelayedexpansion
set "name=Image Catalyst"
set "version=2.6"
set "spacebar=-------------------------------------------------------------------------------"
if "%~1" equ "thrd" call:threadwork %4 %5 "%~2" "%~3" & exit /b
if "%~1" equ "updateic" call:icupdate & exit /b
if "%~1" equ "" call:helpmsg & exit /b
title %name% %version%
set "fullname=%~0"
set "scrpath=%~dp0"
set "sconfig=%scrpath%Tools\"
set "scripts=%scrpath%Tools\scripts\"
set "tmppath=%TEMP%\iCatalyst\"
set "errortimewait=30"
set "iclock=%TEMP%ic.lck"
set "LOG=%scrpath%\iCatalyst"
set "runic="
call:runic "%name% %version%"
if defined runic (
	call:clearscreen
	title [Waiting] %name% %version%
	1>&2 echo.%spacebar%
	1>&2 echo. Attention: running %runic% of %name%.
	1>&2 echo.
	1>&2 echo. Press Enter to continue.
	1>&2 echo.%spacebar%
	1>nul pause
	call:clearscreen
)
set "LOG=%LOG%%runic%"
if not defined runic if exist "%tmppath%" 1>nul 2>&1 rd /s /q "%tmppath%"
set "apps=%~dp0Tools\apps\"
PATH %apps%;%PATH%
set "nofile="
set "num=0"
for %%a in (
	"%sconfig%config.ini"
	"%apps%advdef.exe"
	"%apps%deflopt.exe"
	"%apps%dlgmsgbox.exe"
	"%apps%gifsicle.exe"
	"%apps%jpegstripper.exe"
	"%apps%jpginfo.exe"
	"%apps%jpegtran.exe"
	"%apps%pngwolfzopfli.exe"
	"%apps%truepng.exe"
	"%scripts%filter.js"
	"%scripts%update.js"
) do (
	if not exist "%%~a" (
		set /a "num+=1"
		if !num! gtr 20 set "nofile=!nofile!..." & goto:filelisterr
		set "nofile=!nofile!"%%~a" "
	)
)

:filelisterr
if defined nofile (
	call:clearscreen
	title [Error] %name% %version%
	if exist "%tmppath%" 1>nul 2>&1 rd /s /q "%tmppath%"
	1>&2 echo.%spacebar%
	1>&2 echo. Application can not get access to the following files:
	1>&2 echo.
	for %%j in (%nofile%) do 1>&2 echo. - %%~j
	1>&2 echo.
	1>&2 echo. Check permissions and try again.
	1>&2 echo.%spacebar%
	call:dopause & exit /b
)

:settemp
set "rnd=%random%"
if not exist "%tmppath%%rnd%\" (
	set "tmppath=%tmppath%%rnd%"
	1>nul 2>&1 md "%tmppath%%rnd%" || (
		call:errormsg "Can not create temporary directory:^|%tmppath%%rnd%!"
		exit /b
	)
) else (
	goto:settemp
)
for %%a in (JPG PNG GIF) do (
	set "ImageNum%%a=0"
	set "TotalNum%%a=0"
	set "TotalNumErr%%a=0"
	set "TotalSize%%a=0"
	set "STotalSize%%a=0"
	set "ImageSize%%a=0"
	set "SImageSize%%a=0"
	set "change%%a=0"
	set "perc%%a=0"
	set "step%%a=0"
	set "step10%%a=1000"
	set "stepB%%a=1"
)
set "png="
set "jpeg="
set "gif="
set "perr="
set "stime="
set "ftime="
set "updateurl=http://x128.ho.ua/update.ini"
set "configpath=%~dp0\Tools\config.ini"
set "logfile=%tmppath%\Images"
set "iculog=%tmppath%\icu.log"
set "iculck=%tmppath%\icu.lck"
set "countPNG=%tmppath%\countpng"
set "countJPG=%tmppath%\countjpg"
set "countGIF=%tmppath%\countgif"
set "filelist=%tmppath%\filelist"
::For Images with characters		-	%filelisterr%
::For Images are already optimized	-	%filelisterr%1
::For Images are not supported		-	%filelisterr%2<num thread>
::For Images are not found		-	%filelisterr%3<num thread>
set "filelisterr=%tmppath%\filerr"
::Table size
set "TFN=31"
set "KB=1024"
set /a "MB=KB*KB"
set /a "GB=MB*KB"
::restrictions in bytes (default - 100Mb)
set /a "BYTECONV=100*%MB%"

set "thread=" & set "updatecheck=" & set "outdir=" & set "nooutfolder="
set "jpegtags=" & set "xtreme=" & set "advanced=" & set "pngtags=" & set "giftags="
call:readini "%configpath%"
call:sethread %thread%
set "updatecheck=%update%" & set "update="
if /i "%giftags%" equ "true" (set "giftags=--no-comments --no-extensions --no-names") else (set "giftags=")
call set "outdir=%outdir%"
call:paramcontrol %*
if defined perr (
	call:clearscreen
	title [Error] %name% %version%
	if exist "%tmppath%" 1>nul 2>&1 rd /s /q "%tmppath%"
	1>&2 echo.%spacebar%
	1>&2 echo. Unknown %perr% setting value.
	call:helpmsg & exit /b
)
if "%png%" equ "0" if "%jpeg%" equ "0" if "%gif%" equ "0" goto:endsetcounters
set "oparam="
if not defined jpeg if not defined png if not defined gif (
	set "oparam=/JPG:1 /PNG:1 /GIF:1"
)
if /i "%outdir%" equ "false" (set "outdir=" & set "nooutfolder=yes") else if /i "%outdir%" equ "true" set "outdir="
if not defined nooutfolder if not defined outdir (
	call:clearscreen
	title [Loading] %name% %version%
	for /f "tokens=* delims=" %%a in ('dlgmsgbox "Image Catalyst" "Folder3" " " "Choose directory to save images to. Click 'Cancel' to replace original images with optimized versions." ') do set "outdir=%%~a"
)
if defined outdir (
	if "!outdir:~-1!" neq "\" set "outdir=!outdir!\"
	if not exist "!outdir!" (
		1>nul 2>&1 md "!outdir!" || (
		call:errormsg "Can not create directory for optimized files: !outdir!"
		exit /b
		)
	)
	for /f "tokens=* delims=" %%a in ("!outdir!") do set outdirparam="/Outdir:%%~a"
) else (
	set "outdirparam="
)
call:clearscreen
title [Loading] %name% %version%
echo.%spacebar%
echo. Loading. Please wait...
echo.%spacebar%
cscript //nologo //E:JScript "%scripts%filter.js" %oparam% %outdirparam% %* 1>"%filelist%" 2>"%filelisterr%"

:setcounters
if exist "%filelist%" (
	if "%png%" neq "0" for /f "tokens=*" %%a in ('findstr /i /e ".png"  "%filelist%" ^| find /i /c ".png" 2^>nul') do set /a "TotalNumPNG+=%%a"
	if "%jpeg%" neq "0" for /f "tokens=*" %%a in ('findstr /i /e ".jpg"  "%filelist%" ^| find /i /c ".jpg" 2^>nul') do set /a "TotalNumJPG+=%%a"
	if "%jpeg%" neq "0" for /f "tokens=*" %%a in ('findstr /i /e ".jpe"  "%filelist%" ^| find /i /c ".jpe" 2^>nul') do set /a "TotalNumJPG+=%%a"
	if "%jpeg%" neq "0" for /f "tokens=*" %%a in ('findstr /i /e ".jpeg" "%filelist%" ^| find /i /c ".jpeg" 2^>nul') do set /a "TotalNumJPG+=%%a"
	if "%gif%" neq "0" for /f "tokens=*" %%a in ('findstr /i /e ".gif"  "%filelist%" ^| find /i /c ".gif" 2^>nul') do set /a "TotalNumGIF+=%%a"
)
if %TotalNumPNG% gtr 0 (if not defined png call:png) else set "png=0"
if %TotalNumJPG% gtr 0 (if not defined jpeg call:jpeg) else set "jpeg=0"
if %TotalNumGIF% gtr 0 (if not defined gif call:gif) else set "gif=0"
if exist "%filelisterr%" (
	if defined png  for /f "tokens=* delims=" %%a in ('findstr /i /e ".png"  "%filelisterr%" ^| find /i /c ".png" 2^>nul') do set /a "TotalNumErrPNG+=%%a"
	if defined jpeg for /f "tokens=* delims=" %%a in ('findstr /i /e ".jpg"  "%filelisterr%" ^| find /i /c ".jpg" 2^>nul') do set /a "TotalNumErrJPG+=%%a"
	if defined jpeg for /f "tokens=* delims=" %%a in ('findstr /i /e ".jpe"  "%filelisterr%" ^| find /i /c ".jpe" 2^>nul') do set /a "TotalNumErrJPG+=%%a"
	if defined jpeg for /f "tokens=* delims=" %%a in ('findstr /i /e ".jpeg" "%filelisterr%" ^| find /i /c ".jpeg" 2^>nul') do set /a "TotalNumErrJPG+=%%a"
	if defined gif  for /f "tokens=* delims=" %%a in ('findstr /i /e ".gif"  "%filelisterr%" ^| find /i /c ".gif" 2^>nul') do set /a "TotalNumErrGIF+=%%a"
)

:endsetcounters
if %TotalNumPNG% equ 0 if %TotalNumJPG% equ 0 if %TotalNumGIF% equ 0 (
	call:clearscreen
	1>&2 echo.%spacebar%
	1>&2 echo. No images found. Please check input and try again.
	call:helpmsg
	exit /b
)
for /l %%a in (1,1,%thread%) do (
	>"%logfile%png.%%a" echo.
	>"%logfile%jpg.%%a" echo.
	>"%logfile%gif.%%a" echo.
)
call:clearscreen
echo.%spacebar%
echo. File Name                      ^| Original ^| Optimized ^|  Savings  ^| %% Savings
echo.                                ^| Size     ^| Size      ^|           ^|
echo.%spacebar%
if /i "%updatecheck%" equ "true" start "" /b cmd.exe /c ""%fullname%" updateic"
call:setitle
call:setvtime stime
for /f "usebackq tokens=1,2 delims=	" %%a in ("%filelist%") do (
	call:initsource "%%~a"
	if defined ispng if "%png%" neq "0" call:filework "%%~fa" "%%~fb" png %thread% ImageNumPNG
	if defined isjpeg if "%jpeg%" neq "0" call:filework "%%~fa" "%%~fb" jpg %thread% ImageNumJPG
	if defined isgif if "%gif%" neq "0" call:filework "%%~fa" "%%~fb" gif %thread% ImageNumGIF
)

:waithread
call:waitflag "%tmppath%\thrt*.lck"
for /l %%z in (1,1,%thread%) do (
	call:typelog png %%z
	call:typelog jpg %%z
	call:typelog gif %%z
)
echo.%spacebar%
call:setitle
call:end
call:dopause & exit /b

:paramcontrol
if "%~1" equ "" exit /b
set "tt=%~1"
if "!tt:~,1!" equ "/" (
	if /i "!tt:~1,4!" equ "JPG:" (
		set "jpeg=!tt:~5!"
		if "!jpeg!" neq "0" if "!jpeg!" neq "1" if "!jpeg!" neq "2" if "!jpeg!" neq "3" (
			set "jpeg=0" & set "perr=JPG"
		)
		if not defined png set "png=0"
		if not defined gif set "gif=0"
	) else if /i "!tt:~1,4!" equ "PNG:" (
		set "png=!tt:~5!"
		if "!png!" neq "0" if "!png!" neq "1" if "!png!" neq "2" (
			set "png=0" & set "perr=PNG"
		)
		if not defined jpeg set "jpeg=0"
		if not defined gif set "gif=0"
	) else if /i "!tt:~1,4!" equ "GIF:" (
		set "gif=!tt:~5!"
		if "!gif!" neq "0" if "!gif!" neq "1" (
			set "gif=0" & set "perr=GIF"
		)
		if not defined png set "png=0"
		if not defined jpeg set "jpeg=0"
	) else if /i "!tt:~1,7!" equ "Outdir:" (
		set "outdir=!tt:~8!"
	)
)
shift
goto:paramcontrol

:runningcheck
call:runic "%~1"
set "lastrunic=%runic%"
if defined runic (
	title [Waiting] %name% %version%
	echo.Another process %name% is running. Waiting for it to shut down.
	call:runningcheck2 "%~1"
)
exit /b

:runningcheck2
2>nul (3>"%iclock%" 1>&3 call:runic2 "%~1" || (call:waitrandom 5000 & goto:runningcheck2))
exit /b

:runic
set "runic="
for /f "tokens=* delims=" %%a in ('tasklist /fo csv /v /nh ^| find /i /c "%~1" ') do (
	if %%a gtr 1 set "runic=%%a"
)
exit /b

:setvtime
set "%1=%date% %time:~0,2%:%time:~3,2%:%time:~6,2%"
exit /b

:icupdate
if not exist "%scripts%update.js" exit /b
>"%iculck%" echo.Update IC
cscript //nologo //E:JScript "%scripts%update.js" %updateurl% 2>nul 1>"%iculog%" || 1>nul 2>&1 del /f /q "%iculog%"
1>nul 2>&1 del /f /q "%iculck%"
exit /b

::%1 - png | jpg | gif
::%2 - %thread%
::%3 - input file
::%4 - output file
:createthread
if %2 equ 1 call:threadwork %1 1 %3 %4 & call:typelog %1 1 & exit /b
for /l %%z in (1,1,%2) do (
	if not exist "%tmppath%\thrt%%z.lck" (
		call:typelog %1 %%z
		>"%tmppath%\thrt%%z.lck" echo. Image processing: %3
		start /b /LOW /MIN cmd.exe /s /c ""%fullname%" thrd "%~3" "%~4" %1 %%z"
		exit /b
	)
)
call:waitrandom 500
goto:createthread

::%1 - png | jpg | gif
::%2 - thread number
:typelog
if %thread% equ 1 exit /b
if not defined typenum%~1%~2 set "typenum%~1%~2=1"
if not exist "%logfile%%1.%2" exit /b
set "tmpskip=!typenum%~1%~2!"
for /f "usebackq skip=%tmpskip% tokens=1-5 delims=;" %%b in ("%logfile%%1.%2") do (
	call:stepcalc %~1 %%c %%d
	call:printfileinfo "%%~b" %%c %%d %%e %%f %~1
	set /a "typenum%~1%~2+=1"
)
exit /b

::%1 - file name
::%2 - original size in byte
::%3 - optimize size in byte
::%4 - change (%2 - %3)
::%5 - percent change (%4*100/%2)
::%6 - png | jpg | gif
:printfileinfo
setlocal  
set "fn="
call:cropfilename fn "%~1" %TFN%
set "origsize=%~2"
set "optsize=%~3"
set "measure="
call:prepsize origsize measure
call:prepsize2 optsize measure
set /a "change=%~4"
set "origsize=          %origsize% %measure%"
set "optsize=          %optsize% %measure%"
call:prepsize change measure
set "change=           %change% %measure%"
set "percent=          %~5%%"
echo. !fn:~,%TFN%!^|%origsize:~-10%^|%optsize:~-11%^|%change:~-11%^|%percent:~-10%
endlocal
exit /b

::%1 - variable name for number (in/out)
::%2 - cariable name for measure (out)
:prepsize
setlocal
set "var=!%~1!"
set "sign="
if "%var:~,1%" equ "-" (set "sign=-" & set "var=%var:~1%")
set "meas=B"
if %var% geq %GB% (set "meas=GB" & goto:GBprepsize)
if %var% geq %MB% (set "meas=MB" & goto:MBprepsize)
if %var% geq %KB% (set "meas=KB" & goto:KBprepsize)
goto:finprepsize
::%1 - variable name for number (in/out)
::%2 - cariable name for measure (in/out)
:prepsize2
if not defined %~2 exit /b
setlocal
set "var=!%~1!"
set "sign="
if "%var:~,1%" equ "-" (set "sign=-" & set "var=%var:~1%")
set "meas=!%~2!"
if "%meas%" equ "KB" goto:KBprepsize
if "%meas%" equ "B" goto:finprepsize
if "%meas%" equ "MB" goto:MBprepsize
if "%meas%" equ "GB" goto:GBprepsize
goto:finprepsize
:GBprepsize
call:division var %GB% 100 & goto:finprepsize
:MBprepsize
call:division var %MB% 100 & goto:finprepsize
:KBprepsize
call:division var %KB% 100 & goto:finprepsize
:Bprepsize
call:division var 1 100
:finprepsize
endlocal & set "%~1=%sign%%var%" & set "%~2=%meas%"
exit /b

::%1 - number of 100%
::%2 - number, which is necessary to calculate the percentage
::%3 - variable name for save result
:perccalc
setlocal
::echo.%~0: %*
set "change=%~2"
set "sign="
if "%change:~,1%" equ "-" (set "sign=-" & set "change=%change:~1%")
set /a "perc=%change%*100/%~1" 2>nul
set /a "fract=%change%*100%%%~1*100/%~1" 2>nul
set /a "perc=%perc%*100+%fract%"
call:division perc 100 100
endlocal & set "%~3=%sign%%perc%"
exit /b

::%1 - file name
::%2 - error message
:printfileerr
setlocal
set "fn=%~nx1                                        "
set "errmsg=%~2"
call:centerstring errmsg 45
1>&2 echo. %fn:~,30%^|%errmsg%
endlocal
exit /b

::%1 - variable containing file name
::%2 - file name in %1
::%3 - max length file name
:cropfilename
setlocal  
set "xfn=%~nx2"
set "xfnext=%~x2"
set "xfnlen=0"
set "xfnextlen=0"
call:strlen xfn xfnlen
call:strlen xfnext xfnextlen
set /a "xfnextlen=%3-%xfnextlen%-2"
if %xfnlen% gtr %3 (
	call set "xfn=%%xfn:~,%xfnextlen%%%..%xfnext%"
) else (
	set "xfn=%xfn%                                        "
	set "xfn=!xfn:~,%3!"
)
endlocal & set "%~1=%xfn%"
exit /b

:centerstring StrVar Length
if "%~1" equ "" exit /b
if not defined %~1 exit /b
setlocal
set "xstringlen=0"
set "xstr=!%~1!"
call:strlen xstr xstringlen
set "xstradd=                                                                                                    "
set /a "xstraddlen=(%~2-%xstringlen%)/2"
set "xstradd=!xstradd:~,%xstraddlen%!"
if %xstringlen% geq %~2 (
	set "xstr=!xstr:~,%~2!"
) else (
	set "xstr=!xstradd!%xstr%!xstradd!"
	set /a "xstraddlen=xstringlen+xstraddlen*2"
	if !xstraddlen! lss %~2 set "xstr= !xstr!"
)
endlocal & set "%~1=%xstr%"
exit /b

::original: http://forum.script-coding.com/viewtopic.php?pid=71000#p71000
:strlen  StrVar  RtnVar  --  be sure to check if the returned errorlevel is 0
setlocal
set /a "}=0"
if "%~1" neq "" if defined %~1 (
        for %%# in (4096 2048 1024 512 256 128 64 32 16) do (
            if "!%~1:~%%#,1!" neq "" set "%~1=!%~1:~%%#!" & set /a "}+=%%#"
        )
        set "%~1=!%~1!0FEDCBA9876543211" & set /a "}+=0x!%~1:~32,1!!%~1:~16,1!"
    )
)
endlocal & set /a "%~2=%}%"
exit /b

::%1 - png | jpg | gif
::%2 - thread number
::%3 - input file
::%4 - output file
:threadwork
1>nul 2>&1 md "%~dp4"
if /i "%1" equ "png" call:pngfilework %2 %3 %4 & if %thread% gtr 1 >>"%countPNG%.%2" echo.1
if /i "%1" equ "jpg" call:jpegfilework %2 %3 %4 & if %thread% gtr 1 >>"%countJPG%.%2" echo.1
if /i "%1" equ "gif" call:giffilework %2 %3 %4 & if %thread% gtr 1 >>"%countGIF%.%2" echo.1
if exist "%tmppath%\thrt%2.lck" >nul 2>&1 del /f /q "%tmppath%\thrt%2.lck"
exit /b

:waitflag
if not exist "%~1" exit /b
call:waitrandom 2000
goto:waitflag

:waitrandom
setlocal
set /a "ww=%random%%%%1"
1>nul 2>&1 ping -n 1 -w %ww% 127.255.255.255
endlocal & exit /b

:initsource
set "isjpeg="
set "ispng="
set "isgif="
if /i "%~x1" equ ".png" set "ispng=1"
if /i "%~x1" equ ".jpg" set "isjpeg=1"
if /i "%~x1" equ ".jpeg" set "isjpeg=1"
if /i "%~x1" equ ".jpe" set "isjpeg=1"
if /i "%~x1" equ ".gif" set "isgif=1"
exit /b

:sethread
set /a "thread=%~1+1-1"
if "%~1" neq "" if "%~1" neq "0" set "thread=%~1" & exit /b
if %thread% equ 0 set "thread=%NUMBER_OF_PROCESSORS%"
exit /b

:png
call:clearscreen
set "png="
title [PNG] %name% %version%
echo. ----------------------
echo. PNG optimization mode:
echo. ----------------------
echo.
echo. [1] Advanced
echo.
echo. [2] Xtreme
echo.
echo. [0] Skip
echo.
echo. ------------------------------------
set /p png="#Select mode and press Enter [0-2]: "
echo. ------------------------------------
echo.
if "%png%" neq "0" if "%png%" neq "1" if "%png%" neq "2" goto:png
exit /b

:jpeg
call:clearscreen
set "jpeg="
title [JPEG] %name% %version%
echo. ----------------------
echo. JPEG otimization mode:
echo. ----------------------
echo.
echo. [1] Baseline
echo.
echo. [2] Progressive
echo.
echo. [3] Default
echo.
echo. [0] Skip
echo.
echo. ------------------------------------
set /p jpeg="#Select mode and press Enter [0-3]: "
echo. ------------------------------------
echo.
if "%jpeg%" neq "0" if "%jpeg%" neq "1" if "%jpeg%" neq "2" if "%jpeg%" neq "3" goto:jpeg
exit /b

:gif
call:clearscreen
set "gif="
title [GIF] %name% %version%
echo. ----------------------
echo. GIF optimization mode:
echo. ----------------------
echo.
echo. [1] Default
echo.
echo. [0] Skip
echo.
echo. ------------------------------------
set /p gif="#Select mode and press Enter [0-1]: "
echo. 
echo.
if "%gif%" neq "0" if "%gif%" neq "1" goto:gif
exit /b

:setitle
if "%jpeg%" equ "0" if "%png%" equ "0" if "%gif%" equ "0" (title %~1%name% %version% & exit /b)
if %thread% gtr 1 (
	set "ImageNumPNG=0" & set "ImageNumJPG=0" & set "ImageNumGIF=0"
	for /l %%c in (1,1,%thread%) do  (
		for %%b in ("%countPNG%.%%c") do set /a "ImageNumPNG+=%%~zb/3" 2>nul
		for %%b in ("%countJPG%.%%c") do set /a "ImageNumJPG+=%%~zb/3" 2>nul
		for %%b in ("%countGIF%.%%c") do set /a "ImageNumGIF+=%%~zb/3" 2>nul
	)
)
setlocal
if %png% equ 1  (set "pngtitle=Advanced")
if %png% equ 2  (set "pngtitle=Xtreme")
if %jpeg% equ 1 (set "jpegtitle=Baseline")
if %jpeg% equ 2 (set "jpegtitle=Progressive")
if %jpeg% equ 3 (set "jpegtitle=Default")
if %gif% equ 1  (set "giftitle=Default")
set "titlestr="
set "tmpn=0"
if %png% gtr 0  (
	set /a "perc=%ImageNumPNG%*100/%TotalNumPNG%"
	set "titlestr=PNG %pngtitle%: !perc!%%"
)
if %jpeg% gtr 0 (
	set /a "perc=%ImageNumJPG%*100/%TotalNumJPG%"
	if %png% gtr 0 set "titlestr=%titlestr% ^| "
	set "titlestr=!titlestr!JPG %jpegtitle%: !perc!%%"
)
if %gif% gtr 0 (
	set /a "perc=%ImageNumGIF%*100/%TotalNumGIF%"
	set /a "tmpn=%jpeg%+%png%"
	if !tmpn! gtr 0 (set "titlestr=%titlestr% ^| ")
	set "titlestr=!titlestr!GIF %giftitle%: !perc!%%"
)
title [%titlestr%] %name% %version%
endlocal & exit /b

::%1 - input file
::%2 - output file
::%3 - png | jpg | gif
::%4 - %thread%
::%5 - ImageNum(PNG|JPG|GIF)
:filework
call:createthread %3 %4 "%~f1" "%~f2"
set /a "%5+=1"
call:setitle
exit /b

::%1 - thread number
::%2 - input file
::%3 - output file
:pngfilework
set "zc="
set "zm="
set "zs="
set "psize=%~z2"
set "errbackup=0"
set "logfile2=%logfile%png.%1"
set "pnglog=%tmppath%\png%1.log"
set "filework=%tmppath%\%~n2-ic%1%~x2"
if not exist "%~2" (
	call:saverrorlog "%~f2" 3 %~1 PNG
	exit /b 1
)
if %png% equ 2 (
	>"%pnglog%" 2>nul truepng -y -i0 -zw7 -zc7 -zm5-9 -zs0,1,3 -f0,5 -fs:1 %xtreme% -force -out "%filework%" "%~2"
	if errorlevel 1 (call:saverrorlog "%~f2" 2 %~1 PNG & goto:pngfwe)
	for /f "tokens=2,4,6,8,10 delims=:	" %%a in ('findstr /r /i /b /c:"zc:..zm:..zs:" "%pnglog%"') do (
		set "zc=%%a"
		set "zm=%%b"
		set "zs=%%c"
	)
	pngwolfzopfli --zopfli-iter=10 --zopfli-maxsplit=0 --zlib-window=15 --zlib-level=!zc! --zlib-memlevel=!zm! --zlib-strategy=!zs! --max-stagnate-time=0 --max-evaluations=1 --in="%filework%" --out="%filework%" 1>nul 2>&1
	if errorlevel 1 (call:saverrorlog "%~f2" 2 %~1 PNG & goto:pngfwe)
)
if %png% equ 1 (
	>"%pnglog%" 2>nul truepng -y -i0 -zw7 -zc7 -zm8-9 -zs0,1,3 -f0,5 -fs:1 %advanced% -force -out "%filework%" "%~2"
	if errorlevel 1 (call:saverrorlog "%~f2" 2 %~1 PNG & goto:pngfwe)
	for /f "tokens=2,4,6,8,10 delims=:	" %%a in ('findstr /r /i /b /c:"zc:..zm:..zs:" "%pnglog%"') do (
		set "zc=%%a"
		set "zm=%%b"
		set "zs=%%c"
	)
	truepng -y -i0 -zw7 -zc!zc! -zm!zm! -zs!zs! -f5 -fs:7 -na -nc -np "%filework%" 1>nul 2>&1
	if errorlevel 1 (call:saverrorlog "%~f2" 2 %~1 PNG & goto:pngfwe)
	advdef -z3 "%filework%" 1>nul 2>&1
	if errorlevel 1 (call:saverrorlog "%~f2" 2 %~1 PNG & goto:pngfwe)
)
deflopt -k "%filework%" 1>nul 2>&1
if errorlevel 1 (call:saverrorlog "%~f2" 2 %~1 PNG & goto:pngfwe)
call:backup2 "%~f2" "%filework%" "%~f3" || set "errbackup=1"
if %errbackup% neq 0 (call:saverrorlog "%~f2" 2 %~1 PNG & goto:pngfwe)
if /i "%pngtags%" equ "true" (1>nul 2>&1 truepng -nz -md remove all "%~3" || (call:saverrorlog "%~f2" 2 %~1 PNG & goto:pngfwe))
call:savelog "%~f3" %psize%
if %thread% equ 1 for %%a in ("%~f3") do (set /a "ImageSizePNG+=%%~za" & set /a "TotalSizePNG+=%psize%")
:pngfwe
1>nul 2>&1 del /f /q "%filework%" "%pnglog%"
exit /b

::%1 - thread number
::%2 - input file
::%3 - output file
:jpegfilework
set "ep="
set "jsize=%~z2"
set "errbackup=0"
set "logfile2=%logfile%jpg.%1"
set "jpglog=%tmppath%\jpg%1.log"
if /i "%~f2" equ "%~f3" (
	set "filework=%tmppath%\%~n2-ic%1%~x2"
) else (
	set "filework=%~f3"
)
if not exist "%~2" (
	call:saverrorlog "%~f2" 3 %~1 JPG
	exit /b 1
)
if %jpeg% equ 1 (
	jpegtran -verbose -revert -optimize -copy all -outfile "%filework%" "%~2" 1>"%jpglog%" 2>&1
	if errorlevel 1 (call:saverrorlog "%~f2" 2 %~1 JPG & goto:jpegfwe)
	for /f "tokens=4,10 delims=:,= " %%a in ('findstr /C:"Start Of Frame" "%jpglog%" 2^>nul') do (set "ep=%%a")
	if "!ep!" equ "0xc0" goto:jpegfwb
	if "!ep!" equ "0xc2" (
		if /i "%~f2" equ "%~f3" (1>nul 2>&1 move /y "%filework%" "%~f3" || set "errbackup=1")
		goto:jpegfwf
	) else (
		call:saverrorlog "%~f2" 2 %~1 JPG & goto:jpegfwe
	)
)
if %jpeg% equ 2 (
	jpegtran -verbose -copy all -outfile "%filework%" "%~2" 1>"%jpglog%" 2>&1
	if errorlevel 1 (call:saverrorlog "%~f2" 2 %~1 JPG & goto:jpegfwe)
	for /f "tokens=4,10 delims=:,= " %%a in ('findstr /C:"Start Of Frame" "%jpglog%" 2^>nul') do (set "ep=%%a")
	if "!ep!" equ "0xc2" goto:jpegfwb
	if "!ep!" equ "0xc0" (
		if /i "%~f2" equ "%~f3" (1>nul 2>&1 move /y "%filework%" "%~f3" || set "errbackup=1")
		goto:jpegfwf
	) else (
		call:saverrorlog "%~f2" 2 %~1 JPG & goto:jpegfwe
	)
)
if %jpeg% equ 3 (
	jpginfo "%~2" 1>"%jpglog%" 2>&1
	if errorlevel 1 (call:saverrorlog "%~f2" 2 %~1 JPG & goto:jpegfwe)
	for /f "usebackq tokens=5" %%a in ("%jpglog%") do set "ep=%%~a"
	if /i "!ep!" equ "Baseline" (
		jpegtran -verbose -revert -optimize -copy all -outfile "%filework%" "%~2" 1>nul 2>&1 &&	goto:jpegfwb
	)
	if /i "!ep!" equ "Progressive" (
		jpegtran -verbose -copy all -outfile "%filework%" "%~2" 1>nul 2>&1 && goto:jpegfwb
	)
	call:saverrorlog "%~f2" 2 %~1 JPG & goto:jpegfwe
)
:jpegfwb
if /i "%~f2" neq "%~f3" (
	call:backup "%filework%" "%~f2" >nul || set "errbackup=1"
) else (
	call:backup "%~f2" "%filework%" true >nul || set "errbackup=1"
)
:jpegfwf
1>nul 2>&1 del /f /q "%jpglog%"
if %errbackup% neq 0 (call:saverrorlog "%~f2" 3 %~1 JPG & goto:jpegfwe)
if /i "%jpegtags%" equ "true" (1>nul 2>&1 jpegstripper -y "%~f3" || (call:saverrorlog "%~f2" 2 %~1 JPG & exit /b))
call:savelog "%~f3" %jsize%
if %thread% equ 1 for %%a in ("%~f3") do (set /a "ImageSizeJPG+=%%~za" & set /a "TotalSizeJPG+=%jsize%")
exit /b
:jpegfwe
if /i "%~f2" neq "%~f3" (1>nul 2>&1 del /f /q "%filework%")
1>nul 2>&1 del /f /q "%jpglog%"
exit /b 1

::%1 - thread number
::%2 - input file
::%3 - output file
:giffilework
set "gsize=%~z2"
set "errbackup=0"
set "logfile2=%logfile%gif.%1"
set "filework="
if /i "%~f2" equ "%~f3" (
	set "filework1=%tmppath%\%~n2%1%-gifsicle1~x1"
	set "filework=!filework1! "
) else (
	set "filework1=%~f3"
)
set "filework2=%tmppath%\%~n2%1%-gifsicle2~x1"
set "filework=%filework%%filework2%"
if not exist "%~2" (
	call:saverrorlog "%~f2" 3 %~1 GIF
	exit /b 1
)
gifsicle --batch %giftags% --optimize=3 --output "%filework1%" "%~2" 1>nul 2>&1
if errorlevel 1 (call:saverrorlog "%~f2" 2 %~1 GIF & goto:giffwe)
gifsicle --batch %giftags% --output "%filework2%" "%~2" 1>nul 2>&1
if errorlevel 1 (call:saverrorlog "%~f2" 2 %~1 GIF & goto:giffwe)
if /i "%~f2" neq "%~f3" (
	call:backup "%filework1%" "%~f2" >nul || set "errbackup=1"
	call:backup "%filework1%" "%filework2%" true >nul || set "errbackup=1"
) else (
	call:backup "%~f3" "%filework1%" true >nul || set "errbackup=1"
	call:backup "%~f3" "%filework2%" true >nul || set "errbackup=1"
)
if %errbackup% neq 0 (call:saverrorlog "%~f2" 3 %~1 GIF & goto:giffwe)
call:savelog "%~f3" %gsize%
if %thread% equ 1 for %%a in ("%~f3") do (set /a "ImageSizeGIF+=%%~za" & set /a "TotalSizeGIF+=%jsize%")
exit /b
:giffwe
if /i "%~f2" neq "%~f3" if exist "%filework1%" del /f /q "%filework1%"
if exist "%filework2%" del /f /q "%filework2%"
exit /b 1

:backup
if not exist "%~1" exit /b 2
if not exist "%~2" exit /b 3
if %~z2 equ 0 (if "%3" neq "" (1>nul 2>&1 del /f /q "%~2") & exit /b 4)
if %~z1 leq %~z2 (
	if "%3" neq "" (1>nul 2>&1 del /f /q "%~2")
) else (
	1>nul 2>&1 copy /b /y "%~2" "%~1" || exit /b 1
	if "%3" neq "" 1>nul 2>&1 del /f /q "%~2"
)
exit /b

:backup2
if not exist "%~1" exit /b 2
if not exist "%~2" exit /b 3
set "cone="
if %~z2 equ 0 set "cone=yes"
if %~z1 leq %~z2 set "cone=yes"
if defined cone (
	if "%~1" neq "%~3" (1>nul 2>&1 copy /b /y "%~1" "%~3" || exit /b 1)
) else (
	1>nul 2>&1 copy /b /y "%~2" "%~3" || exit /b 1
)
exit /b 0

::%1 - optimize file path
::%2 - original file size
::%3 - thread number
:savelog
setlocal
::echo.%~0[in]: %1	%~2	%~z1
set /a "change=%~z1-%~2"
call:perccalc %~2 %change% perc
set /a "change=%~z1-%~2"
>>"%logfile2%" echo.%~1;%~2;%~z1;%change%;%perc%;ok
if %thread% equ 1 (
	call:printfileinfo "%~1" %2 %~z1 %change% %perc%
)
endlocal
exit /b

::%1 - file name
::%2 - 	1 - Images are already optimized
::	2 - Images are not supported
::	3 - Images are not found
::%3 -	thread number
::%4 -	JPG|PNG|GIF
:saverrorlog
if exist "%filework%" 1>nul 2>&1 del /f /q "%filework%"
if "%~2" equ "" exit /b
>>"%filelisterr%%~2%~3" echo. %~f1
if %thread% equ 1 (call:printfileerr "%~f1" %~2)
exit /b

::%1 - variable name for division (dividend)
::%2 - divider
::%3 - 10^(number of decimal places) - (100 - 2 decimal places, 1000 - 3 decimal places, 1 - no decimals places)
::Return: float value with %3 decimal places: %1=!%1!/%2
:division
setlocal
1>nul 2>&1 set /a "int=!%1!/%2"
if %~3 equ 1 (
	endlocal & set "%1=%int%" & exit /b
	exit /b
)
1>nul 2>&1 set /a "fractd=!%1!%%%2*%3/%2"
if "%fractd:~,1%" equ "-" (set "fractd=%fractd:~1%")
1>nul 2>&1 set /a "fractd=%3+%fractd%"
endlocal & set "%1=%int%.%fractd:~1%"
exit /b

::%1 - variable name for division (dividend)
::%2 - divider
::%3 - 10^(number of decimal places) - (100 - 2 decimal places, 1000 - 3 decimal places, 1 - no decimals places)
::Return: integer value: %1=!%1!/%2*%3
:division2
::echo.%~0[in]: %~1=!%~1! %~2 %~3
setlocal
1>nul 2>&1 set /a "int=!%~1!/%~2"
if %~3 equ 1 (
	endlocal & set "%~1=%int%" & exit /b
	exit /b
)
1>nul 2>&1 set /a "fractd=!%~1!%%%~2*%~3/%~2"
endlocal & set /a "%~1=%int%*%~3+(%fractd%)"
::echo.%~0[out]: !%~1!
exit /b

:end
call:setvtime ftime
if %jpeg% equ 0 if %png% equ 0 if %gif% equ 0 1>nul 2>&1 ping -n 1 -w 500 127.255.255.255 & goto:finmessage
set /a "TotalNumPNG+=TotalNumErrPNG"
set /a "TotalNumJPG+=TotalNumErrJPG"
set /a "TotalNumGIF+=TotalNumErrGIF"
for %%b in ("%filelisterr%2" "%filelisterr%3") do (
	for /f "tokens=1" %%a in ('findstr /e /i /c:".png" "%%~b*" 2^>nul ^| find /i /c ".png" 2^>nul') do (
		set /a "TotalNumErrPNG+=%%a"
	)
	for /f "tokens=1" %%a in ('findstr /e /i /c:".jpg" "%%~b*" 2^>nul ^| find /i /c ".jpg" 2^>nul') do (
		set /a "TotalNumErrJPG+=%%a"
	)
	for /f "tokens=1" %%a in ('findstr /e /i /c:".jpe" "%%~b*" 2^>nul ^| find /i /c ".jpe" 2^>nul') do (
		set /a "TotalNumErrJPG+=%%a"
	)
	for /f "tokens=1" %%a in ('findstr /e /i /c:".jpeg" "%%~b*" 2^>nul ^| find /i /c ".jpeg" 2^>nul') do (
		set /a "TotalNumErrJPG+=%%a"
	)
	for /f "tokens=1" %%a in ('findstr /e /i /c:".gif" "%%~b*" 2^>nul ^| find /i /c ".gif" 2^>nul') do (
		set /a "TotalNumErrGIF+=%%a"
	)
)
set /a "TotalNumErr=%TotalNumErrPNG%+%TotalNumErrJPG%+%TotalNumErrGIF%"
if %TotalNumErr% gtr 0 (
	echo.
	echo.                                  Error
	echo.%spacebar%
	set "isfirst="
	for %%a in ("%filelisterr%2*") do if %%~za gtr 0 (
		if not defined isfirst (
			echo.
			echo. Images are not supported:
			set "isfirst=1"
		)
		type "%%~a"
	)
	set "isfirst="
	for %%a in ("%filelisterr%3*") do if %%~za gtr 0 (
		if not defined isfirst (
			echo.
			echo. Images are not found:
			set "isfirst=1"
		)
		type "%%~a"
	)
	for %%a in ("%filelisterr%") do if %%~za gtr 0 (
		echo.
		echo. Images with characters:
		type "%%~a"
	)
	set "isfirst="
	echo.%spacebar%
)
call:fincalc PNG
call:fincalc JPG
call:fincalc GIF
:finmessage
call:totalmsg PNG %png%
call:totalmsg JPG %jpeg%
call:totalmsg GIF %gif%
echo.
if defined outdir (echo. Outdir: %outdir%) else echo. Outdir: overwrite original images
echo.
echo. Started  at - %stime%
echo. Finished at - %ftime%
echo.%spacebar%
if /i "%updatecheck%" equ "true" (
	call:waitflag "%iculck%"
	1>nul 2>&1 del /f /q "%iculck%"
	if exist "%iculog%" (
		call:readini "%iculog%"
		if "%version%" neq "!ver!" (
			echo.
			echo. New version available %name% !ver! 
			echo.
			echo. !url!
			echo.%spacebar%
		)
		1>nul 2>&1 del /f /q "%iculog%"
	)
)
1>nul 2>&1 del /f /q "%logfile%*" "%countJPG%" "%countPNG%*" "%filelist%*" "%filelisterr%*" "%iclock%"
if exist "%tmppath%" 1>nul 2>&1 rd /s /q "%tmppath%"
exit /b

::%1 - JPG|PNG|GIF
::%2 - Total Size
::%3 - Image Size
:stepcalc
set /a "TotalSize%~1+=%~2"
set /a "ImageSize%~1+=%~3"
if !ImageSize%~1! lss %BYTECONV% if !TotalSize%~1! lss %BYTECONV% exit /b
if !stepB%~1! gtr 1 (
	call:division2 TotalSize%~1 !stepB%~1! !step10%~1!
	call:division2 ImageSize%~1 !stepB%~1! !step10%~1!
)
set /a "STotalSize%~1+=!TotalSize%~1!"
set /a "SImageSize%~1+=!ImageSize%~1!"
set "TotalSize%~1=0"
set "ImageSize%~1=0"
::echo.!STotalSize%~1!	!SImageSize%~1!	!step%~1!	!step10%~1!	!stepB%~1!
if !SImageSize%~1! lss %BYTECONV% if !STotalSize%~1! lss %BYTECONV% exit /b
set /a "step%~1=(!step%~1!+1)%%3"
if !step%~1! equ 0 (
	set "step10%~1=100"
	set /a "stepB%~1*=%KB%"
	call:division2 STotalSize%~1 %KB% 100
	call:division2 SImageSize%~1 %KB% 100
) else if !stepB%~1! neq 1 (
	set /a "step10%~1/=10"
	set /a "STotalSize%~1/=10"
	set /a "SImageSize%~1/=10"
)
::echo.!STotalSize%~1!	!SImageSize%~1!	!step%~1!	!step10%~1!	!stepB%~1!
exit /b

::%1 - JPG|PNG|GIF
:fincalc
if !TotalSize%~1! equ 0 if !STotalSize%~1! equ 0 exit /b
if !stepB%~1! gtr 1 (
	call:division2 TotalSize%~1 !stepB%~1! !step10%~1!
	call:division2 ImageSize%~1 !stepB%~1! !step10%~1!
)
set /a "STotalSize%~1+=!TotalSize%~1!"
set /a "SImageSize%~1+=!ImageSize%~1!"
set "TotalSize%~1=0"
set "ImageSize%~1=0"
set /a "change%~1=(!SImageSize%~1!-!STotalSize%~1!)" 2>nul
set "TS=!STotalSize%~1!"
set "change=!change%~1!"
set "sign="
if %change% lss 0 (set "sign=-" & set "change=%change:~1%")
set "divider=" & set "dp=" & set "measure="
::echo.%~0:	!STotalSize%~1!	!SImageSize%~1!	!change%~1!	!step%~1!	!step10%~1!	!stepB%~1!	step10="%step10%"
call:finprepsize !stepB%~1! !STotalSize%~1! !step10%~1! divider dp measure
if %divider% gtr 1 (
	call:division STotalSize%~1 %divider% %dp%
	call:division SImageSize%~1 %divider% %dp%
)
set "STotalSize%~1=!STotalSize%~1! %measure%"
set "SImageSize%~1=!SImageSize%~1! %measure%"
set "divider=" & set "dp=" & set "measure="
call:finprepsize !stepB%~1! %change% !step10%~1! divider dp measure
if %divider% gtr 1 (
	call:division2 TS %divider% %dp%
	call:division2 change %divider% %dp%
	call:division change%~1 %divider% %dp%
)
set "change%~1=!change%~1! %measure%"
call:perccalc %TS% %sign%%change% perc%~1
::echo.%~0: %TS%	%change%
::echo.%~0: !STotalSize%~1!	!SImageSize%~1!	!change%~1!	!step%~1!	!step10%~1!	!stepB%~1!	%divider%	%dp%
set "divider=" & set "dp=" & set "measure=" & set "change=" & set "TS="
exit /b

::%1 - stepB (in)
::%2 - size (in)
::%3 - step10 (in)
::%4 - variable name for divider (out)
::%5 - variable name for decimal places (out)
::%6 - variable name for measure (out)
:finprepsize
::echo.%~0: %~1	%~2	%~3
setlocal
set "divider=" & set "dp=100" & set "meas=" & set "step10=%~3"
if %~1 equ %GB% (
	if %~2 geq %KB%%step10:~1% (
		set "divider=%KB%%step10:~1%"
		set "meas=TB"
	) else (
		set "divider=%step10%"
		set "dp=%step10%"
		set "meas=GB"
	)
) else if %~1 equ %MB% (
	if %~2 geq %MB%%step10:~1% (
		set "divider=%MB%%step10:~1%"
		set "meas=TB"
	) else if %~2 geq %KB%%step10:~1% (
		set "divider=%KB%%step10:~1%"
		set "meas=GB"
	) else (
		set "divider=%step10%"
		set "dp=%step10%"
		set "meas=MB"
	)
) else if %~1 equ %KB% (
	if %~2 geq %MB%%step10:~1% (
		set "divider=%MB%%step10:~1%"
		set "meas=GB"
	) else if %~2 geq %KB%%step10:~1% (
		set "divider=%KB%%step10:~1%"
		set "meas=MB"
	) else (
		set "divider=%step10%"
		set "dp=%step10%"
		set "meas=KB"
	)
) else if %~1 equ 1 (
	if %~2 geq %GB% (
		set "divider=%GB%"
		set "meas=GB"
	) else if %~2 geq %MB% (
		set "divider=%MB%"
		set "meas=MB"
	) else if %~2 geq %KB% (
		set "divider=%KB%"
		set "meas=KB"
	) else (
		set "divider=1"
		set "dp=1"
		set "meas=B"
	)
)
::echo.%~0: %divider%	%dp%	%meas%
endlocal & set "%~4=%divider%" & set "%~5=%dp%" & set "%~6=%meas%"
exit /b

::%1 - JPG|PNG|GIF
:totalmsg
if %~2 equ 0 exit /b
set /a "opt=!TotalNum%~1!-!TotalNumErr%~1!"
if %opt% equ 0 exit /b
if not defined isfirst (
	echo.
	echo.                                     Total
	echo.%spacebar%
	set "isfirst=1"
)
setlocal
set "F1=%~1 [%opt%/!TotalNum%~1!]:                                  "
set "F5=           !perc%~1!"
set "F2=           !STotalSize%~1!"
set "F3=           !SImageSize%~1!"
set "F4=           !change%~1!"
echo. !F1:~,%TFN%!^|!F2:~-10!^|!F3:~-11!^|!F4:~-11!^|%F5:~-9%%%
echo.%spacebar%
endlocal & exit /b

:readini
for /f "usebackq tokens=1,* delims== " %%a in ("%~1") do (
	set param=%%a
	if "!param:~,1!" neq ";" if "!param:~,1!" neq "[" set "%%~a=%%~b"
)
exit /b

:helpmsg
title [Manual] %name% %version%
1>&2 (
	echo.%spacebar%
	echo. Image Catalyst - lossless PNG, JPEG and GIF image optimization / compression
	echo.
	echo. Please check README for more details
	echo.
	echo. call iCatalyst.bat [options] [add directories \ add files]
	echo.
	echo. Options:
	echo.
	echo. /png:#	PNG optimization mode ^(Non-Interlaced^):
	echo.	1 - Compression level - Advanced
	echo.	2 - Compression level - Xtreme
	echo.	0 - Skip ^(default^)
	echo.
	echo. /jpg:#	JPEG optimization mode:
	echo.	1 - Encoding Process - Baseline
	echo.	2 - Encoding Process - Progressive
	echo.	3 - use mode of original image
	echo.	0 - Skip ^(default^)
	echo.
	echo. /gif:#	GIF optimization mode:
	echo.	1 - use settings of original image
	echo.	0 - Skip ^(default^)
	echo.
	echo. "/outdir:#" image saving options:
	echo.	true  - open dialog box for saving images ^(default^)
	echo.	false - replace original image with optimized
	echo.	"full path to directory" - specify directory to save images to.
	echo.	for example: "/outdir:C:\temp". If the destination directory
	echo.	does not exist, it will be created automatically.
	echo.
	echo. Add directories \ Add files:
	echo. - Specify full image paths and / or paths to directories containing images.
	echo.   For example: "C:\Images" "C:\logo.png"
	echo. - Full image paths should not contain any special characters such as
	echo.   "&", "%%", "(", ")" etc.
	echo. - Images in sub-directories are optimized recursively.
	echo.
	echo. Examples:
	echo. call iCatalyst.bat /gif:1 "/outdir:C:\photos" "C:\images"
	echo. call iCatalyst.bat /png:2 /jpg:2 "/outdir:true" "C:\images"
	echo.%spacebar%
)
if exist "%tmppath%" 1>nul 2>&1 rd /s /q "%tmppath%"
call:dopause & exit /b

:errormsg
title [Error] %name% %version%
if exist "%tmppath%" 1>nul 2>&1 rd /s /q "%tmppath%"
if "%~1" neq "" 1>&2 echo.%~1
call:dopause
exit /b

:dopause
setlocal
set "x=%~f0"
echo.%CMDCMDLINE% | 1>nul 2>&1 findstr /ilc:"%x%" && 1>nul 2>&1 pause
set "x="
endlocal & exit /b

:clearscreen
setlocal
set "x=%~f0"
echo.%CMDCMDLINE% | 1>nul 2>&1 findstr /ilc:"%x%" && cls
set "x="
endlocal & exit /b
