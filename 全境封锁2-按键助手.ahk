;#####################
;#=====命令====#
;#####################
SetWorkingDir %A_ScriptDir%
#NoEnv
#InstallKeybdHook
#InstallMouseHook
#KeyHistory 0
#UseHook
#MaxThreadsPerHotkey 1
#MaxThreads 30
#MaxThreadsBuffer off
SendMode Input
ListLines , Off
PID := DllCall("GetCurrentProcessId")
Process , Priority, %PID%, High
CoordMode , Pixel, Screen
CoordMode , Mouse, Screen

;#####################
;#====读取ini&初始化====#
;#####################
global _downVal := 2
global _rightVal := 0
global _shotdelay := 0

IniRead , _downVal, TheDivision2.ini, 高级模式, 垂直偏移, 2
IniRead , _rightVal, TheDivision2.ini, 高级模式, 水平偏移, 0
IniRead , _shotdelay, TheDivision2.ini, 高级模式, 单发间隔, 0

IniRead , speedIndex, TheDivision2.ini, 简单模式, 单发间隔, 1

IniRead , _autofire, TheDivision2.ini, 自动射击, 启用, 0
IniRead , vFastShoot, TheDivision2.ini, 自动射击, 简单模式, 1
IniRead , vDiyShoot, TheDivision2.ini, 自动射击, 高级模式, vFastShoot

IniRead , vAutoLiu, TheDivision2.ini, 无限溜溜球, 启用, 0
IniRead , vzpgLiu, TheDivision2.ini, 无限溜溜球, 装配工模式, 1	;1-装配工,2固线
IniRead , vgxLiu, TheDivision2.ini, 无限溜溜球, 固线模式, 0
IniRead , vAutoGxLiu, TheDivision2.ini, 无限溜溜球,技能使用后自动重置固线, 0	;1-装配工,2固线

IniRead , vAutoBox, TheDivision2.ini, 服装箱子, 启用, 0

IniRead , vOneKeyZL, TheDivision2.ini, 一键政令, 启用, 1
IniRead , resetArea, TheDivision2.ini, 一键政令, 重置控制点, 1

;#####################
;#====初始化====#
;#####################
; global _enabled := 0
;高级连击指令

; global _downVal = 2
; global _rightVal = 0
global _rampdown = 1
; global _shotdelay=0
global _readytofire = 1	;射击等待
global _timerRunning = 0
global crosshairX =
global crosshairY =

;简单连击
global speedArray := [25, 50, 75, 120]	; 连击间隔时间，单位毫秒，多个速率请使用这种格式：[80, 160, 320]
; global speedIndex := 1

global keyName := "LButton"

;连击相关
; global _autofire := 0
; global vFastShoot :=1
; global vDiyShoot := not vFastShoot
; global vAutoFireSwitch :=0

;服装箱子
; global skinBoxEnable := 0
; global vAutoBox :=0
;常规指令
global ver := "1.5"
global voiceObject := ComObjCreate("SAPI.SpVoice")
;voiceObject.Rate := 4
voiceObject.Volume := 100
; global resetArea :=1
; global vOneKeyZL :=1

;#####################
;#====菜单相关====#
;#####################
Menu , tray, NoStandard
Menu , tray, add, 一键政令|ALT+1, OnekeyZL
if (vOneKeyZL) {
    Menu , tray, check, 一键政令|ALT+1
}

Menu , tray, add, 一键政令时重置控制点, ResetControlArea
if (resetArea) {
    Menu , tray, check, 一键政令时重置控制点
}

;服装箱
Menu , tray, add,
Menu , tray, add, 自动开服装箱|ALT+2, AutoBox
if (vAutoBox) {
    Menu , tray, check, 自动开服装箱|ALT+2
}
Menu , tray, add, 大小写切换键停止开箱, MenuHandler
Menu , tray, Disable, 大小写切换键停止开箱

;连射
Menu , tray, add,
; Menu, tray, add,自动连射,MenuHandler
; fn := Func("AutoFireSwitch")
Menu , Tray, Add, 自动连射|F4开关, AutoFireSwitch
Menu , MySubmenu1, Add, 简单模式, FastShoot
Menu , MySubmenu1, Add, 高级模式, DiyShoot
if (vFastShoot) {
    Menu , MySubmenu1, check, 简单模式
} else {
    Menu , MySubmenu1, check, 高级模式
}
Menu , Tray, Add, 连射模式, :MySubmenu1
if (_autofire) {
    Menu , tray, check, 自动连射|F4开关
}
else{
    Menu , tray, Disable, 连射模式
}
Menu , tray, add,武器发射设置额外按键为J , MenuHandler
Menu , tray, Disable, 武器发射设置额外按键为J

