;#=====命令====#
;#####################
#NoEnv
#MenuMaskKey vkE8
#InstallKeybdHook
#InstallMouseHook
#KeyHistory 100
#UseHook
#MaxThreadsPerHotkey 1
#MaxThreads 30
#MaxThreadsBuffer off
; #Include BTT.ahk
SendMode InputThenPlay
ListLines , Off
CurPID := DllCall("GetCurrentProcessId")
Process , Priority, %CurPID%, High
CoordMode , Pixel, Screen
CoordMode , Mouse, Screen
SetWorkingDir %A_ScriptDir%
;#####################
;#====读取ini&初始化====#
;#####################
global ver := "3.0"
global voiceObject := ComObjCreate("SAPI.SpVoice")
;voiceObject.Rate := 4
voiceObject.Volume := 100

global debug := 0

if debug
    Speak("debug Online")

global _maxMouseDelay:=30
global _maxKeyDelay:=50

global _downVal := 2
global _rightVal := 0
global _shotdelay := 0

Global vCloseEAC:=1
Global vSetUPC:=1

IniRead , _maxMouseDelay, TheDivision2.ini, 基本参数, 鼠标按键延迟, 30
IniRead , _maxKeyDelay, TheDivision2.ini, 基本参数, 键盘按键延迟, 50

IniWrite , % _maxMouseDelay, TheDivision2.ini, 基本参数, 鼠标按键延迟
IniWrite , % _maxKeyDelay, TheDivision2.ini, 基本参数, 键盘按键延迟

SetMouseDelay, 0,_maxMouseDelay, Play
SetKeyDelay, 0, _maxKeyDelay, Play

IniRead , vOnekeyRun, TheDivision2.ini, 游戏启动, 一键启动, 1
IniRead , vCloseEAC, TheDivision2.ini, 游戏启动, 关闭EAC, 1
IniRead , vSetUPC, TheDivision2.ini, 游戏启动, 降低UPC, 1
IniRead , vSetEN, TheDivision2.ini, 游戏启动, 英文模式, 1

IniRead , vOneKeyZL, TheDivision2.ini, 一键政令, 启用, 1
IniRead , vResetArea, TheDivision2.ini, 一键政令, 重置控制点, 1

IniRead , vAutoBox, TheDivision2.ini, 服装箱子, 启用, 0

IniRead , _downVal, TheDivision2.ini, 高级模式, 垂直偏移, 2
IniRead , _RightVal, TheDivision2.ini, 高级模式, 水平偏移, 0
IniRead , _shotdelay, TheDivision2.ini, 高级模式, 单发间隔, 0

IniRead , speedIndex, TheDivision2.ini, 简单模式, 单发间隔, 1

IniRead , _autofire, TheDivision2.ini, 自动射击, 启用, 0
IniRead , vFastShoot, TheDivision2.ini, 自动射击, 简单模式, 1
IniRead , vDiyShoot, TheDivision2.ini, 自动射击, 高级模式, 0
IniRead , vAutoShoot, TheDivision2.ini, 自动射击, 发现敌人自动射击, 0

IniRead , vAutoLiu, TheDivision2.ini, 无限溜溜球, 启用, 0
IniRead , vzpgLiu, TheDivision2.ini, 无限溜溜球, 装配工模式, 1	;1-装配工,2固线
IniRead , vgxLiu, TheDivision2.ini, 无限溜溜球, 固线模式, 0
IniRead , vAutoGxLiu, TheDivision2.ini, 无限溜溜球,技能使用后自动重置固线, 0	;1-装配工,2固线

IniRead , vAutoJuTa, TheDivision2.ini, 瞬发狙击塔,狙击塔快速使用, 0

;#####################
;#====初始化====#
;#####################
; global _enabled := 0
;高级连击指令

; global _downVal = 2
; global _rightVal = 0
; global _rampdown = 1
; global _shotdelay=0
global _Readytofire = 1	;射击等待
global _timerRunning = 0
global _chooseGun = 1 ;默认1号武器

global crosshairX =
global crosshairY =

;简单连击
global speedArray := [25, 50, 75, 120]	; 连击间隔时间，单位毫秒，多个速率请使用这种格式：[80, 160, 320]
global speedIndex := 1

; global keyName := "LButton"

;连击相关
; global _autofire := 0
; global vFastShoot :=1
; global vDiyShoot := not vFastShoot
; global vAutoFireSwitch :=0

;服装箱子
global skinBoxEnable := 0

;狙击塔循环
global loopJuTaEnable := 0

; global vAutoBox :=0
;常规指令

; global resetArea :=1
; global vOneKeyZL :=1
global vStartTime:=0
global vEndTime:=0
;#####################
;#====菜单相关====#
;#####################

