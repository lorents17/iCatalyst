@echo off

::Lorents & Res2001 2010-2015

setlocal enabledelayedexpansion
set "name=Image Catalyst"
set "version=2.5"
if "%~1" equ "thrd" call:threadwork %4 %5 "%~2" "%~3" & exit /b
if "%~1" equ "updateic" call:icupdate & exit /b
if "%~1" equ "" call:helpmsg & exit /b
title %name% %version%
set "fullname=%~0"
set "scrpath=%~dp0"
set "sconfig=%scrpath%tools\"
set "scripts=%scrpath%tools\scripts\"
set "tmppath=%TEMP%\%name%\"
set "errortimewait=30"
set "iclock=%TEMP%ic.lck"
set "LOG=%scrpath%\iCatalyst"
set "runic="
call:runic "%name% %version%"
if defined runic (
	title [Waiting] %name% %version%
	1>&2 echo -------------------------------------------------------------------------------
	1>&2 echo  Attention: running %runic% of %name%.
	1>&2 echo.
	1>&2 echo  Press Enter to continue.
	1>&2 echo -------------------------------------------------------------------------------
	1>nul pause
	cls
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
	"%apps%defluff.exe"
	"%apps%dlgmsgbox.exe"
	"%apps%gifsicle.exe"
	"%apps%jpegstripper.exe"
	"%apps%jpginfo.exe"
	"%apps%mozjpegtran.exe"
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
	title [Error] %name% %version%
	if exist "%tmppath%" 1>nul 2>&1 rd /s /q "%tmppath%"
	1>&2 echo -------------------------------------------------------------------------------
	1>&2 echo  Application can not get access to files:
	1>&2 echo.
	for %%j in (%nofile%) do 1>&2 echo  - %%~j
	1>&2 echo.
	1>&2 echo  Check access to files and try again.
	1>&2 echo -------------------------------------------------------------------------------
	call:dopause & exit /b
)

:settemp
set "rnd=%random%"
if not exist "%tmppath%%rnd%\" (
	set "tmppath=%tmppath%%rnd%"
	1>nul 2>&1 md "%tmppath%%rnd%" || (
		call:errormsg "Can not create temporary folder:^|%tmppath%%rnd%!"
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
	set "ImageSize%%a=0"
	set "change%%a=0"
	set "perc%%a=0"
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
set "filelisterr=%tmppath%\filerr"
set "thread=" & set "updatecheck=" & set "outdir=" & set "outdir1=" & set "nooutfolder="
set "metadata=" & set "xtreme=" & set "advanced=" & set "chunks=" & set "giftags="
call:readini "%configpath%"
call:sethread %thread%
set "updatecheck=%update%" & set "update="
if /i "%giftags%" equ "true" (set "giftags=--no-comments --no-extensions --no-names") else (set "giftags=")
call set "outdir=%outdir%"
call:paramcontrol %*
if defined perr (
	title [Error] %name% %version%
	if exist "%tmppath%" 1>nul 2>&1 rd /s /q "%tmppath%"
	1>&2 echo -------------------------------------------------------------------------------
	1>&2 echo  Unknown value of setting %perr%.
	call:helpmsg & exit /b
)
if "%png%" equ "0" if "%jpeg%" equ "0" if "%gif%" equ "0" goto:endsetcounters
set "oparam="
if not defined jpeg if not defined png if not defined gif (
	set "oparam=/JPG:1 /PNG:1 /GIF:1"
)
if /i "%outdir%" equ "true" (set "outdir=" & set "nooutfolder=yes") else if /i "%outdir%" equ "false" set "outdir="
if not defined nooutfolder if not defined outdir (
	cls
	title [Loading] %name% %version%
	for /f "tokens=* delims=" %%a in ('dlgmsgbox "Image Catalyst" "Folder3" " " "Select the folder to save images. Click 'Cancel' to replace the original image in the optimized." ') do set "outdir=%%~a"
)
if defined outdir (
	if "!outdir:~-1!" neq "\" set "outdir=!outdir!\"
	if not exist "!outdir!" (
		1>nul 2>&1 md "!outdir!" || (
		call:errormsg "Can not create folder for optimized files: !outdir!"
		exit /b
		)
	)
	for /f "tokens=* delims=" %%a in ("!outdir!") do set outdirparam="/Outdir:%%~a"
) else (
	set "outdirparam="
)
cls
title [Loading] %name% %version%
echo.-------------------------------------------------------------------------------
echo. Images are analazing. Please wait...
echo.-------------------------------------------------------------------------------
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
	if defined png  for /f "tokens=3 delims=:" %%a in ('findstr /i /e ".png"  "%filelisterr%" ^| find /i /c ".png" 2^>nul') do set /a "TotalNumErrPNG+=%%a"
	if defined jpeg for /f "tokens=3 delims=:" %%a in ('findstr /i /e ".jpg"  "%filelisterr%" ^| find /i /c ".jpg" 2^>nul') do set /a "TotalNumErrJPG+=%%a"
	if defined jpeg for /f "tokens=3 delims=:" %%a in ('findstr /i /e ".jpe"  "%filelisterr%" ^| find /i /c ".jpe" 2^>nul') do set /a "TotalNumErrJPG+=%%a"
	if defined jpeg for /f "tokens=3 delims=:" %%a in ('findstr /i /e ".jpeg" "%filelisterr%" ^| find /i /c ".jpeg" 2^>nul') do set /a "TotalNumErrJPG+=%%a"
	if defined gif  for /f "tokens=3 delims=:" %%a in ('findstr /i /e ".gif"  "%filelisterr%" ^| find /i /c ".gif" 2^>nul') do set /a "TotalNumErrGIF+=%%a"
)

