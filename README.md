# witcher3UWfix
Patch for ultrawide resolutions in The Witcher 3 game

The game itself supports ultra-wide monitors, but there is no cutscene.<br>
This fix will allow you to fix the aspect ratio in an automatic way.

Place the tool in the same folder as witcher3.exe (/bin/x64/ or /bin/x64_dx12)<br>
Run the tool and follow instructions

The patch modifies the game.exe file.<br>
Replacement is made for all values "39 8E E3 3F", depends on the selected screen resolution:<br>
2560x1080 (21:9) = 26 B4 17 40<br>
3440x1440 (21:9) = 8E E3 18 40<br>
3840x1200 (32:10) = CD CC 4C 40<br>
3840x1600 (21:9) = 9A 99 19 40<br>
5120x1440 (32:9) = 39 8E 63 40<br>
5120x2160 (21:9) = 26 B4 17 40<br>
6880x2880 (21:9) = 8E E3 18 40<br>

Support custom resolution
