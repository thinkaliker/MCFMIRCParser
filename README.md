##Monstercat Twitch IRC log parser for Pidgin/HexChat
A bit of a mouthful, but what it does is takes Pidgin or HexChat IRC client chat logs in .txt form, parses them for [Monstercat](http://twitch.tv/monstercat) FM's Twitch music streaming service, and formats them for use in [Open Broadcast Software](http://obsproject.org) or any other streaming program that uses a text file to update the current song.

Required batch files:
- `logparser.bat` - main file to run
- `upper.bat` - helper batch file to convert to all caps. Can be optional if you edit logparser.
- `jrepl.bat` - A regex text processor. Unmodified but kept up to date from this [forum post](http://www.dostips.com/forum/viewtopic.php?f=3&t=6044).

How to use:
- Make sure Pidgin logs files in text format NOT HTML.
OR
- Make sure HexChat logs files and make sure the "twitch" server room does NOT log files. I may add prompts for this later.
- Connect to your Twitch IRC channel.
- Make sure you have allowed Monstercat's music bot into your channel.
- Adjust formatting as necesary. There isn't a good way to do this, it's the last three lines before the timer.
- Save and exit your editor.
- Run - you can either open the batch file directly or you can run it from the command line. It doesn't matter.
- It will prompt you for your username, which should be the channel name you connected to in your IRC client. This is how we will get the logs.
- It will check for new "songs" aka messages from the Monstercat bot every 20 seconds and update the text file when it changes.
- Add the text file to your OBS/whatever scene and you're good to go.

Bugs/TODO:
- Prompt for HexChat or Pidgin configurations
- I would support mIRC but I don't have it because you have to buy it
- Only show the current song playing once - add checks to see if it's the same