:endsetcounters
if %TotalNumPNG% equ 0 if %TotalNumJPG% equ 0 if %TotalNumGIF% equ 0 (
	cls
	1>&2 echo -------------------------------------------------------------------------------
	1>&2 echo  There no images found for optimization.
	call:helpmsg
	exit /b
)
for /l %%a in (1,1,%thread%) do (
	>"%logfile%png.%%a" echo.
	>"%logfile%jpg.%%a" echo.
	>"%logfile%gif.%%a" echo.
)
cls
echo -------------------------------------------------------------------------------
echo.
if /i "%updatecheck%" equ "true" start "" /b cmd.exe /c ""%fullname%" updateic"
call:setitle
call:setvtime stime
set "outdirs="
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
	echo.Another process is running %name%. Waiting for shuting down.
	call:runningcheck2 "%~1"
)
exit /b

:runningcheck2
2>nul (3>"%iclock%" 1>&3 call:runic2 "%~1" || (call:waitrandom 5000 & goto:runningcheck2))
exit /b

:runic2
call:waitrandom 5000
call:runic "%~1"
if defined runic (
	if %runic% lss %lastrunic% exit /b 0
	set "lastrunic=%runic%"
	goto:runic2
)	
exit /b 0

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

:createthread
if %2 equ 1 call:threadwork %1 1 %3 %4 & call:typelog %1 1 & exit /b
for /l %%z in (1,1,%2) do (
	if not exist "%tmppath%\thrt%%z.lck" (
		call:typelog %1 %%z
		>"%tmppath%\thrt%%z.lck" echo Image processing: %3
		start /b /LOW /MIN cmd.exe /s /c ""%fullname%" thrd "%~3" "%~4" %1 %%z"
		exit /b
	)
)
call:waitrandom 500
goto:createthread

:typelog
if %thread% equ 1 exit /b
if not defined typenum%1%2 set "typenum%1%2=1"
call:typelogfile "%logfile%%1.%2" "typenum%1%2" %%typenum%1%2%% %1
exit /b

:typelogfile
if not exist "%~1" exit /b
for /f "usebackq skip=%3 tokens=1-5 delims=;" %%b in ("%~1") do (
	if /i "%%d" equ "error" (
		call:printfileerr "%%~b" "%%~c"
	) else (
		call:printfileinfo "%%~b" %%c %%d %%e %%f
	)
	set /a "%~2+=1"
)
exit /b

:printfileinfo
call:echostd " File  - %~f1"
if "%~4" neq "0" (
	set "float=%2"
	call:division float 1024 100
	call:echostd " In    - !float! KB"
	set "change=%4"
	call:division change 1024 100
	set "float=%3"
	call:division float 1024 100
	call:echostd " Out   - !float! KB (!change! KB, %5%%%%%%)"
) else (
	call:echostd " Skip  - This image cannot be optimized any further"
)
call:echostd -------------------------------------------------------------------------------
call:echostd
exit /b

