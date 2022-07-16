; MenuWinGUI.ahk
; Script for creating and operating the PowerMeter menu GUI
; Author: Ringman3640

; Interface functions:
;     initializeMenu()
;     showMenuWin()
;     hideMenuWin()

; Global variables
global MenuWinEnabled
global MenuWinWidth
global MenuWinHeight
global MenuWinExpandedHeight
global MenuWinSettingsMoving
global MenuWinSettingsOpen
global MenuWinSettingsChanged
global MenuWinFileName

; Global controls
global MenuWinHeaderText
global MenuWinHeaderTextShadow
global MenuWinMouseUnselected
global MenuWinKeyUnselected
global MenuWinMouseText
global MenuWinKeyText
global MenuWinSliderDown
global MenuWinSliderUp
global MenuWinMultUpDDL
global MenuWinMultDownDDL
global MenuWinWindupDDL
global MenuConfirmWindDDL
global MenuWinPuttDDL
global MenuWinPowerUpDDL
global MenuWinPowerDownDDL

#include PowerLogic.ahk

;F1::
;    initializeMenu()
;    showMenuWin()
;    return

;F4::
;    ExitApp
;    return

MenuWinGuiClose:
    if (MenuWinSettingsChanged) {
        saveSettings()
    }
    ExitApp
    return

DragHandler:
    ; No idea why this works but poggers
    PostMessage, 0xA1, 2,,, A
    return

