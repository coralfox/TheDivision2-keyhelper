;***************************************************************************************************
;***************************************************************************************************
;***************************************************************************************************
; #Include <My Altered Gdip Lib>  ;<------       Replace with your copy of GDIP
#Include Gdip.ahk
/*
;***************************************************************************************************
;***************************************************************************************************
;***************************************************************************************************

;##################################################################################################################################################
;##################################################################################################################################################

; Written By: Hellbent aka CivReborn (https://www.youtube.com/user/CivReborn)
; Date Started: March 1st, 2019
; Date of Last Edit: July 19th, 2021
; Current Version: v0.1.10 Early Alpha 
; Credits: Speed Master , 

; Updates: v0.1.10 - July 19th, 2021
;---------------------------------------------------------------------------------------------------------------
; Can now add pictures to a bitmap.
; Can load a bitmap that has a picture
; Can export code to add a picture to a bitmap.
; Export code condenced ( Brush , Shape , Delete ) 
; Can crop or Resize Images.
; Can add text to images.

; Updates: v0.1.8 - March 29th, 2020
;---------------------------------------------------------------------------------------------------------------
; Element Listbox now shows if a element has a note attached to it.
; Gdip library removed from the script, user must now #Include it.

; Updates: v0.1.7 - June 6th, 2019
;---------------------------------------------------------------------------------------------------------------
; Fixed major memory leak
; Added Refactored code submitted by - Speed Master
; Added Extra Hotkeys Submitted by - Speed Master
; Added Save progress bar to Save tab, can now see the save progress.
; Removed +AlwaysOnTop Option.
; Added CREDITS DDL to tab 6.
; Other small changes.

; Updates: v0.1.5
;---------------------------------------------------------------------------------------------------------------
; Fill_poygon Added.
; Draw_Lines Added.
; Element Control Panel Update.
; Can now dump bitmap functions directly into clipboard.
; Can now clone a element.
; Smoothing and a lock added to bitmap control panel.
; Text now uses brushes.
; Defaults can now be set and saved to file
; Can now use cursor to set 2 Gradient Brush positions
; Can now use element control panel to adjust all 4 points of a bezier line
; Arrow keys can be used while setting polygon,lines points, gradient points.
; Other minor changes

; Updates: v0.1.4
;---------------------------------------------------------------------------------------------------------------
; Minor Bug fixes

; Updates: v0.1.3
;---------------------------------------------------------------------------------------------------------------
; New control panel to adjust bitmap settings
; You can now zoom in or out of a bitmap.
; You can now adjust the size of a bitmap after it has been created.

; Updates: v0.1.2
;---------------------------------------------------------------------------------------------------------------
; Bitmaps can now be reloaded into the editor later.
; A sound will play and a traytip will pop up when a bitmap is finished saving (Large bitmaps can take 1 min or more to save)
; Multiple copies of the same bitmap can be running at the same time
; Bitmap saves can now be named.
; Bitmap save files can be deleted from within the editor. (Data File and Function File)
; Fixed the output code so that Smoothing is set for the Graphics and not the bitmap (oops)
; Notes will now show up in output code (Functions)
; There is now a master folder that contains 3 additional folders for the saved bitmaps and pngs
; Hidding / UnHidding a element will reselect that element (List was going to the top if the list was longer than dispaly Listbox)

;Version v0.1.10 Paste:								   ;July 19th, 2021
;Version v0.1.8 Paste: https://pastebin.com/y4nMyj7z   ;March 29th, 2020
;Version v0.1.7 Paste: https://pastebin.com/cdaTYN5U   ;June 6th, 2019
;Version v0.1.3 Paste: https://pastebin.com/pscPkD7g   ;March 9th, 2019
;Version v0.1.2 Paste: https://pastebin.com/QMYpJaxY   ;March 8th, 2019
;Version v0.1.1 Paste: https://pastebin.com/pPBEphce
;Version v0.0.6 Paste: https://pastebin.com/A4h2fdEy
*/
#SingleInstance, Force
SetBatchLines,-1
SetTitleMatchMode, 3
#NoEnv
IfNotExist,%A_ScriptDir%\HB Bitmap Maker Folder
{
	FileCreateDir,%A_ScriptDir%\HB Bitmap Maker Folder
	FileCreateDir,%A_ScriptDir%\HB Bitmap Maker Folder\Saved PNGs
	FileCreateDir,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Data
	FileCreateDir,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions
}
SetWorkingDir,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Data
global Saved_Bitmap_List
Load_Saved_Bitmap_List()
;~ global Default_Values:={Default_Bitmap_X:320,Default_Bitmap_Y:30,Default_Bitmap_W:200,Default_Bitmap_H:200,Default_Bitmap_Smoothing:4,Default_Element_W:50,Default_Element_H:50,Default_Element_X:10,Default_Element_Y:10,Default_Element_X2:20,Default_Element_Y2:20,Default_Element_X3:30,Default_Element_Y3:30,Default_Element_X4:40,Default_Element_Y4:40,Default_Element_Alpha:"FF",Default_Element_Color:"FF0000",Default_Element_Alpha2:"FF",Default_Element_Color2:"00FF00",Default_Element_Hatch:39,Default_Element_Radius:5,Default_Element_Thickness:3,Default_Element_Start_Angle:0,Default_Element_End_Angle:90,Default_Element_Text:"Hellbent",Default_Element_Font:"Segoe UI",Default_Element_Options:"s16 Center vCenter Bold Underline",Default_Element_Hidden:0,Default_Element_Brush_Type:1,Default_Element_Polygon_List:"100,50|150,100|50,100|",Default_Element_Lines_List:"100,50|150,100|50,100|100,50|",Default_Element_Line_Brush_X1:0,Default_Element_Line_Brush_Y1:0,Default_Element_Line_Brush_X2:100,Default_Element_Line_Brush_Y2:100,Default_Element_Line_Brush_Wrap_Mode:1,Default_Element_Grade_Brush_X:0,Default_Element_Grade_Brush_Y:0,Default_Element_Grade_Brush_W:100,Default_Element_Grade_Brush_H:100,Default_Element_Grade_Brush_Wrap_Mode:1,Default_Element_Grade_Brush_LinearGradientMode:1}
global Default_Values:={Default_Bitmap_X:320,Default_Bitmap_Y:30,Default_Bitmap_W:200,Default_Bitmap_H:200,Default_Bitmap_Smoothing:4,Default_Element_W:50,Default_Element_H:50,Default_Element_X:10,Default_Element_Y:10,Default_Element_X2:20,Default_Element_Y2:20,Default_Element_X3:30,Default_Element_Y3:30,Default_Element_X4:40,Default_Element_Y4:40,Default_Element_Alpha:"FF",Default_Element_Color:"FF0000",Default_Element_Alpha2:"FF",Default_Element_Color2:"00FF00",Default_Element_Hatch:39,Default_Element_Radius:5,Default_Element_Thickness:3,Default_Element_Start_Angle:0,Default_Element_End_Angle:90,Default_Element_Text:"Hellbent",Default_Element_Font:"Segoe UI",Default_Element_Options:"s16 Center vCenter Bold Underline",Default_Element_Hidden:0,Default_Element_Brush_Type:1,Default_Element_Polygon_List:"100,50|150,100|50,100|",Default_Element_Lines_List:"100,50|150,100|50,100|100,50|",Default_Element_Line_Brush_X1:0,Default_Element_Line_Brush_Y1:0,Default_Element_Line_Brush_X2:100,Default_Element_Line_Brush_Y2:100,Default_Element_Line_Brush_Wrap_Mode:1,Default_Element_Grade_Brush_X:0,Default_Element_Grade_Brush_Y:0,Default_Element_Grade_Brush_W:100,Default_Element_Grade_Brush_H:100,Default_Element_Grade_Brush_Wrap_Mode:1,Default_Element_Grade_Brush_LinearGradientMode:1}
IfNotExist, %A_ScriptDir%\HB Bitmap Maker Folder\Default Values.ini
{
	for k, v in Default_Values
		IniWrite,% v,%A_ScriptDir%\HB Bitmap Maker Folder\Default Values.ini,Defaults,% k
}
for k, v in Default_Values	{
	IniRead,tttt,%A_ScriptDir%\HB Bitmap Maker Folder\Default Values.ini,Defaults,% k
	Default_Values[k]:=tttt
}
global Default_Bitmap_X,Default_Bitmap_Y,Default_Bitmap_W,Default_Bitmap_H,Default_Bitmap_Smoothing,Default_Element_W,Default_Element_H,Default_Element_X,Default_Element_Y,Default_Element_X2,Default_Element_Y2,Default_Element_X3,Default_Element_Y3,Default_Element_X4,Default_Element_Y4,Default_Element_Alpha,Default_Element_Color,Default_Element_Alpha2,Default_Element_Color2,Default_Element_Hatch,Default_Element_Radius,Default_Element_Thickness,Default_Element_Start_Angle,Default_Element_End_Angle,Default_Element_Text,Default_Element_Font,Default_Element_Options,Default_Element_Hidden,Default_Element_Brush_Type,Default_Element_Polygon_List,Default_Element_Lines_List,Default_Element_Line_Brush_X1,Default_Element_Line_Brush_Y1,Default_Element_Line_Brush_X2,Default_Element_Line_Brush_Y2,Default_Element_Line_Brush_Wrap_Mode,Default_Element_Grade_Brush_X,Default_Element_Grade_Brush_Y,Default_Element_Grade_Brush_W,Default_Element_Grade_Brush_H,Default_Element_Grade_Brush_Wrap_Mode,Default_Element_Grade_Brush_LinearGradientMode
;~ global Element_Key_List:= ["Type","X","Y","W","H","X2","Y2","X3","Y3","X4","Y4","Alpha","Color","Alpha2","Color2","Thickness","Radius","Hatch","Notes","Text","Options","Font","Brush_Type","Hidden","Line_Brush_X1","Line_Brush_Y1","Line_Brush_X2","Line_Brush_Y2","Line_Brush_Wrap_Mode","Grade_Brush_X","Grade_Brush_Y","Grade_Brush_W","Grade_Brush_H","Grade_Brush_LinearGradientMode","Grade_Brush_Wrap_Mode","Start_Angle","End_Angle","Polygon_list","Lines_List"]
global Element_Key_List:= ["SourceWidth","SourceHeight","SourceX","SourceY","SourceW","SourceH","Path","Type","X","Y","W","H","X2","Y2","X3","Y3","X4","Y4","Alpha","Color","Alpha2","Color2","Thickness","Radius","Hatch","Notes","Text","Options","Font","Brush_Type","Hidden","Line_Brush_X1","Line_Brush_Y1","Line_Brush_X2","Line_Brush_Y2","Line_Brush_Wrap_Mode","Grade_Brush_X","Grade_Brush_Y","Grade_Brush_W","Grade_Brush_H","Grade_Brush_LinearGradientMode","Grade_Brush_Wrap_Mode","Start_Angle","End_Angle","Polygon_list","Lines_List"]
global Windows:= New Main_Window()
global Selected_New_Element:="Fill_Rectangle",BitmapBackgroundColor

global Current_Elements,Active_Element
global New_Bitmap_Name,New_Bitmap_X,New_Bitmap_Y,New_Bitmap_W,New_Bitmap_H,New_Bitmap_Smoothing,New_Bitmap_Raster
global Bitmap_Array:=[]
global Active_Bitmaps_List
global Active_Bitmap:=1
global Element_Type_List:="Fill_Rectangle||Fill_Rounded_Rectangle|Fill_Circle|Fill_Polygon|Fill_Pie|Draw_Rectangle|Draw_Rounded_Rectangle|Draw_Circle|Draw_Line|Draw_Lines|Draw_Bezier|Draw_Arc|Draw_Pie|Text|Add_Picture" ;|Fill_Region|Fill_Path

;�����Ǻ����õĴ���--------------------------------------------------
global ����_Element_Type_List:=[]
����_Element_Type_List[1]:={"����-���":"Fill_Rectangle"
	, "Բ�Ǿ���-���":"Fill_Rounded_Rectangle"
	, "Բ-���":"Fill_Circle"
	, "�����-���":"Fill_Polygon"
	, "����-���":"Fill_Pie"
	, "����":"Draw_Rectangle"
	, "Բ�Ǿ���":"Draw_Rounded_Rectangle"
	, "Բ":"Draw_Circle"
	, "��":"Draw_Line"
	, "���߶�":"Draw_Lines"
	, "����":"Draw_Bezier"
	, "����":"Draw_Arc"
	, "����":"Draw_Pie"
	, "����":"Text"
, "����ͼƬ":"Add_Picture"}
Element_Type_List:=""
For k,v in ����_Element_Type_List[1]
{
	����_Element_Type_List[2, v] := k
	Element_Type_List .=k (A_Index=1?"||":"|")
}
;--------------------------------------------------

global Bitmap_Name_Counter:=1
global Auto_Draw:=1
global Element_Window:=New Element_Windows()
global Constructor:=New Element_Window_Constructor()
global Brush_Type:=1
global Element_Read_Keys
global Name_To_Save_Files
global Unlock_Delete_Button:=0
global Bitmap_Info_Control_Panel:=New Bitmap_Info_Control_Panel()
global Save_Progress:=0
global Loading := 0
return
GuiClose:
	;~ GuiContextMenu:
ExitApp

Load_Saved_Bitmap_List(){
	Saved_Bitmap_List:=""
	;~ Loop, %A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Data\*.*
	Loop, %A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Data\*.ini
	{
		tep:=StrSplit(A_LoopFileName,".")
		if(A_Index=1)
			Saved_Bitmap_List.=tep[1] "||"
		else
			Saved_Bitmap_List.=tep[1] "|"
	}
	GuiControl,7:,List_Of_Existing_Saves,|
	GuiControl,7:,List_Of_Existing_Saves,% Saved_Bitmap_List
	GuiControl,6:,List_Of_Saved_Bitmaps,|
	GuiControl,6:,List_Of_Saved_Bitmaps,% Saved_Bitmap_List
}

Clip_Bitmap(){
	GuiControlGet,List_Of_Saved_Bitmaps,6:,List_Of_Saved_Bitmaps
	FileRead,Clipboard,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%List_Of_Saved_Bitmaps%.txt
	Loop 2
		SoundBeep,500
	TrayTip,,Done
}

Set_Auto_Draw(){
	Auto_Draw:=!Auto_Draw
}

Test_Load(){
	GuiControlGet,List_Of_Saved_Bitmaps,6:,List_Of_Saved_Bitmaps
	if(!List_Of_Saved_Bitmaps)
		return
	lBM:={}
	IniRead,tttt,%List_Of_Saved_Bitmaps%.ini,Bitmap Properties,X
	lBM.X:=tttt
	IniRead,tttt,%List_Of_Saved_Bitmaps%.ini,Bitmap Properties,Y
	lBM.Y:=tttt
	IniRead,tttt,%List_Of_Saved_Bitmaps%.ini,Bitmap Properties,W
	lBM.W:=tttt
	IniRead,tttt,%List_Of_Saved_Bitmaps%.ini,Bitmap Properties,H
	lBM.H:=tttt
	IniRead,tttt,%List_Of_Saved_Bitmaps%.ini,Bitmap Properties,Name
	lBM.Name:=tttt
	IniRead,tttt,%List_Of_Saved_Bitmaps%.ini,Bitmap Properties,Smoothing
	lBM.Smoothing:=tttt
	IniRead,tttt,%List_Of_Saved_Bitmaps%.ini,Bitmap Properties,Number Of Elements
	lBM.Number_Of_Elements:=tttt
	c_ele:=1
	lBM.temp_Element:=[]
	gui,1:+OwnDialogs
	Loop,% lBM.Number_Of_Elements
	{
		lBM.temp_Element[A_Index]:={}
		Loop,% Element_Key_List.Length()	{
			IniRead,tttt,%List_Of_Saved_Bitmaps%.ini,Bitmap Element %c_ele%,% Element_Key_List[A_Index]
			LBM.temp_Element[c_ele][Element_Key_List[A_Index]]:=tttt
		}
		c_ele++
	}
	Load_Bitmap(lbm)
}

Save_Code(){
	Gui,7:Submit,NoHide
	if(Bitmap_Array[Active_Bitmap]&&Name_To_Save_Files){
		Bitmap_Array[Active_Bitmap].Create_BitMap(1)
		loop, % Bitmap_Array[Active_Bitmap].Bitmap_Elements.Length(){
			Bitmap_Array[Active_Bitmap][Bitmap_Array[Active_Bitmap].Bitmap_Elements[A_Index].Type](A_Index,1)
		}
		temp:="`n`tGdip_DeleteGraphics( G )`n`treturn pBitmap`n}"
		FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
		;Save Bitmap data file
		;------------------------------------------------------------
		FileDelete,%Name_To_Save_Files%.ini
		IniWrite,% Bitmap_Array[Active_Bitmap].X,%Name_To_Save_Files%.ini,Bitmap Properties,X
		IniWrite,% Bitmap_Array[Active_Bitmap].Y,%Name_To_Save_Files%.ini,Bitmap Properties,Y
		IniWrite,% Bitmap_Array[Active_Bitmap].W,%Name_To_Save_Files%.ini,Bitmap Properties,W
		IniWrite,% Bitmap_Array[Active_Bitmap].H,%Name_To_Save_Files%.ini,Bitmap Properties,H
		IniWrite,% Bitmap_Array[Active_Bitmap].Name,%Name_To_Save_Files%.ini,Bitmap Properties,Name
		IniWrite,% Bitmap_Array[Active_Bitmap].Smoothing,%Name_To_Save_Files%.ini,Bitmap Properties,Smoothing
		IniWrite,% Bitmap_Array[Active_Bitmap].Bitmap_Elements.Length(),%Name_To_Save_Files%.ini,Bitmap Properties,Number Of Elements
		c_ele:=1
		Loop,% Bitmap_Array[Active_Bitmap].Bitmap_Elements.Length()
		{
			For, k , v in Bitmap_Array[Active_Bitmap].Bitmap_Elements[A_Index]
				IniWrite,% v,%Name_To_Save_Files%.ini,Bitmap Element %c_ele%,% k
			c_ele++

			GuiControl,% "7: +Range0-" Bitmap_Array[Active_Bitmap].Bitmap_Elements.Length() ,Save_Progress
			GuiControl,7:,Save_Progress,% c_ele
		}
	}
	Load_Saved_Bitmap_List()
	loop 2
		SoundBeep,500
	TrayTip,,Done
}

