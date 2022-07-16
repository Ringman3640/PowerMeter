; PowerLogic.ahk
; Script for managing the power bar GUI and enabling functionality
; Author: Ringman3640

; Interface functions:
;     initializePowerBarLogic()
;     enablePowerBarLogic()
;     disablePowerBarLogic()
;     updateInputMode()
;     updateSelectKey()
;     updatePowerUpKey()
;     updatePowerDownKey()
;     updateWindupButton()
;     updateConfirmButton()
;     updateMultUpKey()
;     updateMultDownKey()

; Constants
global MIN_POWER
global MAX_POWER
global MIN_MULTIPLIER
global MAX_MULTIPLIER
global POWER_REDUCER
global MOUSE_DELTA_ON
global MOUSE_DELTA_OFF

; Key controls
global selectKey
global powerUpKey
global powerDownKey

; Mouse controls
global windupButton
global confirmButton

; Shared controls
global multUpKey
global multDownKey

; General control settings
global inputMode ; "key" or "mouse"
global blockInputFromWindow
global controlEnabled

; Global variables
global puttPower
global puttMultiplier
global puttingBall
global windingPutter
global changingPower
global changingMultiplier
global MDInstance

#Include PuttBall.ahk
#Include PowerBarGUI.ahk
#Include MouseDelta.ahk

;F2::
;    initializePowerLogic()
;    inputMode := "key"
;    enablePowerBarLogic()
;    return

;F4::
;    ExitApp
;    return

; Initialize global variables and controls
initializePowerLogic() {
    initializePowerBar()

    ; Constant initialization
    MIN_POWER := 0
    MAX_POWER := 200
    MIN_MULTIPLIER := 0.1
    MAX_MULTIPLIER := 20.0
    POWER_REDUCER := 1.5
    MOUSE_DELTA_ON := true
    MOUSE_DELTA_OFF := false

    ; Global variable initialization
    puttPower := 0
    puttMultiplier := 1
    puttingBall := false
    windingPutter := false
    changingPower := false
    changingMultiplier := false
    MDInstance := new MouseDelta("MouseEvent")
    MDInstance.SetState(MOUSE_DELTA_OFF)

    ; Default key controls
    selectKey := "z"
    powerUpKey := "Right"
    powerDownKey := "Left"

    ; Default mouse controls
    windupButton := "RButton"
    confirmButton := "LButton"

    ; Default shared controls
    multUpKey := "Up"
    multDownKey := "Down"

    ; Default general controls
    inputMode := "mouse"
    blockInputFromWIndow := false
    controlEnabled := false
}

; Enable the power bar (logic and visual)
enablePowerBarLogic() {
    if (controlEnabled) {
        return
    }

    controlEnabled := true
    enableHotkeys()
    showPowerBar()
}

; Disable the power bar (logic and visual)
disablePowerBarLogic() {
    if (!controlEnabled) {
        return
    }

    controlEnabled := false
    disableHotkeys()
    hidePowerBar()
}

; Change the input mode of the power bar controls
; Expects "mouse" or "key" argument
; Returns false if not "mouse" or "key"
; Controls must be disabled to change input modes
updateInputMode(inMode) {
    if (inMode != "mouse" && inMode != "key") {
        return false
    }
    if (controlEnabled) {
        return false
    }
    if (inMode == inputMode) {
        return true
    }

    inputMode := inMode
    return true
}

; Update a key control function group
; Changes the currently stored key variable and updates the Hotkey if active
; Targets the key input mode
updateSelectKey(key) {
    if (inputMode != "key" || !controlEnabled) {
        selectKey := key
        return
    }

    Hotkey, % selectKey, Off
    selectKey := key
    Hotkey, % selectKey, startPutt, On
}
updatePowerUpKey(key) {
    if (inputMode != "key" || !controlEnabled) {
        powerUpKey := key
        return
    }

    Hotkey, % powerUpKey, Off
    powerUpKey := key
    Hotkey, % powerUpKey, increasePower, On
}
updatePowerDownKey(key) {
    if (inputMode != "key" || !controlEnabled) {
        powerDownKey := key
        return
    }

    Hotkey, % powerDownKey, Off
    powerDownKey := key
    Hotkey, % powerDownKey, decreasePower, On
}

; Update a button control function pair
; Changes the currently stored button variable and updates the Hotkey if active
; Targets the mouse input mode
updateWindupButton(newButton) {
    if (inputMode != "mouse" || !controlEnabled) {
        windupButton := newButton
        return
    }

    Hotkey, % windupButton, Off
    windupButton := newButton
    Hotkey, % windupButton, startWindup, On
}
updateConfirmButton(newButton) {
    confirmButton := newButton
}

; Update multiplier function pair
; Changes the currently stored input variable and updates the Hotkey if active
; Targets both the mouse and key input mode
updateMultUpKey(key) {
    if (!controlEnabled) {
        multUpKey := key
        return
    }

    Hotkey, % multUpKey, Off
    multUpKey := key
    Hotkey, % multUpKey, increaseMultiplier, On
}
updateMultDownKey(key) {
    if (!controlEnabled) {
        multDownKey := key
        return
    }

    Hotkey, % multDownKey, Off
    multDownKey := key
    Hotkey, % multDownKey, decreaseMultiplier, On
}