:printfileerr
call:echoerr " File  - %~1"
call:echoerr " Error - %~2"
call:echoerr -------------------------------------------------------------------------------
call:echoerr
exit /b

:echostd
echo.%~1
exit /b

:echoerr
1>&2 echo.%~1
exit /b

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
set /a "ww=%random%%%%1"
1>nul 2>&1 ping -n 1 -w %ww% 127.255.255.255
exit /b

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
cls
title [PNG] %name% %version%
echo  -------------------------
echo  Optimization setting PNG:
echo  -------------------------
echo.
echo  [1] Xtreme
echo.
echo  [2] Advanced
echo.
echo  [0] Skip
echo.
set "png="
echo  ---------------------------------------
set /p png="#Select setting and press Enter [0-2]: "
echo  ---------------------------------------
echo.
if "%png%" neq "0" if "%png%" neq "1" if "%png%" neq "2" goto:png
exit /b

:jpeg
cls
title [JPEG] %name% %version%
echo  --------------------------
echo  Optimization setting JPEG:
echo  --------------------------
echo.
echo  [1] Baseline
echo.
echo  [2] Progressive
echo.
echo  [3] Default
echo.
echo  [0] Skip
echo.
set "jpeg="
echo  ---------------------------------------
set /p jpeg="#Select setting and press Enter [0-3]: "
echo  ---------------------------------------
echo.
if "%jpeg%" neq "0" if "%jpeg%" neq "1" if "%jpeg%" neq "2" if "%jpeg%" neq "3" goto:jpeg
exit /b

:gif
cls
title [GIF] %name% %version%
echo  -------------------------
echo  Optimization setting GIF:
echo  -------------------------
echo.
echo  [1] Default
echo.
echo  [0] Skip
echo.
set "gif="
echo  ---------------------------------------
set /p gif="#Select setting and press Enter [0-1]: "
echo  ---------------------------------------
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
if %png% equ 1  (set "pngtitle=Xtreme")
if %png% equ 2  (set "pngtitle=Advanced")
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
	set "titlestr=!titlestr!JPEG %jpegtitle%: !perc!%%"
)
if %gif% gtr 0 (
	set /a "perc=%ImageNumGIF%*100/%TotalNumGIF%"
	set /a "tmpn=%jpeg%+%png%"
	if !tmpn! gtr 0 (set "titlestr=%titlestr% ^| ")
	set "titlestr=!titlestr!GIF %giftitle%: !perc!%%"
)
title [%titlestr%] %name% %version%
set "titlestr="
set "tmpn="
exit /b