Menu , tray, NoStandard

if debug{
    Menu , tray, add, ********Debug调试模式**********, MenuHandler
    Menu , tray, add,
    Menu, tray, Color, 00FF00
}

Menu , tray, add, 一键启动|Ctrl+F10, OnekeyRun
if (vOnekeyRun) {
    Menu , tray, check, 一键启动|Ctrl+F10
}

Menu , tray, add, 游戏启动后关闭小蓝熊, CloseEAC
if (vCloseEAC) {
    Menu , tray, check, 游戏启动后关闭小蓝熊
}
Menu , tray, add, 游戏启动后降低UPC优先级, SetUPC
if (vSetUPC) {
    Menu , tray, check, 游戏启动后降低UPC优先级
}
Menu , tray, add,ALT+F10键会顺序关闭全境2/小蓝熊/UPC, MenuHandler
Menu , tray, Disable, ALT+F10键会顺序关闭全境2/小蓝熊/UPC

Menu , tray, add,
Menu , tray, add, 一键政令|ALT+1, OnekeyZL
if (vOneKeyZL) {
    Menu , tray, check, 一键政令|ALT+1
}

Menu , tray, add, 一键政令时重置控制点, ResetArea
if (vResetArea) {
    Menu , tray, check, 一键政令时重置控制点
}

;服装箱
Menu , tray, add,
Menu , tray, add, 自动开服装箱|ALT+2, AutoBox
if (vAutoBox) {
    Menu , tray, check, 自动开服装箱|ALT+2
}
Menu , tray, add,再次按下ALT+2停止开箱, MenuHandler
Menu , tray, Disable, 再次按下ALT+2停止开箱

;连射
Menu , tray, add,
; Menu, tray, add,自动连射,MenuHandler
; fn := Func("AutoFireSwitch")
Menu , Tray, Add, 自动连射|F4开关, AutoFireSwitch
Menu , MySubMenu1, Add, 简单模式, FastShoot
Menu , MySubMenu1, Add, 高级模式, DiyShoot
if (vFastShoot) {
    Menu , MySubMenu1, check, 简单模式
} else {
    Menu , MySubMenu1, check, 高级模式
}
Menu , Tray, Add, 连射模式, :MySubMenu1
Menu , tray, add,发现敌人自动射击 , AutoShoot

if (_autofire) {
    Menu , tray, check, 自动连射|F4开关
}
else{
    Menu , tray, Disable, 连射模式
    Menu , tray, Disable, 发现敌人自动射击
}

if (vAutoShoot) {
    Menu , tray, check, 发现敌人自动射击
}
else{
    Menu , tray, uncheck,发现敌人自动射击
}

Menu , tray, add,武器发射设置额外按键为J, MenuHandler
Menu , tray, Disable, 武器发射设置额外按键为J
Menu , tray, add,发现敌人自动射击需要1920*1080分辨率, MenuHandler
Menu , tray, Disable, 发现敌人自动射击需要1920*1080分辨率
;===========================================
;溜溜球
Menu,tray,add,
Menu,Tray,Add,无限溜溜球|F5开关,AutoLiu
Menu,MySubMenu2,Add,装配工模式,zpgLiu
Menu,MySubMenu2,Add,固线模式,gxLiu
if (vzpgLiu) {
    Menu , MySubMenu2, check, 装配工模式
} else {
    Menu , MySubMenu2, check, 固线模式
}
Menu,Tray,Add,溜溜球模式,:MySubMenu2
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
    Menu , tray, enable, 溜溜球模式
}
else{
    Menu , tray, uncheck, 无限溜溜球|F5开关
    Menu , tray, Disable, 溜溜球模式
    Menu,Tray,Disable,固线自动重置
}
Menu , tray, add,鼠标侧键1|ALT+Q刷新技能 , MenuHandler
Menu , tray, Disable, 鼠标侧键1|ALT+Q刷新技能

Menu,Tray,Add,
Menu , tray, add,瞬发狙击塔|F6开关 , AutoJuTa

if (vAutoJuTa) {
    Menu,Tray,check,瞬发狙击塔|F6开关
}
else{
    Menu,Tray,uncheck,瞬发狙击塔|F6开关
}
Menu , tray, add,鼠标侧键1|ALT+E开启/关闭循环 , MenuHandler
Menu , tray, Disable, 鼠标侧键1|ALT+E开启/关闭循环

;===========================================
startuplnk := A_StartMenu . "\Programs\Startup\全境封锁2-按键助手.lnk"
Menu,Tray,Add,
Menu, Tray, Add, 开机启动,AutoStart
if(FileExist(startuplnk))
    Menu, Tray, Check, 开机启动

