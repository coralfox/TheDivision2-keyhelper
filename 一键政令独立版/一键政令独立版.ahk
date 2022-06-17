#NoEnv
#InstallKeybdHook
#InstallMouseHook
#KeyHistory 50
#UseHook
#MaxThreadsPerHotkey 1
#MaxThreads 30
#MaxThreadsBuffer off
SendMode Input
ListLines, Off

SetWorkingDir %A_ScriptDir%

PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, High

global ver := "1.0"

if FileExist("ZLsettings.ini")
{
  IniRead , vOneKeyZL, ZLsettings.ini, 一键政令, 启用, 1
  IniRead, delay, ZLsettings.ini, 一键政令, 延迟, 150
  IniRead , vResetArea, ZLsettings.ini, 一键政令, 重置控制点, 1
  IniRead , vSwitchLevel, ZLsettings.ini, 一键政令, 切换难度, 1

}
Else
{
  iniWrite , 1, ZLsettings.ini, 一键政令, 启用
  iniWrite, 150, ZLsettings.ini, 一键政令, 延迟
  iniWrite , 1, ZLsettings.ini, 一键政令, 重置控制点
  iniWrite , 1, ZLsettings.ini, 一键政令, 切换难度
}
;#####################
;#====菜单相关====#
;#####################
Menu , tray, NoStandard

Menu , tray, add,
Menu , tray, add, 一键政令|ALT+1, OnekeyZL
if (vOneKeyZL) {
  Menu , tray, check, 一键政令|ALT+1
}

Menu , tray, add, 一键政令时重置控制点, ResetArea
if (vResetArea) {
  Menu , tray, check, 一键政令时重置控制点
}

Menu , tray, add, 一键政令时切换难度, SwitchLevel
if (vSwitchLevel) {
  Menu , tray, check, 一键政令时切换难度
}

;===========================================
Menu,Tray,Add,
;常规控制 Menu, tray, add, Menu, tray, NoStandard
Menu,tray,add,重置 | Reload,ReloadScript
Menu,tray,add,暂停 | Pause,PauseScript
Menu,tray,add,
Menu,tray,add,更新 | Ver %ver%,Version	;使用资源表示符 207 表示的图标
Menu,tray,add,退出 | Exit,ExitScript

#IfWinActive ahk_exe TheDivision2.exe

  ; 打开或关闭 5 政令，默认是 Alt+1
  !1:: ;英雄难度,5政令,重置控制点
    SendKey("m")
    Sleep delay
    SendKey("z")
    Sleep delay

    if (vSwitchLevel)
    {

      SendKey("Space") ;开启英雄难度
      Sleep delay
      Loop, 3
      {
        SendKey("Down")
        Sleep delay
      }
      SendKey("Space") ;英雄难度
      Sleep delay
      SendKey("Esc")
      Sleep delay
    }

    SendKey("Down")
    Sleep delay
    SendKey("Space")
    Sleep delay

    Loop, 4 ;开政令
    {
      SendKey("Space")
      Sleep delay
      SendKey("Down")
      Sleep delay
    }

    SendKey("Space")
    Sleep delay
    SendKey("Esc")
    Sleep delay

    if (vResetArea = 1)
    {
      SendKey("Down")
      Sleep delay
      SendKey("Space")
      Sleep delay
    }

    SendKey("f")
    Sleep 300
    SendKey("Space",200)
    Sleep delay
    SendKey("m")
  return

  !2:: ;一般难度,5政令关闭
    SendKey("m")
    Sleep delay
    SendKey("z")
    Sleep delay
    if (vSwitchLevel){
      ;开启一般难度
      SendKey("Space")
      Sleep delay
      SendKey("Space")
      Sleep delay
    }
    SendKey("Esc")
    Sleep delay
    SendKey("Down")
    Sleep delay
    SendKey("Space")
    Sleep delay

    ;关闭政令
    Loop, 4 
    {
      SendKey("Space")
      Sleep delay
      SendKey("Down")
      Sleep delay
    }

    SendKey("Space")
    Sleep delay
    SendKey("Esc")
    Sleep delay

    if (vResetArea = 1)
    {
      SendKey("Down")
      Sleep delay
      SendKey("Space")
      Sleep delay
    }

    SendKey("f")
    Sleep 300
    SendKey("Space",200)
    Sleep delay
    SendKey("m")
  return
  #IF

  SendKey(Key, vDelay := 80)
  {
    Send {%key% Down}
    Sleep vDelay
    Send {%key% Up}
  }

  ;#####################
  ;#====一键政令相关菜单====#
  ;#####################
  ;一键政令
  OnekeyZL:
    Menu, Tray, ToggleCheck, 一键政令|ALT+1
    vOneKeyZL := Not vOneKeyZL
    IniWrite, % vOneKeyZL, ZLsettings.ini, 一键政令, 启用
  return

  ;重置控制点
  ResetArea:
    Menu, Tray, ToggleCheck, 一键政令时重置控制点
    vResetArea := Not vResetArea
    IniWrite, % vResetArea, ZLsettings.ini, 一键政令, 重置控制点
  return

  ;切换难度
  SwitchLevel:
    Menu, Tray, ToggleCheck, 一键政令时切换难度
    vSwitchLevel := Not vSwitchLevel
    IniWrite, % vSwitchLevel, ZLsettings.ini, 一键政令, 切换难度
  return

  ;#####################
  ;#====常规标签====#
  ;#####################
  MenuHandler:
  return

  ReloadScript:
    Reload
  return

  PauseScript:
    Suspend, Toggle
    Pause, Toggle
  return

  Help:
    run,https://coralfox.notion.site/2-ca1b7772d1ac4043ac1a5fc0e4fb83fe
  return

  Version:
    run,https://github.com/coralfox/TheDivision2-keyhelper/releases/tag/%E4%B8%80%E9%94%AE%E6%94%BF%E4%BB%A4
  return

  ExitScript:
  ExitApp
  return