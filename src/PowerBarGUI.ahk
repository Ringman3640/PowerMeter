; PowerBarGUI.ahk
; Script for creating and controling the PowerMeter power bar overlay
; Author: Ringman3640

; Interface functions:
;     initializePowerBar()
;     updatePowerBarLevel()
;     updateMultiplierValue()
;     showPowerBar()
;     hidePowerBar()

; Global variables
global PowerBarHWND
global PowerBarEnabled
global PowerBarWidth
global PowerBarHeight
global PowerBarPosX
global PowerBarPosY
global PowerBarDefaultMultiplier

; Global controls
global PowerBar1
global PowerBar2
global PowerBar3
global PowerBar4
global PowerBarTextShadow
global PowerBarText

initializePowerBar() {
    ; Gui settings
    PowerBarEnabled := false
    Gui, Overlay:New
    Gui, Overlay:+HwndPowerBarHWND +AlwaysOnTop +Owner +0x08000000 -Resize -Border -Caption
    ; 0x0x08000000 prevents the window from being activated on click
    Gui, Overlay:Color, FFFFFF

    ; Background image
    Gui, Overlay:Add, Picture, x0 y0, resources\power_bar_background.png

    ; Sliding power bars
    BAR_COLOR := "2AA02A"
    Gui, Overlay:Add, Progress, vPowerBar1 Range0-50 c%BAR_COLOR% w80 h35 x5 y30, 0
    Gui, Overlay:Add, Progress, vPowerBar2 Range0-50 c%BAR_COLOR% wp hp xp+82 yp, 0
    Gui, Overlay:Add, Progress, vPowerBar3 Range0-50 c%BAR_COLOR% wp hp xp+82 yp, 0
    Gui, Overlay:Add, Progress, vPowerBar4 Range0-50 c%BAR_COLOR% wp hp xp+82 yp, 0

    ; Power bar text shadow
    PowerBarDefaultMultiplier := 1.0
    FONT_SIZE := 14
    FONT_NAME := "Verdana"
    SHADOW_COLOR := "000000"
    Gui, Overlay:Font, s%FONT_SIZE% c%SHADOW_COLOR% Bold, %FONT_NAME%
    Gui, Overlay:Add, Text, vPowerBarTextShadow w300 h100 x6 y6, % "Power Level  x" . PowerBarDefaultMultiplier
    GuiControl, Overlay:+BackgroundTrans, PowerBarTextShadow

    ; Power bar text
    FONT_COLOR := "FFEA00"
    Gui, Overlay:Font, s%FONT_SIZE% c%FONT_COLOR% Bold, Verdana
    Gui, Overlay:Add, Text, vPowerBarText w300 h100 x5 y5, % "Power Level  x" . PowerBarDefaultMultiplier
    GuiControl, Overlay:+BackgroundTrans, PowerBarText

    ; Default show position
    PowerBarWidth := 336
    PowerBarHeight := 70
    PowerBarPosX := 10
    PowerBarPosY := A_ScreenHeight - PowerBarHeight - 10
}

; Change the power level indicated by the visual power bar
; Power ranges from 0 to 200
; Returns false if power is outside range
updatePowerBarLevel(power) {
    ; Check power validity
    if power is not number
        return false
    if (power < 0 || power > 400) {
        return false
    }

    ; Set power
    CurrentPower := power
    if (power > 150) {
        GuiControl, Overlay:, PowerBar1, 50
        GuiControl, Overlay:, PowerBar2, 50
        GuiControl, Overlay:, PowerBar3, 50
        GuiControl, Overlay:, PowerBar4, % power - 150
        return true
    }
    if (power > 100) {
        GuiControl, Overlay:, PowerBar1, 50
        GuiControl, Overlay:, PowerBar2, 50
        GuiControl, Overlay:, PowerBar3, % power - 100
        GuiControl, Overlay:, PowerBar4, 0
        return true
    }
    if (power > 50) {
        GuiControl, Overlay:, PowerBar1, 50
        GuiControl, Overlay:, PowerBar2, % power - 50
        GuiControl, Overlay:, PowerBar3, 0
        GuiControl, Overlay:, PowerBar4, 0
        return true
    }
    GuiControl, Overlay:, PowerBar1, % power
    GuiControl, Overlay:, PowerBar2, 0
    GuiControl, Overlay:, PowerBar3, 0
    GuiControl, Overlay:, PowerBar4, 0
    return true
}

; Update the printed multiplier value
; The multiplier can be an integer or float value
; Float values will be printed with a precision of 0.1
updateMultiplierValue(multiplier) {
    if multiplier is not number 
        return false
    if multiplier is float
        ; Set float precision to the tens
        multiplier := Format("{:.1f}", multiplier)

    GuiCOntrol, Overlay:, PowerBarTextShadow, % "Power Level  x" . multiplier
    GuiControl, Overlay:, PowerBarText, % "Power Level  x" . multiplier
}

; Show the power bar to the screen
showPowerBar() {
    if (powerBarEnabled) {
        return
    }

    PowerbarEnabled := true
    ;Gui, Overlay:+AlwaysOnTop +Owner -Resize -Border -Caption
    Gui, Overlay:Show, NoActivate w336 h70 x%PowerBarPosX% y%PowerBarPosY%
    WinSet, Region, w%PowerBarWidth% h%PowerBarHeight% x%PowerBarPosX% y%PowerBarPosY% R, ahk_id %PowerBarHWND%
}

; Hide the power bar from the screen
hidePowerBar() {
    if (!PowerBarEnabled) {
        return
    }

    PowerBarEnabled := false
    Gui, Overlay:Hide
}

; Testing function
launchGUI() {
    showPowerBar()

    iteration := 0
    Loop, 401 {
        updatePowerbarLevel(iteration)
        updateMultiplierValue(iteration + 0.5)
        ++iteration
    }
}