Menu,Tray,Add,
;常规控制 Menu, tray, add, Menu, tray, NoStandard
Menu,tray,add,重置 |Reload,ReloadScript
Menu,tray,add,暂停 |F1,PauseScript
Menu,tray,add,
Menu,tray,add,帮助 | Help,Help
Menu,tray,add,版本 | Ver %ver%,Version	;使用资源表示符 207 表示的图标
Menu,tray,add,退出 | Exit,ExitScript
Menu,tray,tip,杀戮小队QQ群专享版

; Text=
; (
; 版本 %ver%
; 欢迎分享，带张截图！！！

; Use template to easily create your own style.
; Please share your custom style and include a screenshot.
; It will help a lot of people.
; )

; btt(Text,700,410,2,Style8)

;#####################
;#====脚本====#
;#####################

#If vOnekeyRun 
    !F10::

    WinGet, NewPID1, PID, ahk_exe TheDivision2.exe
    if NewPID1
        Process,close,%NewPID1%
    Sleep 3000

    WinGet, NewPID2, PID, ahk_exe EasyAntiCheat.exe
    if NewPID2
        Process,close,%NewPID2%
    Sleep 3000

    WinGet, NewPID3, PID, ahk_exe upc.exe
    if NewPID3
        Process,close,%NewPID3%
    Sleep 1000
return

#If vOnekeyRun
^F10::
WinGet, NewPID, PID, ahk_exe TheDivision2.exe
if not NewPID
{Run,uplay://launch/4932/0
    Speak("叛变特工已上线")

    if(vCloseEAC or vSetUPC)
    {
        vStartTime:=A_Now
        SetTimer,timeCS,1000
    }
}
else if (vCloseEAC or vSetUPC)
{
    CloseAndSet()
}
return

timeCS:
    vEndTime:=A_Now
    EnvSub, vEndTime, vStartTime, Minutes
    ; ShowToolTip(vEndTime)
    if(vEndTime>=4)
    {
        CloseAndSet()
        SetTimer,timeCS,Delete
    }
return

CloseAndSet(){

    cmdInfo := cmdClipReturn("taskkill /f /im EasyAntiCheat.exe /t")
    ; cmdInfo := cmdClipReturn("taskkill /f /im notepad++.exe /t")

    ; msgbox % SubStr(cmdInfo,1,2)
    if cmdInfo and vCloseEAC
    {
        Speak(SubStr(cmdInfo,1,2)="成功" ? "已经关闭小蓝熊":"未能关闭小蓝熊")
    }

    if vSetUPC and WinExist("ahk_exe upc.exe")
    {
        WinGet, NewPID, PID, ahk_exe upc.exe
        Process, Priority, %NewPID%, Low
        ;Process, Priority,"upc.exe",Low
        Sleep 3000

        Speak(ErrorLevel ? "成功设置UPC优先级为低":"UPC优先级设置失败")
    }
}
cmdClipReturn(command){
    cmdInfo:=""
    Clip_Saved:=ClipboardAll
    try{
        Clipboard:=""
        Run,% ComSpec " /C " command " | CLIP", , Hide
        ClipWait,2
        cmdInfo:=Clipboard
    }catch{}
    Clipboard:=Clip_Saved
return cmdInfo
}

; 打开或关闭 5 政令，默认是 Alt+1
#If (WinActive("ahk_exe TheDivision2.exe") or debug) AND vOneKeyZL
!1::
vDelay:=80
SendKey("m")
Sleep vDelay
SendKey("z")
Sleep vDelay
SendKey("Down")
Sleep vDelay
SendKey("Space")
Sleep vDelay

loop, 4
{
    SendKey("Space")
    Sleep vDelay
    SendKey("Down")
    Sleep vDelay
}

SendKey("Space")
Sleep vDelay
SendKey("Esc")
Sleep vDelay
;根据选项决定是否重置控制点
if (vResetArea = 1)
{
    SendKey("Down")
    Sleep vDelay
    SendKey("Space")
    Sleep vDelay
}
SendKey("f")
Sleep 300
SendKey("Space",200)
Sleep 300
SendKey("m")
return

; 启动自动打开服装箱，默认是 Alt+2
#If (WinActive("ahk_exe TheDivision2.exe") or debug) AND vAutoBox
    !2::
    skinBoxEnable := !skinBoxEnable

    if(skinBoxEnable)
    {
        Speak("启动自动打开服装箱")
        SetTimer, openBOX, 9000
    }
    else{
        SetTimer, openBOX, delete
        SendKey("x")
        Speak("已停止打开服装箱")
    }
return

