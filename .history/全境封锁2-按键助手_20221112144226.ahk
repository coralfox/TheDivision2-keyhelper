;#=====命令====#
;#####################
#NoEnv
#include FindText.ahk
#Include BTT.ahk
; #Include %A_ScriptDir%\Class_DD\class_DD.ahk

#MenuMaskKey vkE8
#InstallKeybdHook
#InstallMouseHook
#KeyHistory 100
#UseHook
#MaxThreadsPerHotkey 1
#MaxThreads 30
#MaxThreadsBuffer off

; SendMode InputThenPlay
ListLines , Off
CurPID := DllCall("GetCurrentProcessId")
Process , Priority, %CurPID%, High
CoordMode , Pixel, Screen
CoordMode , Mouse, Screen
SetWorkingDir %A_ScriptDir%

;#####################
;#====读取ini&初始化====#
;#####################
global ver := "3.3"
global voiceObject := ComObjCreate("SAPI.SpVoice")
;voiceObject.Rate := 4
voiceObject.Volume := 100

global hwid := 0

global debug := 0 ;调试专用

if debug and vTtsSpeak
    Speak("debug Online")

global _maxMouseDelay:=30
global _maxKeyDelay:=50

global _Readytofire = 1	;射击等待
global _timerRunning = 0

global crosshairX =
global crosshairY =

;简单连击
global speedArray := [25, 50, 75, 120]	; 连击间隔时间，单位毫秒，多个速率请使用这种格式：[80, 160, 320]
global speedIndex := 1

;服装箱子
global skinBoxEnable := 0

;狙击塔循环
global loopJuTaEnable := 0

global vStartTime:=0
global vEndTime:=0

global vTtsSpeak:=1

global _downVal := 2
global _rightVal := 0
global _shotdelay := 0

Global vCloseEAC:=1
Global vSetUPC:=1

global vm := 0
global _chooseGun := 1 ;默认1号武器
global _weaponText :="武器"

global lenInfo:=0
global lenFireInfo:=0

global vajMode:=1 ;按键模式

if FileExist("TheDivision2.ini")
{
    IniRead , _maxMouseDelay, TheDivision2.ini, 基本参数, 鼠标按键延迟, 30
    IniRead , _maxKeyDelay, TheDivision2.ini, 基本参数, 键盘按键延迟, 50

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
    IniRead , vJuTaAndShoot, TheDivision2.ini, 瞬发狙击塔,狙击塔间隔射击, 1

    IniRead , vInfoMethod, TheDivision2.ini, 信息显示, 显示模式, 1 ;1-渐隐,2固定
    ; IniRead , vShadowMode, TheDivision2.ini, 信息显示, 渐隐模式, 1
    ; IniRead , vFixMode, TheDivision2.ini, 信息显示, 固定模式, 0
    IniRead , vTtsSpeak, TheDivision2.ini, 信息显示,TTS语音通报, 1

    IniRead , vajMode, TheDivision2.ini, 键鼠操作模式, 按键模式, 1
    ; IniRead , vPlayMode, TheDivision2.ini, 键鼠操作模式, 游戏模式, 0
    ; IniRead , vDdMode, TheDivision2.ini, 键鼠操作模式, 强力模式, 0
    readWeapon(_chooseGun)

}
Else{

    FileAppend,
    (LTrim
        [自动射击]
        启用=0
        简单模式=1
        高级模式=0
        发现敌人自动射击=0

        [简单模式]
        单发间隔=1

        [高级模式]
        单发间隔1=0
        垂直偏移1=2
        水平偏移1=0
        单发间隔2=0
        垂直偏移2=2
        水平偏移2=0
        单发间隔3=0
        垂直偏移3=2
        水平偏移3=0
        武器名1=武器1
        武器名2=武器2
        武器名3=武器3
        武器名修饰后缀=已上线

        [服装箱子]
        启用=0

        [无限溜溜球]
        启用=0
        装配工模式=1
        固线模式=0
        技能使用后自动重置固线=0

        [游戏启动]
        一键启动=1
        关闭EAC=1
        降低UPC=1

        [一键政令]
        启用=1
        重置控制点=1

        [瞬发狙击塔]
        狙击塔快速使用=0
        狙击塔间隔射击=1

        [信息显示]
        显示模式=1
        TTS语音通报=1

        [基本参数]
        鼠标按键延迟=30
        键盘按键延迟=50

        [键鼠操作模式]
        按键模式=1
    ), TheDivision2.ini

}

SetMouseDelay, 0,_maxMouseDelay, Play
SetKeyDelay, 0, _maxKeyDelay, Play

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

;连射
Menu , tray, add,
; Menu, tray, add,自动连射,MenuHandler
; fn := Func("AutoFireSwitch")
Menu , Tray, Add, 自动连射|F4开关, AutoFireSwitch
Menu , MySubMenu1, Add, 简单模式, FastShoot
Menu , MySubMenu1, Add, 高级模式, DiyShoot
Menu , Tray, Add, 连射模式, :MySubMenu1
Menu , tray, add,发现敌人自动射击 , AutoShoot

