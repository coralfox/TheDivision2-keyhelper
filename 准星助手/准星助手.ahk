;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Windows 7/8/8.1 32/64bit
; Author:         Youcef Hamdani 	<youcef_0665@hotmail.fr>
;				  YOUCEFHam 		<www.mpgh.net>
; Script Function:
;    
;
{
    #NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
    #Persistent
    SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
    SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
    CoordMode, ToolTip, Screen 

    ;-------------Remove .ahk and .exe from filename to get name for INI file
    ScriptName := A_ScriptName
    StringReplace, ScriptName, ScriptName, .ahk,, All
    StringReplace, ScriptName, ScriptName, .exe,, All
}

;---------------------------------------YOUCEFHam-----------------------------No Recoil/Rapid Fire
vm = 1
ft = 1
chv = 0

;--------------------Load the saved values.
IfExist %ScriptName%.ini
{
    IniRead,chxt, %ScriptName%.ini, Crochair tol,chxt
    IniRead,chyt, %ScriptName%.ini, Crochair tol,chyt
    IniRead,chp, %ScriptName%.ini, Crochair Picture, PictureNum
    IniRead,chcl, %ScriptName%.ini, Crochair Picture, Picturecolor
    IniRead,chc, %ScriptName%.ini, Crochair Picture, Picturecolorval
    IniRead,chimg, %ScriptName%.ini, Crochair Picture, PictureFile
    IniRead,chimgw, %ScriptName%.ini, Crochair Picture, PictureWidth
    IniRead,chimgh, %ScriptName%.ini, Crochair Picture, PictureHeight
}
;------------------------------------------

;--------------------Set the new values.
IfnotExist %ScriptName%.ini
{
    chxt = 0
    chyt = 0
    IniWrite, %chxt%, %ScriptName%.ini , Crochair tol, chxt
    IniWrite, %chyt%, %ScriptName%.ini , Crochair tol, chyt
    chp = 1
    chc = 1
    chcl = 蓝色
    IniWrite, %chp%, %ScriptName%.ini , Crochair Picture, PictureNum
    IniWrite, %chcl%, %ScriptName%.ini , Crochair Picture, Picturecolor
    IniWrite, %chc%, %ScriptName%.ini , Crochair Picture, Picturecolorval
    chimg = CH%chp%%chc%
    chimgw = 60
    chimgh = 60
    IniWrite, %chimg%, %ScriptName%.ini , Crochair Picture, PictureFile
    IniWrite, %chimgw%, %ScriptName%.ini , Crochair Picture, PictureWidth
    IniWrite, %chimgh%, %ScriptName%.ini , Crochair Picture, PictureHeight
}
;------------------------------------------

SetTimer, menu, 120
goto menu

PGDN::
    {
        if vm = 1
        {
            vm = 0
            SetTimer, menu, Off
            ToolTip,,,,1
        }
        else if vm = 0
        {
            vm = 1
            SetTimer, menu, 120
            goto menu
        }
    }
return

menu:
    {
        ToolTip,准星类型:	%chp%`n准星颜色:	%chcl%`n准星类型:	%chimgw%`n---------------------------------------------`nKey		Effect`nPageDown	显示/隐藏菜单`nHome		显示/隐藏准星`n/		改变准星类型`n*		改变准星颜色`n+		准星加大`n-		准星减小`nCtrl+方向键	移动准星`nEnd		重载`nPause		暂停`nDelete		退出`n---------------------------------------------`nCreated By 		 YoucefHam,0,0,1
    }
return

Home:: ;------------Show/Hide Crochair
    {
        if chv = 0
        {
            if ft = 1
                gosub, showch
            else if ft =0
                gosub, drawch
            chv = 1
            SetTimer, tick, 200
        }
        else if chv = 1
        {
            Gui, Cancel
            SetTimer, tick, Off
            chv = 0
        }
    }
return 
showch:
    {
        if ft = 1
        {
            WinGetActiveTitle, wint
            WinGetPos, winx, winy, winw, winh, %wint%
            gosub, posch
            Gui Add, Picture, w%chimgw% h%chimgh% AltSubmit, %A_ScriptDir%\IMG\%chimg%
            Gui Color, FFFFFF
            Gui Show, NA x%chx% y%chy%
            Gui +AlwaysOnTop
            WinSet, TransColor, White, %A_ScriptName%
            Gui -Caption
            ft = 0
        }
    }
return