openBOX:
    SendKey("x", 2500)
    Sleep 3500
    SendKey("Space")
    Sleep 1000
return

; 按住鼠标右键再按左键连击，其他情况不连击
#If speedIndex > 0 AND _autofire AND vFastShoot and (WinActive("ahk_exe TheDivision2.exe") or debug)
    ~RButton & LButton::fastFire()

#If (WinActive("ahk_exe TheDivision2.exe") or debug) and vAutoLiu AND vzpgLiu
!q::
XButton1::
    SendPlay {q Down}
    sleep 700
    loop,15{
        Random, keydelay, 10, 50
        SendPlay {5}
        sleep keydelay
    }
    sleep 2500
    SendPlay {q Up}
return

#If (WinActive("ahk_exe TheDivision2.exe") or debug) and vAutoLiu AND vgxLiu
!q::
XButton1::
    Random, vdelay, 80, 120
    SendPlay {b}
    Sleep vdelay
    SendPlay {Down}
    Sleep vdelay
    SendPlay {Down}
    Sleep vdelay
    SendPlay {Space}
    Sleep vdelay

    Random, vdelay, 80, 120
    SendPlay {Down}
    Sleep vdelay
    SendPlay {Space}
    Sleep vdelay
    SendPlay {UP}
    Sleep vdelay
    SendPlay {Space}
    Sleep vdelay

    Random, vdelay, 80, 120
    SendPlay {Esc}
    Sleep vdelay
    SendPlay {b}
    Sleep vdelay
return

#InputLevel 1
#If (WinActive("ahk_exe TheDivision2.exe") or debug) and vAutoLiu AND vgxLiu and vAutoGxLiu
~q::
~e::
~LButton::
    if (A_ThisHotkey = "~LButton" and A_PriorHotkey = "~Q" and A_TimeSincePriorHotkey <= 1500 ;Q然后左键释放
        or A_ThisHotkey="~Q" and A_PriorHotkey = "~Q" and A_TimeSincePriorHotkey <= 600 ;双击Q释放
    or A_ThisHotkey="~Q" and A_TimeSinceThisHotkey >= 400 ;长按Q释放
    OR A_ThisHotkey = "~LButton" and A_PriorHotkey = "~E" and A_TimeSincePriorHotkey <= 1500 ;E然后左键释放
    or A_ThisHotkey="~E" and A_PriorHotkey = "~E" and A_TimeSincePriorHotkey <= 600 ;双击E释放
    or A_ThisHotkey="~E" and A_TimeSinceThisHotkey >= 400 )
    {
        Sleep 1500
        send,{XButton1}
    }

return
#InputLevel 0

#If (WinActive("ahk_exe TheDivision2.exe") or debug)

~F2::
    if (winc_presses > 0) ; SetTimer 已经启动, 所以我们记录键击.
    {
        winc_presses += 1
        return
    }
    ; 否则, 这是新开始系列中的首次按下. 把次数设为 1 并启动
    ; 计时器:
    winc_presses := 1
    SetTimer, KeyWinD, -800 ; 在 800 毫秒内等待更多的键击.
return

KeyWinD:
    if (winc_presses = 1) ; 此键按下了一次.
    {
        gosub,AutoFireSwitch ;单击则切换自动连射功能
    }
    else if (winc_presses = 2) ; 此键按下了两次.
    {
        if vFastShoot
            gosub,DiyShoot
        else
            gosub,FastShoot ;双击则切换连射模式
    }
    else if (winc_presses > 2)
    {
        gosub,AutoShoot ;三击切换发现敌人自动射击
    }
    ; 不论触发了上面的哪个动作, 都对 count 进行重置
    ; 为下一个系列的按下做准备:
    winc_presses := 0
return

~F4::
    if (winc_presses > 0) ; SetTimer 已经启动, 所以我们记录键击.
    {
        winc_presses += 1
        return
    }
    ; 否则, 这是新开始系列中的首次按下. 把次数设为 1 并启动
    ; 计时器:
    winc_presses := 1
    SetTimer, KeyWinA, -800 ; 在 800 毫秒内等待更多的键击.
return

KeyWinA:
    if (winc_presses = 1) ; 此键按下了一次.
    {
        gosub,AutoFireSwitch ;单击则切换自动连射功能
    }
    else if (winc_presses = 2) ; 此键按下了两次.
    {
        if vFastShoot
            gosub,DiyShoot
        else
            gosub,FastShoot ;双击则切换连射模式
    }
    else if (winc_presses > 2)
    {
        gosub,AutoShoot ;三击切换发现敌人自动射击
    }
    ; 不论触发了上面的哪个动作, 都对 count 进行重置
    ; 为下一个系列的按下做准备:
    winc_presses := 0