if (vFastShoot) {
    Menu , MySubMenu1, check, 简单模式
    Menu , tray, Disable, 发现敌人自动射击
} else {
    Menu , MySubMenu1, check, 高级模式
}

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

;===========================================
;溜溜球
Menu,tray,add,
Menu,Tray,Add,无限溜溜球|F5开关,AutoLiu
Menu,MySubMenu2,Add,装配工模式,zpgLiu
Menu,MySubMenu2,Add,固线模式,gxLiu
Menu,Tray,Add,溜溜球模式,:MySubMenu2
Menu,Tray,Add,固线自动重置,AutoGxLiu

if (vzpgLiu) {
    Menu , MySubMenu2, check, 装配工模式
} else {
    Menu , MySubMenu2, check, 固线模式
}

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
Menu , tray, add, 狙击塔间隔射击, JuTaAndShoot

if (vAutoJuTa) {
    Menu,Tray,check,瞬发狙击塔|F6开关
    Menu , tray, enable, 狙击塔间隔射击
}
else{
    Menu,Tray,uncheck,瞬发狙击塔|F6开关
    Menu ,tray, Disable, 狙击塔间隔射击
}

if (vJuTaAndShoot) {
    Menu,Tray,check,狙击塔间隔射击
}
else{
    Menu,Tray,uncheck,狙击塔间隔射击
}

Menu , tray, add,鼠标侧键1|ALT+E开启/关闭循环 , MenuHandler
Menu , tray, Disable, 鼠标侧键1|ALT+E开启/关闭循环

Menu,tray,add,
Menu,MySubMenu4,Add,兼容模式,NormalMode
Menu,MySubMenu4,Add,游戏模式,PlayMode
Menu,MySubMenu4,Add,强力模式,inputMode
if (vajMode==1) {
    Menu , MySubMenu4, check, 兼容模式
} else if(vajMode==2){
    Menu , MySubMenu4, check, 游戏模式
} else if(vajMode==3){
    Menu , MySubMenu4, check, 强力模式
}
Menu,Tray,Add,键鼠操作模式,:MySubMenu4
Menu,tray,add,信息显示|F2,MenuHandler
Menu,tray,check,信息显示|F2
Menu,MySubMenu3,Add,渐隐模式,ShadowMode
Menu,MySubMenu3,Add,固定模式,FixMode
if (vInfoMethod=1) {
    Menu , MySubMenu3, check, 渐隐模式
} else if (vInfoMethod=2) {
    Menu , MySubMenu3, check, 固定模式
}
Menu,Tray,Add,显示模式,:MySubMenu3
Menu,Tray,Add,TTS语音通报,TtsSpeak
if (vTtsSpeak) {
    Menu,Tray,check,TTS语音通报
}
else{
    Menu,Tray,uncheck,TTS语音通报
}

Menu , tray, add,鼠标侧键1|ALT+Q刷新技能 , MenuHandler
Menu , tray, Disable, 鼠标侧键1|ALT+Q刷新技能

;===========================================
startuplnk := A_StartMenu . "\Programs\Startup\" . A_ScriptName . ".lnk"
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

;#####################
;#====脚本====#
;#####################