Save_Png(){
	Gui,7:Submit,NoHide
	if(Bitmap_Array[Active_Bitmap]&&Name_To_Save_Files)
		Gdip_SaveBitmapToFile( Bitmap_Array[Active_Bitmap].Bitmap , A_ScriptDir "\HB Bitmap Maker Folder\Saved PNGs\" Name_To_Save_Files ".PNG" , 100 )
	SoundBeep,700
	TrayTip,,Done
}

Save_Defaults(){
	For k, v in Default_Values
		IniWrite,% v,%A_ScriptDir%\HB Bitmap Maker Folder\Default Values.ini,Defaults,% k
	Loop 2
		SoundBeep,600
	TrayTip,,Done
}

Add_New_Element( path := "" ){
	local out := ""
	GuiControlGet,Selected_New_Element,1:,Selected_New_Element

	;�������ӵĴ���--------------------------------------------
	Selected_New_Element := ����_Element_Type_List[1, Selected_New_Element]
	;----------------------------------------------------------

	if( Selected_New_Element = "Add_Picture" ){
		Gui, 1:+OwnDialogs
		;~ ToolTip, % "here`n" path
		if( !Loading ){

			FileSelectFile, out ,, c:\Pictures\*.Png
		}else{
			;out := Bitmap_Array[Active_Bitmap].Path
			;~ ToolTip, % "here`n" path
			out := path
		}
		if( !Out )
			return
	}
	Bitmap_Array[Active_Bitmap].BitMap_Elements.Push(New Element(Selected_New_Element , out ))

	Update_Element_List()
	Active_Element:=Bitmap_Array[Active_Bitmap].BitMap_Elements.Length()

	if(loading){
		Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element ].PicBitmap := Gdip_CreateBitmapFromFile( Path )
	}
	;~ ToolTip, % "here`nPath: " path "`nPath2: " Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element ].PicBitmap
	Element_Window[Selected_New_Element](Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element])
	GuiControl,8:Choose,Current_Elements,% Active_Element
	if(Auto_Draw){
		SetTimer,Force_Draw,-10
	}
}

Clone_Element(){
	if(Bitmap_Array[Active_Bitmap].BitMap_Elements.Length()&&Active_Element){
		Bitmap_Array[Active_Bitmap].BitMap_Elements.Push(New Element(Selected_New_Element))
		For,k,v in Element_Key_List
			Bitmap_Array[Active_Bitmap].BitMap_Elements[Bitmap_Array[Active_Bitmap].BitMap_Elements.Length()][v]:=Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element][v]
		Active_Element:=Bitmap_Array[Active_Bitmap].BitMap_Elements.Length()
		Element_Window[Selected_New_Element](Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element])
		GuiControl,8:Choose,Current_Elements,% Active_Element
		Set_Bitmap_Controls()
		Update_Element_List()
		GuiControl,8:Choose,Current_Elements,% Active_Element
		if(Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Brush_Type=3){
			GuiControl,13:,Line,1
		}
		if(Auto_Draw){
			SetTimer,Force_Draw,-10
		}
	}
}

Switch_Active_Element(){
	Gui,8:Submit,NoHide
	;123456
	Active_Element:=Current_Elements
	Set_Bitmap_Controls()
	Element_Window[Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Type](Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element])
	;~ Set_Bitmap_Controls()
}

Update_Element_List(){
	Element_List:=""

	;�����Ĵ���-------------------------------------------------------------
	Loop,% Bitmap_Array[Active_Bitmap].BitMap_Elements.Length(){
		if(Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Hidden=1&&Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Notes)
			Element_List.="( N H ) " ����_Element_Type_List[2, Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Type] "|"
		else if(Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Notes)
			Element_List.="( N ) " ����_Element_Type_List[2, Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Type] "|"
		else if(Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Hidden=1)
			Element_List.="( H ) " ����_Element_Type_List[2, Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Type] "|"
		else
			Element_List.=����_Element_Type_List[2, Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Type] "|"
	}
	;----------------------------------------------------------------------

	; Loop,% Bitmap_Array[Active_Bitmap].BitMap_Elements.Length(){
	; if(Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Hidden=1&&Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Notes)
	; Element_List.="( N H )  " Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Type  "|"
	; else if(Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Notes)
	; Element_List.="( N )  " Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Type  "|"
	; else if(Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Hidden=1)
	; Element_List.="( H )  " Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Type  "|"
	; else
	; Element_List.=Bitmap_Array[Active_Bitmap].BitMap_Elements[A_Index].Type  "|"
	; }

	GuiControl,8:,Current_Elements,|
	GuiControl,8:,Current_Elements,% Element_List
}

ReOrder_Elements(){
	if(Active_Element){
		if(A_GuiControl="ReOrder_Up"&&Active_Element!=1){
			tempElement:=Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element]
			Bitmap_Array[Active_Bitmap].BitMap_Elements.RemoveAt(Active_Element)
			Bitmap_Array[Active_Bitmap].BitMap_Elements.InsertAt(Active_Element-1,tempElement)
			Update_Element_List()
			GuiControl,8:Choose,Current_Elements,% Active_Element-1
			Switch_Active_Element()

		}else if(A_GuiControl="ReOrder_Down"&&Active_Element!=Bitmap_Array[Active_Bitmap].BitMap_Elements.Length()){
			tempElement:=Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element]
			Bitmap_Array[Active_Bitmap].BitMap_Elements.RemoveAt(Active_Element)
			Bitmap_Array[Active_Bitmap].BitMap_Elements.InsertAt(Active_Element+1,tempElement)
			Update_Element_List()
			GuiControl,8:Choose,Current_Elements,% Active_Element+1
			Switch_Active_Element()
		}
	}
	if(Auto_Draw){
		SetTimer,Force_Draw,-10
	}
}

Remove_Element(){
	if(Active_Element){
		Bitmap_Array[Active_Bitmap].BitMap_Elements.RemoveAt(Active_Element)
		Update_Element_List()
		if(Bitmap_Array[Active_Bitmap].BitMap_Elements.Length()){
			(Active_Element != 1) ? (Active_Element-=1)
			GuiControl,8:Choose,Current_Elements,% Active_Element
			Element_Window[Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Type](Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element])
		}else	{
			Active_Element:=""
			Gui,13:Destroy
			Gui,14:Destroy
			Gui,15:Destroy
		}
	}
	if(Auto_Draw){
		SetTimer,Force_Draw,-10
	}
}

Load_Bitmap(lBM){
	Loading := 1
	Bitmap_Name_Counter++
	Gui,5:Submit,NoHide
	Bitmap_Array.Push(New Bitmap_Class(lBM.X,lBM.Y,lBM.W,lBM.H,lBM.Smoothing,New_Bitmap_Name,New_Bitmap_Raster))
	GuiControl,5:,New_Bitmap_Name,% Bitmap_Name_Counter
	Active_Bitmap:=Bitmap_Array.Length()
	Add_Bitmaps_To_Bitmaps_List()
	GuiControl,1:Choose,Active_Bitmaps_List,% Active_Bitmap
	Loop,% Bitmap_Array.Length()
		Bitmap_Array[A_Index].move()
	if(Bitmap_Array.Length()=1){
		GuiControl,1:,Selected_New_Element,|
		GuiControl,1:,Selected_New_Element,% Element_Type_List
	}
	Loop, % lbm.temp_Element.Length()	{
		;~ SoundBeep, 500
		;~ ToolTip, % lbm.temp_Element[A_Index].Path
		Add_New_Element(lbm.temp_Element[A_Index].Path)
		indext := A_Index
		For k, v in lbm.temp_Element[A_Index]
			Bitmap_Array[Bitmap_Array.Length()].BitMap_Elements[indext][k]:=v
	}
	GuiControl,7:,Display_Current_Bitmap_Name ,`n�Ѿ������λͼ : %Active_Bitmap% ;`nActive Bitmap : %Active_Bitmap%
	Set_Bitmap_Controls()
	Update_Element_List()
	Loading := 0
}

Set_Bitmap_Controls(){
	Bitmap_Info_Control_Panel.Create_Bitmap_Control_Panel()
	Bitmap_Info_Control_Panel.Bitmap_Position_Controls()
	Bitmap_Info_Control_Panel.Bitmap_Position_Details(Bitmap_Array[Active_Bitmap])
	Bitmap_Info_Control_Panel.Bitmap_Zoom(Bitmap_Array[Active_Bitmap])
	Bitmap_Info_Control_Panel.Bitmap_Lock()
	Bitmap_Info_Control_Panel.Bitmap_Smoothing()
	Bitmap_Info_Control_Panel.Show_Bitmap_Control_Panel()
}

Add_New_Bitmap(){
	Bitmap_Name_Counter++
	Gui,5:Submit,NoHide
	Bitmap_Array.Push(New Bitmap_Class(New_Bitmap_X,New_Bitmap_Y,New_Bitmap_W,New_Bitmap_H,New_Bitmap_Smoothing,New_Bitmap_Name,New_Bitmap_Raster))
	GuiControl,5:,New_Bitmap_Name,% Bitmap_Name_Counter
	if(!Active_Bitmap)
		Active_Bitmap:=1
	Add_Bitmaps_To_Bitmaps_List()
	GuiControl,1:Choose,Active_Bitmaps_List,% Active_Bitmap
	GuiControl,7:,Display_Current_Bitmap_Name ,`n�Ѿ������λͼ : %Active_Bitmap% ;`nActive Bitmap : %Active_Bitmap%
	Loop,% Bitmap_Array.Length()
		Bitmap_Array[A_Index].move()
	if(Bitmap_Array.Length()=1){
		GuiControl,1:,Selected_New_Element,|
		GuiControl,1:,Selected_New_Element,% Element_Type_List
	}
	Set_Bitmap_Controls()
}

Set_Active_Bitmap(){
	GuiControlGet,Active_Bitmap,1:,Active_Bitmaps_List
	GuiControl,7:,Display_Current_Bitmap_Name ,`n�Ѿ������λͼ : %Active_Bitmap% ;`nActive Bitmap : %Active_Bitmap%
	Update_Element_List()
	if(Bitmap_Array[Active_Bitmap].BitMap_Elements.Length()){
		(Active_Element != 1) ? (Active_Element-=1)
		GuiControl,8:Choose,Current_Elements,% Active_Element
		Element_Window[Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Type](Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element])
		;~ Set_Bitmap_Controls()
	}else	{
		Active_Element:=""
		Gui,13:Destroy
	}
	if(Bitmap_Array.Length())
		Set_Bitmap_Controls()
}

Remove_Active_Bitmap(){
	if(Bitmap_Array.Length()>0){
		GuiControlGet,Active_Bitmap,1:,Active_Bitmaps_List
		GuiControl,4:+Redraw,% Bitmap_Array[Active_Bitmap].Name
		GuiControl,4:Hide,% Bitmap_Array[Active_Bitmap].Name
		Bitmap_Array.RemoveAt(Active_Bitmap)
		(Active_Bitmap>1)?(Active_BitMap-=1)
		Add_Bitmaps_To_Bitmaps_List()
		GuiControl,1:Choose,Active_Bitmaps_List,% Active_Bitmap
		Set_Active_Bitmap()
		if(Bitmap_Array.Length()<1)	{
			GuiControl,1:,Selected_New_Element,|
			GuiControl,8:,Current_Elements,|
			Gui,13:Destroy
			Gui,14:Destroy
			Gui,15:Destroy
			Gui,17:Destroy
		}
	}
}

;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
; Element_Windows
;**********************************************************************************************

Class Element_Windows	{
	Add_Picture( obj ){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		;~ Constructor.Rectangle_Lines(obj)
		Constructor.Add_Picture_Lines(obj)

		;~ Constructor.Brush_Options_Lines(obj)
		;~ Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_W_H()

		Constructor.Show_Window()
	}
	Fill_Rectangle(Obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Rectangle_Lines(obj)
		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_W_H()

		Constructor.Show_Window()
	}
	Fill_Rounded_Rectangle(obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Rounded_Rectangle_Lines(obj)
		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_W_H()
		Constructor.Show_Window()
	}
	Fill_Circle(obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Rectangle_Lines(obj)
		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_W_H()
		Constructor.Show_Window()
	}
	Fill_Pie(obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Rectangle_Lines(obj)
		Constructor.Angle_Lines(obj)
		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_W_H()
		Constructor.Show_Window()
	}
	Fill_Polygon(obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)

		Constructor.Polygon_Lines(obj)

		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Position_Buttons_Polygon(obj)
		Constructor.Show_Window()

	}
	Draw_Rectangle(Obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Rectangle_Lines(obj)
		Constructor.Line_Thickness_Lines(obj)
		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_W_H()
		Constructor.Show_Window()
	}
	Draw_Rounded_Rectangle(Obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Rounded_Rectangle_Lines(obj)
		Constructor.Line_Thickness_Lines(obj)
		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_W_H()
		Constructor.Show_Window()
	}
	Draw_Circle(obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Rectangle_Lines(obj)
		Constructor.Line_Thickness_Lines(obj)
		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_W_H()
		Constructor.Show_Window()
	}
	Draw_Line(obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Two_Points_Lines(obj)
		Constructor.Line_Thickness_Lines(obj)
		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_X2_Y2()
		Constructor.Show_Window()
	}
	Draw_Lines(obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Line_Thickness_Lines(obj)
		Constructor.Lines_Lines(obj)

		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Position_Buttons_Polygon(obj)
		Constructor.Show_Window()

	}
	Draw_Arc(obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Rectangle_Lines(obj)
		Constructor.Angle_Lines(obj)
		Constructor.Line_Thickness_Lines(obj)
		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_W_H()
		Constructor.Show_Window()
	}
	Draw_Pie(obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Rectangle_Lines(obj)
		Constructor.Angle_Lines(obj)
		Constructor.Line_Thickness_Lines(obj)
		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_W_H()
		Constructor.Show_Window()
	}
	Draw_Bezier(obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Bezier_Lines(obj)
		Constructor.Line_Thickness_Lines(obj)
		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)
		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_X2_Y2()
		Constructor.Positioning_Buttons_X3_Y3_X4_Y4()
		Constructor.Show_Window()
	}
	Text(obj){
		Constructor.Window_Settings()
		Constructor.Hide_Element_Line(obj)
		Constructor.Notes_Line(obj)
		Constructor.Rectangle_Lines(obj)
		Constructor.Text_Lines(obj)

		Constructor.Brush_Options_Lines(obj)
		Constructor.Create_Brush_Window(obj)

		Constructor.Fine_Control_Window(obj)
		Constructor.Positioning_Buttons_X_Y()
		Constructor.Positioning_Buttons_W_H()
		Constructor.Show_Window()
	}
}

;**********************************************************************************************

; Element_Window_Constructor
;**********************************************************************************************

