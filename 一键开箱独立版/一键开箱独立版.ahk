;#=====命令====#
;#####################

#include FindText.ahk
#Include BTT.ahk
#NoEnv
#MenuMaskKey vkE8
#InstallKeybdHook
#InstallMouseHook
#KeyHistory 100
#UseHook
#MaxThreadsPerHotkey 1
#MaxThreads 30
#MaxThreadsBuffer off

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
global ver := "1.0"
global voiceObject := ComObjCreate("SAPI.SpVoice")
;voiceObject.Rate := 4
voiceObject.Volume := 100

global hwid := 0

global debug := 0

if debug and vTtsSpeak
    Speak("debug Online")

global _maxMouseDelay:=30
global _maxKeyDelay:=50

;服装箱子
global skinBoxEnable := 0

if FileExist("KXsettings.ini")
{

    IniRead , vAutoBox, KXsettings.ini, 服装箱子, 启用, 0

    IniRead , vTtsSpeak, KXsettings.ini, 信息显示,TTS语音通报, 1	;1-装配工,2固线
}
Else{
    FileAppend, 
    (LTrim
    [服装箱子]
    启用=0

    [信息显示]
    TTS语音通报=1

    [基本参数]
    鼠标按键延迟=30
    键盘按键延迟=50
    ), KXsettings.ini

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

;服装箱
Menu , tray, add,
Menu , tray, add, 自动开服装箱|ALT+2, AutoBox
if (vAutoBox) {
    Menu , tray, check, 自动开服装箱|ALT+2
}
Menu,tray,add,

Menu,Tray,Add,TTS语音通报,TtsSpeak
if (vTtsSpeak) {
    Menu,Tray,check,TTS语音通报
}
else{
    Menu,Tray,uncheck,TTS语音通报
}

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

; 启动自动打开服装箱，默认是 Alt+2
#If (WinActive("ahk_exe TheDivision2.exe") or debug) AND vAutoBox
    !2::
    skinBoxEnable := !skinBoxEnable

    if(skinBoxEnable)
    {
        if vTtsSpeak
            Speak("启动自动打开服装箱")

        SetTimer, openBOX, 15000
    }
    else{
        SetTimer, openBOX, delete
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
        SetTimer, openBOX, delete
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

return

~F1::Suspend, Toggle

;自动开服装箱
AutoBox:
    Menu, Tray, ToggleCheck, 自动开服装箱|ALT+2
    vAutoBox := Not vAutoBox
    IniWrite, % vAutoBox, KXsettings.ini, 服装箱子, 启用

return

;TTS语音播报
TtsSpeak:
    Menu, Tray, ToggleCheck, TTS语音通报
    vTtsSpeak := !vTtsSpeak

    if vTtsSpeak
        Speak(vTtsSpeak ? "已开启TTS语音播报" : "已关闭TTS语音播报" )

    IniWrite, % vTtsSpeak, KXsettings.ini, 信息显示,TTS语音通报
return

;#####################
;#====基础函数====#
;#####################

SendKey(Key,DelayTime := 30)
{
    Random, fixDelay, 20, 50

    DelayTime +=fixdelay
    Send {%key% Down}
    Sleep DelayTime
    Send {%key% Up}
}

Speak(Text)
{
    voiceObject.Speak(Text, 0)
return
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
    run,https://github.com/coralfox/TheDivision2-keyhelper/tree/%E6%8C%89%E9%94%AE%E5%8A%A9%E6%89%8B
return

ExitScript:
ExitApp
return