initializeMenu() {
    ; Default window dimensions
    MenuWinWidth := 330
    MenuWinHeight := 240
    MenuWinExpandedHeight := 610
    MenuWinFileName := "preferences.ini"

    ; Global var initialization
    MenuWinEnabled := false
    MenuWinSettingsMoving := false
    MenuWinSettingsOpen := false
    MenuWinSettingsChanged := false

    ; Gui settings
    Gui, MenuWin:New
    Gui, MenuWin:-Border -Caption -MaximizeBox -MinimizeBox -Resize

    ; Exit button (only for exit function)
    xPos := MenuWinWidth - 30
    Gui, MenuWin:Add, Picture, x%xPos% y0 gMenuWinGuiClose, resources\exit_button.png

    ; Header background
    Gui, MenuWin:Add, Picture, x0 y0 gDragHandler, resources\header_background.png

    ; Exit button
    xPos := MenuWinWidth - 30
    Gui, MenuWin:Add, Picture, x%xPos% y0, resources\exit_button.png

    ; Main header shadow
    FONT_NAME := "Bahnschrift"
    FONT_COLOR := "FFFFFF"
    Gui, MenuWin:Font, s28 c%FONT_COLOR% Bold, %FONT_NAME%
    Gui, MenuWin:Add, Text, vMenuWinHeaderTextShadow Left w500 x16 y8, Power Meter
    GuiControl, +BackgroundTrans, MenuWinHeaderTextShadow

    ; Main header
    FONT_COLOR := "000000"
    Gui, MenuWin:Font, s28 c%FONT_COLOR% Bold, %FONT_NAME%
    Gui, MenuWin:Add, Text, vMenuWinHeaderText Left wp xp-1 yp-1, Power Meter
    GuiControl, +BackgroundTrans, MenuWinHeaderText
    
    ; Notice text
    FONT_COLOR := "3B3B3B"
    Gui, MenuWin:Font, s12 c%FONT_COLOR% Normal
    Gui, MenuWin:Add, Text, Left wp xp+1 yp+60, Enter the game to start . . .

    ; Input selection header
    FONT_COLOR := "000000"
    LINE_BAR_WIDTH := MenuWinWidth - 15 - 15
    Gui, MenuWin:Font, s16 c%FONT_COLOR% Normal
    Gui, MenuWin:Add, Text, xp yp+40, Input Mode
    Gui, MenuWin:Add, Text, w%LINE_BAR_WIDTH% xp yp+25 0x10

    ; Mosue input button
    FONT_COLOR := "3B3B3B"
    Gui, MenuWin:Font, s12 c%FONT_COLOR% Normal
    Gui, MenuWin:Add, Picture, xp yp+10, resources\selected_toggle.png
    Gui, MenuWin:Add, Picture, vMenuWinMouseUnselected xp yp gselectMouseMode, resources\unselected_toggle.png
    Gui, MenuWin:Add, Text, vMenuWinMouseText w120 xp yp+10 Center, Mouse
    GuiControl, +BackgroundTrans, MenuWinMouseText

    ; Keyboard input button
    xPos := MenuWinWidth - 120 - 15
    Gui, MenuWin:Add, Picture, x%xPos% yp-10, resources\selected_toggle.png
    Gui, MenuWin:Add, Picture, vMenuWinKeyUnselected xp yp gselectKeyMode, resources\unselected_toggle.png
    Gui, MenuWin:Add, Text, vMenuWinKeyText w120 xp yp+10 Center, Keyboard
    GuiControl, +BackgroundTrans, MenuWinKeyText

    ; Multiplier settings header
    FONT_COLOR := "000000"
    Gui, MenuWin:Font, s16 c%FONT_COLOR% Normal
    Gui, MenuWin:Add, Text, x15 yp+50, Multiplier Controls
    Gui, MenuWin:Add, Text, w%LINE_BAR_WIDTH% xp yp+25 0x10

    CONTROL_OPTIONS := "A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|Up|Down|Left|Right|Shift|Ctrl|Enter|Space|L Click|R Click"

    ; Modify multiplier up control
    FONT_COLOR := "3B3B3B"
    Gui, MenuWin:Font, s12 c%FONT_COLOR% Normal
    Gui, MenuWin:Add, Text, x35 yp+15, Multiplier Up
    xPos := MenuWinWidth - 100 - 18
    Gui, MenuWin:Add, DDL, vMenuWinMultUpDDL w100 h200 x%xPos% yp-5 gmultUpDDL, %CONTROL_OPTIONS%

    ; Modify multiplier down control
    Gui, MenuWin:Add, Text, x35 yp+35, Multiplier Down
    xPos := MenuWinWidth - 100 - 18
    Gui, MenuWin:Add, DDL, vMenuWinMultDownDDL w100 h200 x%xPos% yp-5 gmultDownDDL, %CONTROL_OPTIONS%

    ; Mouse settings header
    FONT_COLOR := "000000"
    Gui, MenuWin:Font, s16 c%FONT_COLOR% Normal
    Gui, MenuWin:Add, Text, x15 yp+50, Mouse Controls
    Gui, MenuWin:Add, Text, w%LINE_BAR_WIDTH% xp yp+25 0x10

    ; Modify start windup control
    FONT_COLOR := "3B3B3B"
    Gui, MenuWin:Font, s12 c%FONT_COLOR% Normal
    Gui, MenuWin:Add, Text, x35 yp+15, Start Windup
    xPos := MenuWinWidth - 100 - 18
    Gui, MenuWin:Add, DDL, vMenuWinWindupDDL w100 h200 x%xPos% yp-5 gwindupDDL, %CONTROL_OPTIONS%

    ; Modify confirm windup control
    Gui, MenuWin:Add, Text, x35 yp+35, Confirm Windup
    xPos := MenuWinWidth - 100 - 18
    Gui, MenuWin:Add, DDL, vMenuConfirmWindDDL w100 h200 x%xPos% yp-5 gconfirmWindDDL, %CONTROL_OPTIONS%

    ; Mouse settings header
    FONT_COLOR := "000000"
    Gui, MenuWin:Font, s16 c%FONT_COLOR% Normal
    Gui, MenuWin:Add, Text, x15 yp+50, Keyboard Controls
    Gui, MenuWin:Add, Text, w%LINE_BAR_WIDTH% xp yp+25 0x10
    
    ; Modify putt control
    FONT_COLOR := "3B3B3B"
    Gui, MenuWin:Font, s12 c%FONT_COLOR% Normal
    Gui, MenuWin:Add, Text, x35 yp+15, Putt
    xPos := MenuWinWidth - 100 - 18
    Gui, MenuWin:Add, DDL, vMenuWinPuttDDL w100 h200 x%xPos% yp-5 gputtDDL, %CONTROL_OPTIONS%

    ; Modify power up control
    Gui, MenuWin:Add, Text, x35 yp+35, Power Up
    xPos := MenuWinWidth - 100 - 18
    Gui, MenuWin:Add, DDL, vMenuWinPowerUpDDL w100 h200 x%xPos% yp-5 gpowerUpDDL, %CONTROL_OPTIONS%

    ; Modify power down control
    Gui, MenuWin:Add, Text, x35 yp+35, Power Down
    xPos := MenuWinWidth - 100 - 18
    Gui, MenuWin:Add, DDL, vMenuWinPowerDownDDL w100 h200 x%xPos% yp-5 gpowerDownDDL, %CONTROL_OPTIONS%

    ; Settings slider
    yPos := MenuWinHeight - 40
    Gui, MenuWin:Add, Picture, vMenuWinSliderUp w%MenuWinWidth% x0 y%yPos% gtoggleSettingSlider, resources\slider_up.png
    Gui, MenuWin:Add, Picture, vMenuWinSliderDown w%MenuWinWidth% x0 y%yPos% gtoggleSettingSlider, resources\slider_down.png

    ; Load settings
    if (!initializeSettings()) {
        loadDefaultSettings()
    }
    updateDDLChoices()
}

