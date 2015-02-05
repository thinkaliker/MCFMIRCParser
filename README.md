##Monstercat Twitch IRC log parser for Pidgin/HexChat
This Windows batch script takes [Pidgin](http://www.pidgin.im/) or [HexChat](http://hexchat.github.io/) IRC client chat logs in .txt form, parses them for [Monstercat](http://twitch.tv/monstercat) FM's Twitch music streaming bot, and formats them for use in [Open Broadcast Software](http://obsproject.org) or any other streaming program that uses a text file to update the current song/artist.

Required batch files:
- `logparser.bat` - main file to run
- `upper.bat` - helper batch file to convert to all caps. Can be optional if you edit logparser.
- `jrepl.bat` - A regex text processor. Unmodified but kept up to date from this [forum post](http://www.dostips.com/forum/viewtopic.php?f=3&t=6044).

How to use:
- Make sure Pidgin logs files in text format NOT HTML.
OR
- Make sure HexChat logs files and make sure the "twitch" server room does NOT log files. There is a prompt that will automatically delete this file for you.
- Connect to your Twitch IRC channel. I assume that you already know how to set it up. If not, Google "connect to twitch IRC" and all the instructions will be similar.
- Make sure you have allowed Monstercat's music bot into your channel and modded it so that it does not get timed out.
- Adjust formatting as necesary. There isn't a good way to do this, it's the last three lines before the timer near the end of the file.
- Save and exit your editor.
- Run - you can either open the batch file directly or you can run it from the command line. It doesn't matter.
- It will prompt you for your username, which should be the channel name you connected to in your IRC client. This is how we will get the logs.
- It will prompt you for the location of where you want the text file which contains the output of the formatted song name and artist.
- It will ask you which IRC client you are using (press `p` for Pidgin, press `h` for HexChat).
- It will check for new "songs" aka messages from the Monstercat bot every 20 seconds and update the text file when it changes.
- Add the text file to your OBS/whatever scene and you're good to go.
- To exit, press `Ctrl+C` or close the command prompt window. The last played song will be kept in the text file.

Bugs/TODO:
- Copies the entire log file - it can't be too big, obviously
- I would support mIRC but I don't have it because you have to buy it
- Only show the current song playing once - add checks to see if it's the same