#If vOnekeyRun
!F10::

    WinGet, NewPID1, PID, ahk_exe TheDivision2.exe
    if NewPID1
        Process,close,%NewPID1%
    Sleep 3000

    ; WinGet, NewPID2, PID, ahk_exe EasyAntiCheat.exe
    ; if NewPID2
    ;     Process,close,%NewPID2%
    ; Sleep 3000

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
        if vTtsSpeak
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
    if cmdInfo and vCloseEAC and vTtsSpeak
    {
        Speak(SubStr(cmdInfo,1,2)="成功" ? "已经关闭小蓝熊":"未能关闭小蓝熊")
    }

    if vSetUPC and WinExist("ahk_exe upc.exe")
    {
        WinGet, NewPID, PID, ahk_exe upc.exe
        Process, Priority, %NewPID%, Low
        ;Process, Priority,"upc.exe",Low
        Sleep 3000
        if vTtsSpeak
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
    ; vDelay:=80
    sleep 250
    SendKey("m")
    ; Sleep vDelay
    SendKey("z")
    ; Sleep vDelay
    SendKey("Down")
    ; Sleep vDelay
    SendKey("Space")
    ; Sleep vDelay

    loop, 4
    {
        SendKey("Space")
        ; Sleep vDelay
        SendKey("Down")
        ; Sleep vDelay
    }

    SendKey("Space")
    ; Sleep vDelay
    SendKey("Esc")
    ; Sleep vDelay
    ;根据选项决定是否重置控制点
    if (vResetArea = 1)
    {
        SendKey("Down")
        ; Sleep vDelay
        SendKey("Space")
        ; Sleep vDelay
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
        if vTtsSpeak
            Speak("启动自动打开服装箱")

        SetTimer, openBOX, 15000
        Gosub, openBOX
    }
    else{
        SetTimer, openBOX, off
        SendKey("x")

        btt(,,,3)
        if vTtsSpeak
            Speak("已停止打开服装箱")
    }
return

openBOX:

    ;发现黄色标题-删除特工
    Text :="|<删除特工>*101$130.0000000000000000000000000000000000k0U000000000yDU47s1k03020000000003Az0ElUBU1A080000000008m4F321X04k1k000000000X8H4AMA60n3zy3zzzk0002AVAEl3UA3A08000k000008m4l3Aw0QDw0U003000000X8H4Ar00sn02000A000002AVAEm3zy2A0Q000k000008m4l380Q08lzzk03000000X8n4Ak0U1X00800A00000DzzwEn0206A00U00k00000Tzyl360800o02003000000X8H4AM1k03rzy00A000002AVAEkjzz0Czzw00k000008m4l320803k02003000000X8H4A80U0T00800A000002BVAElV2A7A70U00k000008q4l3iA8M0kC2003000000XMH4DkUVU30Q800A000006BV0Ek6230A0kU00k00000Mo4130k8A0k02003000001XEEAA30UM300800C000004D3AkkM21UA1VUTzzzk000Hwwz303s00k7y000000000000080300200000000000000000000000000000000000000000000000000008"
    if (ok:=FindText(X, Y,, , , , 0, 0, Text))
    {
        SendKey("Esc")
        sleep 1500
    }

    btt("删除特工检测1完成",800,500,3,"Style8")
    ;发现白色标题-删除特工
    Text :="|<删除特工>*91$81.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzjvzzzzzzzzVwzpzTzU1zzyysD/wi0D00zz+GrNnbYzTztzzvLGvMyQ3vzzDzzOuLOC1hk1ztzzvLGuQ0xiCTzDzzOuLHyzBznztzzv02vDrzXUDzDzy00LN03wU3ztzzvHGvcbyDyTzDzzOuLRyrZtnztzzvLGtBqTjaTzDzzOuL3Cvxynzs0zvLSvvrDjyS00TyMvrSyxxw7zzzzn6Svy7zjtzzzzyUW7Tzzzzzzzzzyzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw"

    if (ok:=FindText(X, Y,, , , , 0, 0, Text))
    {
        SetTimer, openBOX, off
        skinBoxEnable := !skinBoxEnable

        btt(,,,3)
        MsgBox, 0, 警告, 发现删除特工按钮停止运行
        if vTtsSpeak
            Speak("已停止打开服装箱")

        Gosub,ReloadScript
    }
    btt("删除特工检测2完成",800,500,3,"Style8")

    Text :="|<开启贮藏箱>*93$110.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzszzzzzzzzzzzzzzzzzz00Tzzzzzzzzzzzzzzzwy3ztzzzzzzzzzzzzzzTryDTz1zzzzzzzzzzzrxzU07bDjzzzzzzzzzxzTnzwtm1yNxzzzzzzrTrwzziIA1k07yzzzzw01z0Dvh3zTrk7bxzzzxy1nk0vEzqzz7k6TzzzTbwzzyozzg00trU7zzbtzDzzhDztTkDwrbzzvyTm01vHzy63TwzxzzwzbxDzCozzx9rsD0TzyTtzHzvdDzzERD0bnzzDyTozyuTzy41HwtyzzrzjtDzjXzzhSJyC1Dzzzvys0nmTzvE4TVb3zzzzzzz0to1ypbDl9yzzzzzzzzyzy1d/mNO7jzzzzzzzzzzzqs8irU3zzzzzzzzzzzzDsfxvwzzzzzzzzzzzzzyMzSTDzzzzzzzzzzzzzzzrU3zzzzzzzzzzzzzzzzztzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzs"
    if (ok:=FindText(X, Y,, , , , 0, 0, Text))
    {
        btt("开启箱子",800,500,3,"Style8")
        SendKey("x", 2500)
        Sleep 4500
        SendKey("Space")
        btt("接受箱子",800,500,3,"Style8")
        Sleep 2000
        SendKey("x")
    }
    else{
        SendKey("Space")
        Sleep 2000
        SendKey("x")
    }

    ; Text:="|<揭露物品>*192$123.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzXzzzzzzzzzzzzzzzzzs00Dzzzzzzzzzzzzjtzzy07tzzzzzzzzzzzzxzDzzXzzjzzzzzzzzzkTzjtzzwzzxzzzzzzzs003zRzDzzbzzjzzzzsTw00zznjk07wzzxzzzk01zzwTzyRy00TbzzDztw1zDzy007njkAnwzztzzDbzty007yS04taTbzkDztwzzDkzrznk1bAnw003zzDby1wzySCyRtvaTk3zzztw00Db1n1brjCQnzzzzzy1UTtwkCzzwxnnCTzzzzz0AzzDzzr0zbiytnzzw0TzDbztzkDzzwxzbCS07Dtztws0Dzzz0DDjxvnUwnzDzDU07zkDk1zxzCSQzaTtztz7zzs0wTDzcnnnjwnzTzBtzzyDa3nzwCSSRzaTvzsCDUDnwqCTz3bbnjwnzTz1k00yTbs7zktwyRzaTvzsQ0TblszVzsCDDnjwnzTz77nwy0Ds1w9nvyxzaTvzllyzbwDwD3bjyTbjwnzTwADXwztw7VzxzbwxzaTnz9Vs7bz0w0Dzjtzbjwk0zzhCAQyM77sztyTww0D0zzxtXlbnDtzbzjbzDU3zzzzjAzwyNzDwzxts1zzzzzzxsjXbnDtzbzDT0TzzzzzzjU0QyNXDxztzzzzzzzzzxy1zjn0s0Dzzzzzzzzzzzjzzty0TU7zzzzzzzzzzzxzz0DUTzzzzzzzzzzzzzsDzw3zzzzzzzzzzzzzzzz1zzzzzzzzzzzzzzzzzzzwTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzU"
    ; if (ok:=FindText(X, Y,, , , , 0, 0, Text))
    ; {
    ;     btt("接受箱子",500,500,3,"Style9")
    ;     SendKey("Space")
    ;     Sleep 1500
    ;     SendKey("x")
    ; }
return

#If (WinActive("ahk_exe TheDivision2.exe") or debug) and vAutoLiu AND vzpgLiu
!q::
XButton1::
    ; SetKeyDelay, 0, 30, Play
    SendKey("q",30,"down")
    loop,15{
        ; Random, keydelay, 10, 50
        SendKey("5")
        ; sleep keydelay
    }
    sleep 1500
    SendKey("q",30,"up")
return

#If (WinActive("ahk_exe TheDivision2.exe") or debug) and vAutoLiu AND vgxLiu
!q::
~XButton1::
    Sleep 200
    gxliuAction()
return

gxliuAction()
{
    ; SetKeyDelay, 0, 40, Play
    ; Random, vdelay, 80, 120
    SendKey("b")
    ; Sleep vdelay
    SendKey("Down")
    ; Sleep vdelay
    SendKey("Down")
    ; Sleep vdelay
    SendKey("Space")
    ; Sleep vdelay

    Random, vdelay, 100, 150
    SendKey("Down")
    Sleep vdelay
    SendKey("Space")
    Sleep vdelay
    SendKey("UP")
    Sleep vdelay
    SendKey("Space")
    Sleep vdelay

    ; Random, vdelay, 80, 120
    SendKey("Esc")
    ; Sleep vdelay
    SendKey("UP")
    SendKey("Space")
    SendKey("Space") ;切换到主武器

    SendKey("Esc")
    SendKey("b")
    ; Sleep vdelay
    Return
}

#InputLevel 1
#If (WinActive("ahk_exe TheDivision2.exe") or debug) and vAutoLiu AND vgxLiu and vAutoGxLiu
~q::
~e::
~5::
~6::
~LButton::
    if (A_ThisHotkey = "~LButton" and A_PriorHotkey = "~Q" and A_TimeSincePriorHotkey <= 1500 ;Q然后左键释放
            or A_ThisHotkey="~Q" and A_PriorHotkey = "~Q" and A_TimeSincePriorHotkey <= 600 ;双击Q释放
        or A_ThisHotkey="~Q" and A_TimeSinceThisHotkey >= 400 ;长按Q释放
    or A_ThisHotkey="~5" ) ;立即使用特工技能1
    {
        Sleep 800
        gxliuAction()
    }
    else if (A_ThisHotkey = "~LButton" and A_PriorHotkey = "~E" and A_TimeSincePriorHotkey <= 1500 ;E然后左键释放
            or A_ThisHotkey="~E" and A_PriorHotkey = "~E" and A_TimeSincePriorHotkey <= 600 ;双击E释放
        or A_ThisHotkey="~E" and A_TimeSinceThisHotkey >= 400
    or A_ThisHotkey="~6" ) ;立即使用特工技能2
    {
        Sleep 400
        gxliuAction()
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
        gosub,ShowBTT ;单击则切换显示信息
    }
    else if (winc_presses = 2) ; 此键按下了两次.
    {
        if vShadowMode
            gosub,FixMode
        else
            gosub,ShadowMode ;双击则切换显示模式
    }
    else if (winc_presses > 2)
    {
        gosub,TtsSpeak ;三击切换TTS语音播报
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
        gosub,JuTaAndShoot ;双击则切换狙击塔间隔射击
    }
    ; else if (winc_presses > 2)
    ; {
    ;     ; gosub,AutoGxLiu ;三击切换发现敌人自动射击
    ; }
    ; ; 不论触发了上面的哪个动作, 都对 count 进行重置
    ; ; 为下一个系列的按下做准备:
    winc_presses := 0
return

~F1::Suspend, Toggle

#If

#If (WinActive("ahk_exe TheDivision2.exe") or debug) and vAutoJuTa
!e up::
XButton1 Up::
loopJuTaEnable := !loopJuTaEnable

if(loopJuTaEnable)
{

    if vTtsSpeak
        Speak("狙击塔 battle control online")

    SetTimer, loopJuTa, 4000
    gosub loopJuTa
}
else{
    SetTimer, loopJuTa, off

    if vTtsSpeak
        Speak("狙击塔已下线")
}
return

loopJuTa:
    ; Random, vRanDelay, 50, 180
    ; sleep vRanDelay6

    if vJuTaAndShoot
    {
        SendKey("LButton",20,2)
        ; SendKey("Click")
        sleep 600
    }
    else{
        sleep 1000
    }

    SendKey("6",500)
    sleep 600
    loop 5{
        sleep 120
        SendKey("e")
    }
    sleep 600
    SendKey("6",500)
    sleep 200
return

; #IfWinActive ahk_exe TheDivision2.exe
; 切换速率，默认是鼠标侧键
#If (WinActive("ahk_exe TheDivision2.exe") or debug) AND vFastShoot and _autofire
~\::
    speedIndex += 1
    if (speedIndex > speedArray.Length()) {
        speedIndex := 0
    }
    if vTtsSpeak
        Speak(speedIndex > 0 ? "连击间隔 " speedArray[speedIndex] : "已关闭连击")

    IniWrite, %speedIndex%, TheDivision2.ini, 简单模式, 单发间隔
return

~^\::
    speedIndex -= 1
    if (speedIndex <0) {
        speedIndex := speedArray.Length()
    }
    if vTtsSpeak
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

}

