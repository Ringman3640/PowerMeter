; PowerMeter.ahk
; User-launched script for managing the Menu GUI and Power Bar Gui
; Author: Ringman3640

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance Force

initializeAll()
return

#Include MenuWInGUI.ahk

F4::
    ExitApp
    return

initializeAll() {
    initializePowerLogic()
    initializeMenu()
    setupShellHook()

    GAME_WIN_TITLE := "GolfIt  "
    if (WinActive(GAME_WIN_TITLE)) {
        enablePowerBarLogic()
    }
    else {
        showMenuWin()
    }
}

setupShellHook() {
    Gui, +LastFound
    winHandle := WinExist()
    DllCall("RegisterShellHookWindow", uint, winHandle)
    messageReg := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")
    OnMessage(messageReg, "winChangeHandler")
}

winChangeHandler(nCode, lParam) {
    static HSHELL_WINDOWACTIVATED := 4
    static HSHELL_RUDEAPPACTIVATED := 32772
    static GAME_WIN_TITLE := "GolfIt  "

    if (nCode != HSHELL_WINDOWACTIVATED && nCode != HSHELL_RUDEAPPACTIVATED) {
        return
    }

    if (WinActive(GAME_WIN_TITLE)) {
        hideMenuWin()
        enablePowerBarLogic()
    }
    else {
        disablePowerBarLogic()
        showMenuWin()
    }
}