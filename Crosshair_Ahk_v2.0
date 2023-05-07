; This works on AutoHotkey version 2.0
; Some settings (such as CrosshairLineColor, CrosshairLineWidth, CrosshairLineLength, and CrosshairUpdateInterval) may be written in auto-execution area as global variables.


; Toggle crosshair by Ctrl + Alt + X
^!x::
{
	If WinExist("HorizontalCrosshair") OR WinExist("VerticalCrosshair")
	{
		StopCrosshair()
		Return
	} Else {
		StartCrosshair()
		Return
	}
}

; Crosshair without Gdip_all.ahk library
StartCrosshair()
{
	; Crosshair settings
	CoordMode "Mouse", "Screen"
	global CrosshairLineColor := "00FF00" ; Green
	global CrosshairLineWidth := 1
	global CrosshairLineLength := max(SysGet(78), SysGet(79)) * 2
	global CrosshairTransparency := 127 ; 0 (invisible) ~ 255 (opaque)
	global CrosshairUpdateInterval := 40
	; Prepare horizontal and vertical line GUIs
	global HorizontalCrosshair := Gui("+LastFound +Owner +OwnDialogs +AlwaysOnTop -Border -Caption +ToolWindow +E0x00080020", "HorizontalCrosshair")
	global VerticalCrosshair := Gui("+LastFound +Owner +OwnDialogs +AlwaysOnTop -Border -Caption +ToolWindow +E0x00080020", "VerticalCrosshair")
	HorizontalCrosshair.BackColor := CrosshairLineColor
	VerticalCrosshair.BackColor := CrosshairLineColor
	; 0x0080000 (WS_EX_LAYERED): Enable showing GUI larger than screen size but mouse position seems relative to the active window.
	; 0x00000020 (WS_EX_TRANSPARENT): Same to E0x20 (WS_EX_CLICKTHROUGH)? Enable mouse click/scroll while crosshair is shown.
	; Repeat scanning mouse position and draw crosshair
	SetTimer CheckCrosshair, CrosshairUpdateInterval
	Return
}

CheckCrosshair()
{
	If !IsSet(MouseX) OR !IsSet(MouseY) {
		RedrawCrosshair()
	} Else {
		MouseGetPos &CurrentX, &CurrentY
		If (CurrentX != MouseX OR CurrentY != MouseY) {
			RedrawCrosshair()
		}
	}
	Return
}

RedrawCrosshair()
{
	global MouseX, MouseY
	MouseGetPos &MouseX, &MouseY
	;GetActiveWindow()
	If WinExist("A") {
		WinGetClientPos &ActiveClientX, &ActiveClinetY
		HorX := MouseX + ActiveClientX - CrosshairLineLength / 2
		HorY := MouseY + ActiveClinetY - CrosshairLineWidth / 2
		VerX := MouseX + ActiveClientX - CrosshairLineWidth / 2
		VerY := MouseY + ActiveClinetY - CrosshairLineLength / 2
	} Else {
		HorX := MouseX - CrosshairLineLength / 2
		HorY := MouseY - CrosshairLineWidth / 2
		VerX := MouseX - CrosshairLineWidth / 2
		VerY := MouseY - CrosshairLineLength / 2
	}
	HorizontalCrosshair.Show("x" HorX " y" HorY " w" CrosshairLineLength " h" CrosshairLineWidth " NA")
	VerticalCrosshair.Show("x" VerX " y" VerY " w" CrosshairLineWidth " h" CrosshairLineLength " NA")
	WinSetTransparent CrosshairTransparency, "HorizontalCrosshair"
	WinSetTransparent CrosshairTransparency, "VerticalCrosshair"
	Return
}

StopCrosshair()
{
	SetTimer CheckCrosshair, 0
	WinClose "HorizontalCrosshair"
	WinClose "VerticalCrosshair"
	Return
}