;===========================================
;溜溜球
Menu,tray,add,
Menu,Tray,Add,无限溜溜球|F5开关,AutoLiu
Menu,MySubmenu2,Add,装配工模式,zpgLiu
Menu,MySubmenu2,Add,固线模式,gxLiu
if (vzpgLiu) {
    Menu , MySubmenu2, check, 装配工模式
} else {
    Menu , MySubmenu2, check, 固线模式
}
Menu,Tray,Add,溜溜球模式,:MySubmenu2
Menu,Tray,Add,固线自动重置,AutoGxLiu
if (vzpgLiu) {
    Menu,Tray,Disable,固线自动重置
}
else{
    Menu,Tray,enable,固线自动重置
}
if (vAutoGxLiu) {
    Menu,Tray,check,固线自动重置
}
else{
    Menu,Tray,uncheck,固线自动重置
}

if (vAutoLiu) {
    Menu , tray, check, 无限溜溜球|F5开关
}
Else{
    Menu , tray, Disable, 溜溜球模式
}
Menu , tray, add,使用鼠标侧键1刷新技能 , MenuHandler
Menu , tray, Disable, 使用鼠标侧键1刷新技能

;===========================================
Menu,Tray,Add,
;常规控制 Menu, tray, add, Menu, tray, NoStandard
Menu,tray,add,重置 | Reload,ReloadScript
Menu,tray,add,暂停 | Pause,PauseScript
Menu,tray,add,
Menu,tray,add,更新 | Ver %ver%,Version	;使用资源表示符 207 表示的图标
Menu,tray,add,退出 | Exit,ExitScript
menu,tray,tip,杀戮小队QQ群专享版

;#####################
;#====脚本====#
;#####################

; #IfWinActive ahk_exe TheDivision2.exe
; 切换速率，默认是鼠标侧键
#IF WinActive("ahk_exe TheDivision2.exe") AND vFastShoot and _autofire
    ~o::
    speedIndex += 1
    if (speedIndex > speedArray.Length()) {
        speedIndex := 0
    }
    Speak(speedIndex > 0 ? "连击间隔 " speedArray[speedIndex] : "已关闭连击")

    iniwrite, %speedIndex%, TheDivision2.ini, 简单模式, 单发间隔

return

; 按住鼠标右键再按左键连击，其他情况不连击
#If speedIndex > 0 AND _autofire AND vFastShoot and WinActive("ahk_exe TheDivision2.exe")
    ~RButton & LButton::fastFire(speedIndex)

#If WinActive("ahk_exe TheDivision2.exe") and vAutoLiu AND vzpgLiu
XButton1::
SendInput {q Down}
Sleep 500
SendInput {q Up}
;   SendKey("q",1000)
Sleep 100
Loop , 6 {
    SendKey("5")
    Sleep 100
}
Return

#If WinActive("ahk_exe TheDivision2.exe") and vAutoLiu AND vgxLiu
    XButton1::
    SendKey("b")
    Sleep 120

    SendKey("Down")
    Sleep 1000
    SendKey("Down")
    Sleep 1000

    SendKey("Space")
    Sleep 1000

    SendKey("Down")
    Sleep 1000
    SendKey("Space")
    Sleep 1000

    SendKey("UP")
    Sleep 1000
    SendKey("Space")
    Sleep 1000
    SendKey("b")
    Sleep 1000
Return

; #InputLevel 1
#If WinActive("ahk_exe TheDivision2.exe") and vAutoLiu AND vgxLiu and vAutoGxLiu
~Q UP::
~LButton UP::
~E UP::
    if (A_ThisHotkey = "~LButton" and A_PriorHotkey = "~Q" and A_TimeSincePriorHotkey <= 1500 ;Q然后左键释放
        or A_ThisHotkey="~Q" and A_PriorHotkey = "~Q" and A_TimeSincePriorHotkey <= 600 ;双击Q释放
    or A_ThisHotkey="~Q" and A_TimeSinceThisHotkey >= 400 ;长按Q释放
    OR A_ThisHotkey = "~LButton" and A_PriorHotkey = "~E" and A_TimeSincePriorHotkey <= 1500 ;E然后左键释放
    or A_ThisHotkey="~E" and A_PriorHotkey = "~E" and A_TimeSincePriorHotkey <= 600 ;双击E释放
    or A_ThisHotkey="~E" and A_TimeSinceThisHotkey >= 400 )
    {
        ; Sleep 1000
        ; send,{XButton1}
    }

