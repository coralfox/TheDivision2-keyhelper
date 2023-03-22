#Persistent
#SingleInstance Force
; #Warn ; 启用警告以帮助检测错误
SetWorkingDir %A_ScriptDir%

Menu, Tray, Icon, Shell32.dll, 174

Window := {Width: 590, Height: 390, Title: "Menu Interface"}  ; Version: "0.2"
Navigation := {Label: ["General", "Advanced", "Language", "Theme", "---", "Help", "About"]}

Gui +LastFound -Resize +HwndhGui
Gui Color, FFFFFF
Gui Add, Picture, x0 y0 w1699 h1 +0x4E +HwndhDividerLine1  ; 分割线 从左到右【顶部菜单栏】

Gui Add, Tab2, x-666 y10 w1699 h334 -Wrap +Theme Buttons HwndTabControl
Gui Tab

Gui Add, Picture, % "x" -9999 " y" -9999 " w" 96 " h" 32 " vpMenuHover +0x4E +HwndhMenuHover" ; 菜单悬停
Gui Add, Picture, % "x" 0 " y" 18 " w" 4 " h" 32 " vpMenuSelect +0x4E +HwndhMenuSelect" ; 菜单选择

Gui Add, Picture, x96 y0 w1 h1340 +0x4E +HwndhDividerLine3  ; 分割线 从上到下
Gui Add, Progress, x0 y0 w96 h799 +0x4000000 +E0x4 Disabled BackgroundF7F7F7 ; 左侧常态背景色

; 左侧Tab标题的 字体大小 和 字体加粗
Gui Font, Bold c808080 Q5, Microsoft YaHei UI
Loop % Navigation.Label.Length() {
	GuiControl,, %TabControl%, % Navigation.Label[A_Index] "|"
	If (Navigation.Label[A_Index] = "---")
		Continue

	Gui Add, Text, % "x0 y" (32*A_Index)-24 " h32 w96 Center +0x200 BackgroundTrans gMenuClick vMenuItem" . A_Index, % Navigation.Label[A_Index]
}
Gui Font

; 底部的按钮和背景【可删除，现代界面不需要确定取消按钮。徒增步骤而已，g标签实时存值替代】
Global HtmlButton1, HtmlButton2

NewButton1 := New HtmlButton("HtmlButton1", "OK", "Button1_", (Window.Width-176)-20, (Window.Height-24)-14)
NewButton2 := New HtmlButton("HtmlButton2", "Cancel", "Button1_", (Window.Width-80)-20, (Window.Height-24)-14)

; Gui Add, Button, % "x" (Window.Width-176)-20 " y" (Window.Height-24)-14 " w78 h26 vButtonOK", OK
; Gui Add, Button, % "x" (Window.Width-80)-20 " y" (Window.Height-24)-14 " w78 h26 vButtonCancel", Cancel

Gui Add, Picture, x96 y340 w1001 h1 +0x4E +HwndhDividerLine4  ; 分割线 从左到右【底】
Gui Add, Progress, x0 y340 w1502 h149 +0x4000000 +E0x4 Disabled BackgroundFBFBFB


; 右侧顶部Tab标题的字体大小【可删除】
Gui Font, s15 Q5 c000000, Segoe UI
Gui Add, Text, % "x" 117 " y" 4 " w" (Window.Width-110)-16 " h32 +0x200 vPageTitle"
Gui Add, Picture, % "x" 110 " y" 38 " w" (Window.Width-110)-16 " h1 +0x4E +HwndhDividerLine2"  ; 分割线
Gui Font

Gui Tab, 1
Gui Font, W560, Segoe UI
Gui Add, Text, Section x116 y50 BackgroundWhite, Select your primary button
Gui Font
Gui Add, DropDownList, xs+10 w80 vPrimaryButton Choose1, Left||Right
Gui Font, W560, Segoe UI
Gui Add, Text, xs yp+40, Cursor Speed
Gui Font
Gui Add, Slider, vMySlider NoTicks, 50
Gui Font, W560, Segoe UI
Gui Add, Text, yp+40 , Roll the mouse wheel to scrol
Gui Font
Gui Add, Radio, xs+10 yp+22 h14 Checked, Multiple lines at a time
Gui Add, Radio, xs+10 y+8 h14, On screen at a time
Gui Font, W560, Segoe UI
Gui Add, Checkbox, xs yp+36 h14, Mouse Button Tips
Gui Font