:filework
call:createthread %3 %4 "%~f1" "%~f2"
set /a "%5+=1"
call:setitle
exit /b

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
	call:saverrorlog "%~f2" "The image is not found"
	exit /b 1
)
if %png% equ 1 (
	>"%pnglog%" 2>nul truepng -y -i0 -zw7 -zc7 -zm5-9 -zs0-3 -f0,5 -fs:2 %xtreme% -force -out "%filework%" "%~2"
	if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:pngfwe)
	for /f "tokens=2,4,6,8,10 delims=:	" %%a in ('findstr /r /i /b /c:"zc:..zm:..zs:" "%pnglog%"') do (
		set "zc=%%a"
		set "zm=%%b"
		set "zs=%%c"
	)
	pngwolfzopfli --zopfli-iter=5 --zlib-window=15 --zlib-level=!zc! --zlib-memlevel=!zm! --zlib-strategy=!zs! --max-stagnate-time=0 --max-evaluations=1 --in="%filework%" --out="%filework%" 1>nul 2>&1
	if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:pngfwe)
)
if %png% equ 2 (
	>"%pnglog%" 2>nul truepng -y -i0 -zw7 -zc7 -zm8-9 -zs0,1,3 -f0,1,5 -fs:2 %advanced% -force -out "%filework%" "%~2"
	if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:pngfwe)
	for /f "tokens=2,4,6,8,10 delims=:	" %%a in ('findstr /r /i /b /c:"zc:..zm:..zs:" "%pnglog%"') do (
		set "zc=%%a"
		set "zm=%%b"
		set "zs=%%c"
	)
	truepng -y -i0 -zw7 -zc!zc! -zm!zm! -zs!zs! -f5 -fs:7 -na -nc -np "%filework%" 1>nul 2>&1
	if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:pngfwe)
	advdef -z3 "%filework%" 1>nul 2>&1
	if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:pngfwe)
)
deflopt -k "%filework%" >nul && defluff < "%filework%" > "%filework%-defluff.png" 2>nul 
if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & 1>nul 2>&1 del /f/q "%filework%-defluff.png" & goto:pngfwe)
1>nul 2>&1 move /y "%filework%-defluff.png" "%filework%" && deflopt -k "%filework%" >nul
if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:pngfwe)
call:backup2 "%~f2" "%filework%" "%~f3" || set "errbackup=1"
if %errbackup% neq 0 (call:saverrorlog "%~f2" "The image is not found" & goto:pngfwe)
if /i "%chunks%" equ "true" (1>nul 2>&1 truepng -nz -md remove all "%~3" || (call:saverrorlog "%~f2" "The image is not supported" & goto:pngfwe))
call:savelog "%~f3" %psize%
if %thread% equ 1 for %%a in ("%~f3") do (set /a "ImageSizePNG+=%%~za" & set /a "TotalSizePNG+=%psize%")
:pngfwe
1>nul 2>&1 del /f /q "%filework%" "%pnglog%"
exit /b

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
	call:saverrorlog "%~f2" "The image is not found"
	exit /b 1
)
if %jpeg% equ 1 (
	mozjpegtran -verbose -revert -optimize -copy all -outfile "%filework%" "%~2" 1>"%jpglog%" 2>&1
	if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:jpegfwe)
	for /f "tokens=4,10 delims=:,= " %%a in ('findstr /C:"Start Of Frame" "%jpglog%" 2^>nul') do (set "ep=%%a")
	if "!ep!" equ "0xc0" goto:jpegfwb
	if "!ep!" equ "0xc2" (
		if /i "%~f2" equ "%~f3" (1>nul 2>&1 move /y "%filework%" "%~f3" || set "errbackup=1")
		goto:jpegfwf
	) else (
		call:saverrorlog "%~f2" "The image is not supported" & goto:jpegfwe
	)
)
if %jpeg% equ 2 (
	mozjpegtran -verbose -copy all -outfile "%filework%" "%~2" 1>"%jpglog%" 2>&1
	if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:jpegfwe)
	for /f "tokens=4,10 delims=:,= " %%a in ('findstr /C:"Start Of Frame" "%jpglog%" 2^>nul') do (set "ep=%%a")
	if "!ep!" equ "0xc2" goto:jpegfwb
	if "!ep!" equ "0xc0" (
		if /i "%~f2" equ "%~f3" (1>nul 2>&1 move /y "%filework%" "%~f3" || set "errbackup=1")
		goto:jpegfwf
	) else (
		call:saverrorlog "%~f2" "The image is not supported" & goto:jpegfwe
	)
)
if %jpeg% equ 3 (
	jpginfo "%~2" 1>"%jpglog%" 2>&1
	if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:jpegfwe)
	for /f "usebackq tokens=5" %%a in ("%jpglog%") do set "ep=%%~a"
	if /i "!ep!" equ "Baseline" (
		mozjpegtran -verbose -revert -optimize -copy all -outfile "%filework%" "%~2" 1>nul 2>&1
		if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:jpegfwe)
		goto:jpegfwb
	)
	if /i "!ep!" equ "Progressive" (
		mozjpegtran -verbose -copy all -outfile "%filework%" "%~2" 1>nul 2>&1
		if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:jpegfwe)
		goto:jpegfwb
	)
	call:saverrorlog "%~f2" "The image is not supported" & goto:jpegfwe
)
:jpegfwb
if /i "%~f2" neq "%~f3" (
	call:backup "%filework%" "%~f2" >nul || set "errbackup=1"
) else (
	call:backup "%~f2" "%filework%" true >nul || set "errbackup=1"
)
:jpegfwf
1>nul 2>&1 del /f /q "%jpglog%"
if %errbackup% neq 0 (call:saverrorlog "%~f2" "The image is not found" & goto:jpegfwe)
if /i "%metadata%" equ "true" (1>nul 2>&1 jpegstripper -y "%~f3" || (call:saverrorlog "%~f2" "The image is not supported" & exit /b))
call:savelog "%~f3" %jsize%
if %thread% equ 1 for %%a in ("%~f3") do (set /a "ImageSizeJPG+=%%~za" & set /a "TotalSizeJPG+=%jsize%")
exit /b
:jpegfwe
if /i "%~f2" neq "%~f3" (1>nul 2>&1 del /f /q "%filework%")
1>nul 2>&1 del /f /q "%jpglog%"
exit /b 1