~=::
    _downVal := _downVal + 1

    if vTtsSpeak
        Speak("垂直偏移补偿为" _downVal)

    IniWrite, % _downVal, TheDivision2.ini, 高级模式, 垂直偏移%_chooseGun%
return

~-::
    if _downVal > 0
    {
        _downVal := _downVal - 1

        if vTtsSpeak
            Speak("垂直偏移补偿为" _downVal)

        IniWrite , % _downVal, TheDivision2.ini, 高级模式, 垂直偏移%_chooseGun%
    }

return

~^=::	; Adds right adjust
    _RightVal := _RightVal + 1
    ; 右为正值,左为负值
    if vTtsSpeak
        Speak("水平偏移补偿为" _RightVal)

    IniWrite, % _RightVal, TheDivision2.ini, 高级模式, 水平偏移%_chooseGun%
return

~^-::	; 增加水平偏移
    _RightVal := _RightVal - 1
    ; 右为正值,左为负值
    if vTtsSpeak
        Speak("水平偏移补偿为" _RightVal)

    IniWrite, % _RightVal, TheDivision2.ini, 高级模式, 水平偏移%_chooseGun%
return

~\::	;单发延迟 (0为连射)
    _shotdelay := _shotdelay + 25

    if vTtsSpeak
        Speak("单发射击延迟为" _shotdelay)

    IniWrite, % _shotdelay, TheDivision2.ini, 高级模式, 单发间隔%_chooseGun%