Gui Tab, 2
Gui Add, ListView, % "x" 116 " y" 50 " w" (Window.Width-110)-30, Col1|Col2
LV_Add("", "ListView", "Example"), LV_ModifyCol()

Gui Tab, 3
Gui Add, MonthCal, % "x" 116 " y" 50

Gui Tab, 4
Gui Add, DateTime, % "x" 116 " y" 50, LongDate

Gui Tab, 5  ; Skipped

Gui Tab, 6
Gui Add, GroupBox, % "x" 116 " y" 50 " w" (Window.Width-110)-30, GroupBox

Gui Tab, 7
Gui Add, TreeView, % "x" 116 " y" 50 " w220 h148"
P1 := TV_Add("First parent"), P1C1 := TV_Add("Parent 1's first child", P1)

Gui Show, % " w" Window.Width " h" Window.Height, % Window.Title

SetPixelColor("E9E9E9", hMenuHover)
SetPixelColor("0078D7", hMenuSelect)
Loop 4
    SetPixelColor("D8D8D8", hDividerLine%A_Index%)
SelectMenu("MenuItem1")
OnMessage(0x200, "WM_MOUSEMOVE")
EmptyMem()  ; 清理进程占用内存
Return


MenuClick:
	SelectMenu(A_GuiControl)
Return

GuiClose:
	ExitApp

; HtmlButton事件处理
Button1_OnClick() {
	ExitApp
}

SelectMenu(Control) {
	Global
    Loop % Navigation.Label.Length()
        SetControlColor("808080", Navigation.Label[A_Index])  ; 左侧未选中按钮的颜色

	CurrentMenu := Control
	, SetControlColor("237FFF", Control)  ; 左侧选中按钮的颜色
	GuiControl, Move, pMenuSelect, % "x" 0 " y" (32*SubStr(Control, 9, 2))-20 " w" 4 " h" 24
	GuiControl, Choose, %TabControl%, % SubStr(Control, 9, 2)
	GuiControl,, PageTitle, % Navigation.Label[SubStr(Control, 9, 2)]
}

WM_MOUSEMOVE(wParam, lParam, Msg, Hwnd) {
	Global hMenuSelect
    Static hover := {}

    if (wParam = "timer") {
        MouseGetPos,,,, hControl, 2
        if (hControl != hwnd) && (hControl != hMenuSelect) {
            SetTimer,, Delete
            GuiControl, Move, pMenuHover, % "x" -9999 " y" -9999
            OnMessage(0x200, "WM_MOUSEMOVE")
            , hover[hwnd] := False
        }
     } else {
        if (InStr(A_GuiControl, "MenuItem") = True) {
            GuiControl, Move, pMenuHover, % "x" 0 " y" (32*SubStr(A_GuiControl, 9, 2))-24
            GuiControl, MoveDraw, pMenuHover
            hover[hwnd] := True
            , OnMessage(0x200, "WM_MOUSEMOVE", 0)
            , timer := Func(A_ThisFunc).Bind("timer", "", "", hwnd)
            SetTimer % timer, 15
        } else if (InStr(A_GuiControl, "MenuItem") = False)
            GuiControl, Move, pMenuHover, % "x" -9999 " y" -9999
    }
}

SetControlColor(Color, Control) {
	GuiControl, % "+c" Color, % Control

	; 由于 Tab2 控件的重绘问题而需要
	GuiControlGet, ControlText,, % Control
	GuiControlGet, ControlHandle, Hwnd, % Control
	DllCall("SetWindowText", "Ptr", ControlHandle, "Str", ControlText)
    GuiControl, MoveDraw, % Control
}