return

~F5::
    if (winc_presses > 0) ; SetTimer 已经启动, 所以我们记录键击.
    {
        winc_presses += 1
        return
    }
    ; 否则, 这是新开始系列中的首次按下. 把次数设为 1 并启动
    ; 计时器:
    winc_presses := 1
    SetTimer, KeyWinB, -800 ; 在 800 毫秒内等待更多的键击.
return

KeyWinB:
    if (winc_presses = 1) ; 此键按下了一次.
    {
        gosub,AutoLiu ;单击则切换自动溜溜球功能
    }
    else if (winc_presses = 2) ; 此键按下了两次.
    {
        if vzpgLiu
            gosub,gxLiu
        else
            gosub,zpgLiu ;双击则切换溜溜球模式
    }
    else if (winc_presses > 2)
    {
        gosub,AutoGxLiu ;三击切换发现敌人自动射击
    }
    ; 不论触发了上面的哪个动作, 都对 count 进行重置
    ; 为下一个系列的按下做准备:
    winc_presses := 0
return

~F6::
    if (winc_presses > 0) ; SetTimer 已经启动, 所以我们记录键击.
    {
        winc_presses += 1
        return
    }
    ; 否则, 这是新开始系列中的首次按下. 把次数设为 1 并启动
    ; 计时器:
    winc_presses := 1
    SetTimer, KeyWinC, -800 ; 在 800 毫秒内等待更多的键击.
return

KeyWinC:
    if (winc_presses = 1) ; 此键按下了一次.
    {
        gosub,AutoJuTa ;单击则切换狙击塔功能
    }
    else if (winc_presses = 2) ; 此键按下了两次.
    {
        ; if vzpgLiu
        ;     gosub,gxLiu
        ; else
        ;     gosub,zpgLiu ;双击则切换溜溜球模式
    }
    else if (winc_presses > 2)
    {
        ; gosub,AutoGxLiu ;三击切换发现敌人自动射击
    }
    ; 不论触发了上面的哪个动作, 都对 count 进行重置
    ; 为下一个系列的按下做准备:
    winc_presses := 0
return

~F1::Suspend, Toggle

#If

#If (WinActive("ahk_exe TheDivision2.exe") or debug) and vAutoJuTa 
!e::
XButton1::
    loopJuTaEnable := !loopJuTaEnable

    if(loopJuTaEnable)
    {
        SetTimer, loopJuTa, 3000
        Speak("狙击塔 battle control online")
    }
    else{
        SetTimer, loopJuTa, delete
        Speak("狙击塔已下线")
    }
return

loopJuTa:
    Random, vRanDelay, 80, 180 
    ; sleep vRanDelay6
    SendPlay {6}
    sleep 800
    loop 4{
        sleep vRanDelay
        SendPlay {e}
    }
    ; sleep 50
    SendPlay {6 down}
    sleep 500
    SendPlay {6 up}
    ; sleep 1200
return

; #IfWinActive ahk_exe TheDivision2.exe
; 切换速率，默认是鼠标侧键
#If (WinActive("ahk_exe TheDivision2.exe") or debug) AND vFastShoot and _autofire
~o::
speedIndex += 1
if (speedIndex > speedArray.Length()) {
    speedIndex := 0
}
Speak(speedIndex > 0 ? "连击间隔 " speedArray[speedIndex] : "已关闭连击")
IniWrite, %speedIndex%, TheDivision2.ini, 简单模式, 单发间隔
return
#If

#If (WinActive("ahk_exe TheDivision2.exe") or debug) AND vDiyShoot and _autofire

~1::
    _chooseGun :=1
    readWeapon(_chooseGun)
return

~2::
    _chooseGun :=2
    readWeapon(_chooseGun)
return

~3::
    _chooseGun :=3
    readWeapon(_chooseGun)
return

readWeapon(_chooseGun)
{
    IniRead , _downVal, TheDivision2.ini, 高级模式, 垂直偏移%_chooseGun%, 2
    IniRead , _RightVal, TheDivision2.ini, 高级模式, 水平偏移%_chooseGun%, 0
    IniRead , _shotdelay, TheDivision2.ini, 高级模式, 单发间隔%_chooseGun%, 0
    IniRead , _weaponText, TheDivision2.ini, 高级模式, 武器名%_chooseGun%, 武器%_chooseGun%
    IniRead , _weaponTextFix, TheDivision2.ini, 高级模式, 武器名修饰后缀, 已上线

    if _weaponText = 武器%_chooseGun%
    {
        IniWrite , % _weaponText, TheDivision2.ini, 高级模式, 武器名%_chooseGun%
    }

    if _weaponTextFix = 已上线
    {
        IniWrite , % _weaponTextFix, TheDivision2.ini, 高级模式, 武器名修饰后缀
    }

    ; Speak(_weaponText . _weaponTextFix)
}