Class Element_Window_Constructor	{
	Window_Settings(){
		Gui,13:Destroy
		Gui,13:+Parent12 -Caption -DPIScale
		Gui,13:Color,333333,333333
		Gui,13:Font,cWhite s8 ,Segoe Ui
	}
	Show_Window(){
		Gui,13:Show,x0 y0 w290 h380 ,
	}
	Notes_Line(obj){
		global
		Gui,13:Add,Text,x10 y+10 w40 r1,ע�� : ;Notes :
		Gui,13:Add,Edit,x+10 yp-2 w220 r1 -E0x200 +Border vNotes gSubmit_13 ,% obj.Notes
	}
	Rectangle_Lines(obj){
		global
		Gui,13:Add,Text,x10 y+10 w15 r1 ,X :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vX_Position gSubmit_13,% obj.X
		Gui,13:Add,Text,x+5 yp+4 w15 r1 ,Y :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vY_Position gSubmit_13,% obj.Y
		Gui,13:Add,Text,x+5 yp+4 w20 r1 ,W :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center Number -E0x200 +Border vW_Position gSubmit_13,% obj.W
		Gui,13:Add,Text,x+5 yp+4 w20 r1 ,H :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center Number -E0x200 +Border vH_Position gSubmit_13,% obj.H
	}
	Add_Picture_Lines(obj){
		global
		Gui,13:Add,Text,x10 y+10 w15 r1 ,X :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vX_Position gSubmit_13,% obj.X
		Gui,13:Add,Text,x+5 yp+4 w15 r1 ,Y :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vY_Position gSubmit_13,% obj.Y
		Gui,13:Add,Text,x+5 yp+4 w20 r1 ,W :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center Number -E0x200 +Border vW_Position gSubmit_13,% obj.W
		Gui,13:Add,Text,x+5 yp+4 w20 r1 ,H :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center Number -E0x200 +Border vH_Position gSubmit_13,% obj.H

		Gui,13:Add, text , x10 y+10 w20 r1 , % "SX: "
		Gui,13:Add, Edit , x+5 yp w50 r1 Center Number -E0x200 +Border vSx gSubmit_13, % obj.SourceX

		Gui,13:Add, text , x+10 w20 r1 , % "SY: "
		Gui,13:Add, Edit , x+5 w50 r1 Center Number -E0x200 +Border vSy gSubmit_13, % obj.SourceY

		Gui,13:Add, text , x10 w20 r1 , % "SW: "
		Gui,13:Add, Edit , x+5 w50 r1 Center Number -E0x200 +Border vSw gSubmit_13, % obj.SourceW

		Gui,13:Add, text , x+10 w20 r1 , % "SH: "
		Gui,13:Add, Edit , x+5 w50 r1 Center Number -E0x200 +Border vSh gSubmit_13, % obj.SourceH

		Gui,13:Add, Edit , x10 y+20 w270 r1 Center -E0x200 +Border ReadOnly, % obj.Path

		Gui,13:Add, text , x10 w60 r1 , % "Width:"
		Gui,13:Add, Edit , x+5 w50 r1 Center Number ReadOnly -E0x200 +Border , % obj.SourceWidth

		Gui,13:Add, text , x+20 w60 r1 , % "Height:"
		Gui,13:Add, Edit ,cAqua x+5 w50 r1 Center Number ReadOnly -E0x200 +Border , % obj.SourceHeight

	}
	Polygon_Lines(obj){
		global
		Gui,13:Add,Text,x10 y+20 w60 r1 ,λ�� : ;Positions :
		Gui,13:Add,Edit,x10 y+10 w270 r1 vPolygon_List gSubmit_13,% obj.Polygon_List
		Gui,13:Add,Button,x10 y+20 w80 h25 -Theme gAdd_New_Polygon_Point,���ӵ�λ ; Add Point
		Gui,13:Add,Button,x+10 w80 h25 -Theme gClear_Points, ��� ;Clear
	}
	Lines_Lines(obj){
		global
		Gui,13:Add,Text,x10 y+10 w60 r1 ,λ�� : ;Positions :
		Gui,13:Add,Edit,x10 y+5 w270 r1 vLines_List gSubmit_13,% obj.Lines_List
		Gui,13:Add,Button,x10 y+10 w80 h25 -Theme gAdd_New_Lines_Point,���ӵ�λ ; Add Point
		Gui,13:Add,Button,x+10 w80 h25 -Theme gClear_Points, ��� ;Clear
	}
	Rounded_Rectangle_Lines(obj){
		global
		Gui,13:Add,Text,x10 y+15 w15 r1 ,X :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vX_Position gSubmit_13,% obj.X
		Gui,13:Add,Text,x+5 yp+4 w15 r1 ,Y :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vY_Position gSubmit_13,% obj.Y
		Gui,13:Add,Text,x+5 yp+4 w20 r1 ,W :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center Number -E0x200 +Border vW_Position gSubmit_13,% obj.W
		Gui,13:Add,Text,x+5 yp+4 w20 r1 ,H :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center Number -E0x200 +Border vH_Position gSubmit_13,% obj.H
		Gui,13:Add,Text,x10 y+12 w50 r1,�뾶 : ;Radius :
		Gui,13:Add,Edit,x+10 yp-4 w50 r1 Center -E0x200 +Border Uppercase vRadius gSubmit_13,% obj.Radius
	}
	Brush_Options_Lines(obj){
		global
		Gui,13:Add,Radio,x10 y180 -Theme Group AltSubmit vBrush_Type gSubmit_Brush_Type,���� ;Normal
		Gui,13:Add,Radio,x+10 yp -Theme gSubmit_Brush_Type,Hatch
		Gui,13:Add,Radio,x+10 yp -Theme gSubmit_Brush_Type,Lines
		Gui,13:Add,Radio,x+10 yp -Theme gSubmit_Brush_Type,Grade
		if(obj.Brush_Type=1)
			GuiControl,13:,Brush_Type,1
		else if(obj.Brush_Type=2)
			GuiControl,13:,Hatch,1
		else if(obj.Brush_Type=3)
			GuiControl,13:,Lines,1
		else if(obj.Brush_Type=4)
			GuiControl,13:,Grade,1
	}
	Hide_Element_Line(obj){
		global
		if(obj.Hidden)
			Gui,13:Add,Checkbox,x10 y10 Checked vHide_Element gHide_Element,����Ԫ�� ;Hide Element
		else
			Gui,13:Add,Checkbox,x10 y10 vHide_Element gHide_Element,����Ԫ�� ;Hide Element
	}
	Line_Thickness_Lines(obj){
		Gui,13:Add,Text,x10 y+10 w80 r1,Thickness :
		Gui,13:Add,Edit,x+10 yp-2 w40 r1 Center -E0x200 +Border vThickness gSubmit_13 ,% obj.Thickness
	}
	Two_Points_Lines(obj){
		Gui,13:Add,Text,x10 y+15 w25 r1 ,X :
		Gui,13:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vX_Position gSubmit_13,% obj.X
		Gui,13:Add,Text,x+10 yp+4 w25 r1 ,Y :
		Gui,13:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vY_Position gSubmit_13,% obj.Y
		Gui,13:Add,Text,x10 y+15 w25 r1 ,X2 :
		Gui,13:Add,Edit,x+10 yp-4 w40 r1 Center Number -E0x200 +Border vX2_Position gSubmit_13,% obj.X2
		Gui,13:Add,Text,x+10 yp+4 w25 r1 ,Y2 :
		Gui,13:Add,Edit,x+10 yp-4 w40 r1 Center Number -E0x200 +Border vY2_Position gSubmit_13,% obj.Y2
	}
	Bezier_Lines(obj){
		Gui,13:Add,Text,x5 y+10 w15 r1 ,X :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vX_Position gSubmit_13,% obj.X
		Gui,13:Add,Text,x+5 yp+4 w15 r1 ,Y :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vY_Position gSubmit_13,% obj.Y
		Gui,13:Add,Text,x+5 yp+4 w20 r1 ,X2 :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vX2_Position gSubmit_13,% obj.X2
		Gui,13:Add,Text,x+5 yp+4 w20 r1 ,Y2 :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vY2_Position gSubmit_13,% obj.Y2
		Gui,13:Add,Text,x5 y+10 w20 r1 ,X3 :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vX3_Position gSubmit_13,% obj.X3
		Gui,13:Add,Text,x+5 yp+4 w20 r1 ,Y3 :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vY3_Position gSubmit_13,% obj.Y3
		Gui,13:Add,Text,x+5 yp+4 w20 r1 ,X4 :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vX4_Position gSubmit_13,% obj.X4
		Gui,13:Add,Text,x+5 yp+4 w20 r1 ,Y4 :
		Gui,13:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vY4_Position gSubmit_13,% obj.Y4
	}
	Angle_Lines(obj){
		Gui,13:Add,Text,x10 y+15 w70 r1 ,Start Angle :
		Gui,13:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vStart_Angle gSubmit_13,% obj.Start_Angle
		Gui,13:Add,Text,x+10 yp+4 w80 r1 ,Sweep Angle :
		Gui,13:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vEnd_Angle gSubmit_13,% obj.End_Angle
	}
	Text_Lines(obj){
		Gui,13:Add,Text,x10 y+7 w40 r1,���� : ;Text :
		Gui,13:Add,Edit,x+10 yp-2 w220 r1 -E0x200 +Border vText gSubmit_13 ,% obj.Text
		Gui,13:Add,Text,x10 y+7 w40 r1,ѡ�� : ;Options :
		Gui,13:Add,Edit,x+10 yp-2 w220 r1 -E0x200 +Border vOptions gSubmit_13 ,% obj.Options
		Gui,13:Add,Text,x10 y+7 w40 r1,���� : ;Font :
		Gui,13:Add,Edit,x+10 yp-2 w220 r1 -E0x200 +Border vFont gSubmit_13 ,% obj.Font

	}
	Create_Brush_Window(obj){
		Gui,14:Destroy
		Gui,14:+AlwaysOnTop -Caption -DpiScale +Parent13
		Gui,14:Color,333333,444444
		Gui,14:Font,cWhite s8 ,Segoe Ui
		Gui,14:Show,x0 y200 w290 h200
		if(obj.Brush_Type=1)
			This.Normal_Brush_Window(obj)
		else if(obj.Brush_Type=2)
			This.Hatch_Brush_Window(obj)
		else if(obj.Brush_Type=3)
			This.Line_Brush_Window(obj)
		else if(obj.Brush_Type=4)
			This.Grade_Brush_Window(obj)
	}
	Normal_Brush_Window(obj){
		Gui,14:Add,Text,x5 y30 w40 r1 ,͸���� ;Alpha :
		Gui,14:Add,Edit,x+5 yp-4 w40 r1 Center Limit2 -E0x200 +Border vAlpha gSubmit_13,% obj.Alpha
		Gui,14:Add,Text,x+5 yp+4 w40 r1 ,��ɫ ;Color :
		Gui,14:Add,Edit,x+5 yp-4 w60 r1 Center Limit6 -E0x200 +Border vColor gSubmit_13,% obj.Color
		Gui,14:Add,Button,x+10 yp w70 h20 -Theme gSet_Color_1,��ȡ ;Get
		Gui,14:Submit,NoHide
	}
	Hatch_Brush_Window(obj){
		Gui,14:Add,Text,x5 y20 w40 r1 ,͸���� ;Alpha :
		Gui,14:Add,Edit,x+5 yp-4 w40 r1 Center Limit2 -E0x200 +Border vAlpha gSubmit_13,% obj.Alpha
		Gui,14:Add,Text,x+5 yp+4 w40 r1 ,��ɫ ;Color :
		Gui,14:Add,Edit,x+5 yp-4 w60 r1 Center Limit6 -E0x200 +Border vColor gSubmit_13,% obj.Color
		Gui,14:Add,Button,x+10 yp w70 h20 -Theme gSet_Color_1,��ȡ ;Get

		Gui,14:Add,Text,x5 y+10 w40 r1 ,͸���� ;Alpha 2 :
		Gui,14:Add,Edit,x+5 yp-4 w40 r1 Center Limit2 -E0x200 +Border vAlpha2 gSubmit_13,% obj.Alpha2
		Gui,14:Add,Text,x+5 yp+4 w40 r1 ,��ɫ ;Color2 :
		Gui,14:Add,Edit,x+5 yp-4 w60 r1 Center Limit6 -E0x200 +Border vColor2 gSubmit_13,% obj.Color2
		Gui,14:Add,Button,x+10 yp w70 h20 -Theme gSet_Color_2,��ȡ ;Get

		Gui,14:Add,Text,x5 y+10 w40 r1 ,Hatch :
		Gui,14:Add,Edit,x+5 yp-4 w40 r1 Center Limit2 -E0x200 +Border vHatch gSubmit_13,% obj.Hatch
		Gui,14:Submit,NoHide

	}
	Line_Brush_Window(obj){
		Gui,14:Add,Text,x5 y10 w40 r1 ,͸���� ;Alpha :
		Gui,14:Add,Edit,x+5 yp-4 w40 r1 Center Limit2 -E0x200 +Border vAlpha gSubmit_13,% obj.Alpha
		Gui,14:Add,Text,x+5 yp+4 w40 r1 ,��ɫ ;Color :
		Gui,14:Add,Edit,x+5 yp-4 w60 r1 Center Limit6 -E0x200 +Border vColor gSubmit_13,% obj.Color
		Gui,14:Add,Button,x+10 yp w70 h20 -Theme gSet_Color_1,��ȡ ;Get

		Gui,14:Add,Text,x5 y+10 w40 r1 ,͸���� ;Alpha 2 :
		Gui,14:Add,Edit,x+5 yp-4 w40 r1 Center Limit2 -E0x200 +Border vAlpha2 gSubmit_13,% obj.Alpha2
		Gui,14:Add,Text,x+5 yp+4 w40 r1 ,��ɫ ;Color2 :
		Gui,14:Add,Edit,x+5 yp-4 w60 r1 Center Limit6 -E0x200 +Border vColor2 gSubmit_13,% obj.Color2
		Gui,14:Add,Button,x+10 yp w70 h20 -Theme gSet_Color_2,��ȡ ;Get

		Gui,14:Add,Text,x10 y+10 w25 r1 ,X1 :
		Gui,14:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vLine_Brush_X1 gSubmit_13,% obj.Line_Brush_X1
		Gui,14:Add,Text,x+10 yp+4 w25 r1 ,Y1 :
		Gui,14:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vLine_Brush_Y1 gSubmit_13,% obj.Line_Brush_Y1

		Gui,14:Add,Text,x10 y+10 w25 r1 ,X2 :
		Gui,14:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vLine_Brush_X2 gSubmit_13,% obj.Line_Brush_X2
		Gui,14:Add,Text,x+10 yp+4 w25 r1 ,Y2 :
		Gui,14:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vLine_Brush_Y2 gSubmit_13,% obj.Line_Brush_Y2
		Gui,14:Add,Button,x+40 yp w70 r1 -Theme gSet_LineBrush_Positions, Set
		Gui,14:Add,Text,x10 y+10 w65 r1 ,����ģʽ : ;Wrap Mode :
		Gui,14:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vLine_Brush_Wrap_Mode gSubmit_13,% obj.Line_Brush_Wrap_Mode
		Gui,14:Submit,NoHide
	}
	Grade_Brush_Window(obj){
		Gui,14:Add,Text,x5 y10 w40 r1 ,͸���� ;Alpha :
		Gui,14:Add,Edit,x+5 yp-4 w40 r1 Center Limit2 -E0x200 +Border vAlpha gSubmit_13,% obj.Alpha
		Gui,14:Add,Text,x+5 yp+4 w40 r1 ,��ɫ ;Color :
		Gui,14:Add,Edit,x+5 yp-4 w60 r1 Center Limit6 -E0x200 +Border vColor gSubmit_13,% obj.Color
		Gui,14:Add,Button,x+10 yp w70 h20 -Theme gSet_Color_1,��ȡ ;Get

		Gui,14:Add,Text,x5 y+10 w40 r1 ,͸���� ;Alpha 2 :
		Gui,14:Add,Edit,x+5 yp-4 w40 r1 Center Limit2 -E0x200 +Border vAlpha2 gSubmit_13,% obj.Alpha2
		Gui,14:Add,Text,x+5 yp+4 w40 r1 ,��ɫ ;Color2 :
		Gui,14:Add,Edit,x+5 yp-4 w60 r1 Center Limit6 -E0x200 +Border vColor2 gSubmit_13,% obj.Color2
		Gui,14:Add,Button,x+10 yp w70 h20 -Theme gSet_Color_2,��ȡ ;Get

		Gui,14:Add,Text,x10 y+10 w25 r1 ,X :
		Gui,14:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vGrade_Brush_X gSubmit_13,% obj.Grade_Brush_X
		Gui,14:Add,Text,x+10 yp+4 w25 r1 ,Y :
		Gui,14:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vGrade_Brush_Y gSubmit_13,% obj.Grade_Brush_Y
		Gui,14:Add,Text,x10 y+10 w25 r1 ,W :
		Gui,14:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vGrade_Brush_W gSubmit_13,% obj.Grade_Brush_W
		Gui,14:Add,Text,x+10 yp+4 w25 r1 ,H :
		Gui,14:Add,Edit,x+10 yp-4 w40 r1 Center -E0x200 +Border vGrade_Brush_H gSubmit_13,% obj.Grade_Brush_H
		Gui,14:Add,Button,x+40 yp w70 r1 -Theme gSet_GradeBrush_Positions, Set

		Gui,14:Add,Text,x5 y+10 w65 r1 ,����ģʽ : ;Wrap Mode :
		Gui,14:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vGrade_Brush_Wrap_Mode gSubmit_13,% obj.Grade_Brush_Wrap_Mode
		Gui,14:Add,Text,x+10 yp+4 w110 r1 ,�����ݶ�ģʽ : ;LinearGradientMode :
		Gui,14:Add,Edit,x+5 yp-4 w40 r1 Center -E0x200 +Border vGrade_Brush_LinearGradientMode gSubmit_13,% obj.Grade_Brush_LinearGradientMode
		Gui,14:Submit,NoHide
	}
	Fine_Control_Window(obj){
		Gui,15:Destroy
		Gui,15:+AlwaysOnTop -Caption -DpiScale +Parent11
		Gui,15:Color,333333,444444
		Gui,15:Font,cWhite s8 ,Segoe Ui
		Gui,15:Show,x0 y0 w290 h200
	}
	Positioning_Buttons_X_Y(){
		global
		Gui,15:Font,cWhite s8 , ;Segoe Ui
		Gui,15:Add,Button,x35 y10 w50 h25 -Theme vMove_Up gRePosition_Element,Y Up
		Gui,15:Add,Button,x5 y+5 w50 h25 -Theme vMove_Left gRePosition_Element,X Left
		Gui,15:Add,Button,x+10 yp w50 h25 -Theme vMove_Right gRePosition_Element,X Right
		Gui,15:Add,Button,x35 y+5 w50 h25 -Theme vMove_Down gRePosition_Element,Y Down

	}
	Positioning_Buttons_X2_Y2(){
		global
		Gui,15:Font,cWhite s8 ,Segoe Ui
		Gui,15:Add,Button,x151 y10 w60 h25 -Theme vMove_Up2 gRePosition_Element,Y2 Up
		Gui,15:Add,Button,x123 y+5 w60 h25 -Theme vMove_Left2 gRePosition_Element,X2 Left
		Gui,15:Add,Button,x+6 yp w60 h25 -Theme vMove_Right2 gRePosition_Element,X2 Right
		Gui,15:Add,Button,x151 y+5 w60 h25 -Theme vMove_Down2 gRePosition_Element,Y2 Down

	}
	Positioning_Buttons_X3_Y3_X4_Y4(){
		global
		Gui,15:Font,cWhite s8 , ;Segoe Ui
		Gui,15:Add,Button,x35 y110 w50 h25 -Theme vMove_Up3 gRePosition_Element,Y3
		Gui,15:Add,Button,x5 y+5 w50 h25 -Theme vMove_Left3 gRePosition_Element,X3
		Gui,15:Add,Button,x+10 yp w50 h25 -Theme vMove_Right3 gRePosition_Element,X3
		Gui,15:Add,Button,x35 y+5 w50 h25 -Theme vMove_Down3 gRePosition_Element,Y3

		Gui,15:Add,Button,x151 y110 w60 h25 -Theme vMove_Up4 gRePosition_Element,Y4
		Gui,15:Add,Button,x123 y+5 w60 h25 -Theme vMove_Left4 gRePosition_Element,X4
		Gui,15:Add,Button,x+6 yp w60 h25 -Theme vMove_Right4 gRePosition_Element,X4
		Gui,15:Add,Button,x151 y+5 w60 h25 -Theme vMove_Down4 gRePosition_Element,Y4
	}
	Positioning_Buttons_W_H(){
		global
		Gui,15:Font,cWhite s8 ,Segoe Ui

		Gui,15:Add,Button,x160 y10 w50 h25 -Theme vMinus_Height gReSize_Element,-H
		Gui,15:Add,Button,x130 y+5 w50 h25 -Theme vMinus_Width gReSize_Element,-W
		Gui,15:Add,Button,x+10 yp w50 h25 -Theme vPlus_Width gReSize_Element,+W
		Gui,15:Add,Button,x160 y+5 w50 h25 -Theme vPlus_Height gReSize_Element,+H

	}
	Position_Buttons_Polygon(obj){
		global
		Gui,15:Font,cWhite s8 , ;Segoe Ui
		Gui,15:Add,Button,x40 y10 w50 h25 -Theme vMove_Up gRePosition_Polygon_Element,Y Up
		Gui,15:Add,Button,x10 y+5 w50 h25 -Theme vMove_Left gRePosition_Polygon_Element,X Left
		Gui,15:Add,Button,x+10 yp w50 h25 -Theme vMove_Right gRePosition_Polygon_Element,X Right
		Gui,15:Add,Button,x40 y+5 w50 h25 -Theme vMove_Down gRePosition_Polygon_Element,Y Down

		Gui,15:Add,ListBox,x150 y10 w80 h90 -Theme

		Gui,15:Add,Button,x10 y105 w105 h25 -Theme ,< - - ���� ;<-- Back
		Gui,15:Add,Button,x+20 y105 w105 h25 -Theme ,��һ�� - - > ;Next -->

		Gui,15:Add,Text,x10 y140 w30 h20 ,X :
		Gui,15:Add,Edit,x+0 w50 h20 Center -E0x200 Border,
		Gui,15:Add,Text,x+15 y140 w30 h20 ,Y :
		Gui,15:Add,Edit,x+0 w50 h20 Center -E0x200 Border,
		Gui,15:Add,Button,x+10 yp w50 h25 -Theme ,���� ;Set

		Gui,15:Add,Button,x5 y170 w75 h25 -Theme,���� ;Add
		Gui,15:Add,Button,x+5 w75 h25 -Theme,ɾ�� ;Remove
		Gui,15:Add,Button,x+5 w75 h25 -Theme,���� ;Insert

	}
}
;**********************************************************************************************

