; PuttBall.ahk
; Provides the puttBall() function for interacting with the game
; Author: Ringman3640

puttBall(power) {
    ; Constant variables
    MOVEMENT_ITERATIONS := 5
    GAME_WIN_TITLE := "GolfIt  "
    MIN_POWER := 4
    X_OFFSET := 0

    ; Check input validity
    if power is not Number 
        return false
    if (power < 0) {
        return false
    }
    if (power == 0) {
        return true
    }

    ; Check active window
    WinGetTitle, activeWinTitle, A
    if (activeWinTitle != GAME_WIN_TITLE) {
        return false
    }

    ; Putt ball
    BlockInput, On
    Click, Left
    Sleep, 10

    power += MIN_POWER - 1
    DllCall("mouse_event", uint, 1, int, X_OFFSET, int, power * MOVEMENT_ITERATIONS, uint, 0, int, 0)
    Sleep, 50
    Loop % MOVEMENT_ITERATIONS * 2 {
        DllCall("mouse_event", uint, 1, int, X_OFFSET, int, power * -1, uint, 0, int, 0)
        Sleep, 1
    }

    Sleep, 50
    Click, Right
    BlockInput, Off
    return true
}