~NumpadAdd::	; Adds compensation.
    _downVal := _downVal + 1
    ; ToolTip("向下补偿= " . _downVal)
    Speak("垂直偏移补偿为" _downVal)

    IniWrite, % _downVal, TheDivision2.ini, 高级模式, 垂直偏移%_chooseGun%
return

~NumpadSub::	; Substracts compensation.
    if _downVal > 0
    {
        _downVal := _downVal - 1
        ; ToolTip("向下补偿= " . _downVal)
        Speak("垂直偏移补偿为" _downVal)

        IniWrite , % _downVal, TheDivision2.ini, 高级模式, 垂直偏移%_chooseGun%
    }

return

~^NumpadAdd::	; Adds right adjust
    _RightVal := _RightVal + 1
    ; ToolTip("Right(+)/Left(-)= " . _rightVal)
    Speak("水平偏移补偿为" _RightVal)

    IniWrite, % _RightVal, TheDivision2.ini, 高级模式, 水平偏移%_chooseGun%
return

~^NumpadSub::	; Adds left adjust
    _RightVal := _RightVal - 1
    ; ToolTip("Right(+)/Left(-)= " . _rightVal)
    Speak("水平偏移补偿为" _RightVal)

    IniWrite, % _RightVal, TheDivision2.ini, 高级模式, 水平偏移%_chooseGun%
return

~o::	; Single shot timer up (zero is always fire)
    _shotdelay := _shotdelay + 25
    ; ToolTip("Single Shot Delay up= " _shotdelay)
    Speak("单发射击延迟为" _shotdelay)

    IniWrite, % _shotdelay, TheDivision2.ini, 高级模式, 单发间隔%_chooseGun%
return

~^o:: ; Single shot timer down (zero is always fire)
    if _shotdelay > 0
    {
        _shotdelay := _shotdelay - 25
        _shotdelay<0?_shotdelay:=0:
            Speak("单发射击延迟为" _shotdelay)

            IniWrite, % _shotdelay, TheDivision2.ini, 高级模式, 单发间隔%_chooseGun%
        }
        return

        #If (WinActive("ahk_exe TheDivision2.exe") or debug) AND vDiyShoot and _autofire
            ~LButton:: lessrecoil()
        #If

        lessrecoil()
        {
            while GetKeyState("LButton", "P")
            { 
                sleep 10
                ApplyReduction()
                sleep 10
            }
        return
    }

    #If (WinActive("ahk_exe TheDivision2.exe") or debug) AND vDiyShoot and _autofire and not vAutoShoot
        ~RButton & LButton:: lessrecoil_noCheck()

    ~RButton Up::
        loop,4{
            Sleep 120
            Sendinput , { j up}
        }
    RETURN

    lessrecoil_noCheck()
    {
        while GetKeyState("LButton", "P") and GetKeyState("RButton", "P")
        {
            TryToFire()
            ApplyReduction()
        }
        SendInput { j up }
        sleep 10
        _timerRunning = 0
        _Readytofire = 1
    return
}
#If

#If (WinActive("ahk_exe TheDivision2.exe") or debug) AND vDiyShoot and _autofire and vAutoShoot
    ~RButton:: lessrecoil_triggerbot()	;"RButton" is mouse 2.  If you change this, make sure you replace every RButton in the script.
;~Joy10:: lessrecoil_triggerbot_xbox()
~RButton Up::
    loop,4{
        Sleep 120
        Sendinput , { j up}
    }
RETURN
#If

;####################
;======Functions======
;####################