showMenuWin() {
    if (MenuWinEnabled) {
        return
    }

    showHeight := ""
    if (MenuWinSettingsOpen) {
        showHeight := MenuWinExpandedHeight
    }
    else {
        showHeight := MenuWInHeight
    }

    MenuWinEnabled := true
    Gui, MenuWin:Show, w%MenuWinWidth% h%showHeight%, Power Meter
}

hideMenuWin() {
    if (!MenuWinEnabled) {
        return
    }

    MenuWinEnabled := false
    Gui, MenuWin:Hide
}

initializeSettings() {
    if (!FileExist(MenuWinFileName)) {
        return false
    }

    ; General preferences
    IniRead, inputMode, %MenuWinFileName%, General Preferences, input mode
    if (inputMode == "ERROR") {
        return false
    }
    if (inputMode == "mouse") {
        selectMouseMode()
    }
    else {
        selectKeyMode()
    }
    MenuWinSettingsChanged := false
    IniRead, multUpKey, %MenuWinFileName%, General Preferences, mult up
    if (multUpKey == "ERROR") {
        return false
    }
    IniRead, multDownKey, %MenuWinFileName%, General Preferences, mult down
    if (multDownKey == "ERROR") {
        return false
    }

    ; Mouse preferences
    IniRead, windupButton, %MenuWinFileName%, Mouse Preferences, windup
    if (windupButton == "ERROR") {
        return false
    }
    IniRead, confirmButton, %MenuWinFileName%, Mouse Preferences, confirm
    if (confirmButton == "ERROR") {
        return false
    }
    
    ; Keyboard preferences
    IniRead, selectKey, %MenuWinFileName%, Keyboard Preferences, putt
    if (selectKey == "ERROR") {
        return false
    }
    IniRead, powerUpKey, %MenuWinFileName%, Keyboard Preferences, power up
    if (powerUpKey == "ERROR") {
        return false
    }
    IniRead, powerDownKey, %MenuWinFileName%, Keyboard Preferences, power down
    if (powerDownKey == "ERROR") {
        return false
    }

    return true
}

loadDefaultSettings() {
    selectMouseMode()
    MenuWinSettingsChanged := false

    updateMultUpKey("Up")
    updateMultDownKey("Down")
    updateWindupButton("RButton")
    updateConfirmButton("LButton")
    updateSelectKey("Z")
    updatePowerUpKey("Right")
    updatePowerDownKey("Left")
}

; Get the associated index of a choice string from a DDL
; Implementation is very cluttered and messy, but can't think of another solution atm
; Any addition/changes to CONTROL_OPTIONS in initializeMenu() need to be reflected in the choiceList array
getDDLChoiceNum(choiceString) {
    static choiceList := ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "Up", "Down", "Left", "Right", "Shift", "Ctrl", "Enter", "Space", "LButton", "RButton"]

    For index, value in choiceList {
        StringLower, lowerValue, value
        StringLower, lowerchoice, choiceString
        if (lowerValue == lowerchoice) {
            return index
        }
    }

    return 0
}

updateDDLChoices() {
    ; Mult up DDL
    idx := getDDLChoiceNum(multUpKey)
    GuiControl, Choose, MenuWinMultUpDDL, %idx%

    ; Mult down DDL
    idx := getDDLChoiceNum(multDownKey)
    GuiControl, Choose, MenuWinMultDownDDL, %idx%

    ; Windup DDL
    idx := getDDLChoiceNum(windupButton)
    GuiControl, Choose, MenuWinWindupDDL, %idx%

    ; Confirm DDL
    idx := getDDLChoiceNum(confirmButton)
    GuiControl, Choose, MenuConfirmWindDDL, %idx%

    ; Putt DDL
    idx := getDDLChoiceNum(selectKey)
    GuiControl, Choose, MenuWinPuttDDL, %idx%

    ; Power up DDL
    idx := getDDLChoiceNum(powerUpKey)
    GuiControl, Choose, MenuWinPowerUpDDL, %idx%

    ; Power down DDL
    idx := getDDLChoiceNum(powerDownKey)
    GuiControl, Choose, MenuWinPowerDownDDL, %idx%
}

