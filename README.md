# Golf It! PowerMeter
A program to add a power meter to the game Golf It!

Allows users to measure the power of their shots rather than needing to manually swing using the mouse.

Download: [PowerMeter v1.0 Release](https://github.com/Ringman3640/PowerMeter/releases/download/v1.0/Golf-It-PowerMeter-v1.0.zip)

## Instructions

Tutorial/Demonstration Video

[![Demonstration YouTube video](https://img.youtube.com/vi/QLcEq95ct8A/hqdefault.jpg)](https://www.youtube.com/watch?v=QLcEq95ct8A)

### Input Mode
Launching the program will bring up a window for changing input modes and controls. The two input modes available are mouse input and keyboard input.

**Mouse Input:** Slide the mouse up and down to set the position of the power meter bar.

**Keyboard Input:** Use separate keys to slide the power meter bar position.

### Starting The Game
To use the functionality of PowerMeter, simply startup Golf It! PowerMeter will automatically show a power bar overlay on the bottom left of the screen. 

**For the overlay to appear, make sure that fullscreen is turned off in the game settings.**

### Using The Power Meter
Once in-game, the controls to use PowerMeter depend on the input mode selected and any changes to the controls. Instructions for the default controls are as follows:

In mouse input mode, hold down the right mouse button to begin changing the power meter bar. Move the mouse up or down to set the power level. To putt the golf ball, click the left mouse button while still holding the right mouse button. To cancel the windup, release the right mouse button.

In keyboard input mode, use the left and right arrows to set the power level. Putt the golf ball using the Z key.

In both modes, the multiplier can be set using the up and down arrow keys.

### Multiplier
The multiplier is used to modify the output power of the power bar. The current multiplier is shown on the overlay to the right of the "Power Level" text. By default, the multiplier is set to x1.0. If more power is needed than the maximum allowed by the power bar, increasing the multiplier will raise the output power across the power bar.

The multiplier value can range from x0.1 to x20.0.

## Dependencies 
The PowerMeter executable must be in the same directory containing the program resources. This resources folder contains necessary images for the startup menu to properly display.

If using the AHK script files, launch the program through PowerMeter.ahk. The script requires the [MouseDelta library](https://www.autohotkey.com/boards/viewtopic.php?t=10159) by evilC. Include this file in the working directory of PowerMeter.ahk.