:giffilework
set "gsize=%~z2"
set "errbackup=0"
set "logfile2=%logfile%gif.%1"
if /i "%~f2" equ "%~f3" (
	set "filework1=%tmppath%\%~n2%1%-gifsicle1~x1"
) else (
	set "filework1=%~f3"
)
set "filework2=%tmppath%\%~n2%1%-gifsicle2~x1"
if not exist "%~2" (
	call:saverrorlog "%~f2" "The image is not found"
	exit /b 1
)
gifsicle --batch %giftags% --optimize=3 --output "%filework1%" "%~2" 1>nul 2>&1
if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:giffwe)
gifsicle --batch %giftags% --output "%filework2%" "%~2" 1>nul 2>&1
if errorlevel 1 (call:saverrorlog "%~f2" "The image is not supported" & goto:giffwe)
if /i "%~f2" neq "%~f3" (
	call:backup "%filework1%" "%~f2" >nul || set "errbackup=1"
	call:backup "%filework1%" "%filework2%" true >nul || set "errbackup=1"
) else (
	call:backup "%~f3" "%filework1%" true >nul || set "errbackup=1"
	call:backup "%~f3" "%filework2%" true >nul || set "errbackup=1"
)
if %errbackup% neq 0 (call:saverrorlog "%~f2" "The image is not found" & goto:giffwe)
call:savelog "%~f3" %gsize%
if %thread% equ 1 for %%a in ("%~f3") do (set /a "ImageSizeGIF+=%%~za" & set /a "TotalSizeGIF+=%jsize%")
exit /b
:giffwe
if /i "%~f2" neq "%~f3" 1>nul 2>&1 del /f /q "%filework1%"
1>nul 2>&1 del /f /q "%filework2%"
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

:savelog
set /a "change=%~z1-%2"
set /a "perc=%change%*100/%2" 2>nul
set /a "fract=%change%*100%%%2*100/%2" 2>nul
set /a "perc=%perc%*100+%fract%"
call:division perc 100 100
>>"%logfile2%" echo.%~1;%2;%~z1;%change%;%perc%;ok
if %thread% equ 1 (
	call:printfileinfo "%~1" %2 %~z1 %change% %perc%
)
exit /b

:division
set "sign="
1>nul 2>&1 set /a "int=!%1!/%2"
1>nul 2>&1 set /a "fractd=!%1!*%3/%2%%%3"
if "%fractd:~,1%" equ "-" (set "sign=-" & set "fractd=%fractd:~1%")
1>nul 2>&1 set /a "fractd=%3+%fractd%"
if "%int:~,1%" equ "-" set "sign="
set "%1=%sign%%int%.%fractd:~1%"
exit /b

:saverrorlog
1>nul 2>&1 del /f /q "%filework%"
>>"%logfile2%" echo.%~1;%~2;error
if %thread% equ 1 (call:printfileerr "%~f1" "%~2")
exit /b