saveSettings() {
    ; General preferences
    IniWrite, %inputMode%, %MenuWinFileName%, General Preferences, input mode
    IniWrite, %multUpKey%, %MenuWinFileName%, General Preferences, mult up
    IniWrite, %multDownKey%, %MenuWinFileName%, General Preferences, mult down

    ; Mouse preferences
    IniWrite, %windupButton%, %MenuWinFileName%, Mouse Preferences, windup
    IniWrite, %confirmButton%, %MenuWinFileName%, Mouse Preferences, confirm
    
    ; Keyboard preferences
    IniWrite, %selectkey%, %MenuWinFileName%, Keyboard Preferences, putt
    IniWrite, %powerUpKey%, %MenuWinFileName%, Keyboard Preferences, power up
    IniWrite, %powerDownKey%, %MenuWinFileName%, Keyboard Preferences, power down
}

selectMouseMode() {
    GuiControl, Hide, MenuWinMouseUnselected
    GuiControl, Show, MenuWinKeyUnselected
    updateInputMode("mouse")
    MenuWinSettingsChanged := true
}

selectKeyMode() {
    GuiControl, Hide, MenuWinKeyUnselected
    GuiControl, Show, MenuWinMouseUnselected
    updateInputMode("key")
    MenuWinSettingsChanged := true
}

toggleSettingSlider() {
    if (MenuWinSettingsMoving) {
        return
    }

    MenuWinSettingsMoving := true

    if (MenuWinSettingsOpen) {
        currentSize := MenuWinExpandedHeight
        yPos := MenuWinHeight - 40
        GuiControl, Move, MenuWinSliderDown, y%yPos%
        GuiControl, Move, MenuWinSliderUp, y%yPos%
        Gui, MenuWin:Show, NoActivate w%MenuWinWidth% h%MenuWinHeight%, Power Meter
        GuiControl, Show, MenuWinSliderDown
        MenuWinSettingsOpen := false
    }
    else {
        yPos := MenuWinExpandedHeight - 40
        GuiControl, Move, MenuWinSliderDown, y%yPos%
        GuiControl, Move, MenuWinSliderUp, y%yPos%
        Gui, MenuWin:Show, NoActivate w%MenuWinWidth% h%MenuWinExpandedHeight%, Power Meter
        GuiControl, Hide, MenuWinSliderDown
        MenuWinSettingsOpen := true
    }

    MenuWinSettingsMoving := false
}

DDLChangeHelper(DDLVal, updateFunc) {
    if (DDLVal == "L Click") {
        %updateFunc%("LButton")
        return
    }
    if (DDLVal == "R Click") {
        %updateFunc%("RButton")
        return
    }

    %updateFunc%(DDLVal)
    MenuWinSettingsChanged := true
}

multUpDDL() {
    Gui, MenuWin:Submit, NoHide
    DDLChangeHelper(MenuWinMultUpDDL, "updateMultUpKey")
}

multDownDDL() {
    Gui, MenuWin:Submit, NoHide
    DDLChangeHelper(MenuWinMultDownDDL, "updateMultDownKey")
}

windupDDL() {
    Gui, MenuWin:Submit, NoHide
    DDLChangeHelper(MenuWinWindupDDL, "updateWindupButton")
}

confirmWindDDL() {
    Gui, MenuWin:Submit, NoHide
    DDLChangeHelper(MenuConfirmWindDDL, "updateConfirmButton")
}

puttDDL() {
    Gui, MenuWin:Submit, NoHide
    DDLChangeHelper(MenuWinPuttDDL, "updateSelectKey")
}

powerUpDDL() {
    Gui, MenuWin:Submit, NoHide
    DDLChangeHelper(MenuWinPowerUpDDL, "updatePowerUpKey")
}

powerDownDDL() {
    Gui, MenuWin:Submit, NoHide
    DDLChangeHelper(MenuWinPowerDownDDL, "updatePowerDownKey")
}