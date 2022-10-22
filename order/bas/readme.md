# Welcome
VB6 code to be included in a slideshow. Reads the [tags] from the notes of a powerpoint and sends them to the production PC.

## Setup

### Env Setup
Once ALT+F11 is pressed, be sure to toggle the immediate window to see all the console logging 
 * View > Immediate window
 * or CTRL+G

### Adding code to a ppt
From powerpoint, press ALT+F11 to bring up the macro view.
From there, rightclick on 'VBAProject' in the project window and 'Import File'
 > Select MainModule.bas, and repeat for TestHarness.bas

## Testing
Open TestHarness.bas
click 'Run Sub/User Form" and all break points should land on "Test Passed"

## Powerpoint Tags

Slide listener will listen for these tags and behave approprately.

[Start]
[Worship Hymn]
[Call To Worship]
[Call To Worship Warnecke]
[Old Testament]
[Sermon Hymn]
[Sermon Text]
[Sermon Text Krause]
[Sermon Theme]
[Creed]
[Prayer]
[Lords Prayer]
[Institution]
[Distribution]
[End of Distribution]
[Closing Hymn]
[Silent prayer]
[Announcements]
[After Service Video]
[Thank You For Worshiping]
[Sanctuary Special]
