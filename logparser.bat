@echo off
setlocal enabledelayedexpansion
cls

title Monstercat FM Twitch IRC Log Parser
echo        __  ___                 __                       __      ________  ___
echo       /  \/  /___  ____  _____/ /____  ______________ _/ /_    / ____/  \/  /
echo      / /\_/ / __ \/ __ \/ ___/ __/ _ \/ ___/ ___/ __ `/ __/   / /_  / /\_/ / 
echo     / /  / / /_/ / / / (__  ) /_/  __/ /  / /__/ /_/ / /_    / __/ / /  / /  
echo    /_/  /_/\____/_/ /_/____/\__/\___/_/   \___/\__,_/\__/   /_/   /_/  /_/ 
echo.
echo Created by thinkaliker                                  [http://thinkaliker.com]
echo Source available on GitHub         [http://github.com/thinkaliker/MCFMIRCParser]
echo ////////////////////////////////////////////////////////////////////////////////

set cpy=%temp%\lp_cpy.txt
set mcat=%temp%\lp_mcat.txt
set line=%temp%\lp_line.txt
set sa=%temp%\lp_sa.txt
set satemp=%temp%\lp_satemp.txt

::cleanup any previous sessions
break>%mcat%
break>%line%
break>%sa%
break>%satemp%

:loc
set dest=%temp%\lp_np.txt
set /p destloc="Enter text file output location (Somewhere on C:\ recommended): "
if /i "%destloc%" EQU "none" (
	echo You must enter a destination file.
	GOTO :loc
) else (
	set dest=%destloc%
	if exist %destloc% (
		GOTO :prompts
	) else (
		echo This file does not exist. We will create it for you.
		fsutil file createnew %destloc% 0 > NUL
		GOTO :prompts
	)

)

:prompts
set username=none
set /p username="Enter IRC channel name (should be your username): "
if /i "%username%" EQU "none" (
	echo You must enter a username.
	GOTO :prompts
) else (
	GOTO :client
)

:client
set src=none
set /p src="Which IRC client? Type [ p ] for Pidgin or [ h ] for HexChat: "
if /i "%src%" EQU "none" (
	echo You must enter a client.
	GOTO :client
) else (
	GOTO :clientpick
)

:clientpick
if %src%==p GOTO :p
if %src%==h GOTO :h

echo Invalid client, try again. Only Pidgin or HexChat is supported.
GOTO :client

:p
:: make sure this source line matches whatever DIRECTORY your chat logs are stored in - please make sure this is correct for your system/configuration
set source=%AppData%\.purple\logs\irc\%username%@irc.twitch.tv\#%username%.chat
if exist %source% (
	echo You are using Pidgin.
) else (
	echo The folder doesn't exist. Did you follow the set up instructions?
	GOTO :prompts
)
GOTO :delay

:h
:: make sure this source line matches whatever DIRECTORY your chat logs are stored in - please make sure this is correct for your system/configuration
set source=%AppData%\HexChat\logs\twitch
if exist %source% (
	echo You are using HexChat.
) else (
	echo The folder doesn't exist. Did you follow the set up instructions?
	GOTO :prompts
)
GOTO :delay

:delay
set /a delay=10
set /p delay="Default delay is 10 seconds. Configured delay (optional): "

if %src%==p GOTO :pnew
if %src%==h GOTO :hnew

:pnew
for /f "tokens=*" %%G in ('dir *.txt /b /a-d /od %source% 2^> NUL') do (
	set newest=%%G
)
set cpysrc=%source%\%newest%
GOTO :begin

:hnew
set cpysrc=%source%\#%username%.log
GOTO :begin

:begin
echo --------------------------------------------------------------------------------
echo Your currently playing song text file will be located at: %dest%
echo Press (Ctrl+C) to exit, or simply close the window.
echo Artist and song will be listed below everytime a change is detected.
echo First time running may require a !song command in Twitch to show the first song.
echo If no song is shown below, the song has not changed since last run.
echo ================================================================================

:recopy
if %src%==p GOTO :pcopy
if %src%==h GOTO :hcopy

:pcopy
copy /V /Y %cpysrc% %cpy% > NUL
GOTO :mcatfind

:hcopy
copy /V /Y %cpysrc% %cpy% > NUL
GOTO :mcatfind

:mcatfind
findstr ".*monstercat.*.*Now Playing:.*- Listen now: http://spoti.fi/.*" %cpy% > %mcat%
for /f %%C in ('find /V /C "" ^< %mcat%') do set LINES=%%C
set /a LINES=LINES-1
more /S +%LINES%  %mcat% > %line%

::  _____ ___  ____  __  __    _  _____ _____ ___ _   _  ____ 
:: |  ___/ _ \|  _ \|  \/  |  / \|_   _|_   _|_ _| \ | |/ ___|
:: | |_ | | | | |_) | |\/| | / _ \ | |   | |  | ||  \| | |  _ 
:: |  _|| |_| |  _ <| |  | |/ ___ \| |   | |  | || |\  | |_| |
:: |_|   \___/|_| \_\_|  |_/_/   \_\_|   |_| |___|_| \_|\____|
::
:: you will need to know a little bit of regex, but if you want to make changes to what your text looks like you don't
:: the part of the line below containing "$2 // $1" is how your final output text is going to look
:: $1 is the song name
:: $2 is the artist name
:: simply rearrange to change the order and formatting you desire
type %line% | jrepl ".*Playing: (.*) by (.*) -.*" "$2 // $1" > %sa%
set /p string= < %sa%
upper "%string%" | jrepl "\q(.*)\q" "$1" /B /X > %satemp%

::keep \/
fc /A /C %dest% %sa% > NUL && GOTO :nochange || GOTO :change
::keep /\

:change
:: \/ change this ilne if you DO NOT want all caps
type %satemp% > %dest%
:: this just shows you what the string you're putting into the OBS text file looks like
type %dest%
GOTO :wait

:nochange
:wait
timeout /t %delay% /nobreak > NUL

GOTO :recopy