return

~^\::
    if _shotdelay > 0
    {
        _shotdelay := _shotdelay - 25
        if _shotdelay<0
            _shotdelay:=0

        if vTtsSpeak
            Speak("单发射击延迟为" _shotdelay)

        IniWrite, % _shotdelay, TheDivision2.ini, 高级模式, 单发间隔%_chooseGun%
    }
return

; 按住鼠标右键再按左键连击，其他情况不连击
#If speedIndex > 0 AND _autofire AND vFastShoot and (WinActive("ahk_exe TheDivision2.exe") or debug)
~RButton & LButton::fastFire()

; #If (WinActive("ahk_exe TheDivision2.exe") or debug) and _autofire AND vFastShoot
; ~CapsLock::
; if GetKeyState("CapsLock", "T")
; {
;     rbtnState = 1
; }
; else
; {
;     rbtnState = 0
; }

; if (winc_presses > 0) ; SetTimer 已经启动, 所以我们记录键击.
; {
;     winc_presses += 1
;     return
; }
; ; 否则, 这是新开始系列中的首次按下. 把次数设为 1 并启动
; ; 计时器:
; winc_presses := 1
; SetTimer, KeyWinE, -800 ; 在 800 毫秒内等待更多的键击.
; return

; KeyWinE:
;     if (winc_presses = 1) ; 此键按下了一次.
;     {
;         SendKey("RButton UP}
;         rbtnState = 0
;     }
;     else if (winc_presses = 2) ; 此键按下了两次.
;     {
;         SendKey("RButton Down}
;         rbtnState = 1 ;进入右键模式

;     }

;     ; 不论触发了上面的哪个动作, 都对 count 进行重置
;     ; 为下一个系列的按下做准备:
;     winc_presses := 0
; return
return

#If (WinActive("ahk_exe TheDivision2.exe") or debug) AND vDiyShoot and _autofire
LButton::lessrecoil()
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

lessrecoil_noCheck()
{
    while GetKeyState("LButton", "P") and GetKeyState("RButton", "P")
    {
        TryToFire()
        ApplyReduction()
    }

    loop,4{
        Sleep 120
        sendkey("j",25,"up")
    }
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
    sendkey("j",25,"up")
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
    loop,4{
        Sleep 120
        sendkey("j",25,"up")
    }
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
        sendkey("j",25,"up")
        Sleep 10
        return false
    }
}
;==================
TryToFire()
{
    if _shotdelay = 0
    {
        sendkey("j",25,"down")
        return
    } else
    {
        if _Readytofire = 1
        {
            sendkey("j",25,"down")
            sleep 30
            sendkey("j",25,"up")
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
            sendkey("j",25,"up")
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

    if vTtsSpeak
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

    if vTtsSpeak
        Speak(vFastShoot ? "已切换简单模式" : "已切换高级模式" )

    IniWrite, % vFastShoot, TheDivision2.ini, 自动射击, 简单模式
    IniWrite, % vDiyShoot, TheDivision2.ini, 自动射击, 高级模式
return

;自动连射开关
AutoFireSwitch:
    Menu, Tray, ToggleCheck, 自动连射|F4开关
    _autofire := !_autofire

    fireMode:=vFastShoot?"简单模式":"高级模式"

    if vTtsSpeak
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

    if vTtsSpeak
        Speak(vAutoShoot ? "已开启发现敌人自动射击" : "已关闭发现敌人自动射击" )

    IniWrite, % vAutoShoot, TheDivision2.ini, 自动射击, 发现敌人自动射击
return

;自动溜溜球开关
AutoLiu:
    Menu, Tray, ToggleCheck, 无限溜溜球|F5开关
    vAutoLiu := !vAutoLiu
    LiuMode := vzpgLiu ? "装配工模式" : "固线模式"
    if vTtsSpeak
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
    if vTtsSpeak
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
    if vTtsSpeak
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
    if vTtsSpeak
        Speak(vAutoGxLiu ? "已开启固线自动重置" : "已关闭固线自动重置" )

    IniWrite, % vAutoGxLiu, TheDivision2.ini, 无限溜溜球,技能使用后自动重置固线
return

;自动使用狙击塔
AutoJuTa:
    Menu, Tray, ToggleCheck, 瞬发狙击塔|F6开关
    vAutoJuTa := !vAutoJuTa

    if vTtsSpeak
        Speak(vAutoJuTa ? "已开启瞬发狙击塔" : "已关闭瞬发狙击塔" )

    if (vAutoJuTa) {
        Menu,Tray,enable,狙击塔间隔射击
    }
    else{
        Menu,Tray,Disable,狙击塔间隔射击
    }
    IniWrite, % vAutoJuTa, TheDivision2.ini, 瞬发狙击塔,狙击塔快速使用
return

;自动使用狙击塔时夹杂射击
JuTaAndShoot:
    Menu, Tray, ToggleCheck, 狙击塔间隔射击
    vJuTaAndShoot := !vJuTaAndShoot

    if vTtsSpeak
        Speak(vJuTaAndShoot ? "已开启狙击塔间隔射击" : "已关闭狙击塔间隔射击" )

    IniWrite, % vJuTaAndShoot, TheDivision2.ini, 瞬发狙击塔,狙击塔间隔射击
return

;#####################
;#====信息显示相关菜单====#
;#####################
;渐隐模式
ShadowMode:
    Menu , MySubMenu3, check, 渐隐模式
    Menu , MySubMenu3, uncheck, 固定模式
    vShadowMode := 1
    vFixMode := 0

    if vTtsSpeak
        Speak(vShadowMode ? "信息显示已切换渐隐模式" : "信息显示已切换固定模式" )

    IniWrite, % vShadowMode, TheDivision2.ini, 信息显示, 渐隐模式
    IniWrite, % vFixMode, TheDivision2.ini, 信息显示, 固定模式
return

;固定模式
FixMode:
    Menu , MySubMenu3, check, 固定模式
    Menu , MySubMenu3, uncheck, 渐隐模式
    vShadowMode := 0
    vFixMode := 1

    if vTtsSpeak
        Speak(vShadowMode ? "信息显示已切换渐隐模式" : "信息显示已切换固定模式" )

    IniWrite, % vShadowMode, TheDivision2.ini, 信息显示, 渐隐模式
    IniWrite, % vFixMode, TheDivision2.ini, 信息显示, 固定模式
return

;TTS语音播报
TtsSpeak:
    Menu, Tray, ToggleCheck, TTS语音通报
    vTtsSpeak := !vTtsSpeak

    if vTtsSpeak
        Speak(vTtsSpeak ? "已开启TTS语音播报" : "已关闭TTS语音播报" )

    IniWrite, % vTtsSpeak, TheDivision2.ini, 信息显示,TTS语音通报
return

;兼容模式
NormalMode:
    Menu , MySubMenu4, check, 兼容模式
    Menu , MySubMenu4, uncheck, 游戏模式
    Menu , MySubMenu4, uncheck, 强力模式
    vajMode := 1 ;1-兼容模式 2-游戏模式 3-强力模式
    SendMode Event
    ; vPlayMode := 0
    ; vDdMode := 0

    if vTtsSpeak
        Speak(vajMode==1 ? "助手按键已切换兼容模式" : )

    IniWrite, % vajMode, TheDivision2.ini, 键鼠操作模式, 按键模式
    ; IniWrite, % vPlayMode, TheDivision2.ini, 键鼠操作模式, 游戏模式
    ; IniWrite, % vDdMode, TheDivision2.ini, 键鼠操作模式, 强力模式
return

;游戏模式
PlayMode:
    Menu , MySubMenu4, uncheck, 兼容模式
    Menu , MySubMenu4, check, 游戏模式
    Menu , MySubMenu4, uncheck, 强力模式
    vajMode := 2 ;1-兼容模式 2-游戏模式 3-强力模式
    ; SendMode Play
    ; vPlayMode := 1
    ; vDdMode := 0

    if vTtsSpeak
        Speak(vajMode == 2 ? "助手按键已切换游戏模式" : )

    IniWrite, % vajMode, TheDivision2.ini, 键鼠操作模式, 按键模式
    ; IniWrite, % vPlayMode, TheDivision2.ini, 键鼠操作模式, 游戏模式
    ; IniWrite, % vDdMode, TheDivision2.ini, 键鼠操作模式, 强力模式
return

;强力模式
inputMode:
    Menu , MySubMenu4, uncheck, 兼容模式
    Menu , MySubMenu4, uncheck, 游戏模式
    Menu , MySubMenu4, check, 强力模式
    vajMode := 3 ;1-兼容模式 2-游戏模式 3-强力模式
    ; SendMode InputThenPlay
    ; vNormalMode := 0
    ; vPlayMode := 0
    ; vDdMode := 1

    if vTtsSpeak
        Speak(vajMode==3 ? "助手按键已切换强力模式" : )

    IniWrite, % vajMode, TheDivision2.ini, 键鼠操作模式, 按键模式
    ; IniWrite, % vNormalMode, TheDivision2.ini, 键鼠操作模式, 兼容模式
    ; IniWrite, % vPlayMode, TheDivision2.ini, 键鼠操作模式, 游戏模式
    ; IniWrite, % vDdMode, TheDivision2.ini, 键鼠操作模式, 强力模式
return

/*  TODO:info修改
* 1.增加界面
* 2.修改按键模式

*/

infoMenu:
    ;菜单头
    info =
    (LTrim
        功能`t`t- 开关`t`t- 按键
        ---------------------------------------------
    )

    info .="`n一键政令:`t- " transit(vOneKeyZL) "`t`t- 单击ALT+1"
    . "`n重置控制点:`t- " transit(vResetArea)
    . "`n自动开服装箱:`t- " transit(vAutoBox) "`t`t- 切换ALT+2"
    . "`n自动连射:`t- " transit(_autofire) "`t`t- 单击F4"

    ;自动射击子菜单
    if _autofire
    {
        info .="`n连射模式:`t- " transit(vFastShoot,"fire") "`t`t- 双击F4"
        . "`n遇敌自动射击:`t- " transit(vAutoShoot) "`t`t- 三连F4"
    }

    info .="`n无限溜溜球:`t- " transit(vAutoLiu) "`t`t- 单击F5"

    ;无限溜溜球子菜单
    if vAutoLiu
    {
        info .="`n溜溜球模式:`t- " transit(vzpgLiu,"liu") "`t`t- 双击F5"
        . "`n固线自动重置:`t- " transit(vAutoGxLiu) "`t`t- 三连F5"
    }

    info .="`n瞬发狙击塔:`t- " transit(vAutoJuTa) "`t`t- 单击F6"
    if vAutoJuTa
    {
        info .="`n狙击塔间隔射击:`t- " transit(vJuTaAndShoot) "`t`t- 双击F6"
    }

    info .="`n显示模式:`t- " transit(vShadowMode,"info") "`t`t- 双击F2"

    info .="`n键鼠操作模式:`t- " transit(vajMode,"ajmode")

    btt(info,10,10,1,"Style8",{Transparent:180,TargetHWND:target})
    ret := btt(info,10,10,1,"Style8",{Transparent:180,TargetHWND:target,JustCalculateSize:1})

    ;菜单头-自动射击

    if _autofire{

        fireInfo =
        (LTrim
            功能`t`t数值`t`t- 按键
            ---------------------------------------------
        )

        ;自动射击子菜单
        if vDiyShoot
        {
            fireInfo .= "`n选择武器:`t " _weaponText "`t`t- 单击1/2/3"
            . "`n垂直偏移:`t " _downVal "`t`t- =或-"
            . "`n水平偏移:`t " _RightVal "`t`t- Ctrl加=或-"
            . "`n单发间隔:`t " _shotdelay "`t`t- \或Ctrl加\"
        }
        else if vFastShoot
        {
            fireInfo .= "`n单发间隔:`t " transit(speedIndex,"fastshoot") "`t`t- \或Ctrl加\"
        }

        btt(fireInfo,10,ret.h+10,2,"Style8",{Transparent:180,TargetHWND:target})

    }
    else{
        btt(,,,2)
    }

    if vShadowMode
    {
        if(StrLen(info) != lenInfo or StrLen(fireInfo) != lenFireInfo){
            SetTimer, RemoveBtt,-30000

            lenInfo := StrLen(info)
            lenFireInfo := StrLen(fireInfo)
        }

    }
    else if vFixMode{
        SetTimer, RemoveBtt,off
    }

return

;#####################
;#====基础函数====#
;#####################
ShowBTT:
    WinGet, target,ID, ahk_exe TheDivision2.exe

    if vShadowMode and vm=0
    {
        SetTimer, RemoveBtt,-30000
    }

    if vm = 1
    {
        vm = 0
        Gosub, RemoveBtt
    }
    else if vm = 0
    {
        vm = 1
        SetTimer, infoMenu, 120
        gosub, infoMenu
    }
Return

RemoveBtt:
    btt(,,,1)
    btt(,,,2)
    SetTimer, infoMenu, off
    vm = 0
return

transit(varb,mode:="normal"){
    ;normal 常规1,0翻译
    ;fire 连射模式
    ;liu 溜溜球模式
    ;info 显示模式
    ;fastshoot 简单模式

    switch mode
    {
    case "normal":
    return varb = 1?"开启":"关闭"
case "fire":
return varb = 1?"简单":"高级"
case "liu":
return varb = 1?"装配工":"固线"
case "ajMode":
if (varb==1)
    return "兼容"
else if (varb==2)
    return "游戏"
else if (varb==3)
    return "强力"
case "info":
return varb = 1?"渐隐":"固定"
case "fastshoot":
return varb = 0?"关闭":speedArray[varb] . "毫秒"

}

}

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

SendKey(Key,DelayTime := 30,mode:="normal")
{
    Random, fixDelay, 0, 20

    DelayTime +=fixdelay

    if (vajMode==1){
        switch mode
        {
        case "down":
        send {%key% down}
        Sleep DelayTime
        return
    case "up":
    send {%key% up}
    Sleep DelayTime
    return
    Default:
        send {%key% down}
        Sleep DelayTime
        send {%key% up}
        Sleep DelayTime
    return
}
}
Else if (vajMode==2){
    switch mode
    {
    case "down":
    SendPlay {%key% down}
    Sleep DelayTime
    return
case "up":
SendPlay {%key% up}
Sleep DelayTime
return
Default:
    SendPlay {%key% down}
    Sleep DelayTime
    SendPlay {%key% up}
    Sleep DelayTime
return
}
}
Else if (vajMode==3){
    switch mode
    {
    case "down":
    SendInput {%key% down}
    Sleep DelayTime
    return
case "up":
SendInput {%key% up}
Sleep DelayTime
return
Default:
    SendInput {%key% down}
    Sleep DelayTime
    SendInput {%key% up}
    Sleep DelayTime
return
}
}
}

; Sleep3(value) {
;     DllCall("Winmm.dll\timeBeginPeriod", UInt, 1)
;     DllCall("Sleep", "UInt", value)
;     DllCall("Winmm.dll\timeEndPeriod", UInt, 1)
; }

Speak(Text)
{
    voiceObject.Speak(Text, 0)
    return
}

;#####################
;#====常规标签====#
;#####################

OnExit, Clear

Clear:
    DD_Helper.UnloadDll()
ExitApp

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
    run,https://github.com/coralfox/TheDivision2-keyhelper/tree/%E6%8C%89%E9%94%AE%E5%8A%A9%E6%89%8B
return

ExitScript:
ExitApp
return