:end
call:setvtime ftime
set "fract=0"
set "changePNG=0" & set "percPNG=0"
set "changeJPG=0" & set "percJPG=0"
set "changeGIF=0" & set "percGIF=0"
set "TotalNumNOptJPG=0" & set "TotalNumNOptPNG=0" & set "TotalNumNOptGIF=0"
if %jpeg% equ 0 if %png% equ 0 if %gif% equ 0 1>nul 2>&1 ping -n 1 -w 500 127.255.255.255 & goto:finmessage
if %thread% gtr 1 (
	for /f "tokens=1-5 delims=;" %%a in ('findstr /e /i /r /c:";ok" "%logfile%png*" ') do (
		set /a "TotalSizePNG+=%%b" & set /a "ImageSizePNG+=%%c"
	)
	for /f "tokens=1-5 delims=;" %%a in ('findstr /e /i /r /c:";ok" "%logfile%jpg*" ') do (
		set /a "TotalSizeJPG+=%%b" & set /a "ImageSizeJPG+=%%c"
	)
	for /f "tokens=1-5 delims=;" %%a in ('findstr /e /i /r /c:";ok" "%logfile%gif*" ') do (
		set /a "TotalSizeGIF+=%%b" & set /a "ImageSizeGIF+=%%c"
	)
)
for /f "tokens=1" %%a in ('findstr /e /i /r /c:";error" "%logfile%png*" 2^>nul ^| find /i /c ";error" 2^>nul') do (
	set /a "TotalNumErrPNG+=%%a" & set /a "TotalNumPNG-=%%a"
)
for /f "tokens=1" %%a in ('findstr /e /i /r /c:";error" "%logfile%jpg*" 2^>nul ^| find /i /c ";error" 2^>nul') do (
	set /a "TotalNumErrJPG+=%%a" & set /a "TotalNumJPG-=%%a"
)
for /f "tokens=1" %%a in ('findstr /e /i /r /c:";error" "%logfile%gif*" 2^>nul ^| find /i /c ";error" 2^>nul') do (
	set /a "TotalNumErrGIF+=%%a" & set /a "TotalNumGIF-=%%a"
)
for /f "tokens=1" %%a in ('findstr /e /i /r /c:";0;0.00;ok" "%logfile%png*" 2^>nul ^| find /i /c ";0;0.00;ok" 2^>nul') do (
	set /a "TotalNumNOptPNG+=%%a"
)
for /f "tokens=1" %%a in ('findstr /e /i /r /c:";0;0.00;ok" "%logfile%jpg*" 2^>nul ^| find /i /c ";0;0.00;ok" 2^>nul') do (
	set /a "TotalNumNOptJPG+=%%a"
)
for /f "tokens=1" %%a in ('findstr /e /i /r /c:";0;0.00;ok" "%logfile%gif*" 2^>nul ^| find /i /c ";0;0.00;ok" 2^>nul') do (
	set /a "TotalNumNOptGIF+=%%a"
)
set /a "changePNG=(%ImageSizePNG%-%TotalSizePNG%)" 2>nul
set /a "percPNG=%changePNG%*100/%TotalSizePNG%" 2>nul
set /a "fract=%changePNG%*100%%%TotalSizePNG%*100/%TotalSizePNG%" 2>nul
set /a "percPNG=%percPNG%*100+%fract%" 2>nul
call:division changePNG 1024 100
call:division percPNG 100 100
set /a "changeJPG=(%ImageSizeJPG%-%TotalSizeJPG%)" 2>nul
set /a "percJPG=%changeJPG%*100/%TotalSizeJPG%" 2>nul
set /a "fract=%changeJPG%*100%%%TotalSizeJPG%*100/%TotalSizeJPG%" 2>nul
set /a "percJPG=%percJPG%*100+%fract%" 2>nul
call:division changeJPG 1024 100
call:division percJPG 100 100
set /a "changeGIF=(%ImageSizeGIF%-%TotalSizeGIF%)" 2>nul
set /a "percGIF=%changeGIF%*100/%TotalSizeGIF%" 2>nul
set /a "fract=%changeGIF%*100%%%TotalSizeGIF%*100/%TotalSizeGIF%" 2>nul
set /a "percGIF=%percGIF%*100+%fract%" 2>nul
call:division changeGIF 1024 100
call:division percGIF 100 100

:finmessage
call:totalmsg PNG %png%
call:totalmsg JPG %jpeg%
call:totalmsg GIF %gif%
call:echostd " Started  at - %stime%"
call:echostd " Finished at - %ftime%"
echo.
echo -------------------------------------------------------------------------------
call:listerrfiles
echo  Image optimization is completed.
echo -------------------------------------------------------------------------------
if /i "%updatecheck%" equ "true" (
	call:waitflag "%iculck%"
	1>nul 2>&1 del /f /q "%iculck%"
	if exist "%iculog%" (
		call:readini "%iculog%"
		if "%version%" neq "!ver!" (
			echo  New version available %name% !ver!.
			echo -------------------------------------------------------------------------------
			start "" !url!
		)
		1>nul 2>&1 del /f /q "%iculog%"
	)
)
1>nul 2>&1 del /f /q "%logfile%*" "%countJPG%" "%countPNG%*" "%filelist%*" "%filelisterr%*" "%iclock%"
if exist "%tmppath%" 1>nul 2>&1 rd /s /q "%tmppath%"
exit /b

