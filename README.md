#Monstercat Twitch IRC log parser for Pidgin/HexChat
This Windows batch script takes [Pidgin](http://www.pidgin.im/) or [HexChat](http://hexchat.github.io/) IRC client chat logs in .txt form, parses them for [Monstercat](http://twitch.tv/monstercat) FM's Twitch music streaming bot, and formats them for use in [Open Broadcast Software](http://obsproject.org) or any other streaming program that uses a text file to update the current song/artist.

Don't have Pidgin or HexChat? Try [MCFMIRCParser](http://github.com/thinkaliker/mcfmircparser).

![what it looks like](http://i.imgur.com/d5CBfSn.png)

##Features
This script provides an easy, user friendly interface for pulling the currently playing Monstercat FM song from IRC chat logs and writing the result into a text file for use in streaming software. Contains checks so that it is difficult to screw up inputting values.

##Required batch files
- `logparser.bat` - main file to run
- `upper.bat` - helper batch file to convert to all caps. Can be optional if you edit logparser.
- `jrepl.bat` - A regex text processor. Unmodified but kept up to date from this [forum post](http://www.dostips.com/forum/viewtopic.php?f=3&t=6044).

##How to use

###Before you start
- Make sure Pidgin logs files in text format NOT HTML.    
OR    
- Make sure HexChat logs files and is in the proper directory. (server should be called `twitch`)
- Connect to your Twitch IRC channel. I assume that you already know how to set it up. If not, Google "connect to twitch IRC" and all the instructions will be similar.
- Make sure you have allowed Monstercat's music bot into your channel and modded it so that it does not get timed out by other bots.
- Adjust formatting as necesary. There isn't a good way to do this, it's the last three lines before the timer near the end of the file.
- Save and exit your editor.

###Running
- Run the batch file - you can either open the batch file directly or you can run it from the command line. It doesn't matter.
- It will prompt you for the location of where you want the text file which contains the output of the formatted song name and artist. This is the file you will be putting into OBS/whatever. I recommend it be somewhere in your Documents folder. I have had issues with it in other places.
- It will prompt you for your username, which should be the channel name you connected to in your IRC client. This is how we will get the logs.
- It will ask you which IRC client you are using (press `p` for Pidgin, press `h` for HexChat).
- It will prompt you for the delay. The default is 10 seconds - you can input something else, but keep in mind that each check requires copying a file. It will check for new "songs" aka messages from the Monstercat bot every 10 seconds (or however many seconds you provided).
- Add the text file to your OBS/whatever scene and you're good to go.
- You may need to type `!songs` in Twitch chat or your IRC window to cause a change to show up otherwise the currently playing song will not show up.
- To exit, press `Ctrl+C` or close the command prompt window. The last played song will be kept in the text file.

##Bugs/TODO
- Using another drive such as D:\ may cause issues with the text file - YMMV
- Different output styles selection
- Copies the entire log file - it can't be too big, obviously
- I would support mIRC but I don't have it because you have to buy it
