@echo off
setlocal enabledelayedexpansion

title Monstercat FM Twitch IRC Log Parser
echo     __  ___                 __                       __     ________  ___
echo    /  \/  /___  ____  _____/ /____  ______________ _/ /_   / ____/  \/  /
echo   / /\_/ / __ \/ __ \/ ___/ __/ _ \/ ___/ ___/ __ `/ __/  / /_  / /\_/ / 
echo  / /  / / /_/ / / / (__  ) /_/  __/ /  / /__/ /_/ / /_   / __/ / /  / /  
echo /_/  /_/\____/_/ /_/____/\__/\___/_/   \___/\__,_/\__/  /_/   /_/  /_/  
echo.
echo.
echo Twitch IRC Log Parser by thinkaliker
echo --------------------------------------------------------------------------------

:prompts
set /p username="Enter IRC channel name (should be your username): "
set /p dest="Enter text file output location (eg. D:\nowplaying.txt ): "
set /p src="Which IRC client are you using? Type [p] for Pidgin or [h] for HexChat: "
echo The recommended delay is 20 seconds.
set /p delay="Delay in checking new songs (seconds): "

if %src%==p GOTO :p
if %src%==h GOTO :h

echo Invalid input, try again.
GOTO :prompts

:p
:: change this source line to match whatever DIRECTORY your chat logs are stored in - please make sure this is correct for your system
set source=%AppData%\.purple\logs\irc\%username%@irc.twitch.tv\#%username%.chat
echo You are using Pidgin.
GOTO  :begin

:h
:: change this source line to match whatever DIRECTORY your chat logs are stored in - please make sure this is correct for your system
set source=%AppData%\HexChat\logs\twitch
echo You are using HexChat.
GOTO :begin


:begin
echo --------------------------------------------------------------------------------
echo Your currently playing song text file will be located at: %dest%
echo Press (Ctrl+C) to exit, or close the window.
echo Artist and song will be listed below everytime the log is checked.
echo --------------------------------------------------------------------------------

set cpy=%temp%\lp_cpy.txt
set mcat=%temp%\lp_mcat.txt
set line=%temp%\lp_line.txt
set sa=%temp%\lp_sa.txt

:start

if %src%==p GOTO :pcopy
if %src%==h GOTO :hcopy

:pcopy
for /f "tokens=*" %%G in ('dir *.txt /b /a-d /od %source% 2^> NUL') do (
	set newest=%%G
)
copy /V /Y %source%\%newest% %cpy% > NUL
GOTO :find

:hcopy
copy /V /Y %source%\#%username%.log %cpy% > NUL
GOTO :find

:find
break>%mcat%
break>%line%

findstr ".*monstercat.*.*Now Playing:.*- Listen now: http://spoti.fi/.*" %cpy% > %mcat%

for /f %%C in ('find /V /C "" ^< %mcat%') do set LINES=%%C

set /a LINES=LINES-1

more +%LINES% %mcat% > %line%

:: this is where the formatting happens
:: you will need to know a little bit of regex, but if you want to make changes to what your text looks like you don't
:: the part of the line below containing "$2 // $1" is how your final output text is going to look
:: $1 is the song name
:: $2 is the artist name
:: simply rearrange to change the order and formatting you desire
type %line% | jrepl ".*Playing: (.*) by (.*) -.*" "$2 // $1" /O %sa%
:: replace the above^ %sa% with %dest% and delete the second two lines if you DO NOT want all caps
set /p string= < %sa%
upper "%string%" | jrepl "\q(.*)\q" "$1" /B /X > %dest%

:: this just shows you what the string you're putting into the OBS text file looks like
type %dest%

:: adjust this time to be shorter or longer depending on how quickly you want to check for a new song in IRC
timeout /t %delay% /nobreak > NUL

GOTO :start