:totalmsg
call set /a "tt=%%TotalNum%1%%+%%TotalNumErr%1%%"
if "%2" equ "0" (
	set "opt=0"
	set "tterr=%tt%"
	set "nopt=0"
) else (
	call set "nopt=%%TotalNumNOpt%1%%"
	call set /a "opt=%%TotalNum%1%%-!nopt!"
	call set "tterr=%%TotalNumErr%1%%"
)
if "%tt%" neq "0" (
	call:echostd " Total Number of %1:	%tt%"
	call:echostd " Optimized %1:		%opt%"
	if "%nopt%" neq "0" call:echostd " Not optimized %1:	%nopt%"
	if "%tterr%" neq "0" call:echostd " Skipped %1:		%tterr%"
	call:echostd " Total %1:  		%%change%1%% KB, %%perc%1%%%%%%"
	call:echostd
)
exit /b

:listerrfiles
set "iserr="
for %%a in ("%filelisterr%") do if %%~za gtr 0 (
	set "iserr=1" & echo. & echo  Image with characters:
	type "%%~a"
	echo.
)
for /f "tokens=2* delims=:" %%a in ('findstr /e /i /r /c:";error" "%logfile%*" 2^>nul') do (
	if not defined iserr (set "iserr=1" & echo.)
	echo  Images with errors:
	for /f "tokens=1-2 delims=;" %%c in ("%%~b") do echo. %%~c
	echo.
)
if defined iserr echo -------------------------------------------------------------------------------
exit /b

:readini
for /f "usebackq tokens=1,* delims== " %%a in ("%~1") do (
	set param=%%a
	if "!param:~,1!" neq ";" if "!param:~,1!" neq "[" set "%%~a=%%~b"
)
exit /b

:helpmsg
title [Manual] %name% %version%
1>&2 echo -------------------------------------------------------------------------------
1>&2 echo  Image Catalyst - optimization / compression images GIF, PNG, and JPEG lossless
1>&2 echo.
1>&2 echo  Recommended to examine ReadMe
1>&2 echo.
1>&2 echo  call iCatalyst.bat [options] [add folders \ add files]
1>&2 echo.
1>&2 echo  Options:
1>&2 echo.
1>&2 echo  /png:#	Optimization settings PNG (Non-Interlaced):
1>&2 echo 	1 - Compression level - Xtreme
1>&2 echo 	2 - Compression level - Advanced
1>&2 echo 	0 - Skip (default)
1>&2 echo.
1>&2 echo  /jpg:#	Optimization settings JPEG:
1>&2 echo 	1 - Encoding Process - Baseline
1>&2 echo 	2 - Encoding Process - Progressive
1>&2 echo 	3 - uses settings of original images
1>&2 echo 	0 - Skip (default)
1>&2 echo.
1>&2 echo  /gif:#	Optimization settings GIF:
1>&2 echo 	1 - uses settings of original images
1>&2 echo 	0 - Skip (default)
1>&2 echo.
1>&2 echo  "/outdir:#" Settings save optimized images:
1>&2 echo 	true  - replace the original image on optimized
1>&2 echo 	false - open dialog box for saving images (default)
1>&2 echo 	"full path to folder" - specify the folder to save images.
1>&2 echo 	for example: "/outdir:C:\temp", if the destination folder does not 
1>&2 echo 	exist, it will be created automatically.
1>&2 echo.
1>&2 echo  Add folders \ Add files:
1>&2 echo  - Specify the full path to the images and / or folders with images.
1>&2 echo    For example: "C:\Images" "C:\logo.png"
1>&2 echo  - The full paths of images should not be special characters. 
1>&2 echo    For example: "&", "%%", "(", ")" etc.
1>&2 echo  - The application optimizes images in nested subfolders.
1>&2 echo.
1>&2 echo  Examples:
1>&2 echo  call iCatalyst.bat /gif:1 "/outdir:C:\photos" "C:\images"
1>&2 echo  call iCatalyst.bat /png:2 /jpg:2 "/outdir:true" "C:\images"
1>&2 echo -------------------------------------------------------------------------------
if exist "%tmppath%" 1>nul 2>&1 rd /s /q "%tmppath%"
call:dopause & exit /b

:errormsg
title [Error] %name% %version%
if exist "%tmppath%" 1>nul 2>&1 rd /s /q "%tmppath%"
if "%~1" neq "" echo.%~1
call:dopause
exit /b

:dopause
set "x=%~f0"
echo.%CMDCMDLINE% | 1>nul 2>&1 findstr /ilc:"%x%" && 1>nul 2>&1 pause
set "x="
exit /b
