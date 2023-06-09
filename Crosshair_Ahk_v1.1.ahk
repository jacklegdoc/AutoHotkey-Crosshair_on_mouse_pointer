; This works on AutoHotkey version 1.1
; Gui 21 and 22 is used for this script.
; Some settings (such as LineColor, LineWidth, Transparency, and UpdateInterval) may be written in auto-execution area as global variables.


; Toggle crosshair by Ctrl + Alt + X (without Gdip_all.ahk library)
^!x::
{
	If WinExist("HorCrosshair") OR WinExist("VerCrosshair")
	{
		Gosub, StopCrosshair
		Return
	} Else {
		Gosub, StartCrosshair
		Return
	}
}

; Crosshair Gosub script (without Gdip_all.ahk library)
StartCrosshair:
{
	; Crosshair settings
	SysGet, ScreenWidth, 78
	SysGet, ScreenHeight, 79
	CoordMode, Mouse, Screen
	LineColor := "00FF00" ; Green
	LineWidth := 1
	LineLength := max(ScreenWidth, ScreenHeight) * 2
	Transparency := 127 ; 0 (invisible) ~ 255 (opaque)
	UpdateInterval := 40 ; Update interval to redraw crosshair
	; Prepare horizontal and vertical line GUIs
	Gui, 21: Color, %LineColor%
	Gui, 22: Color, %LineColor%
	Gui, 21: +LastFound +Owner +OwnDialogs +AlwaysOnTop -Border -Caption +ToolWindow +E0x00080020
	Gui, 22: +LastFound +Owner +OwnDialogs +AlwaysOnTop -Border -Caption +ToolWindow +E0x00080020
	; 0x0080000 (WS_EX_LAYERED): Enable showing GUI larger than screen size but mouse position seems relative to the active window.
	; 0x00000020 (WS_EX_TRANSPARENT): Same to E0x20 (WS_EX_CLICKTHROUGH)? Enable mouse click/scroll while crosshair is shown.
	; Repeat scanning mouse position and draw crosshair
	SetTimer, CheckCrosshair, %UpdateInterval%
	Return
}

CheckCrosshair:
{
	MouseGetPos, CurrentX, CurrentY
	If (CurrentX != MouseX OR CurrentY != MouseY) {
		Gosub, RedrawCrosshair
	}
	Return
}

RedrawCrosshair:
{
	MouseGetPos, MouseX, MouseY
	WinGetPos, WinX, WinY, , , A
	If WinX = 
	{
		WinX := 0
	}
	If WinY =
	{
		WinY := 0
	}
	HorX := MouseX + WinX - LineLength / 2
	HorY := MouseY + WinY - LineWidth / 2
	VerX := MouseX + WinX - LineWidth / 2
	VerY := MouseY + WinY - LineLength / 2
	Gui, 21: Show, x%HorX% y%HorY% w%LineLength% h%LineWidth% NA, HorCrosshair
	Gui, 22: Show, x%VerX% y%VerY% w%LineWidth% h%LineLength% NA, VerCrosshair
	WinSet, Transparent, %Transparency%, HorCrosshair
	WinSet, Transparent, %Transparency%, VerCrosshair
	Return
}

StopCrosshair:
{
	SetTimer, CheckCrosshair, Off
	Gui, 21: Destroy
	Gui, 22: Destroy
	Return
}