;==================
lessrecoil_triggerbot()
{
    while GetKeyState("RButton", "P")
    {

        if CrosshairCheck()
        {
            TryToFire()
            ApplyReduction()
        }

    }
    SendInput , { j up }
    sleep 10
    _timerRunning = 0
    _Readytofire = 1
return
}
;==================
ApplyReduction()
{

    DllCall("mouse_event", uint, 1, int, _rightVal, int, _downVal, uint, 0, int, 0)
    Sleep _shotdelay
    ; DllCall("mouse_event",uint,1,int,_rightVal,int,_downVal,uint,0,int,0)
    ; Sleep 10
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
        SendInput , {j up}
        Sleep 10
        return false
    }
}
;==================
TryToFire()
{
    if _shotdelay = 0
    {
        SendInput, {j down}
        return
    } else
    {
        if _Readytofire = 1
        {
            SendInput, {j down}
            sleep 30
            SendInput, {j up}
            _Readytofire = 0
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
            SendInput , { j up }
            ShotTimer()
            sleep 10
        } else
        {
            _Readytofire = 1
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
    _Readytofire = 1
return
}
;#####################
;#====游戏启动相关菜单====#
;#####################
OnekeyRun:
    Menu, Tray, ToggleCheck, 一键启动|Ctrl+F10
    vOnekeyRun := Not vOnekeyRun
    IniWrite, % vOnekeyRun, TheDivision2.ini, 游戏启动, 一键启动
return

CloseEAC:
    Menu, Tray, ToggleCheck, 游戏启动后关闭小蓝熊
    vCloseEAC := Not vCloseEAC
    IniWrite, % vCloseEAC, TheDivision2.ini, 游戏启动, 关闭EAC
return

SetUPC:
    Menu, Tray, ToggleCheck, 游戏启动后降低UPC优先级
    vSetUPC := Not vSetUPC
    IniWrite, % vSetUPC, TheDivision2.ini, 游戏启动, 降低UPC
return

;#####################
;#====一键政令相关菜单====#
;#####################
;一键政令
OnekeyZL:
    Menu, Tray, ToggleCheck, 一键政令|ALT+1
    vOneKeyZL := Not vOneKeyZL
    IniWrite, % vOneKeyZL, TheDivision2.ini, 一键政令, 启用
return

;重置控制点
ResetArea:
    Menu, Tray, ToggleCheck, 一键政令时重置控制点
    vResetArea := Not vResetArea
    IniWrite, % vResetArea, TheDivision2.ini, 一键政令, 重置控制点
return

;自动开服装箱
AutoBox:
    Menu, Tray, ToggleCheck, 自动开服装箱|ALT+2
    vAutoBox := Not vAutoBox
    IniWrite, % vAutoBox, TheDivision2.ini, 服装箱子, 启用

return

fastFire()
{
    while (speedIndex > 0 and GetKeyState("LButton", "P") and GetKeyState("RButton", "P"))
    {
        SendKey("LButton")
        Sleep speedArray[speedIndex]
    }
}

;#####################
;#====自动射击相关菜单====#
;#####################
;左键简单模式
FastShoot:
    Menu, MySubMenu1, Check, 简单模式
    Menu, MySubMenu1, UnCheck, 高级模式
    Menu , tray, Disable,发现敌人自动射击

    vFastShoot := 1
    vDiyShoot := 0

    Speak(vFastShoot ? "已切换简单模式" : "已切换高级模式" )

    IniWrite, % vFastShoot, TheDivision2.ini, 自动射击, 简单模式
    IniWrite, % vDiyShoot, TheDivision2.ini, 自动射击, 高级模式
return

;左键高级模式
DiyShoot:
    Menu, MySubMenu1, Check, 高级模式
    Menu, MySubMenu1, UnCheck, 简单模式
    Menu , tray, Enable,发现敌人自动射击

    vDiyShoot := 1
    vFastShoot := 0

    Speak(vFastShoot ? "已切换简单模式" : "已切换高级模式" )

    IniWrite, % vFastShoot, TheDivision2.ini, 自动射击, 简单模式
    IniWrite, % vDiyShoot, TheDivision2.ini, 自动射击, 高级模式
return

;自动连射开关
AutoFireSwitch:
    Menu, Tray, ToggleCheck, 自动连射|F4开关
    _autofire := !_autofire
fireMode := vFastShoot ? "简单模式" : "高级模式"
    Speak(_autofire ? "已开启自动连射 " fireMode : "已关闭自动连射" fireMode)

    if(_autofire){
        Menu , tray, enable, 连射模式
        Menu , tray, Enable,发现敌人自动射击
    }
    else{
        Menu , tray, Disable, 连射模式
        Menu , tray, Disable,发现敌人自动射击
    }
    IniWrite, % _autofire, TheDivision2.ini, 自动射击, 启用
return

AutoShoot:
    Menu , tray, ToggleCheck,发现敌人自动射击

    vAutoShoot := !vAutoShoot

    Speak(vAutoShoot ? "已开启发现敌人自动射击" : "已关闭发现敌人自动射击" )

    IniWrite, % vAutoShoot, TheDivision2.ini, 自动射击, 发现敌人自动射击
return

;自动溜溜球开关
AutoLiu:
    Menu, Tray, ToggleCheck, 无限溜溜球|F5开关
    vAutoLiu := !vAutoLiu
LiuMode := vzpgLiu ? "装配工模式" : "固线模式"
    Speak(vAutoLiu ? "已开启无限溜溜球 " LiuMode : "已关闭无限溜溜球" LiuMode)

    if(vAutoLiu){
        Menu , tray, enable, 溜溜球模式

        if (vzpgLiu) {
            Menu,Tray,Disable,固线自动重置
        }
        else{
            Menu,Tray,enable,固线自动重置
        }

    }
    else{
        Menu , tray, Disable, 溜溜球模式
        Menu , tray, Disable, 固线自动重置

    }
    IniWrite, % vAutoLiu, TheDivision2.ini, 无限溜溜球, 启用
return
;#####################
;#====溜溜球相关菜单====#
;#####################
;左键装配工模式
zpgLiu:
    Menu, MySubMenu2, Check, 装配工模式
    Menu, MySubMenu2, UnCheck, 固线模式
    Menu , tray, Disable, 固线自动重置
    vzpgLiu := 1
    vgxLiu := 0
    ; LiuMode := vzpgLiu ? "装配工模式" : "固线模式"
    ;     Speak(vAutoLiu ? "已开启无限溜溜球 " LiuMode : "已关闭无限溜溜球" LiuMode)

    Speak(vzpgLiu ? "已切换装配工模式" : "已切换固线模式" )

    IniWrite, % vzpgLiu, TheDivision2.ini, 无限溜溜球, 装配工模式
    IniWrite, % vgxLiu, TheDivision2.ini, 无限溜溜球, 固线模式
return

;左键固线模式
gxLiu:
    Menu, MySubMenu2, Check, 固线模式
    Menu, MySubMenu2, UnCheck, 装配工模式
    Menu , tray, enable, 固线自动重置
    vgxLiu := 1
    vzpgLiu := 0

    ; LiuMode := vzpgLiu ? "装配工模式" : "固线模式"
    ;     Speak(vAutoLiu ? "已开启无限溜溜球 " LiuMode : "已关闭无限溜溜球" LiuMode)
    Speak(vzpgLiu ? "已切换装配工模式" : "已切换固线模式" )

    IniWrite, % vzpgLiu, TheDivision2.ini, 无限溜溜球, 装配工模式
    IniWrite, % vgxLiu, TheDivision2.ini, 无限溜溜球, 固线模式
return

;自动固线重置
AutoGxLiu:
    Menu, Tray, ToggleCheck, 固线自动重置
    vAutoGxLiu := !vAutoGxLiu
    ; LiuMode := vAutoGxLiu ? "装配工模式" : "固线模式"
    ; Speak(vAutoLiu ? "已开启无限溜溜球 " LiuMode : "已关闭无限溜溜球" LiuMode)

    Speak(vAutoGxLiu ? "已开启固线自动重置" : "已关闭固线自动重置" )

    IniWrite, % vAutoGxLiu, TheDivision2.ini, 无限溜溜球,技能使用后自动重置固线
return

;自动使用狙击塔
AutoJuTa:
    Menu, Tray, ToggleCheck, 瞬发狙击塔|F6开关
    vAutoJuTa := !vAutoJuTa

    Speak(vAutoJuTa ? "已开启瞬发狙击塔" : "已关闭瞬发狙击塔" )

    ; if (vAutoJuTa) {
    ;     Menu,Tray,check,瞬发狙击塔|F6开关
    ; }
    ; else{
    ;     Menu,Tray,uncheck,瞬发狙击塔|F6开关
    ; }
    IniWrite, % vAutoJuTa, TheDivision2.ini, 瞬发狙击塔,狙击塔快速使用
return

;#####################
;#====基础函数====#
;#####################
ShowToolTip(Text)
{
    ToolTip, %Text%
    SetTimer, RemoveToolTip, 3000
return
RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return
}

SendKey(Key,DelayTime := 30)
{
    Random, fixDelay, 20, 50

    DelayTime +=fixdelay
    Send {%key% Down}
    Sleep DelayTime
    Send {%key% Up}
}

Sleep3(value) {
    DllCall("Winmm.dll\timeBeginPeriod", UInt, 1)
    DllCall("Sleep", "UInt", value)
    DllCall("Winmm.dll\timeEndPeriod", UInt, 1)
}

Speak(Text)
{
    voiceObject.Speak(Text, 0)
}

;#####################
;#====常规标签====#
;#####################
MenuHandler:
return

AutoStart:
    if(FileExist(startuplnk))
        FileDelete, % startuplnk
    else
        FileCreateShortcut, % A_ScriptFullpath, % startuplnk
    Menu, Tray, ToggleCheck, 开机启动
return

ReloadScript:
    Reload
return

PauseScript:
    Suspend, Toggle
    Pause, Toggle
return

Help:
    run,https://coralfox.notion.site/2-4e842f64f12f4e34bf827f29c30a6942
return

Version:
    ;ShowToolTip("1.5")
return

ExitScript:
ExitApp
return