return
; #InputLevel 0

; 打开或关闭 5 政令，默认是 Alt+1
#If WinActive("ahk_exe TheDivision2.exe") AND vOneKeyZL
!1::
send {m}
Sleep 600
send {z}
Sleep 400
SendKey("Down")
Sleep 200
SendKey("Space")
Sleep 300

Loop, 4
{
    SendKey("Space")
    Sleep 100
    SendKey("Down")
    Sleep 100
}

SendKey("Space")
Sleep 300
SendKey("Esc")
Sleep 300
;根据选项决定是否重置控制点
if (resetArea = 1)
{
    SendKey("Down")
    Sleep 200
    SendKey("Space")
    Sleep 200
}
SendKey("f")
Sleep 200
SendKey("Space")
Sleep 200
SendKey("Esc")
return

; 启动自动打开服装箱，默认是 Alt+2
#If WinActive("ahk_exe TheDivision2.exe") AND vAutoBox
    !2::
    ; skinBoxEnable := 1

    Speak("启动自动打开服装箱")

    while (vAutoBox)
    {
        SendKey("x", 2500)
        Sleep 5000
        SendKey("Space")
        Sleep 1000
    }

return

; 停止自动打开服装箱，默认是 大小写切换键
CapsLock::
    if (vAutoBox)
    {
        vAutoBox := 0
        Speak("已停止自动打开服装箱")
    }

return
#If
    ; ~F3:: ; 自动
;         _enabled := ! _enabled
;         _autofire = 0
;         ToolTip("Script Enabled= "_enabled)
; return

#IF WinActive("ahk_exe TheDivision2.exe")
~F4::	;Change triggerbot to singleshot OR enable autofire if you also turn up duration with o / ctrl-o 将触发器改为单发，或启用自动射击，如果你也用O/ctrl-o调高持续时间的话。
; _autofire := ! _autofire
Gosub,AutoFireSwitch
; ToolTip("Autofire= "_autofire)
return

#IF WinActive("ahk_exe TheDivision2.exe")
    ~F5::	
    Gosub,AutoLiu
return

~NumpadAdd::	; Adds compensation.
    _downVal := _downVal + 1
    ; ToolTip("向下补偿= " . _downVal)
    Speak("垂直偏移补偿为" _downVal)

    iniwrite, % _downVal, TheDivision2.ini, 高级模式, 垂直偏移
return

~NumpadSub::	; Substracts compensation.
    if _downVal > 0
    {
        _downVal := _downVal - 1
        ; ToolTip("向下补偿= " . _downVal)
        Speak("垂直偏移补偿为" _downVal)

        iniwrite , % _downVal, TheDivision2.ini, 高级模式, 垂直偏移
    }

return

~^NumpadAdd::	; Adds right adjust
    _rightVal := _rightVal + 1
    ; ToolTip("Right(+)/Left(-)= " . _rightVal)
    Speak("水平偏移补偿为" _rightVal)

    iniwrite, % _rightVal, TheDivision2.ini, 高级模式, 水平偏移
return

~^NumpadSub::	; Adds left adjust
    _rightVal := _rightVal - 1
    ; ToolTip("Right(+)/Left(-)= " . _rightVal)
    Speak("水平偏移补偿为" _rightVal)

    iniwrite, % _rightVal, TheDivision2.ini, 高级模式, 水平偏移
return

~o::	; Single shot timer up (zero is always fire)
    _shotdelay := _shotdelay + 25
    ; ToolTip("Single Shot Delay up= " _shotdelay)
    Speak("单发射击延迟为" _shotdelay)

    iniwrite, % _shotdelay, TheDivision2.ini, 高级模式, 单发间隔
Return

~^o::	; Single shot timer down (zero is always fire)
    if _shotdelay > 0
    {
        _shotdelay := _shotdelay - 25
        ; ToolTip("Single Shot Delay down= " _shotdelay)
        Speak("单发射击延迟为" _shotdelay)

        iniwrite , % _shotdelay, TheDivision2.ini, 高级模式, 单发间隔
    }
return

#IF WinActive("ahk_exe TheDivision2.exe") AND vDiyShoot and _autofire
    ~LButton:: lessrecoil()