; Master Element Class
;**********************************************************************************************
Class Element	{
	__New( Type , path := "" ){
		local Width, Height
		;~ ToolTip, % path "`n" Default_Values.Default_Element_W
		This.Type:=								Type
		This.X:=								Default_Values.Default_Element_X
		This.Y:=								Default_Values.Default_Element_Y
		This.W:=								Default_Values.Default_Element_W
		This.H:=								Default_Values.Default_Element_H
		This.X2:=								Default_Values.Default_Element_X2
		This.Y2:= 								Default_Values.Default_Element_Y2
		This.X3:=								Default_Values.Default_Element_X3
		This.Y3:=								Default_Values.Default_Element_Y3
		This.X4:=								Default_Values.Default_Element_X4
		This.Y4:=								Default_Values.Default_Element_Y4
		This.Alpha:=							Default_Values.Default_Element_Alpha
		This.Color:=							Default_Values.Default_Element_Color
		This.Alpha2:=							Default_Values.Default_Element_Alpha2
		This.Color2:=							Default_Values.Default_Element_Color2
		This.Thickness:=						Default_Values.Default_Element_Thickness
		This.Radius:=							Default_Values.Default_Element_Radius
		This.Hatch:=							Default_Values.Default_Element_Hatch
		This.Notes:=							""
		This.Text:=								Default_Values.Default_Element_Text
		This.Options:=							Default_Values.Default_Element_Options
		This.Font:=								Default_Values.Default_Element_Font
		This.Brush_Type:=						Default_Values.Default_Element_Brush_Type
		This.Hidden:=							Default_Values.Default_Element_Hidden
		This.Line_Brush_X1:=					Default_Values.Default_Element_Line_Brush_X1
		This.Line_Brush_Y1:=					Default_Values.Default_Element_Line_Brush_Y1
		This.Line_Brush_X2:=					Default_Values.Default_Element_Line_Brush_X2
		This.Line_Brush_Y2:=					Default_Values.Default_Element_Line_Brush_Y2
		This.Line_Brush_Wrap_Mode:=				Default_Values.Default_Element_Line_Brush_Wrap_Mode
		This.Grade_Brush_X:=					Default_Values.Default_Element_Grade_Brush_X
		This.Grade_Brush_Y:=					Default_Values.Default_Element_Grade_Brush_Y
		This.Grade_Brush_W:=					Default_Values.Default_Element_Grade_Brush_W
		This.Grade_Brush_H:=					Default_Values.Default_Element_Grade_Brush_H
		This.Grade_Brush_LinearGradientMode:=	Default_Values.Default_Element_Grade_Brush_LinearGradientMode
		This.Grade_Brush_Wrap_Mode:=			Default_Values.Default_Element_Grade_Brush_Wrap_Mode
		This.Start_Angle:=						Default_Values.Default_Element_Start_Angle
		This.End_Angle:=						Default_Values.Default_Element_End_Angle
		This.Polygon_List:=						Default_Values.Default_Element_Polygon_List
		This.Lines_List:=						Default_Values.Default_Element_Lines_List

		if( path ){
			;~ SoundBeep, 1500
			This.Path := 						path

			This.PicBitmap := 					Gdip_CreateBitmapFromFile( This.Path )

			Gdip_GetImageDimensions( This.PicBitmap , Width , Height )

			This.X :=							0
			This.Y :=							0
			This.W :=							Width
			This.H := 							Height
			;~ SoundBeep, 500
			;~ ToolTip, % path
			This.SourceX := 					0
			This.SourceY := 					0
			This.SourceW := 					Width
			This.SourceH :=						Height
			This.SourceWidth := 				Width
			This.SourceHeight := 				Height

		}else	{
			This.Path := ""
			This.SourceX := 					0
			This.SourceY := 					0
			This.SourceW := 					100
			This.SourceH :=						100
			This.SourceWidth := 				100
			This.SourceHeight := 				100

		}

	}
}

;**********************************************************************************************