SetPixelColor(Color, Handle) {
	VarSetCapacity(BMBITS, 4, 0), Numput("0x" . Color, &BMBITS, 0, "UInt")
	, hBM := DllCall("Gdi32.dll\CreateBitmap", "Int", 1, "Int", 1, "UInt", 1, "UInt", 24, "Ptr", 0)
	, hBM := DllCall("User32.dll\CopyImage", "Ptr", hBM, "UInt", 0, "Int", 0, "Int", 0, "UInt", 0x2008)
	, DllCall("Gdi32.dll\SetBitmapBits", "Ptr", hBM, "UInt", 3, "Ptr", &BMBITS)
	return DllCall("User32.dll\SendMessage", "Ptr", Handle, "UInt", 0x172, "Ptr", 0, "Ptr", hBM)
}

; 用网页按钮样式来代替标准按钮，兼容到XP系统。如果Gui开启的-DPIScale，需要把HtmlButton最后一个参数"DPIScale"设置成非0即可修正匹配。
Class HtmlButton
{
	__New(ButtonGlobalVar, ButtonName, gLabelFunc, OptionsOrX:="", y:="", w:=78 , h:=26, GuiLabel:="", TextColor:="001C30", DPIScale:=False) {
		Static Count:=0
        f := A_Temp "\" A_TickCount "-tmp" ++Count ".DELETEME.html"

		Html_Str =
		(
			<!DOCTYPE html><html><head>
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<style>body {overflow-x:hidden;overflow-y:hidden;}
				button { color: #%TextColor%;
					background-color: #F4F4F4;
					border-radius:2px;
					border: 1px solid #A7A7A7;
					cursor: pointer; }
				button:hover {background-color: #BEE7FD;}
			</style></head><body><body oncontextmenu="return false">
			<button id="MyButton%Count%" style="position:absolute;left:0px;top:0px;width:%w%px;height:%h%px;font-size:12px;font-family:'Microsoft YaHei UI';">%ButtonName%</button></body></html>
		)
        if (OptionsOrX!="")
            if OptionsOrX is Number
                x := "x" OptionsOrX
             else
                Options := " " OptionsOrX
        (y != "" && y := " y" y)
		Gui, %GuiLabel%Add, ActiveX, %  x . y . " w" w " h" h " v" ButtonGlobalVar . Options, Shell.Explorer
		FileAppend, % Html_Str, % f
		%ButtonGlobalVar%.Navigate("file://" . f)
        , this.Html_Str := Html_Str
        , this.ButtonName := ButtonName
        , this.gLabelFunc := gLabelFunc
        , this.Count := Count 
		, %ButtonGlobalVar%.silent := True
        , this.ConnectEvents(ButtonGlobalVar, f)
        if !DPIScale
            %ButtonGlobalVar%.ExecWB(63, 1, Round((A_ScreenDPI/96*100)*A_ScreenDPI/96) ) ; Fix ActiveX control DPI scaling
	}

    Text(ButtonGlobalVar, ButtonText) {
        Html_Str := StrReplace(this.Html_Str, ">" this.ButtonName "</bu", ">" ButtonText "</bu")
        FileAppend, % Html_Str, % f := A_Temp "\" A_TickCount "-tmp.DELETEME.html"
		%ButtonGlobalVar%.Navigate("file://" . f)
        , this.ConnectEvents(ButtonGlobalVar, f)
    }

    ConnectEvents(ButtonGlobalVar, f) {
		While %ButtonGlobalVar%.readystate != 4 or %ButtonGlobalVar%.busy
			Sleep 5
        this.MyButton := %ButtonGlobalVar%.document.getElementById("MyButton" this.Count)
		, ComObjConnect(this.MyButton, this.gLabelFunc)
		FileDelete, % f
	}
}

; 清理进程占用内存
EmptyMem(PID="", Priority:=""){
	if Priority is Number
	{   ; 实现异步延时清理进程占用内存
		AsyncEmpty%A_ScriptHwnd%:=Func(A_ThisFunc).Bind(PID, "Asynchronous")
		SetTimer % AsyncEmpty%A_ScriptHwnd%, % "-" Priority
		Return
	}
	pid:=!PID ? DllCall("GetCurrentProcessId") : pid
	, h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
	, DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
	, DllCall("CloseHandle", "Int", h)
}