~RButton:: lessrecoil_triggerbot()	;"RButton" is mouse 2.  If you change this, make sure you replace every RButton in the script.
~Joy10:: lessrecoil_triggerbot_xbox()

~RButton UP::
    loop,4{
        sleep 200
        Send , { j up}
    }
RETURN
;####################
;======Functions======
;####################
lessrecoil()
{
    While GetKeyState("LButton", "P")
    {
        sleep 10
        ApplyReduction()
        sleep 10
    }
return
}
;==================
lessrecoil_triggerbot()
{
    While GetKeyState("RButton", "P")
    {

        if CrosshairCheck()
        {
            TryToFire()
            ApplyReduction()
        }

    }
    Send , { j up }
    Sleep3(10)
    _timerRunning = 0
    _readytofire = 1
return
}
;==================
lessrecoil_triggerbot_xbox()
{
    While GetKeyState("Joy10")
    {

        if CrosshairCheck()
        {
            TryToFire()
            ApplyReduction()
        }

    }
    Send , { j up }
    Sleep3(5)
    _timerRunning = 0
    _readytofire = 1
return
}
;==================
ApplyReduction()
{

    DllCall("mouse_event", uint, 1, int, _rightVal, int, _downVal, uint, 0, int, 0)
    Sleep 20
    ; DllCall("mouse_event",uint,1,int,_rightVal,int,_downVal,uint,0,int,0)
    ; Sleep 20
    ; DllCall("mouse_event",uint,1,int,_rightVal,int,_downVal,uint,0,int,0)
    ; Sleep 20
return
}
;==================
CrosshairCheck()	; returns as "true" if either autofire, or crosshair is found.
{
    if _autofire = 0
        return false
    else
    {
        crosshairX =
        MouseGetPos , mX, mY
        x1 := (mX - 50)
        x2 := (mX + 50)
        y1 := (mY - 10)
        y2 := (mY + 10)
        PixelSearch , crosshairX, crosshairY, x1, y1, x2, y2, 0x3636F4, 0, Fast
    }
    if crosshairX > 0	;this will be set to either the x coord of the red found, or "1" if the triggerbot is turned off.
    {
        return true
    } else {
        Send , {j up}
        Sleep 20
        return false
    }
}
;==================
TryToFire()
{
    if _shotdelay = 0
    {
        Send , { j down }
        return
    } else
    {
        if _readytofire = 1
        {
            Send , { j up }
            sleep 10
            Send , { j down }
            _readytofire = 0
            ShotTimer()
            return
        } else
        {
            ShotTimer()
            return

        }
        ShotTimer()
        if _shotdelay > 0
        {
            Send , { j up }
            ShotTimer()
            sleep 10
        } else
        {
            _readytofire = 1
        }
    }
}
;==================
ShotTimer()
{

    if _timerRunning = 0
    {
        SetTimer , ShotWait, %_shotdelay%
        _timerRunning = 1
        return
    } else
return
ShotWait:
    SetTimer, ShotWait, Off
    _timerRunning = 0
    _readytofire = 1
return
}
;==================

;一键政令
OnekeyZL:
    Menu, Tray, ToggleCheck, 一键政令|ALT+1
    vOneKeyZL := Not vOneKeyZL
    iniwrite, % vOneKeyZL, TheDivision2.ini, 一键政令, 启用
return

;重置控制点
ResetControlArea:
    Menu, Tray, ToggleCheck, 一键政令时重置控制点
    resetArea := Not resetArea
    iniwrite, % resetArea, TheDivision2.ini, 一键政令, 重置控制点
return

;自动开服装箱
AutoBox:
    Menu, Tray, ToggleCheck, 自动开服装箱|ALT+2
    vAutoBox := Not vAutoBox
    iniwrite, % vAutoBox, TheDivision2.ini, 服装箱子, 启用

return

;左键简单模式
FastShoot:
    Menu, MySubmenu1, Check, 简单模式
    Menu, MySubmenu1, UnCheck, 高级模式
    vFastShoot := 1
    vDiyShoot := 0
    iniwrite, % vFastShoot, TheDivision2.ini, 自动射击, 简单模式
    iniwrite, % vDiyShoot, TheDivision2.ini, 自动射击, 高级模式
return

;左键高级模式
DiyShoot:
    Menu, MySubmenu1, Check, 高级模式 
    Menu, MySubmenu1, UnCheck, 简单模式
    vDiyShoot := 1
    vFastShoot := 0

    iniwrite, % vFastShoot, TheDivision2.ini, 自动射击, 简单模式
    iniwrite, % vDiyShoot, TheDivision2.ini, 自动射击, 高级模式
