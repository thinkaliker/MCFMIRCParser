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

:prompts
set username=none
set /p username="Enter IRC channel name (should be your username): "
if /i "%username%" EQU "none" (
	echo You must enter a username.
	GOTO :prompts
) else (
	GOTO :loc
)

:loc
set dest=none
set /p dest="Enter text file output location (eg. D:\nowplaying.txt ): "
if /i "%dest%" EQU "none" (
	echo You must enter a destination file.
	GOTO :loc
) else (
	GOTO :client
)

:client
set src=none
set /p src="Which IRC client are you using? Type [p] for Pidgin or [h] for HexChat: "
if /i "%src%" EQU "none" (
	echo You must enter a client.
	GOTO :client
) else (
	GOTO :clientpick
)

:clientpick
if %src%==p GOTO :p
if %src%==h GOTO :h

echo Invalid input, try again.
GOTO :prompts

:p
:: make sure this source line matches whatever DIRECTORY your chat logs are stored in - please make sure this is correct for your system/configuration
set source=%AppData%\.purple\logs\irc\%username%@irc.twitch.tv\#%username%.chat
echo You are using Pidgin.
GOTO :delay

:h
:: make sure this source line matches whatever DIRECTORY your chat logs are stored in - please make sure this is correct for your system/configuration
set source=%AppData%\HexChat\logs\twitch
echo You are using HexChat.
GOTO :delay

:delay
set /a delay=10
set /p delay="Default delay is 10 seconds. Configured delay (optional): "

:begin
echo --------------------------------------------------------------------------------
echo Your currently playing song text file will be located at: %dest%
echo Press (Ctrl+C) to exit, or simply close the window.
echo Artist and song will be listed below everytime a change is detected.
echo First time running may require a !song command in Twitch to show the first song.
echo If no song is shown below, the song has not changed since last run.
echo ================================================================================

set cpy=%temp%\lp_cpy.txt
set mcat=%temp%\lp_mcat.txt
set line=%temp%\lp_line.txt
set sa=%temp%\lp_sa.txt

:parse

if %src%==p GOTO :pcopy
if %src%==h GOTO :hcopy

:pcopy
for /f "tokens=*" %%G in ('dir *.txt /b /a-d /od %source% 2^> NUL') do (
	set newest=%%G
)
copy /V /Y %source%\%newest% %cpy% > NUL
GOTO :mcatfind

:hcopy
copy /V /Y %source%\#%username%.log %cpy% > NUL
GOTO :mcatfind

:mcatfind
break>%mcat%
break>%line%

findstr ".*monstercat.*.*Now Playing:.*- Listen now: http://spoti.fi/.*" %cpy% > %mcat%

for /f %%C in ('find /V /C "" ^< %mcat%') do set LINES=%%C

set /a LINES=LINES-1

more +%LINES% %mcat% > %line%

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
type %line% | jrepl ".*Playing: (.*) by (.*) -.*" "$2 // $1" /O %sa%
:: replace the above^ %sa% with %dest% and delete this line \/
set /p string= < %sa%

::keep \/
fc /c %sa% %dest% > NUL && GOTO :nochange || GOTO :change
::keep /\

:change
:: \/ and this ilne if you DO NOT want all caps
upper "%string%" | jrepl "\q(.*)\q" "$1" /B /X > %dest%
:: this just shows you what the string you're putting into the OBS text file looks like
type %dest%
GOTO :timeout

:nochange

:timeout
timeout /t %delay% /nobreak > NUL

GOTO :parse