;    Main Windows Class
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class Main_Window	{
	;~ __New(x:=1366,y:=0,w:=1350,h:=700){
	__New(x:=0,y:=0,w:=1350,h:=700){
		This.X:=x, This.Y:=y, This.W:=w, This.H:=h
		This.Create_Main_Window()
		This.Create_Left_Control_Window()
		This.Create_Right_Control_Window()
		This.Create_Element_Control_Window()
		This.Create_Bitmap_Control_Panel()
		This.Inner_Window()
		This.Setup_Gdip()
	}
	Create_Main_Window(){
		global
		Gui,1: +LastFound -DPIScale ;+AlwaysOnTop
		Gui,1:Color,222222,333333
		Gui,1:Font,cWhite s10 q5, Segoe UI
		Gui,1:Add,Progress,% "x0 y0 w" This.W " h3 Background880000"
		Gui,1:Add,Progress,% "x0 y" This.H-3 " w" This.W " h3 Background880000"
		Gui,1:Add,Button,x305 y5 w110 r1 -Theme gRemove_Active_Bitmap,ɾ��λͼ ;Remove Bitmap
		Gui,1:Add,DDL,x+5 y5 w160 r20 -Theme AltSubmit vActive_Bitmaps_List,
		Gui,1:Add,Button,x+5 yp w110 r1 -Theme gSet_Active_Bitmap,����λͼ ;Activate Bitmap

		Gui,1:Add,DDL,x+25 y5 w190 r20 -Theme vSelected_New_Element ,
		Gui,1:Add,Button,x+5 yp w130 r1 -Theme gAdd_New_Element,���� ;Add

		Gui,1:Show,% "x" This.X " y" This.Y " w" This.W " h" This.H ,HB Bitmap Maker

	}
	Create_Left_Control_Window(){
		global
		Gui,2:+AlwaysOnTop -DPIScale -Caption +Parent1
		Gui,2:Color,333333,444444
		Gui,2:Font,cWhite s10 q5, Segoe UI
		Gui,2:Add,Progress,% "x297 y0 w3 h" This.H " Background880000"
		Gui,2:Add,Text,x8 y10 w90 h30 vTab1 gSwap_Tabs,Tab 1 trigger
		Gui,2:Add,Text,x+5 y10 w90 h30 vTab2 gSwap_Tabs,Tab 2 trigger
		Gui,2:Add,Text,x+5 y10 w90 h30 vTab3 gSwap_Tabs,Tab 3 trigger
		Gui,2:Add,Progress,x3 y5 w290 h40 Background442222
		Gui,2:Add,Progress,x8 y10 w90 h30 Background3399FF vTab1_Background
		Gui,2:Add,Progress,x+5 y10 w90 h30 Background777777 vTab2_Background
		Gui,2:Add,Progress,x+5 y10 w90 h30 Background777777 vTab3_Background
		Gui,2:Add,Text,cBlack x8 y10 w90 h30 Border Center BackgroundTrans 0x200 vTab1_Text,�½� ;New
		Gui,2:Add,Text,cBlack x+5 y10 w90 h30 Border Center BackgroundTrans 0x200 vTab2_Text,���� ;Load
		Gui,2:Add,Text,cBlack x+5 y10 w90 h30 Border Center BackgroundTrans 0x200 vTab3_Text,���� ;Save
		Gui,2:Show,% "x0 y0 w300 h" This.H
		This.Create_Window_2_Tabs()
	}
	Create_Right_Control_Window(){
		global
		Gui,3:+AlwaysOnTop -DPIScale -Caption +Parent1
		Gui,3:Color,333333,444444
		Gui,3:Font,cWhite s10 q5, Segoe UI
		Gui,3:Add,Progress,% "x0 y0 w3 h" This.H " Background880000"

		Gui,3:Add,Text,x8 y10 w90 h30 vTab4 gSwap_Tabs,Tab 4 trigger
		Gui,3:Add,Text,x+5 y10 w90 h30 vTab5 gSwap_Tabs,Tab 5 trigger
		Gui,3:Add,Text,x+5 y10 w90 h30 vTab6 gSwap_Tabs,Tab 6 trigger
		Gui,3:Add,Progress,x3 y5 w290 h40 Background442222
		Gui,3:Add,Progress,x8 y10 w90 h30 Background3399FF vTab4_Background
		Gui,3:Add,Progress,x+5 y10 w90 h30 Background777777 vTab5_Background
		Gui,3:Add,Progress,x+5 y10 w90 h30 Background777777 vTab6_Background
		Gui,3:Add,Text,cBlack x8 y10 w90 h30 Border Center BackgroundTrans 0x200 vTab4_Text,Ԫ�� ;Elements
		Gui,3:Add,Text,cBlack x+5 y10 w90 h30 Border Center BackgroundTrans 0x200 vTab5_Text,Ĭ�� ;Defaults
		Gui,3:Add,Text,cBlack x+5 y10 w90 h30 Border Center BackgroundTrans 0x200 vTab6_Text,Tab 6

		Gui,3:Show,% "x" This.W-300 " y0 w300 h" This.H
		This.Create_Window_3_Tabs()
	}
	Inner_Window(){
		Gui,4:+AlwaysOnTop -DPIScale -Caption +Parent1 +LastFound
		Gui,4:Color,004444,444444
		Gui,4:Font,cWhite s10 q5, Segoe UI
		Gui,4:Show,% "x0 y40 w" This.W " h" This.H-50
	}
	Create_Window_2_Tabs(){ ;Tabs 1 - 3
		global
		; Tab 1
		;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

		Gui,5:+Parent2 -Caption -DPIScale +AlwaysOnTop
		Gui,5:Color,333333,444444
		Gui,5:Font,cWhite s10 q5, Segoe UI

		Gui,5:Add,Text,x10 y30 w70 r1,������ɫ ;Background Color
		Gui,5:Add,Edit,x+10 yp w100 r1 vBitmapBackgroundColor gChange_Bitmap_Background_Color,004444

		Gui,5:Add,Text,x10 y+50 w267 r2 Border Center, �½�λͼ ;New Bitmap

		Gui,5:Add,Text,x5 y+10 w40 r1 ,Name :
		Gui,5:Add,Edit,x+10 yp w200 r1 Center -E0x200 +Border ReadOnly vNew_Bitmap_Name,1

		Gui,5:Add,Text,x5 y+10 w40 r1 ,X :
		Gui,5:Add,Edit,x+10 yp w200 r1 Center Number -E0x200 +Border vNew_Bitmap_X,% Default_Values.Default_Bitmap_X
		Gui,5:Add,Text,x5 y+10 w40 r1 ,Y :
		Gui,5:Add,Edit,x+10 yp w200 r1 Center Number -E0x200 +Border vNew_Bitmap_Y,% Default_Values.Default_Bitmap_Y
		Gui,5:Add,Text,x5 y+10 w40 r1 ,W :
		Gui,5:Add,Edit,x+10 yp w200 r1 Center Number -E0x200 +Border vNew_Bitmap_W,% Default_Values.Default_Bitmap_W
		Gui,5:Add,Text,x5 y+10 w40 r1 ,H :
		Gui,5:Add,Edit,x+10 yp w200 r1 Center Number -E0x200 +Border vNew_Bitmap_H,% Default_Values.Default_Bitmap_H

		Gui,5:Add,Text,x5 y+10 w40 r1 ,ƽ��: ; Smoothing :
		Gui,5:Add,Edit,x+10 yp w200 r1 Limit1 Center Number -E0x200 +Border vNew_Bitmap_Smoothing,% Default_Values.Default_Bitmap_Smoothing

		Gui,5:Add,Button,x20 y+10 w247 r1 -Theme gAdd_New_Bitmap,������λͼ ;Add New Bitmap

		Gui,5:Show,x5 y50 w287 h640

		; Tab 2
		;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		Gui,6:+Parent2 -Caption -DPIScale +AlwaysOnTop
		Gui,6:Color,333333,444444
		Gui,6:Font,cWhite s10 q5, Segoe UI
		Gui,6:Add,ListBox,x5 y10 w280 r10 -Theme vList_Of_Saved_Bitmaps,% Saved_Bitmap_List

		Gui,6:Add,Button,x5 y+10 w280 r1 -Theme gTest_Load,����λͼ ;Load Bitmap

		Gui,6:Add,Button,x5 y+20 w280 r1 -Theme gClip_Bitmap,����λͼ�����а� ;Clipboard Bitmap

		Gui,6:Add,CheckBox,x10 y+100 gUnlock_Delete_Bitmap,���� ;Unlock

		Gui,6:Add,Button,x10 y+10 w267 r1 -Theme Disabled vDelete_Bitmap_Button gDelete_Bitmap,ɾ��λͼ ;Delete Bitmap

		Gui,6:Show,Hide x5 y50 w287 h640
		; Tab 3
		;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
		Gui,7:+Parent2 -Caption -DPIScale +AlwaysOnTop
		Gui,7:Color,333333,444444
		Gui,7:Font,cWhite s10 q5, Segoe UI
		Gui,7:Add,Text,cLime x10 y10 w267 r3 Center Border vDisplay_Current_Bitmap_Name ,`n�Ѿ������λͼ : %Active_Bitmap% ;`nActive Bitmap : %Active_Bitmap%
		Gui,7:Add,ListBox,x10 y+20 w267 r10 -Theme vList_Of_Existing_Saves gDump_Name_In_Name_To_Save_Edit,% Saved_Bitmap_List
		Gui,7:Submit,NoHide
		Gui,7:Add,Text,x10 y+20 w100 r1,Name :
		Gui,7:Add,Edit,x10 y+10 w267 r1 -E0x200 +Border vName_To_Save_Files,% List_Of_Existing_Saves

		Gui,7:Add,Button,x10 y+20 w267 r1 -Theme gSave_Code,����λͼ ;Save Bitmap
		Gui,7:Add,Button,x10 y+10 w267 r1 -Theme gSave_PNG,�����PNG�ļ� ;Save PNG

		;Added in update 0.1.7
		;-------------------------------------
		Gui,7:Add,Progress,x20 y+50 w200 h30 BackgroundBlack c880000 vSave_Progress,0
		;-----------------------------------
		Gui,7:Show,Hide x5 y50 w287 h640
	}
	Create_Window_3_Tabs(){
		global
		Gui,8:+Parent3 -Caption -DPIScale +AlwaysOnTop
		Gui,8:Color,333333,444444
		Gui,8:Font,cWhite s10 q5, Segoe UI
		Gui,8:Add,ListBox,x5 y0 w170 r15 -Theme AltSubmit vCurrent_Elements gSwitch_Active_Element,% Element_List
		Gui,8:Add,Checkbox,x+10 yp Checked -Theme vAuto_Draw gSet_Auto_Draw,�Զ�ˢ�� ;Auto Draw
		Gui,8:Add,Button,xp y+5 w100 h20 -Theme gForce_Draw,ˢ�� ;Draw
		Gui,8:Add,Button,xp y+5 w45 h20 -Theme vReOrder_Up gReOrder_Elements,���� ;Up
		Gui,8:Add,Button,x+10 yp w45 h20 -Theme vReOrder_Down gReOrder_Elements,���� ;Down
		Gui,8:Add,Checkbox,xp-55 y+5 gUnlock_Element_Remove,���� ;Unlock
		Gui,8:Add,Button,xp y+5 w100 h20 -Theme Disabled vElement_Remove_Button gRemove_Element,��� ;Remove
		Gui,8:Add,Button,xp y+10 w100 h25 -Theme gClone_Element,��¡ ;Clone

		This.Create_Tab_4_Element_Window()
		Gui,8:Show,x5 y50 w287 h640
		;---------------------------------------------------------------------
		Gui,9:+Parent3 -Caption -DPIScale +AlwaysOnTop
		Gui,9:Color,333333,444444
		Gui,9:Font,cWhite s8 q5, Segoe UI

		Gui,9:Add,Text,x10 y0 w267 h22 Center Border,λͼĬ��ֵ ;Bitmap Defaults
		;-------------------------------Bitmap Defaults
		Gui,9:Add,Text,x10 y+5 w40 h20 ,X :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Bitmap_X gSubmit_Defaults,% Default_Values.Default_Bitmap_X
		Gui,9:Add,Text,x+10 yp+2 w40 h20 ,Y :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Bitmap_Y gSubmit_Defaults,% Default_Values.Default_Bitmap_Y

		Gui,9:Add,Text,x10 y+5 w40 h20 ,W :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Bitmap_W gSubmit_Defaults,% Default_Values.Default_Bitmap_W
		Gui,9:Add,Text,x+10 yp+2 w40 h20 ,H :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Bitmap_H gSubmit_Defaults,% Default_Values.Default_Bitmap_H

		Gui,9:Add,Text,x10 y+5 w40 h20 ,ƽ�� : ;Smoothing :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Bitmap_Smoothing gSubmit_Defaults,% Default_Values.Default_Bitmap_Smoothing

		Gui,9:Add,Text,x10 y+5 w267 h22 Center Border,Ԫ��Ĭ��ֵ ;Element Defaults
		;-------------------------------Element Defaults
		Gui,9:Add,Text,x10 y+5 w40 h20 ,W :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_W gSubmit_Defaults,% Default_Values.Default_Element_W
		Gui,9:Add,Text,x+10 yp+2 w40 h20 ,H :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_H gSubmit_Defaults,% Default_Values.Default_Element_H

		Gui,9:Add,Text,x10 y+5 w40 h20 ,X :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_X gSubmit_Defaults,% Default_Values.Default_Element_X
		Gui,9:Add,Text,x+10 yp+2 w40 h20 ,Y :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_Y gSubmit_Defaults,% Default_Values.Default_Element_Y

		Gui,9:Add,Text,x10 y+5 w40 h20 ,X2 :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_X2 gSubmit_Defaults,% Default_Values.Default_Element_X2
		Gui,9:Add,Text,x+10 yp+2 w40 h20 ,Y2 :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_Y2 gSubmit_Defaults,% Default_Values.Default_Element_Y2

		Gui,9:Add,Text,x10 y+5 w40 h20 ,X3 :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_X3 gSubmit_Defaults,% Default_Values.Default_Element_X3
		Gui,9:Add,Text,x+10 yp+2 w40 h20 ,Y3 :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_Y3 gSubmit_Defaults,% Default_Values.Default_Element_Y3

		Gui,9:Add,Text,x10 y+5 w40 h20 ,X4 :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_X4 gSubmit_Defaults,% Default_Values.Default_Element_X4
		Gui,9:Add,Text,x+10 yp+2 w40 h20 ,Y4 :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_Y4 gSubmit_Defaults,% Default_Values.Default_Element_Y4

		Gui,9:Add,Text,x10 y+5 w40 h20 ,͸���� ;Alpha :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_Alpha gSubmit_Defaults,% Default_Values.Default_Element_Alpha
		Gui,9:Add,Text,x+10 yp+2 w40h20 ,��ɫ ;Color :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_Color gSubmit_Defaults,% Default_Values.Default_Element_Color

		Gui,9:Add,Text,x10 y+5 w40 h20 ,͸���� ;Alpha2 :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_Alpha2 gSubmit_Defaults,% Default_Values.Default_Element_Alpha2
		Gui,9:Add,Text,x+10 yp+2 w40 h20 ,��ɫ ;Color2 :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_Color2 gSubmit_Defaults,% Default_Values.Default_Element_Color2

		Gui,9:Add,Text,x3 y+5 w55 h20 ,Hatch :
		Gui,9:Add,Edit,x+0 yp-2 w30 h20 -E0x200 Border Center vDefault_Element_Hatch gSubmit_Defaults,% Default_Values.Default_Element_Hatch
		Gui,9:Add,Text,x+3 yp+2 w55 h20 ,�뾶 ;Radius :
		Gui,9:Add,Edit,x+0 yp-2 w30 h20 -E0x200 Border Center vDefault_Element_Radius gSubmit_Defaults,% Default_Values.Default_Element_Radius
		Gui,9:Add,Text,x+3 yp+2 w75 h20 ,Thickness :
		Gui,9:Add,Edit,x+0 yp-2 w30 h20 -E0x200 Border Center vDefault_Element_Thickness gSubmit_Defaults,% Default_Values.Default_Element_Thickness

		Gui,9:Add,Text,x5 y+5 w90 h20 ,Start Angle :
		Gui,9:Add,Edit,x+0 yp-2 w40 h20 -E0x200 Border Center vDefault_Element_Start_Angle gSubmit_Defaults,% Default_Values.Default_Element_Start_Angle
		Gui,9:Add,Text,x+10 yp+2 w100 h20 ,Sweep Angle :
		Gui,9:Add,Edit,x+0 yp-2 w40 h20 -E0x200 Border Center vDefault_Element_End_Angle gSubmit_Defaults,% Default_Values.Default_Element_End_Angle

		Gui,9:Add,Text,x10 y+5 w45 h20 ,���� ;Text :
		Gui,9:Add,Edit,x+0 yp-2 w90 h20 -E0x200 Border Center vDefault_Element_Text gSubmit_Defaults,% Default_Values.Default_Element_Text
		Gui,9:Add,Text,x+5 yp+2 w45 h20 ,���� ;Font :
		Gui,9:Add,Edit,x+0 yp-2 w90 h20 -E0x200 Border Center vDefault_Element_Font gSubmit_Defaults,% Default_Values.Default_Element_Font

		Gui,9:Add,Text,x10 y+5 w65 h20 ,����ѡ�� ;Text Options :
		Gui,9:Add,Edit,x+0 yp-2 w210 h20 -E0x200 Border vDefault_Element_Options gSubmit_Defaults,% Default_Values.Default_Element_Options

		Gui,9:Add,Text,x10 y+5 w65 h20 ,���� ;Hidden :
		Gui,9:Add,Edit,x+0 yp-2 w40 h20 -E0x200 Border Center Limit1 Number vDefault_Element_Hidden gSubmit_Defaults,% Default_Values.Default_Element_Hidden
		Gui,9:Add,Text,x+15 yp+2 w95 h20 ,ˢ������ ;Brush Type :
		Gui,9:Add,Edit,x+0 yp-2 w40 h20 -E0x200 Border Center Limit1 Number vDefault_Element_Brush_Type gSubmit_Defaults,% Default_Values.Default_Element_Brush_Type

		Gui,9:Add,Text,x10 y+5 w65 h20 ,����� ;Polygon List :
		Gui,9:Add,Edit,x+0 yp-2 w210 h20 -E0x200 Border Center vDefault_Element_Polygon_List gSubmit_Defaults,% Default_Values.Default_Element_Polygon_List

		Gui,9:Add,Text,x10 y+5 w65 h20 ,���߶� ;Lines List :
		Gui,9:Add,Edit,x+0 yp-2 w210 h20 -E0x200 Border Center vDefault_Element_Lines_List gSubmit_Defaults,% Default_Values.Default_Element_Lines_List

		Gui,9:Add,Text,x10 y+5 w267 h22 Center Border,��ˢ ;Line Brush

		Gui,9:Add,Text,x10 y+5 w25 h20 ,X1 :
		Gui,9:Add,Edit,x+0 yp-2 w40 h20 -E0x200 Border Center vDefault_Element_Line_Brush_X1 gSubmit_Defaults,% Default_Values.Default_Element_Line_Brush_X1
		Gui,9:Add,Text,x+5 yp+2 w25 h20 ,Y1 :
		Gui,9:Add,Edit,x+0 yp-2 w40 h20 -E0x200 Border Center vDefault_Element_Line_Brush_Y1 gSubmit_Defaults,% Default_Values.Default_Element_Line_Brush_Y1
		Gui,9:Add,Text,x+5 yp+2 w25 h20 ,X2 :
		Gui,9:Add,Edit,x+0 yp-2 w40 h20 -E0x200 Border Center vDefault_Element_Line_Brush_X2 gSubmit_Defaults,% Default_Values.Default_Element_Line_Brush_X2
		Gui,9:Add,Text,x+5 yp+2 w25 h20 ,Y2 :
		Gui,9:Add,Edit,x+0 yp-2 w40 h20 -E0x200 Border Center vDefault_Element_Line_Brush_Y2 gSubmit_Defaults,% Default_Values.Default_Element_Line_Brush_Y2

		Gui,9:Add,Text,x10 y+5 w100 h20 ,ѭ��ģʽ ;Wrap Mode :
		Gui,9:Add,Edit,x+10 yp-2 w40 h20 -E0x200 Border Center Limit1 Number vDefault_Element_Line_Brush_Wrap_Mode gSubmit_Defaults,% Default_Values.Default_Element_Line_Brush_Wrap_Mode

		Gui,9:Add,Text,x10 y+5 w267 h22 Center Border,�ݶ�ˢ ;Gradient Brush

		Gui,9:Add,Text,x10 y+5 w40 h20 ,X :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_Grade_Brush_X gSubmit_Defaults,% Default_Values.Default_Element_Grade_Brush_X
		Gui,9:Add,Text,x+10 yp+2 w40 h20 ,Y :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_Grade_Brush_Y gSubmit_Defaults,% Default_Values.Default_Element_Grade_Brush_Y

		Gui,9:Add,Text,x10 y+5 w40 h20 ,W :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_Grade_Brush_W gSubmit_Defaults,% Default_Values.Default_Element_Grade_Brush_W
		Gui,9:Add,Text,x+10 yp+2 w40 h20 ,H :
		Gui,9:Add,Edit,x+10 yp-2 w60 h20 -E0x200 Border Center vDefault_Element_Grade_Brush_H gSubmit_Defaults,% Default_Values.Default_Element_Grade_Brush_H

		Gui,9:Add,Text,x5 y+5 w150 h20 ,ѭ��ģʽ ;Wrap Mode :
		Gui,9:Add,Edit,x+0 yp-2 w30 h20 -E0x200 Border Center Limit1 Number vDefault_Element_Grade_Brush_Wrap_Mode gSubmit_Defaults,% Default_Values.Default_Element_Grade_Brush_Wrap_Mode
		Gui,9:Add,Text,x5 y+5 w150 h20 ,�����ݶ�ģʽ ;Linear Gradient Mode :
		Gui,9:Add,Edit,x+0 yp-2 w30 h20 -E0x200 Border Center Limit1 Number vDefault_Element_Grade_Brush_LinearGradientMode gSubmit_Defaults,% Default_Values.Default_Element_Grade_Brush_LinearGradientMode

		Gui,9:Add,Button,x+10 yp-10 w100 h30 -Theme gSave_Defaults,���� ;Save

		Gui,9:Show,Hide x5 y50 w287 h640
		Gui,9:Submit,NoHide
		;---------------------------------------------------------------------
		Gui,10:+Parent3 -Caption -DPIScale +AlwaysOnTop
		Gui,10:Color,333333,444444
		Gui,10:Font,cWhite s8 q5, Segoe UI
		Gui,10:Add,DDL,x10 y100 w270 r10 -Theme,Credits||Speed Master- Code Refactor / extra hotkeys|
		;~ Gui,10:Add,Button,x10 y200 w200 h30 -Theme, This is Tab 6
		Gui,10:Show,Hide x5 y50 w287 h640
	}
	Create_Tab_4_Element_Window(){
		Gui,12:+Parent8 -Caption -DPIScale +AlwaysOnTop
		Gui,12:Color,333333,444444
		Gui,12:Show,x0 y260 w287 h380
	}
	Create_Element_Control_Window(){
		Gui,11:+Parent1 -Caption -DPIScale +AlwaysOnTop
		Gui,11:Color,333333,444444
		Gui,11:Add,Progress,x0 y0 w250 h3 Background880000
		Gui,11:Add,Progress,x0 y0 w3 h200 Background880000
		Gui,11:Add,Progress,x247 y0 w3 h200 Background880000

		Gui,11:Show,x780 y500 w250 h200
	}
	Create_Bitmap_Control_Panel(){
		Gui,16:+Parent1 -Caption -DPIScale +AlwaysOnTop
		Gui,16:Color,333333,444444
		Gui,16:Font,cWhite s10 q5, Segoe UI
		Gui,16:Add,Progress,x0 y0 w350 h3 Background880000
		Gui,16:Add,Progress,x0 y0 w3 h200 Background880000
		Gui,16:Add,Progress,x347 y0 w3 h200 Background880000
		Gui,16:Show,x320 y500 w350 h200
	}
	Setup_Gdip(){
		This.Token:=Gdip_Startup()
		This.HWND:= WinExist()
	}
	Setup_DC(obj){
		obj.hdc1:= GetDC(This.HWND)
		obj.hdc2:=CreateCompatibleDC()
		obj.hbm:=CreateDIBSection(obj.W,obj.H)
		obj.obm:= SelectObject(obj.hdc2,obj.hbm)
		obj.G:= Gdip_GraphicsFromHDC(obj.hdc2)
	}
	Resize_DC(obj,w,h){
		obj.hdc1:= GetDC(This.HWND)
		obj.hdc2:=CreateCompatibleDC()
		obj.hbm:=CreateDIBSection(W,H)
		obj.obm:= SelectObject(obj.hdc2,obj.hbm)
		obj.G:= Gdip_GraphicsFromHDC(obj.hdc2)
	}
}

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;    Bitmap Class
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class BitMap_Class	{
	__New(x,y,w,h,smoothing,Name,Raster:=""){
		global
		This.X:=x
		This.Y:=y
		This.W:=w
		This.H:=h
		This.Name:=Name
		This.Zoom:=1.00
		This.Bitmap_Elements:=[]
		Windows.Setup_DC(This)
		This.Smoothing:=smoothing
		This.Raster:=Raster
		This.Create_BitMap()
		Gui,4:Add,Text,% "x" This.X " y" This.Y " w" This.W " h" This.H " gMove_Graphics v" This.Name
		This.move()
	}
	Zoom_Bitmap(){
		Windows.Resize_DC(This,This.W*This.Zoom,This.H*This.Zoom)
		GuiControl,4:Move,% This.Name,% "w" This.W*This.Zoom " h" This.H*This.Zoom
	}
	move(){
		Gdip_GraphicsClear(This.G)
		Gdip_DrawImage(This.G,This.Bitmap,0,0,This.W*This.Zoom,This.H*This.Zoom)
		BitBlt(This.hdc1 , This.X , This.Y , This.W*This.Zoom , This.H*This.Zoom , This.hdc2 ,0,0,This.Raster)
	}
	Create_BitMap(Save_Flag:=0){
		if(Save_Flag=0){
			;----------------------------------------------
			;Fix memory leak
			Gdip_DisposeImage(This.Bitmap)
			This.Bitmap:=""
			Gdip_DeleteGraphics( This.Bitmap_G )
			This.Bitmap_G:=""
			;----------------------------------------------
			This.Bitmap:=Gdip_CreateBitmap(This.W,This.H),This.Bitmap_G := Gdip_GraphicsFromImage(This.Bitmap),Gdip_SetSmoothingMode(This.Bitmap_G,This.Smoothing)
		}
		else if(Save_Flag=1){
			FileDelete,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Bitmap_Settings:="HB_BITMAP_MAKER(){`n`t;Bitmap Created Using: HB Bitmap Maker`n`tpBitmap := Gdip_CreateBitmap( " This.W " , " This.H " ) , G := Gdip_GraphicsFromImage( pBitmap ) , Gdip_SetSmoothingMode( G , " This.Smoothing " )"

			FileAppend,%Bitmap_Settings%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Bitmap_Settings:=""
		}
	}
	Create_Brush(index,Save_Flag:=0){
		if(Save_Flag=0){
			if(This.Bitmap_Elements[index].Brush_Type=1)
				This.Brush1:=New_Brush(This.Bitmap_Elements[index].Color,This.Bitmap_Elements[index].Alpha)
			else if(This.Bitmap_Elements[index].Brush_Type=2)
				This.Brush1:=Gdip_BrushCreateHatch("0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color,"0x" This.Bitmap_Elements[index].Alpha2 This.Bitmap_Elements[index].Color2 , This.Bitmap_Elements[index].Hatch)
			else if(This.Bitmap_Elements[index].Brush_Type=3)
				This.Brush1:=Gdip_CreateLineBrush(This.Bitmap_Elements[index].Line_Brush_X1, This.Bitmap_Elements[index].Line_Brush_Y1, This.Bitmap_Elements[index].Line_Brush_X2, This.Bitmap_Elements[index].Line_Brush_Y2, "0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color,"0x" This.Bitmap_Elements[index].Alpha2 This.Bitmap_Elements[index].Color2, This.Bitmap_Elements[index].Line_Brush_Wrap_Mode)
			else if(This.Bitmap_Elements[index].Brush_Type=4)
				This.Brush1:=Gdip_CreateLineBrushFromRect(This.Bitmap_Elements[index].Grade_Brush_X, This.Bitmap_Elements[index].Grade_Brush_Y, This.Bitmap_Elements[index].Grade_Brush_W, This.Bitmap_Elements[index].Grade_Brush_H,"0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color,"0x" This.Bitmap_Elements[index].Alpha2 This.Bitmap_Elements[index].Color2, This.Bitmap_Elements[index].Grade_Brush_LinearGradientMode, This.Bitmap_Elements[index].Grade_Brush_Wrap_Mode)
		}else if(Save_Flag=1){
			if(This.Bitmap_Elements[index].Brush_Type=1)
				Brush:="`n`tBrush := Gdip_BrushCreateSolid( ""0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color """ )"
			else if(This.Bitmap_Elements[index].Brush_Type=2)
				Brush:="`n`tBrush := Gdip_BrushCreateHatch( ""0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color """ , ""0x" This.Bitmap_Elements[index].Alpha2 This.Bitmap_Elements[index].Color2 """ , " This.Bitmap_Elements[index].Hatch " )"
			else if(This.Bitmap_Elements[index].Brush_Type=3)
				Brush:="`n`tBrush := Gdip_CreateLineBrush( " This.Bitmap_Elements[index].Line_Brush_X1 " , " This.Bitmap_Elements[index].Line_Brush_Y1 " , " This.Bitmap_Elements[index].Line_Brush_X2 " , " This.Bitmap_Elements[index].Line_Brush_Y2 " , ""0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color """ , ""0x" This.Bitmap_Elements[index].Alpha2 This.Bitmap_Elements[index].Color2 """ , " This.Bitmap_Elements[index].Line_Brush_Wrap_Mode " )"
			else if(This.Bitmap_Elements[index].Brush_Type=4)
				Brush:="`n`tBrush := Gdip_CreateLineBrushFromRect( " This.Bitmap_Elements[index].Grade_Brush_X " , " This.Bitmap_Elements[index].Grade_Brush_Y " , " This.Bitmap_Elements[index].Grade_Brush_W " , " This.Bitmap_Elements[index].Grade_Brush_H " , ""0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color """ , ""0x" This.Bitmap_Elements[index].Alpha2 This.Bitmap_Elements[index].Color2 """ , " This.Bitmap_Elements[index].Grade_Brush_LinearGradientMode " , " This.Bitmap_Elements[index].Grade_Brush_Wrap_Mode " )"
			if(This.Bitmap_Elements[index].Notes){
				Notes:="`n`t;" This.Bitmap_Elements[index].Notes
				FileAppend,%Notes%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
				Notes:=""
			}
			FileAppend,%Brush%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Brush:=""
		}
	}
	Create_Pen(Index,Save_Flag){
		if(Save_Flag=0){
			if(This.Bitmap_Elements[index].Brush_Type=1){
				This.Pen1:=New_Pen(This.Bitmap_Elements[index].Color,This.Bitmap_Elements[index].Alpha,This.Bitmap_Elements[index].Thickness)
			}else if(This.Bitmap_Elements[index].Brush_Type=2){
				This.Brush1:=Gdip_BrushCreateHatch("0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color,"0x" This.Bitmap_Elements[index].Alpha2 This.Bitmap_Elements[index].Color2 , This.Bitmap_Elements[index].Hatch)
				This.Pen1:=Gdip_CreatePenFromBrush(This.Brush1,This.Bitmap_Elements[index].Thickness)
				Gdip_DeleteBrush(This.Brush1)
			}else if(This.Bitmap_Elements[index].Brush_Type=3){
				This.Brush1:=Gdip_CreateLineBrush(This.Bitmap_Elements[index].Line_Brush_X1, This.Bitmap_Elements[index].Line_Brush_Y1, This.Bitmap_Elements[index].Line_Brush_X2, This.Bitmap_Elements[index].Line_Brush_Y2, "0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color,"0x" This.Bitmap_Elements[index].Alpha2 This.Bitmap_Elements[index].Color2, This.Bitmap_Elements[index].Line_Brush_Wrap_Mode)
				This.Pen1:=Gdip_CreatePenFromBrush(This.Brush1,This.Bitmap_Elements[index].Thickness)
				Gdip_DeleteBrush(This.Brush1)
			}else if(This.Bitmap_Elements[index].Brush_Type=4){
				This.Brush1:=Gdip_CreateLineBrushFromRect(This.Bitmap_Elements[index].Grade_Brush_X, This.Bitmap_Elements[index].Grade_Brush_Y, This.Bitmap_Elements[index].Grade_Brush_W, This.Bitmap_Elements[index].Grade_Brush_H,"0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color,"0x" This.Bitmap_Elements[index].Alpha2 This.Bitmap_Elements[index].Color2, This.Bitmap_Elements[index].Grade_Brush_LinearGradientMode, This.Bitmap_Elements[index].Grade_Brush_Wrap_Mode)
				This.Pen1:=Gdip_CreatePenFromBrush(This.Brush1,This.Bitmap_Elements[index].Thickness)
				Gdip_DeleteBrush(This.Brush1)
			}
		}else if(Save_Flag=1){
			if(This.Bitmap_Elements[index].Brush_Type=1){
				Pen:="`n`tPen := Gdip_CreatePen( ""0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color """ , " This.Bitmap_Elements[index].Thickness " )"
				Brush:=""
				Delete_Brush:=""
			}else if(This.Bitmap_Elements[index].Brush_Type=2){
				Brush:="`n`tBrush := Gdip_BrushCreateHatch( ""0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color """ , ""0x" This.Bitmap_Elements[index].Alpha2 This.Bitmap_Elements[index].Color2 """ , " This.Bitmap_Elements[index].Hatch " )"
				Pen:=" , Pen := Gdip_CreatePenFromBrush( Brush , " This.Bitmap_Elements[index].Thickness " )"
				Delete_Brush:=" , Gdip_DeleteBrush( Brush )"
			}else if(This.Bitmap_Elements[index].Brush_Type=3){
				Brush:="`n`tBrush := Gdip_CreateLineBrush( " This.Bitmap_Elements[index].Line_Brush_X1 " , " This.Bitmap_Elements[index].Line_Brush_Y1 " , " This.Bitmap_Elements[index].Line_Brush_X2 " , " This.Bitmap_Elements[index].Line_Brush_Y2 " , ""0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color """ , ""0x" This.Bitmap_Elements[index].Alpha2 This.Bitmap_Elements[index].Color2 """ , " This.Bitmap_Elements[index].Line_Brush_Wrap_Mode " )"
				Pen:=" , Pen := Gdip_CreatePenFromBrush( Brush , " This.Bitmap_Elements[index].Thickness " )"
				Delete_Brush:=" , Gdip_DeleteBrush( Brush )"
			}else if(This.Bitmap_Elements[index].Brush_Type=4){
				Brush:="`n`tBrush := Gdip_CreateLineBrushFromRect( " This.Bitmap_Elements[index].Grade_Brush_X " , " This.Bitmap_Elements[index].Grade_Brush_Y " , " This.Bitmap_Elements[index].Grade_Brush_W " , " This.Bitmap_Elements[index].Grade_Brush_H " , ""0x" This.Bitmap_Elements[index].Alpha This.Bitmap_Elements[index].Color """ , ""0x" This.Bitmap_Elements[index].Alpha2 This.Bitmap_Elements[index].Color2 """ , " This.Bitmap_Elements[index].Grade_Brush_LinearGradientMode " , " This.Bitmap_Elements[index].Grade_Brush_Wrap_Mode " )"
				Pen:=" , Pen := Gdip_CreatePenFromBrush( Brush , " This.Bitmap_Elements[index].Thickness " )"
				Delete_Brush:=" , Gdip_DeleteBrush( Brush )"
			}
			FileAppend,%Brush%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Pen%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Brush%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Brush:=""
			Pen:=""
			Delete_Brush:=""
		}
	}
	Add_Picture( index , Save_Flag := 0 ){
		if(Save_Flag=0){
			Gdip_DrawImage( This.Bitmap_G , This.Bitmap_Elements[ index ].PicBitmap , This.Bitmap_Elements[ index ].X , This.Bitmap_Elements[index].Y , This.Bitmap_Elements[index].W , This.Bitmap_Elements[index].H , This.Bitmap_Elements[index].SourceX , This.Bitmap_Elements[index].SourceY , This.Bitmap_Elements[index].SourceW , This.Bitmap_Elements[index].SourceH)
		}else if(Save_Flag=1){
			temp := "`n`tpicBitmap := Gdip_CreateBitmapFromFile( """ This.Bitmap_Elements[ index ].Path """ )"
			Temp.= " , Gdip_DrawImage( G , picBitmap , " This.Bitmap_Elements[ index ].X " , " This.Bitmap_Elements[index].Y " , " This.Bitmap_Elements[index].W " , " This.Bitmap_Elements[index].H " , " This.Bitmap_Elements[index].SourceX " , " This.Bitmap_Elements[index].SourceY " , " This.Bitmap_Elements[index].SourceW " , " This.Bitmap_Elements[index].SourceH " )"
			Temp.= " , Gdip_DisposeImage( picBitmap )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Temp := ""
		}
	}
	Fill_Rectangle(index,Save_Flag:=0){
		This.Create_Brush(index,Save_Flag)
		if(Save_Flag=0){
			Fill_Box(This.Bitmap_G,This.Brush1,This.Bitmap_Elements[index].X,This.Bitmap_Elements[index].Y,This.Bitmap_Elements[index].W,This.Bitmap_Elements[index].H)
			Gdip_DeleteBrush(This.Brush1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_FillRectangle( G , Brush , " This.Bitmap_Elements[index].X " , " This.Bitmap_Elements[index].Y " , "This.Bitmap_Elements[index].W " , " This.Bitmap_Elements[index].H " )"
			Delete_Brush:=" , Gdip_DeleteBrush( Brush )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Brush%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Brush:=""
			Temp:=""
		}
	}
	Fill_Rounded_Rectangle(index,Save_Flag:=0){
		This.Create_Brush(index,Save_Flag)
		if(Save_Flag=0){
			Gdip_FillRoundedRectangle(This.Bitmap_G,This.Brush1,This.Bitmap_Elements[index].X,This.Bitmap_Elements[index].Y,This.Bitmap_Elements[index].W,This.Bitmap_Elements[index].H, This.Bitmap_Elements[index].Radius)
			Gdip_DeleteBrush(This.Brush1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_FillRoundedRectangle( G , Brush , " This.Bitmap_Elements[index].X " , " This.Bitmap_Elements[index].Y " , " This.Bitmap_Elements[index].W " , " This.Bitmap_Elements[index].H " , " This.Bitmap_Elements[index].Radius " )"
			Delete_Brush:=" , Gdip_DeleteBrush( Brush )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Brush%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Brush:=""
			Temp:=""
		}
	}
	Fill_Circle(index,Save_Flag:=0){
		This.Create_Brush(index,Save_Flag)
		if(Save_Flag=0){
			Gdip_FillEllipse(This.Bitmap_G,This.Brush1,This.Bitmap_Elements[index].X,This.Bitmap_Elements[index].Y,This.Bitmap_Elements[index].W,This.Bitmap_Elements[index].H)
			Gdip_DeleteBrush(This.Brush1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_FillEllipse( G , Brush , " This.Bitmap_Elements[index].X " , " This.Bitmap_Elements[index].Y " , " This.Bitmap_Elements[index].W " , " This.Bitmap_Elements[index].H " )"
			Delete_Brush:=" , Gdip_DeleteBrush( Brush )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Brush%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Brush:=""
			Temp:=""
		}
	}
	Fill_Pie(index,Save_Flag:=0){
		This.Create_Brush(index,Save_Flag)
		if(Save_Flag=0){
			Gdip_FillPie(This.Bitmap_G,This.Brush1,This.Bitmap_Elements[index].X,This.Bitmap_Elements[index].Y,This.Bitmap_Elements[index].W,This.Bitmap_Elements[index].H, This.Bitmap_Elements[index].Start_Angle, This.Bitmap_Elements[index].End_Angle)
			Gdip_DeleteBrush(This.Brush1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_FillPie( G , Brush , " This.Bitmap_Elements[index].X " , " This.Bitmap_Elements[index].Y " , " This.Bitmap_Elements[index].W " , " This.Bitmap_Elements[index].H " , " This.Bitmap_Elements[index].Start_Angle " , " This.Bitmap_Elements[index].End_Angle " )"
			Delete_Brush:=" , Gdip_DeleteBrush( Brush )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Brush%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Brush:=""
			Temp:=""
		}
	}
	Fill_Polygon(index,Save_Flag:=0){
		;~ ToolTip,% This.Bitmap_Elements[index].Polygon_List " here"
		This.Create_Brush(index,Save_Flag)
		if(Save_Flag=0){
			Gdip_FillPolygon(This.Bitmap_G,This.Brush1, This.Bitmap_Elements[index].Polygon_List) ;, FillMode=0)
			Gdip_DeleteBrush(This.Brush1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_FillPolygon( G , Brush , """ This.Bitmap_Elements[index].Polygon_List """ )"
			Delete_Brush:=" , Gdip_DeleteBrush( Brush )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Brush%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Brush:=""
			Temp:=""
		}

	}
	Text(Index,Save_Flag:=0){
		This.Create_Brush(index,Save_Flag)
		if(Save_Flag=0){
			Gdip_TextToGraphics(This.Bitmap_G, This.Bitmap_Elements[index].Text , This.Bitmap_Elements[index].Options " c" This.Brush1 " x" This.Bitmap_Elements[index].X " y" This.Bitmap_Elements[index].Y , This.Bitmap_Elements[index].Font , This.Bitmap_Elements[index].W , This.Bitmap_Elements[index].H )
		}else if(Save_Flag=1){
			if(This.Bitmap_Elements[index].Notes){
				Notes:="`n`t;" This.Bitmap_Elements[index].Notes
				FileAppend,%Notes%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
				Notes:=""
			}
			Temp:=" , Gdip_TextToGraphics( G , """ This.Bitmap_Elements[index].Text """ , """ This.Bitmap_Elements[index].Options " c"" Brush "" x" This.Bitmap_Elements[index].X " y" This.Bitmap_Elements[index].Y """ , """ This.Bitmap_Elements[index].Font """ , " This.Bitmap_Elements[index].W " , " This.Bitmap_Elements[index].H " )"
			Delete_Brush:=" , Gdip_DeleteBrush( Brush )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Brush%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Brush:=""
			Temp:=""
		}
	}
	Draw_Rectangle(Index,Save_Flag:=0){
		This.Create_Pen(Index,Save_Flag)
		if(Save_Flag=0){
			Gdip_DrawRectangle(This.Bitmap_G,This.Pen1,This.Bitmap_Elements[index].X,This.Bitmap_Elements[index].Y,This.Bitmap_Elements[index].W,This.Bitmap_Elements[index].H)
			Gdip_DeletePen(This.Pen1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_DrawRectangle( G , Pen , " This.Bitmap_Elements[index].X " , " This.Bitmap_Elements[index].Y " , " This.Bitmap_Elements[index].W " , " This.Bitmap_Elements[index].H " )"
			Delete_Pen:=" , Gdip_DeletePen( Pen )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Pen%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Pen:=""
			Temp:=""
		}
	}
	Draw_Rounded_Rectangle(index,Save_Flag:=0){
		This.Create_Pen(Index,Save_Flag)
		if(Save_Flag=0){
			Gdip_DrawRoundedRectangle(This.Bitmap_G,This.Pen1,This.Bitmap_Elements[index].X,This.Bitmap_Elements[index].Y,This.Bitmap_Elements[index].W,This.Bitmap_Elements[index].H, This.Bitmap_Elements[index].Radius)
			Gdip_DeletePen(This.Pen1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_DrawRoundedRectangle( G , Pen , " This.Bitmap_Elements[index].X " , " This.Bitmap_Elements[index].Y " , " This.Bitmap_Elements[index].W " , " This.Bitmap_Elements[index].H " , " This.Bitmap_Elements[index].Radius " )"
			Delete_Pen:=" , Gdip_DeletePen( Pen )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Pen%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Pen:=""
			Temp:=""
		}
	}
	Draw_Circle(index,Save_Flag:=0){
		This.Create_Pen(Index,Save_Flag)
		if(Save_Flag=0){
			Gdip_DrawEllipse(This.Bitmap_G,This.Pen1,This.Bitmap_Elements[index].X,This.Bitmap_Elements[index].Y,This.Bitmap_Elements[index].W,This.Bitmap_Elements[index].H)
			Gdip_DeletePen(This.Pen1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_DrawEllipse( G , Pen , " This.Bitmap_Elements[index].X " , " This.Bitmap_Elements[index].Y " , " This.Bitmap_Elements[index].W " , " This.Bitmap_Elements[index].H " )"
			Delete_Pen:=" , Gdip_DeletePen( Pen )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Pen%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Pen:=""
			Temp:=""
		}
	}
	Draw_Line(index,Save_Flag:=0){
		This.Create_Pen(Index,Save_Flag)
		if(Save_Flag=0){
			Gdip_DrawLine(This.Bitmap_G,This.Pen1,This.Bitmap_Elements[index].X,This.Bitmap_Elements[index].Y,This.Bitmap_Elements[index].X2,This.Bitmap_Elements[index].Y2)
			Gdip_DeletePen(This.Pen1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_DrawLine( G , Pen , " This.Bitmap_Elements[index].X " , " This.Bitmap_Elements[index].Y " , " This.Bitmap_Elements[index].X2 " , " This.Bitmap_Elements[index].Y2 " )"
			Delete_Pen:=" , Gdip_DeletePen( Pen )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Pen%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Pen:=""
			Temp:=""
		}
	}
	Draw_Lines(index,Save_Flag:=0){
		This.Create_Pen(Index,Save_Flag)
		if(Save_Flag=0){
			Gdip_DrawLines(This.Bitmap_G,This.Pen1,This.Bitmap_Elements[index].Lines_List)
			Gdip_DeletePen(This.Pen1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_DrawLines( G , Pen , """ This.Bitmap_Elements[index].Lines_List """ )"
			Delete_Pen:=" , Gdip_DeletePen( Pen )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Pen%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Pen:=""
			Temp:=""
		}
	}
	Draw_Arc(index,Save_Flag:=0){
		This.Create_Pen(Index,Save_Flag)
		if(Save_Flag=0){
			Gdip_DrawArc(This.Bitmap_G,This.Pen1,This.Bitmap_Elements[index].X,This.Bitmap_Elements[index].Y,This.Bitmap_Elements[index].W,This.Bitmap_Elements[index].H, This.Bitmap_Elements[index].Start_Angle, This.Bitmap_Elements[index].End_Angle)
			Gdip_DeletePen(This.Pen1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_DrawArc( G , Pen , " This.Bitmap_Elements[index].X " , " This.Bitmap_Elements[index].Y " , " This.Bitmap_Elements[index].W " , " This.Bitmap_Elements[index].H " , " This.Bitmap_Elements[index].Start_Angle " , " This.Bitmap_Elements[index].End_Angle " )"
			Delete_Pen:=" , Gdip_DeletePen( Pen )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Pen%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Pen:=""
			Temp:=""
		}
	}
	Draw_Pie(index,Save_Flag:=0){
		This.Create_Pen(Index,Save_Flag)
		if(Save_Flag=0){
			Gdip_DrawPie(This.Bitmap_G,This.Pen1,This.Bitmap_Elements[index].X,This.Bitmap_Elements[index].Y,This.Bitmap_Elements[index].W,This.Bitmap_Elements[index].H, This.Bitmap_Elements[index].Start_Angle, This.Bitmap_Elements[index].End_Angle)
			Gdip_DeletePen(This.Pen1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_DrawPie( G , Pen , " This.Bitmap_Elements[index].X " , " This.Bitmap_Elements[index].Y " , " This.Bitmap_Elements[index].W " , " This.Bitmap_Elements[index].H " , " This.Bitmap_Elements[index].Start_Angle " , " This.Bitmap_Elements[index].End_Angle " )"
			Delete_Pen:=" , Gdip_DeletePen( Pen )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Pen%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Pen:=""
			Temp:=""
		}
	}
	Draw_Bezier(index,Save_Flag:=0){
		This.Create_Pen(Index,Save_Flag)
		if(Save_Flag=0){
			Gdip_DrawBezier(This.Bitmap_G,This.Pen1,This.Bitmap_Elements[index].X,This.Bitmap_Elements[index].Y, This.Bitmap_Elements[index].x2, This.Bitmap_Elements[index].y2, This.Bitmap_Elements[index].x3, This.Bitmap_Elements[index].y3, This.Bitmap_Elements[index].x4, This.Bitmap_Elements[index].y4)
			Gdip_DeletePen(This.Pen1)
			This.Move()
		}else if(Save_Flag=1){
			Temp:=" , Gdip_DrawBezier( G , Pen , " This.Bitmap_Elements[index].X " , " This.Bitmap_Elements[index].Y " , " This.Bitmap_Elements[index].x2 " , " This.Bitmap_Elements[index].y2 " , " This.Bitmap_Elements[index].x3 " , " This.Bitmap_Elements[index].y3 " , " This.Bitmap_Elements[index].x4 " , " This.Bitmap_Elements[index].y4 " )"
			Delete_Pen:=" , Gdip_DeletePen( Pen )"
			FileAppend,%Temp%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			FileAppend,%Delete_Pen%,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%Name_To_Save_Files%.txt
			Delete_Pen:=""
			Temp:=""
		}
	}
}

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;    Bitmap Control Panel Class
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
class Bitmap_Info_Control_Panel	{
	Create_Bitmap_Control_Panel(){
		Gui,17:Destroy
		Gui,17:+Parent16 -Caption +AlwaysOnTop -DPIScale
		Gui,17:Color,333333,444444
		Gui,17:Font,cWhite s8 q5, Segoe UI
	}
	Show_Bitmap_Control_Panel(){
		Gui,17:Show,x3 y3 w346 h197
	}
	Bitmap_Position_Controls(){
		global
		Gui,17:Add,Button,x45 y10 w60 h25 -Theme Disabled vBit_Up gMove_Bitmap,Up
		Gui,17:Add,Button,x10 y+5 w60 h25 -Theme Disabled vBit_Left gMove_Bitmap,Left
		Gui,17:Add,Button,x+10 yp w60 h25 -Theme Disabled vBit_Right gMove_Bitmap,Right
		Gui,17:Add,Button,x45 y+5 w60 h25 -Theme Disabled vBit_Down gMove_Bitmap,Down

		Gui,17:Add,Button,x210 y10 w60 h25 -Theme Disabled vBit_Minus_Height gAdjust_Bitmap_Width_Height,- Height
		Gui,17:Add,Button,x175 y+5 w60 h25 -Theme Disabled vBit_Minus_Width gAdjust_Bitmap_Width_Height,- Width
		Gui,17:Add,Button,x+10 yp w60 h25 -Theme Disabled vBit_Plus_Width gAdjust_Bitmap_Width_Height,+ Width
		Gui,17:Add,Button,x210 y+5 w60 h25 -Theme Disabled vBit_Plus_Height gAdjust_Bitmap_Width_Height,+ Height

	}
	Bitmap_Position_Details(obj){
		global
		Gui,17:Add,Text,x10 y+10 w25 h20 0x200,X :
		Gui,17:Add,Edit,x+5 yp w40 h20 Center Disabled -E0x200 vSet_Bit_X gSubmit_17,% obj.X
		Gui,17:Add,Text,x+10 yp w25 h20 0x200,Y :
		Gui,17:Add,Edit,x+5 yp w40 h20 Center Disabled -E0x200 vSet_Bit_Y gSubmit_17,% obj.Y
		Gui,17:Add,Text,x+10 yp w25 h20 0x200,W :
		Gui,17:Add,Edit,x+5 yp w40 h20 Center Disabled -E0x200 vSet_Bit_W gSubmit_17,% obj.W
		Gui,17:Add,Text,x+10 yp w25 h20 0x200,H :
		Gui,17:Add,Edit,x+5 yp w40 h20 Center Disabled -E0x200 vSet_Bit_H gSubmit_17,% obj.H
	}
	Bitmap_Zoom(obj){
		global
		Gui,17:Add,Text,x10 y+10 w30 h20 0x200,���� ;Zoom :
		Gui,17:Add,DDL,x+10 yp w100 r10 -Theme Disabled vZoom_Level gSubmit_17,.25|.50|.75|1.00|1.25|1.50|1.75|2.00|3.00|4.00|5.00|6.00|7.00|8.00|9.00|10.00|15.00|20.00|
		GuiControl,17:Choose,Zoom_Level,% Bitmap_Array[Active_Bitmap].Zoom
	}
	Bitmap_Lock(){
		global
		Gui,17:Add,Checkbox,x140 y5 h25 vBitmap_Control_Lock gUnlock_Bitmap_Controls,���� ;Unlock
	}
	Bitmap_Smoothing(){
		global
		Gui,17:Add,Text,x160 y135 w30 h20 0x200,ƽ�� ;Smoothing :
		Gui,17:Add,DDL,x+10 yp w100 r5 -Theme Disabled vBitmap_Smoothing gSubmit_17,0|1|2|3|4|
		GuiControl,17:Choose,Bitmap_Smoothing,% Bitmap_Array[Active_Bitmap].Smoothing+1
	}
}

Set_LineBrush_Positions(){
	isPressed:=0,Set:=0
	CoordMode,Mouse,Client
	While(!GetKeyState("Alt")){
		if(!Set&&!isPressed){
			MouseGetPos,tcx,tcy
			tcx:=floor((tcx-Bitmap_Array[Active_Bitmap].X)/Bitmap_Array[Active_Bitmap].Zoom)
			tcy:=floor((tcy-(Bitmap_Array[Active_Bitmap].Y+40))/Bitmap_Array[Active_Bitmap].Zoom)
			ԭ�� := "Press ""Shift"" to set a position`nPress ""ctrl"" to switch between sets`nPress ""Alt"" to finish`nCurrent Set: "
			���� := "���� Shift ����λ��`n���� Ctrl ����֮���л�`n���� Alt �˳�`n ��ǰ����: "
			ToolTip,% ���� Set+1 "`nX1: " tcx " Y1: " tcy
			if(GetKeyState("Shift")&&!isPressed){
				isPressed:=1
				Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Line_Brush_X1:=tcx
				Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Line_Brush_Y1:=tcy
				GuiControl,14:,Line_Brush_X1,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Line_Brush_X1
				GuiControl,14:,Line_Brush_Y1,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Line_Brush_Y1
			}else if(GetKeyState("ctrl")&&!isPressed){
				isPressed:=1
				Set:=1
			}
		}else if(Set&&!isPressed){
			MouseGetPos,tcx,tcy
			tcx:=floor((tcx-Bitmap_Array[Active_Bitmap].X)/Bitmap_Array[Active_Bitmap].Zoom)
			tcy:=floor((tcy-(Bitmap_Array[Active_Bitmap].Y+40))/Bitmap_Array[Active_Bitmap].Zoom)
			ԭ�� := "Press ""Shift"" to set a position`nPress ""ctrl"" to switch between sets`nPress ""Alt"" to finish`nCurrent Set: "
			���� := "���� Shift ����λ��`n���� Ctrl ����֮���л�`n���� Alt �˳�`n ��ǰ����: "
			ToolTip,% ���� Set+1 "`nX2: " tcx " Y2: " tcy
			if(GetKeyState("Shift")&&!isPressed){
				isPressed:=1
				Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Line_Brush_X2:=tcx
				Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Line_Brush_Y2:=tcy
				GuiControl,14:,Line_Brush_X2,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Line_Brush_X2
				GuiControl,14:,Line_Brush_Y2,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Line_Brush_Y2
			}else if(GetKeyState("ctrl")&&!isPressed){
				isPressed:=1
				Set:=0
			}
		}else if(isPressed&&!GetKeyState("Shift")&&!GetKeyState("ctrl")){
			isPressed:=0
		}
		if(GetKeyState("Up"))
			MouseMove,0,-1,,R
		else if(GetKeyState("Down"))
			MouseMove,0,1,,R
		else if(GetKeyState("Left"))
			MouseMove,-1,0,,R
		else if(GetKeyState("Right"))
			MouseMove,1,0,,R
	}
	ToolTip,
}

Set_GradeBrush_Positions(){
	isPressed:=0,Set:=0
	CoordMode,Mouse,Client
	While(!GetKeyState("Alt")){
		if(!Set&&!isPressed){
			MouseGetPos,tcx,tcy
			tcx:=floor((tcx-Bitmap_Array[Active_Bitmap].X)/Bitmap_Array[Active_Bitmap].Zoom)
			tcy:=floor((tcy-(Bitmap_Array[Active_Bitmap].Y+40))/Bitmap_Array[Active_Bitmap].Zoom)
			ԭ�� := "Press ""Shift"" to set a position`nPress ""ctrl"" to switch between sets`nPress ""Alt"" to finish`nCurrent Set: "
			���� := "���� Shift ����λ��`n���� Ctrl ����֮���л�`n���� Alt �˳�`n ��ǰ����: "
			ToolTip,% ���� Set+1 "`nX: " tcx " Y: " tcy
			if(GetKeyState("Shift")&&!isPressed){
				isPressed:=1
				Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Grade_Brush_X:=tcx
				Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Grade_Brush_Y:=tcy
				GuiControl,14:,Grade_Brush_X,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Grade_Brush_X
				GuiControl,14:,Grade_Brush_Y,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Grade_Brush_Y

			}else if(GetKeyState("ctrl")&&!isPressed){
				isPressed:=1
				Set:=1
			}
		}else if(Set&&!isPressed){
			MouseGetPos,tcx,tcy
			tcx:=floor((tcx-(Bitmap_Array[Active_Bitmap].X+Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Grade_Brush_X))/Bitmap_Array[Active_Bitmap].Zoom)
			tcy:=floor((tcy-(Bitmap_Array[Active_Bitmap].Y+40+Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Grade_Brush_Y))/Bitmap_Array[Active_Bitmap].Zoom)
			ԭ�� := "Press ""Shift"" to set a position`nPress ""ctrl"" to switch between sets`nPress ""Alt"" to finish`nCurrent Set: "
			���� := "���� Shift ����λ��`n���� Ctrl ����֮���л�`n���� Alt �˳�`n ��ǰ����: "
			ToolTip,% ���� Set+1 "`nW: " tcx " H: " tcy
			if(GetKeyState("Shift")&&!isPressed){
				isPressed:=1
				Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Grade_Brush_W:=tcx
				Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Grade_Brush_H:=tcy
				GuiControl,14:,Grade_Brush_W,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Grade_Brush_W
				GuiControl,14:,Grade_Brush_H,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Grade_Brush_H
			}else if(GetKeyState("ctrl")&&!isPressed){
				isPressed:=1
				Set:=0
			}
		}else if(isPressed&&!GetKeyState("Shift")&&!GetKeyState("ctrl")){
			isPressed:=0
		}
		if(GetKeyState("Up"))
			MouseMove,0,-1,,R
		else if(GetKeyState("Down"))
			MouseMove,0,1,,R
		else if(GetKeyState("Left"))
			MouseMove,-1,0,,R
		else if(GetKeyState("Right"))
			MouseMove,1,0,,R
	}
	ToolTip,
}

Adjust_Bitmap_Width_Height(){
	if(A_GuiControl="Bit_Minus_Width"){
		if(GetKeyState("Shift")&&Bitmap_Array[Active_Bitmap].W>10){
			Bitmap_Array[Active_Bitmap].W-=10
		}else if(Bitmap_Array[Active_Bitmap].W>1){
			Bitmap_Array[Active_Bitmap].W-=1
		}
	}else if(A_GuiControl="Bit_Plus_Width"){
		if(GetKeyState("Shift")){
			Bitmap_Array[Active_Bitmap].W+=10
		}else	{
			Bitmap_Array[Active_Bitmap].W+=1
		}
	}else if(A_GuiControl="Bit_Minus_Height"){
		if(GetKeyState("Shift")&&Bitmap_Array[Active_Bitmap].H>10){
			Bitmap_Array[Active_Bitmap].H-=10
		}else if(Bitmap_Array[Active_Bitmap].H>1){
			Bitmap_Array[Active_Bitmap].H-=1
		}
	}else if(A_GuiControl="Bit_Plus_Height"){
		if(GetKeyState("Shift")){
			Bitmap_Array[Active_Bitmap].H+=10
		}else	{
			Bitmap_Array[Active_Bitmap].H+=1
		}
	}
	GuiControl,4:Move,% Bitmap_Array[Active_Bitmap].Name,% "w" Bitmap_Array[Active_Bitmap].W*Bitmap_Array[Active_Bitmap].Zoom " h" Bitmap_Array[Active_Bitmap].H*Bitmap_Array[Active_Bitmap].Zoom
	GuiControl,17:,Set_Bit_H,% Bitmap_Array[Active_Bitmap].H
	GuiControl,17:,Set_Bit_W,% Bitmap_Array[Active_Bitmap].W
	Bitmap_Array[Active_Bitmap].Zoom_Bitmap()
	if(Auto_Draw){
		SetTimer,Force_Draw,-10
	}
	Loop,% Bitmap_Array.Length()
		Bitmap_Array[A_Index].move()
}

Move_Bitmap(){
	if(A_GuiControl="Bit_Up"){
		if(GetKeyState("Shift")){
			Bitmap_Array[Active_Bitmap].Y-=10
		}else	{
			Bitmap_Array[Active_Bitmap].Y-=1
		}
	}else if(A_GuiControl="Bit_Left"){
		if(GetKeyState("Shift")){
			Bitmap_Array[Active_Bitmap].X-=10
		}else	{
			Bitmap_Array[Active_Bitmap].X-=1
		}
	}else if(A_GuiControl="Bit_Right"){
		if(GetKeyState("Shift")){
			Bitmap_Array[Active_Bitmap].X+=10
		}else	{
			Bitmap_Array[Active_Bitmap].X+=1
		}
	}else if(A_GuiControl="Bit_Down"){
		if(GetKeyState("Shift")){
			Bitmap_Array[Active_Bitmap].Y+=10
		}else	{
			Bitmap_Array[Active_Bitmap].Y+=1
		}
	}
	GuiControl,4:Move,% Bitmap_Array[Active_Bitmap].Name,% "x" Bitmap_Array[Active_Bitmap].X " y" Bitmap_Array[Active_Bitmap].Y
	GuiControl,17:,Set_Bit_X,% Bitmap_Array[Active_Bitmap].X
	GuiControl,17:,Set_Bit_Y,% Bitmap_Array[Active_Bitmap].Y
	Loop,% Bitmap_Array.Length()
		Bitmap_Array[A_Index].move()
	if(Auto_Draw){
		SetTimer,Force_Draw,-10
	}
}

RePosition_Polygon_Element(){
	; ToolTip,Here
}

Add_New_Polygon_Point(){
	isPressed:=""
	CoordMode,Mouse,Client
	While(!GetKeyState("ctrl")){
		MouseGetPos,polyX,polyY
		ԭ�� := "Move your cursor to where you want to add the point and then press ""Shift"" `nPress ""Ctrl"" To Finish`n"
		���� := "������ƶ���Ҫ���ӵ��λ��,Ȼ���� Shift`n���� Ctrl �˳�`n"
		ToolTip,% ���� floor((polyX-Bitmap_Array[Active_Bitmap].X)/Bitmap_Array[Active_Bitmap].Zoom) "`n" floor((polyY-(Bitmap_Array[Active_Bitmap].Y+40))/Bitmap_Array[Active_Bitmap].Zoom)
		If(GetKeyState("Shift")&&!isPressed){
			isPressed:=1
			MouseGetPos,polyX,polyY
			polyX-=Bitmap_Array[Active_Bitmap].X
			polyY-=(Bitmap_Array[Active_Bitmap].Y+40)
			polyX:=floor(polyX/Bitmap_Array[Active_Bitmap].Zoom)
			polyY:=floor(polyY/Bitmap_Array[Active_Bitmap].Zoom)
			Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Polygon_List.=polyX "," polyY "|"
			GuiControl,13:,Polygon_List,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Polygon_List
		}else if(!GetKeyState("Shift")&&isPressed){
			isPressed:=0
		}
		if(GetKeyState("Up"))
			MouseMove,0,-1,,R
		else if(GetKeyState("Down"))
			MouseMove,0,1,,R
		else if(GetKeyState("Left"))
			MouseMove,-1,0,,R
		else if(GetKeyState("Right"))
			MouseMove,1,0,,R
	}
	ToolTip,
	GuiControl,13:,Polygon_List,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Polygon_List
}

Add_New_Lines_Point(){
	isPressed:=""
	CoordMode,Mouse,Client
	While(!GetKeyState("ctrl")){
		MouseGetPos,polyX,polyY
		ԭ�� := "Move your cursor to where you want to add the point and then press ""Shift"" `nPress ""Ctrl"" To Finish`n"
		���� := "������ƶ���Ҫ���ӵ��λ��,Ȼ���� Shift`n���� Ctrl �˳�`n"
		ToolTip,% ���� floor((polyX-Bitmap_Array[Active_Bitmap].X)/Bitmap_Array[Active_Bitmap].Zoom) "`n" floor((polyY-(Bitmap_Array[Active_Bitmap].Y+40))/Bitmap_Array[Active_Bitmap].Zoom)
		If(GetKeyState("Shift")&&!isPressed){
			isPressed:=1
			MouseGetPos,polyX,polyY
			polyX-=Bitmap_Array[Active_Bitmap].X
			polyY-=(Bitmap_Array[Active_Bitmap].Y+40)
			polyX:=floor(polyX/Bitmap_Array[Active_Bitmap].Zoom)
			polyY:=floor(polyY/Bitmap_Array[Active_Bitmap].Zoom)
			Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Lines_List.=polyX "," polyY "|"
			GuiControl,13:,Lines_List,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Lines_List
		}else if(!GetKeyState("Shift")&&isPressed){
			isPressed:=0
		}
		if(GetKeyState("Up"))
			MouseMove,0,-1,,R
		else if(GetKeyState("Down"))
			MouseMove,0,1,,R
		else if(GetKeyState("Left"))
			MouseMove,-1,0,,R
		else if(GetKeyState("Right"))
			MouseMove,1,0,,R
	}
	ToolTip,
	GuiControl,13:,Polygon_List,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Polygon_List
}

Clear_Points(){
	Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Lines_List:=""
	Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Polygon_List:=""
	GuiControl,13:,Lines_List,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Lines_List
	GuiControl,13:,Polygon_List,% Bitmap_Array[Active_Bitmap].BitMap_Elements[Active_Element].Polygon_List
}

Unlock_Bitmap_Controls(){
	GuiControlGet,Bitmap_Control_Lock,17:,Bitmap_Control_Lock
	if(Bitmap_Control_Lock){
		Guicontrol,17:Enable,Bit_Up
		Guicontrol,17:Enable,Bit_Down
		Guicontrol,17:Enable,Bit_Left
		Guicontrol,17:Enable,Bit_Right
		Guicontrol,17:Enable,Bit_Minus_Width
		Guicontrol,17:Enable,Bit_Plus_Width
		Guicontrol,17:Enable,Bit_Minus_Height
		Guicontrol,17:Enable,Bit_Plus_Height
		Guicontrol,17:Enable,Set_Bit_W
		Guicontrol,17:Enable,Set_Bit_H
		Guicontrol,17:Enable,Set_Bit_X
		Guicontrol,17:Enable,Set_Bit_Y
		Guicontrol,17:Enable,Zoom_Level
		Guicontrol,17:Enable,Bitmap_Smoothing
	}else	{
		Guicontrol,17:Disable,Bit_Up
		Guicontrol,17:Disable,Bit_Down
		Guicontrol,17:Disable,Bit_Left
		Guicontrol,17:Disable,Bit_Right
		Guicontrol,17:Disable,Bit_Minus_Width
		Guicontrol,17:Disable,Bit_Plus_Width
		Guicontrol,17:Disable,Bit_Minus_Height
		Guicontrol,17:Disable,Bit_Plus_Height
		Guicontrol,17:Disable,Set_Bit_W
		Guicontrol,17:Disable,Set_Bit_H
		Guicontrol,17:Disable,Set_Bit_X
		Guicontrol,17:Disable,Set_Bit_Y
		Guicontrol,17:Disable,Zoom_Level
		Guicontrol,17:Disable,Bitmap_Smoothing
	}
}

Submit_Defaults(){
	Gui,9:Submit,NoHide
	For k, v in Default_Values
		Default_Values[k]:=%k%
	GuiControl,5:,New_Bitmap_X,% Default_Values.Default_Bitmap_X
	GuiControl,5:,New_Bitmap_Y,% Default_Values.Default_Bitmap_Y
	GuiControl,5:,New_Bitmap_W,% Default_Values.Default_Bitmap_W
	GuiControl,5:,New_Bitmap_H,% Default_Values.Default_Bitmap_H
	GuiControl,5:,New_Bitmap_Smoothing,% Default_Values.Default_Bitmap_Smoothing
}

Submit_17:
	Gui,17:Submit,NoHide
	Bitmap_Array[Active_Bitmap].X:=Set_Bit_X
	Bitmap_Array[Active_Bitmap].Y:=Set_Bit_Y
	Bitmap_Array[Active_Bitmap].W:=Set_Bit_W
	Bitmap_Array[Active_Bitmap].H:=Set_Bit_H
	Bitmap_Array[Active_Bitmap].Zoom:=Zoom_Level
	Bitmap_Array[Active_Bitmap].Smoothing:=Bitmap_Smoothing
	Bitmap_Array[Active_Bitmap].Zoom_Bitmap()
	GuiControl,4:Move,% Bitmap_Array[Active_Bitmap].Name,% "x" Bitmap_Array[Active_Bitmap].X " y" Bitmap_Array[Active_Bitmap].Y " w" Bitmap_Array[Active_Bitmap].W*Bitmap_Array[Active_Bitmap].Zoom " h" Bitmap_Array[Active_Bitmap].H*Bitmap_Array[Active_Bitmap].Zoom
	Move_Bitmap()
	if(Auto_Draw){
		SetTimer,Force_Draw,-10
	}
return

Dump_Name_In_Name_To_Save_Edit(){
	GuiControlGet,List_Of_Existing_Saves,7:,List_Of_Existing_Saves
	GuiControl,7:,Name_To_Save_Files,% List_Of_Existing_Saves
}

Delete_Bitmap(){
	GuiControlGet,List_Of_Saved_Bitmaps,6:,List_Of_Saved_Bitmaps
	FileDelete,%List_Of_Saved_Bitmaps%.ini
	FileDelete,%A_ScriptDir%\HB Bitmap Maker Folder\Saved Bitmaps Functions\%List_Of_Saved_Bitmaps%.txt
	Load_Saved_Bitmap_List()
	SoundBeep,700
	TrayTip,,Done

}

Unlock_Delete_Bitmap(){
	Unlock_Delete_Button:=!Unlock_Delete_Button
	if(Unlock_Delete_Button)
		GuiControl,6:Enable,Delete_Bitmap_Button
	else
		GuiControl,6:Disable,Delete_Bitmap_Button
}

Move_Graphics(){
	CoordMode,Mouse,Client
	While(Getkeystate("LButton")){
		MouseGetPos,x,y
		y-=40
		GuiControl,4:Move,%A_GuiControl%,% "x" x " y" y
		Loop,% Bitmap_Array.Length()	{
			if(Bitmap_Array[A_Index].Name=A_GuiControl){
				Bitmap_Array[A_Index].X:=x
				Bitmap_Array[A_Index].Y:=y
				Loop,% Bitmap_Array.Length()
					Bitmap_Array[A_Index].move()
				break
			}
		}
	}
	Loop,% Bitmap_Array.Length()
		Bitmap_Array[A_Index].move()
	if(Bitmap_Array[Active_Bitmap].Name=A_GuiControl){
		GuiControl,17:,Set_Bit_X,% Bitmap_Array[Active_Bitmap].X
		GuiControl,17:,Set_Bit_Y,% Bitmap_Array[Active_Bitmap].Y
		GuiControl,17:,Set_Bit_W,% Bitmap_Array[Active_Bitmap].W
		GuiControl,17:,Set_Bit_H,% Bitmap_Array[Active_Bitmap].H
	}
}

Unlock_Element_Remove(){
	static ElementLock
	ElementLock:=!ElementLock
	if(ElementLock){
		GuiControl,8:Enable,Element_Remove_Button
	}else	{
		GuiControl,8:Disable,Element_Remove_Button
	}
}

2GuiContextMenu(){
	static Tog2
	Tog2:=!Tog2
	if(!Tog2)
		Gui,2:Show,% "x0 y0 w300 h" Windows.H
	else
		Gui,2:Show,% "x-280 y0 w300 h" Windows.H
	Loop,% Bitmap_Array.Length()
		Bitmap_Array[A_Index].move()
}

3GuiContextMenu(){
	static Tog3
	Tog3:=!Tog3
	if(!Tog3)
		Gui,3:Show,% "x" Windows.W-300 " y0 w300 h" Windows.H
	else
		Gui,3:Show,% "x" Windows.W-20 " y0 w300 h" Windows.H
	Loop,% Bitmap_Array.Length()
		Bitmap_Array[A_Index].move()
}

11GuiContextMenu(){
	static Tog11
	Tog11:=!Tog11
	if(!Tog11)
		Gui,11:Show,x780 y500 w250 h200
	else
		Gui,11:Show,x780 y680 w250 h200
	Loop,% Bitmap_Array.Length()
		Bitmap_Array[A_Index].move()
}

16GuiContextMenu(){
	static Tog16
	Tog16:=!Tog16
	if(!Tog16)
		Gui,16:Show,x320 y500 w350 h200
	else
		Gui,16:Show,x320 y680 w350 h200
	Loop,% Bitmap_Array.Length()
		Bitmap_Array[A_Index].move()
}

Swap_Tabs(){
	if(A_GuiControl="Tab1"){
		Gui,5:Show ;,x10 y70 w300 h500
		Gui,6:Hide
		Gui,7:Hide
		GuiControl,2:+Background3399FF,Tab1_Background
		GuiControl,2:+Background777777,Tab2_Background
		GuiControl,2:+Background777777,Tab3_Background
	}else if(A_GuiControl="Tab2"){
		Gui,5:Hide
		Gui,6:Show ;,x10 y70 w300 h500
		Gui,7:Hide
		GuiControl,2:+Background777777,Tab1_Background
		GuiControl,2:+Background3399FF,Tab2_Background
		GuiControl,2:+Background777777,Tab3_Background
	}else if(A_GuiControl="Tab3"){
		Gui,5:Hide
		Gui,6:Hide
		Gui,7:Show ;,x10 y70 w300 h500
		GuiControl,2:+Background777777,Tab1_Background
		GuiControl,2:+Background777777,Tab2_Background
		GuiControl,2:+Background3399FF,Tab3_Background
	}else if(A_GuiControl="Tab4"){
		Gui,8:Show
		Gui,9:Hide
		Gui,10:Hide ;,x10 y70 w300 h500
		GuiControl,3:+Background3399FF,Tab4_Background
		GuiControl,3:+Background777777,Tab5_Background
		GuiControl,3:+Background777777,Tab6_Background
	}else if(A_GuiControl="Tab5"){
		Gui,8:Hide
		Gui,9:Show
		Gui,10:Hide ;,x10 y70 w300 h500
		GuiControl,3:+Background777777,Tab4_Background
		GuiControl,3:+Background3399FF,Tab5_Background
		GuiControl,3:+Background777777,Tab6_Background
	}else if(A_GuiControl="Tab6"){
		Gui,8:Hide
		Gui,9:Hide
		Gui,10:Show ;,x10 y70 w300 h500
		GuiControl,3:+Background777777,Tab4_Background
		GuiControl,3:+Background777777,Tab5_Background
		GuiControl,3:+Background3399FF,Tab6_Background
	}
	if(A_GuiControl="Tab1"||A_GuiControl="Tab2"||A_GuiControl="Tab3"){
		GuiControl,2:+Redraw,Tab1_Text
		GuiControl,2:+Redraw,Tab2_Text
		GuiControl,2:+Redraw,Tab3_Text
	}else	{
		GuiControl,3:+Redraw,Tab4_Text
		GuiControl,3:+Redraw,Tab5_Text
		GuiControl,3:+Redraw,Tab6_Text
	}
}

Change_Bitmap_Background_Color(){
	Gui,5:Submit,NoHide
	Gui,4:Color,% BitmapBackgroundColor
	sleep,20
	Loop,% Bitmap_Array.Length()
		Bitmap_Array[A_Index].move()
}

Add_Bitmaps_To_Bitmaps_List(){
	temp_Bitmap_List:=""
	Loop,% Bitmap_Array.Length(){
		temp_Bitmap_List.=Bitmap_Array[A_Index].Name "|"
	}
	GuiControl,1:,Active_Bitmaps_List,|
	GuiControl,1:,Active_Bitmaps_List,% temp_Bitmap_List
}

Hide_Element:
	Gui,13:Submit,NoHide
	Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Hidden:=Hide_Element
	Update_Element_List()
	GuiControl,8:Choose,Current_Elements,% Active_Element
	if(Auto_Draw){
		SetTimer,Force_Draw,-10
	}
return

Force_Draw(){
	if(Bitmap_Array[Active_Bitmap]){
		Bitmap_Array[Active_Bitmap].Create_BitMap()
		loop, % Bitmap_Array[Active_Bitmap].Bitmap_Elements.Length(){
			if(Bitmap_Array[Active_Bitmap].Bitmap_Elements[A_Index].Hidden!=1)
				Bitmap_Array[Active_Bitmap][Bitmap_Array[Active_Bitmap].Bitmap_Elements[A_Index].Type](A_Index)
		}
		Bitmap_Array[Active_Bitmap].Move()
	}
}
;--------------------------------------------------------------------
;--------------------------------------------------------------------
;--------------------------------------------------------------------
; Refactored Code Credit - Speed Master

ReSize_Element:
	keyShift:=GetKeyState("Shift")
	(A_GuiControl=="Minus_Width" ) ? ( keyShift && (GetActiveElement("W")>10) ? ResizeElement(-10,0) : (GetActiveElement("W")>1) ? ResizeElement(-1, 0) )
	(A_GuiControl=="Plus_Width" ) ? ( keyShift ? ResizeElement(10,0) : ResizeElement(1, 0) )
	(A_GuiControl=="Minus_Height") ? ( keyShift && (GetActiveElement("H")>10) ? ResizeElement(0,-10) : (GetActiveElement("H")>1) ? ResizeElement(0, -1) )
	(A_GuiControl=="Plus_Height" ) ? ( keyShift ? ResizeElement(0,10) : ResizeElement(0, 1) )
return

GetActiveElement(key) {
	return Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element][key]
}

ResizeElement(w:=0,h:=0) {
	(w) ? Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element]["W"] +=w
	(h) ? Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element]["H"] +=h
	GuiControl,13:,W_Position,% Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element]["W"]
	GuiControl,13:,H_Position,% Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element]["H"]
}

RePosition_Element() {
	keyShift:=GetKeyState("Shift")
	(A_GuiControl=="Move_Up") 		? 	( keyShift ?	MoveElement(-10,0) 		: MoveElement(-1, 0) )
	(A_GuiControl=="Move_Down") 	? 	( keyShift ?	MoveElement(10, 0) 		: MoveElement( 1, 0) )
	(A_GuiControl=="Move_Left") 	? 	( keyShift ?	MoveElement(0,-10)		: MoveElement( 0,-1) )
	(A_GuiControl=="Move_Right") 	? 	( keyShift ?	MoveElement(0, 10) 		: MoveElement( 0, 1) )

	(A_GuiControl=="Move_Up2") 		? 	( keyShift ?	MoveElement(-10,0,2) 	: MoveElement(-1, 0,2) )
	(A_GuiControl=="Move_Down2") 	? 	( keyShift ?	MoveElement(10, 0,2) 	: MoveElement( 1, 0,2) )
	(A_GuiControl=="Move_Left2") 	? 	( keyShift ?	MoveElement(0,-10,2)	: MoveElement( 0,-1,2) )
	(A_GuiControl=="Move_Right2") 	? 	( keyShift ?	MoveElement(0, 10,2) 	: MoveElement( 0, 1,2) )

	(A_GuiControl=="Move_Up3") 		? 	( keyShift ?	MoveElement(-10,0,3) 	: MoveElement(-1, 0,3) )
	(A_GuiControl=="Move_Down3") 	? 	( keyShift ?	MoveElement(10, 0,3) 	: MoveElement( 1, 0,3) )
	(A_GuiControl=="Move_Left3") 	? 	( keyShift ?	MoveElement(0,-10,3)	: MoveElement( 0,-1,3) )
	(A_GuiControl=="Move_Right3") 	? 	( keyShift ?	MoveElement(0, 10,3) 	: MoveElement( 0, 1,3) )

	(A_GuiControl=="Move_Up4") 		? 	( keyShift ?	MoveElement(-10,0,4) 	: MoveElement(-1, 0,4) )
	(A_GuiControl=="Move_Down4") 	? 	( keyShift ?	MoveElement(10, 0,4) 	: MoveElement( 1, 0,4) )
	(A_GuiControl=="Move_Left4") 	? 	( keyShift ?	MoveElement(0,-10,4)	: MoveElement( 0,-1,4) )
	(A_GuiControl=="Move_Right4") 	? 	( keyShift ?	MoveElement(0, 10,4) 	: MoveElement( 0, 1,4) )
}

MoveElement(y:=0,x:=0,Enum:="") {
	Current_Element:=Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element]
	(y) ? Current_Element["Y" Enum] +=y
	(x) ? Current_Element["X" Enum] +=x
	GuiControl,13:,Y%Enum%_Position,% Current_Element["Y" Enum]
	GuiControl,13:,X%Enum%_Position,% Current_Element["X" Enum]
	if(Auto_Draw)
		SetTimer,Force_Draw,-10
}

;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
;NEW HOTKEYS - Submitted By: Speed Master

#IfWinActive HB Bitmap Maker

	up::MoveElement(-1,0), (GetActiveElement("type")="Draw_Line" || GetActiveElement("type")="Draw_Bezier") ? MoveElement(-1,0,2), MoveElement(-1,0,3), MoveElement(-1,0,4)
	down::MoveElement(1,0), (GetActiveElement("type")="Draw_Line" || GetActiveElement("type")="Draw_Bezier") ? MoveElement(1,0,2), MoveElement(1,0,3), MoveElement(1,0,4)
	left::MoveElement(0,-1), (GetActiveElement("type")="Draw_Line" || GetActiveElement("type")="Draw_Bezier") ? MoveElement(0,-1,2), MoveElement(0,-1,3), MoveElement(0,-1,4)
	right::MoveElement(0,1), (GetActiveElement("type")="Draw_Line" || GetActiveElement("type")="Draw_Bezier") ? MoveElement(0,1,2), MoveElement(0,1,3), MoveElement(0,1,4)

	+up::MoveElement(-10,0), (GetActiveElement("type")="Draw_Line" || GetActiveElement("type")="Draw_Bezier") ? MoveElement(-10,0,2), MoveElement(-10,0,3), MoveElement(-10,0,4)
	+down::MoveElement(10,0), (GetActiveElement("type")="Draw_Line" || GetActiveElement("type")="Draw_Bezier") ? MoveElement(10,0,2), MoveElement(10,0,3), MoveElement(10,0,4)
	+left::MoveElement(0,-10), (GetActiveElement("type")="Draw_Line" || GetActiveElement("type")="Draw_Bezier") ? MoveElement(0,-10,2), MoveElement(0,-10,3), MoveElement(0,-10,4)
	+right::MoveElement(0,10), (GetActiveElement("type")="Draw_Line" || GetActiveElement("type")="Draw_Bezier") ? MoveElement(0,10,2), MoveElement(0,10,3), MoveElement(0,10,4)

	^up::(GetActiveElement("type")="Draw_Line") ? MoveElement(-1,0) : (GetActiveElement("H")>1) ? ResizeElement(0,-1)
	^down::(GetActiveElement("type")="Draw_Line") ? MoveElement(1,0) : ResizeElement(0,1)
	^left::(GetActiveElement("type")="Draw_Line") ? MoveElement(0,-1) : (GetActiveElement("w")>1) ? ResizeElement(-1,0)
	^right::(GetActiveElement("type")="Draw_Line") ? MoveElement(0,1) : ResizeElement(1,0)

	^+up::(GetActiveElement("H")>10) ? ResizeElement(0,-10) : (GetActiveElement("H")>1) ? ResizeElement(0,-1)
	^+down::ResizeElement(0,10)
	^+left::(GetActiveElement("w")>10) ? ResizeElement(-10,0) : (GetActiveElement("W")>1) ? ResizeElement(-1,0)
	^+right::ResizeElement(10,0)

	#up::(GetActiveElement("type")="Draw_Line") ? MoveElement(-1,0,2)
	#down::(GetActiveElement("type")="Draw_Line") ? MoveElement(1,0,2)
	#left::(GetActiveElement("type")="Draw_Line") ? MoveElement(0,-1,2)
	#right::(GetActiveElement("type")="Draw_Line") ? MoveElement(0,1,2)

	^d::Clone_Element()

	#If ; end

	;End of - Speed Master Code Section
	;---------------------------------------------------------------------
	;---------------------------------------------------------------------
	;---------------------------------------------------------------------

	Set_Color_1(){
		CoordMode,Mouse,Screen
		CoordMode,Pixel,Screen
		While(!GetKeyState("ctrl")){
			; ToolTip, hover over color and press "ctrl"
			ToolTip, �������ͣ����ɫ�ϲ��� Ctrl
		}
		ToolTip,
		MouseGetPos,xt,yt
		PixelGetColor,Color,xt,yt,RGB
		CoordMode,Mouse,Client
		StringTrimLeft,Color,Color,2
		GuiControl,14:,Color,% Color
	}
	Set_Color_2(){
		CoordMode,Mouse,Screen
		CoordMode,Pixel,Screen
		While(!GetKeyState("ctrl")){
			; ToolTip, hover over color and press "ctrl"
			ToolTip, �������ͣ����ɫ�ϲ��� Ctrl
		}
		ToolTip,
		MouseGetPos,xt,yt
		PixelGetColor,Color2,xt,yt,RGB
		CoordMode,Mouse,Client
		StringTrimLeft,Color2,Color2,2
		GuiControl,14:,Color2,% Color2
	}
	;Submit element values
	;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	Submit_13:
		Gui,13:Submit,NoHide
		Gui,14:Submit,NoHide
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].X:=X_Position
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Y:=Y_Position
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].W:=W_Position
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].H:=H_Position
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Notes:=Notes
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Alpha:=Alpha
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Color:=Color
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].X2:=X2_Position
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Y2:=Y2_Position
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].X3:=X3_Position
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Y3:=Y3_Position
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].X4:=X4_Position
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Y4:=Y4_Position
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Radius:=Radius
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Thickness:=Thickness
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Text:=Text
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Options:=Options
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Font:=Font
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Start_Angle:=Start_Angle
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].End_Angle:=End_Angle
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Polygon_List:=Polygon_List
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Lines_List:=Lines_List

		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].SourceX := Sx
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].SourceY := Sy
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].SourceW := Sw
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].SourceH := Sh

		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Brush_Type:=Brush_Type
		if(Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Brush_Type=2){
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Hatch:=Hatch
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Alpha2:=Alpha2
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Color2:=Color2
		}
		if(Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Brush_Type=3){
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Line_Brush_X1:=Line_Brush_X1
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Line_Brush_Y1:=Line_Brush_Y1
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Line_Brush_X2:=Line_Brush_X2
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Line_Brush_Y2:=Line_Brush_Y2
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Line_Brush_Wrap_Mode:=Line_Brush_Wrap_Mode
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Alpha2:=Alpha2
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Color2:=Color2
		}
		if(Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Brush_Type=4){
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Grade_Brush_X:=Grade_Brush_X
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Grade_Brush_Y:=Grade_Brush_Y
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Grade_Brush_W:=Grade_Brush_W
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Grade_Brush_H:=Grade_Brush_H
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Grade_Brush_LinearGradientMode:=Grade_Brush_LinearGradientMode
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Grade_Brush_Wrap_Mode:=Grade_Brush_Wrap_Mode
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Alpha2:=Alpha2
			Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Color2:=Color2
		}
		if(Auto_Draw){
			SetTimer,Force_Draw,-10
		}
	return
	Submit_Brush_Type:
		Gui,13:Submit,NoHide
		Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element].Brush_Type:=Brush_Type
		Constructor.Create_Brush_Window(Bitmap_Array[Active_Bitmap].Bitmap_Elements[Active_Element])
		if(Auto_Draw){
			SetTimer,Force_Draw,-10
		}
	return

	;/*
	Layered_Window_SetUp(Smoothing,Window_X,Window_Y,Window_W,Window_H,Window_Name:=1,Window_Options:=""){
		Layered:={}
		Layered.W:=Window_W
		Layered.H:=Window_H
		Layered.X:=Window_X
		Layered.Y:=Window_Y
		Layered.Name:=Window_Name
		Layered.Options:=Window_Options
		Layered.Token:=Gdip_Startup()
		Create_Layered_GUI(Layered)
		Layered.hwnd:=winExist()
		Layered.hbm := CreateDIBSection(Window_W,Window_H)
		Layered.hdc := CreateCompatibleDC()
		Layered.obm := SelectObject(Layered.hdc,Layered.hbm)
		Layered.G := Gdip_GraphicsFromHDC(Layered.hdc)
		Gdip_SetSmoothingMode(Layered.G,Smoothing)
		return Layered
	}
	Create_Layered_GUI(Layered){
		Gui,% Layered.Name ": +E0x80000 +LastFound " Layered.Options
		Gui,% Layered.Name ":Show",% "x" Layered.X " y" Layered.Y " w" Layered.W " h" Layered.H " NA"
	}
	Layered_Window_ShutDown(This){
		SelectObject(This.hdc,This.obm)
		DeleteObject(This.hbm)
		DeleteDC(This.hdc)
		gdip_deleteGraphics(This.g)
		Gdip_Shutdown(This.Token)
	}
	Gdip_RotateBitmap(pBitmap, Angle, Dispose=1) { ; returns rotated bitmap. By Learning one.
		Gdip_GetImageDimensions(pBitmap, Width, Height)
		Gdip_GetRotatedDimensions(Width, Height, Angle, RWidth, RHeight)
		Gdip_GetRotatedTranslation(Width, Height, Angle, xTranslation, yTranslation)
		pBitmap2 := Gdip_CreateBitmap(RWidth, RHeight)
		G2 := Gdip_GraphicsFromImage(pBitmap2), Gdip_SetSmoothingMode(G2, 4), Gdip_SetInterpolationMode(G2, 7)
		Gdip_TranslateWorldTransform(G2, xTranslation, yTranslation)
		Gdip_RotateWorldTransform(G2, Angle)
		Gdip_DrawImage(G2, pBitmap, 0, 0, Width, Height)
		Gdip_ResetWorldTransform(G2)
		Gdip_DeleteGraphics(G2)
		if Dispose
			Gdip_DisposeImage(pBitmap)
		return pBitmap2
	}

	New_Brush(colour:="000000",Alpha:="FF"){
		new_colour := "0x" Alpha colour
		return Gdip_BrushCreateSolid(new_colour)
	}

	New_Pen(colour:="000000",Alpha:="FF",Width:= 5){
		new_colour := "0x" Alpha colour
		return Gdip_CreatePen(New_Colour,Width)
	}
	Fill_Box(pGraphics,pBrush,x,y,w,h)	{
		Ptr := A_PtrSize ? "UPtr" : "UInt"
		return DllCall("gdiplus\GdipFillRectangle", Ptr, pGraphics, Ptr, pBrush, "float", x, "float", y, "float", w, "float", h)
	}
	Draw_Box(pGraphics, pPen, x, y, w, h){
		Ptr := A_PtrSize ? "UPtr" : "UInt"
		return DllCall("gdiplus\GdipDrawRectangle", Ptr, pGraphics, Ptr, pPen, "float", x, "float", y, "float", w, "float", h)
	}