return

;自动连射开关
AutoFireSwitch:
    Menu, Tray, ToggleCheck, 自动连射|F4开关
    _autofire := !_autofire
fireMode := vFastShoot ? "简单模式" : "高级模式"
    Speak(_autofire ? "已开启自动连射 " fireMode : "已关闭自动连射" fireMode)

    if(_autofire){
        Menu , tray, enable, 连射模式
    }
    else{
        Menu , tray, Disable, 连射模式
    }
    iniwrite, % _autofire, TheDivision2.ini, 自动射击, 启用
Return

;自动连射开关
AutoLiu:
    Menu, Tray, ToggleCheck, 无限溜溜球|F5开关
    vAutoLiu := !vAutoLiu
LiuMode := vzpgLiu ? "装配工模式" : "固线模式" 
    Speak(vAutoLiu ? "已开启无限溜溜球 " LiuMode : "已关闭无限溜溜球" LiuMode)

    if(vAutoLiu){
        Menu , tray, enable, 溜溜球模式
    }
    else{
        Menu , tray, Disable, 溜溜球模式
    }
    iniwrite, % vAutoLiu, TheDivision2.ini, 无限溜溜球, 启用
Return
; ======================
;左键装配工模式
zpgLiu:
    Menu, MySubmenu2, Check, 装配工模式
    Menu, MySubmenu2, UnCheck, 固线模式
    vzpgLiu := 1
    vgxLiu := 0
LiuMode := vzpgLiu ? "装配工模式" : "固线模式" 
    Speak(vAutoLiu ? "已开启无限溜溜球 " LiuMode : "已关闭无限溜溜球" LiuMode)

    iniwrite, % vzpgLiu, TheDivision2.ini, 无限溜溜球, 装配工模式
    iniwrite, % vgxLiu, TheDivision2.ini, 无限溜溜球, 固线模式
return

;左键固线模式
gxLiu:
    Menu, MySubmenu2, Check, 固线模式
    Menu, MySubmenu2, UnCheck, 装配工模式
    vgxLiu := 1
    vzpgLiu := 0

LiuMode := vzpgLiu ? "装配工模式" : "固线模式" 
    Speak(vAutoLiu ? "已开启无限溜溜球 " LiuMode : "已关闭无限溜溜球" LiuMode)

    iniwrite, % vzpgLiu, TheDivision2.ini, 无限溜溜球, 装配工模式
    iniwrite, % vgxLiu, TheDivision2.ini, 无限溜溜球, 固线模式
return

;自动固线重置
AutoGxLiu:
    Menu, Tray, ToggleCheck, 固线自动重置
    vAutoGxLiu := !vAutoGxLiu
    ; LiuMode := vAutoGxLiu ? "装配工模式" : "固线模式" 
    ; Speak(vAutoLiu ? "已开启无限溜溜球 " LiuMode : "已关闭无限溜溜球" LiuMode)

    if (vAutoGxLiu) {
        Menu,Tray,check,固线自动重置
    }
    else{
        Menu,Tray,uncheck,固线自动重置
    }
    iniwrite, % vAutoGxLiu, TheDivision2.ini, 无限溜溜球,技能使用后自动重置固线
return

fastFire(speedIndex)
{
    while (speedIndex > 0 and GetKeyState("LButton", "P") and GetKeyState("RButton", "P"))
    {
        SendKey(keyName)
        Sleep speedArray[speedIndex]
    }
}

;#####################
;#====基础函数====#
;#####################
ToolTip(Text)
{
    ToolTip , %Text%
    SetTimer , RemoveToolTip, 3000
return

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return
}

SendKey(Key, Delay := 60)
{
    Send {%key% Down }
    Sleep Delay
    Send {%key% Up }
}

Sleep3(value) {
    DllCall("Winmm.dll\timeBeginPeriod", UInt, 1)
    DllCall("Sleep", "UInt", value)
    DllCall("Winmm.dll\timeEndPeriod", UInt, 1)
}

Speak(Text)
{
    voiceObject.Speak(Text, 1)
}

;#####################
;#====常规标签====#
;#####################
MenuHandler:
return

ReloadScript:
    Reload
Return

PauseScript:
    Pause, Toggle, 1
Return

Version:

return

ExitScript:
ExitApp
Return