; Enable hotkey controls for the indicated input mode
enableHotkeys() {
    if (!controlEnabled) {
        return
    }

    Hotkey, % multUpKey, increaseMultiplier, On
    Hotkey, % multDownKey, decreaseMultiplier, On

    if (inputMode == "key") {
        Hotkey, % selectKey, startPutt, On
        Hotkey, % powerUpKey, increasePower, On
        Hotkey, % powerDownKey, decreasePower, On
    }
    else if (inputMode == "mouse") {
        Hotkey, % windupButton, startWindup, On
    }
}

; Disable all active hotkey controls
disableHotkeys() {
    if (controlEnabled) {
        return
    }

    Hotkey, % multUpKey, Off
    Hotkey, % multDownKey, Off

    if (inputMode == "key") {
        Hotkey, % selectKey, Off
        Hotkey, % powerUpKey, Off
        Hotkey, % powerDownKey, Off
    }
    else if (inputMode == "mouse") {
        Hotkey, % windupButton, Off
    }
    
    ;Hotkey, % multUpKey, Off
    ;Hotkey, % multDownKey, Off
    ;Hotkey, % selectKey, Off
    ;Hotkey, % powerUpKey, Off
    ;Hotkey, % powerDownKey, Off
    ;Hotkey, % windupButton, Off
}

startPutt() {
    if (changingPower || changingMultiplier || puttingBall) {
        return
    }

    puttingBall := true
    puttBall(puttPower * puttMultiplier / POWER_REDUCER)
    puttingBall := false
}

increasePower() {
    if (changingPower) {
        return
    }

    increment := 1
    iteration := 0
    changingPower := true
    
    while (GetKeyState(powerUpKey, "P")) {
        if (iteration > 10 && increment < 10) {
            ++increment
            iteration := 0
        }

        puttPower += increment
        if (puttPower > MAX_POWER) {
            puttPower := MAX_POWER
        }

        updatePowerBarLevel(puttPower)
        ++iteration
        Sleep, 1
    }

    changingPower := false
}

decreasePower() {
    if (changingPower) {
        return
    }

    increment := 1
    iteration := 0
    changingPower := true
    
    while (GetKeyState(powerDownKey, "P")) {
        if (iteration > 10 && increment < 20) {
            ++increment
            iteration := 0
        }

        puttPower -= increment
        if (puttPower < MIN_POWER) {
            puttPower := MIN_POWER
        }

        updatePowerBarLevel(puttPower)
        ++iteration
        Sleep, 1
    }

    changingPower := false
}

startWindup() {
    if (windingPutter) {
        return
    }

    windingPutter := true

    ; Block if user is holding confirm button
    while (GetKeyState(confirmButton, "P")) {
        Sleep, 10
    }

    ; Spawn game putter to disable camera movement
    ; Move putter very far back
    Click, Left
    distance := 9999999
    DllCall("mouse_event", uint, 1, int, X_OFFSET, int, distance, uint, 0, int, 0)

    MDInstance.SetState(MOUSE_DELTA_ON)
    BlockInput, MouseMove
    while (GetKeyState(windupButton, "P")) {
        if (GetKeyState(confirmButton, "P")) {
            MDInstance.SetState(MOUSE_DELTA_OFF)
            Click, Right
            puttball(puttPower * puttMultiplier / POWER_REDUCER)
            break
        }
        Sleep, 10
    }
    click, Right
    MDInstance.SetState(MOUSE_DELTA_OFF)
    updatePowerBarLevel(0)
    puttPower := 0
    BlockInput, MouseMoveOff

    ; Block until user releases windup button
    while (GetKeyState(windupButton, "P")) {
        Sleep, 10
    }
    windingPutter := false
}

MouseEvent(MouseID, x := 0, y := 0) {
    if (!windingPutter) {
        return
    }

    puttPower -= y
    if (puttPower < MIN_POWER) {
        puttPower := MIN_POWER
    }
    else if (puttPower > MAX_POWER) {
        puttPower := MAX_POWER
    }

    updatePowerBarLevel(puttPower)
}

increaseMultiplier() {
    if (changingMultiplier) {
        return
    }

    sleepDuration := 100
    iteration := 0
    changingMultiplier := true
    
    while (GetKeyState(multUpKey, "P")) {
        if (iteration > 4 && sleepDuration > 20) {
            sleepDuration -= 20
            iteration := 0
        }

        puttMultiplier += 0.1
        if (puttMultiplier > MAX_MULTIPLIER) {
            puttMultiplier := MAX_MULTIPLIER
        }

        updateMultiplierValue(puttMultiplier)
        ++iteration
        Sleep, % sleepDuration
    }

    changingMultiplier := false
}

decreaseMultiplier() {
    if (changingMultiplier) {
        return
    }

    sleepDuration := 100
    iteration := 0
    changingMultiplier := true
    
    while (GetKeyState(multDownKey, "P")) {
        if (iteration > 4 && sleepDuration > 20) {
            sleepDuration -= 20
            iteration := 0
        }

        puttMultiplier -= 0.1
        if (puttMultiplier < MIN_MULTIPLIER) {
            puttMultiplier := MIN_MULTIPLIER
        }

        updateMultiplierValue(puttMultiplier)
        ++iteration
        Sleep, % sleepDuration
    }

    changingMultiplier := false
}