posch:
    {
        chx := winx + (winw /2) + chxt - chimgw
        chy := winy + (winh /2) + chyt - chimgh
    }
return

drawch:
    {
        GoSub, posch
        Gui, Show, NA x%chx% y%chy%
    }
return

tick:
    {
        IfWinActive, %wint%
        {
            WinGetPos, winx1, winy1, winw1, winh1, %wint%
            if winx1 <> winx or winy1 <> winy or winw1 <> winw or winh1 <> winh
            {
                WinGetPos, winx, winy, winw, winh, %wint%
                if chv = 1
                    GoSub, drawch
            }
        }
        else
        {
            Gui, Cancel
        }
    }
return

;-------------------------------Move/Adjust Crochair
{
^Up::
    {
        chyt -= 1
        GoSub, drawch
        IniWrite, %chyt%, %ScriptName%.ini, Crochair tol, chyt
    }
return

^Down::
    {
        chyt += 1
        GoSub, drawch
        IniWrite, %chyt%, %ScriptName%.ini, Crochair tol, chyt
    }
return

^Left::
    {
        chxt -= 1
        GoSub, drawch
        IniWrite, %chxt%, %ScriptName%.ini, Crochair tol, chxt
    }
return

^Right::
    {
        chxt += 1
        GoSub, drawch
        IniWrite, %chxt%, %ScriptName%.ini, Crochair tol, chxt
    }
return
}
;--------------------------------------------------

NumpadDiv::
    {
        if chv = 1
        {
            if chp = 1
            {
                chp = 2
                chimg = CH%chp%%chc%
            }
            else if chp = 2
            {
                chp = 3
                chimg = CH%chp%%chc%
            }
            else if chp = 3
            {
                chp = 4
                chimg = CH%chp%%chc%
            }
            else if chp = 4
            {
                chp = 5
                chimg = CH%chp%%chc%
            }
            else if chp = 5
            {
                chp = 6
                chimg = CH%chp%%chc%
            }
            else if chp = 6
            {
                chp = 1
                chimg = CH%chp%%chc%
            }
            IniWrite, %chimg%, %ScriptName%.ini , Crochair Picture, PictureFile
            IniWrite, %chp%, %ScriptName%.ini , Crochair Picture, PictureNum
            Gui, Destroy
            ft = 1
            gosub, showch
        }
    }
return

NumpadMult::
    {
        if chv = 1
        {
            if chc = 1
            {
                chc = 2
                chcl = 绿色
                chimg = CH%chp%%chc%
            }
            else if chc = 2
            {
                chc = 3
                chcl = 红色
                chimg = CH%chp%%chc%
            }
            else if chc = 3
            {
                chc = 4
                chcl = 黄色
                chimg = CH%chp%%chc%
            }
            else if chc = 4
            {
                chc = 1
                chcl = 蓝色
                chimg = CH%chp%%chc%
            }
            IniWrite, %chimg%, %ScriptName%.ini , Crochair Picture, PictureFile
            IniWrite, %chcl%, %ScriptName%.ini , Crochair Picture, Picturecolor
            IniWrite, %chc%, %ScriptName%.ini , Crochair Picture, Picturecolorval
            Gui, Destroy
            ft = 1
            gosub, showch
        }
    }
return

NumpadSub::
    {
        if chv = 1
        {
            chimgw -= 1
            if chimgw < 5
                chimgw = 5
            chimgh -= 1
            if chimgh < 5
                chimgh = 5
            IniWrite, %chimgw%, %ScriptName%.ini , Crochair Picture, PictureWidth
            IniWrite, %chimgh%, %ScriptName%.ini , Crochair Picture, PictureHeight
            Gui, Destroy
            ft = 1
            gosub, showch
        }
    }
return

NumpadAdd::
    {
        if chv = 1
        {
            chimgw += 1
            if chimgw > 200
                chimgw = 200
            chimgh += 1
            if chimgh > 200
                chimgh = 200
            IniWrite, %chimgw%, %ScriptName%.ini , Crochair Picture, PictureWidth
            IniWrite, %chimgh%, %ScriptName%.ini , Crochair Picture, PictureHeight
            Gui, Destroy
            ft = 1
            gosub, showch
        }
    }
return

End:: ;-------------Reload the script
    {
        Gui, Destroy
        Reload
    }
return ;-------------------------------

Delete:: ;-------------Exit the script.
    {
        Gui, Destroy
        Sleep, 200
        ExitApp
    }
return ;-------------------------------