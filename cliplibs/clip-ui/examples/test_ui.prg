/*-------------------------------------------------------------------------*/
/*   This is a part of CLIP-UI library					   */
/*						                 	   */
/*   Copyright (C) 2003,2004 by E/AS Software Foundation 	           */
/*   Author: Andrey Cherepanov <sibskull@mail.ru>			   */
/*   Last change: 16 Dec 2004						   */
/*   									   */
/*   This program is free software; you can redistribute it and/or modify  */
/*   it under the terms of the GNU General Public License as               */
/*   published by the Free Software Foundation; either version 2 of the    */
/*   License, or (at your option) any later version.                       */
/*-------------------------------------------------------------------------*/
#include <clip-ui.ch>

/* Test of clip-ui library usage */

static ws
static wnd := NIL
static childToolbar

/* Declaration */
local menu, i, sp, b
local journal_menu, action_menu, doc_menu
local ref_menu, cfg_menu, window_menu, help_menu
local main_tbar, statusbar
local accel_group
local win := NIL

/* create workspace */
ws  := UIWorkSpace()

/*--------------------------------------------------------------------*/
/* create main window */
win := UIMainWindow("E/AS " + getClipUIVersion(), NIL, "mainWindow" )

/* create menu of main window*/
menu := UIMenu()
journal_menu := UIPopupMenu()
action_menu := UIPopupMenu()
doc_menu := UIPopupMenu()
ref_menu := UIPopupMenu()
cfg_menu := UIPopupMenu()
window_menu := UIPopupMenu()
help_menu := UIPopupMenu()

menu:add(,"&Journal", journal_menu)
i := journal_menu:add( UIImage("icons/journal_bank_pp.xpm"),"&Payment orders", {|| qout("Payment orders") } )
journal_menu:disable(i)
i := journal_menu:add( UIImage("icons/doc_bank_pp.xpm"),"&Create payment order", {|| qout("Create payment order") } )
journal_menu:setKey(i,"F5")
journal_menu:addSeparator()
journal_menu:add(,"&Exit", @quit())

menu:add(,"&Settings", cfg_menu)
cff := @cfg_menu
win:widget["showTB"] := cfg_menu:addChecked(.T., "Show &toolbar", {|w,e| showToolBar(win, "showTB", cfg_menu) } )
win:widget["showSB"] := cfg_menu:addChecked(.T., "Show &statusbar", {|w,e| showStatusBar(win, "showSB", cfg_menu) } )
cfg_menu:addSeparator()
cfg_menu:add(,"&Configure...", NIL)

/* ToolBars */
main_tbar := UIToolBar()
main_tbar:addButton( UIImage("icons/journal_bank_pp.xpm"), "List of payment orders", {|| qout("List of payment orders") } )
main_tbar:addButton( UIImage("icons/doc_bank_pp.xpm"), "Create payment order", {|| qout("Create payment order") })
main_tbar:addSeparator()
main_tbar:addButton( UIImage("icons/reference_partner.xpm"), "Partners", NIL )

statusbar   := UIStatusBar()
statusbar:setText("Ready.")

win:setPanels( menu, main_tbar, statusbar )

/* Test widgets */
sp := UISplitter(SPLITTER_VERTICAL)
win:userSpace:add(sp, .T., .T.)

BankRefReq( sp )

b  := UIVBox(,3,3)
sp:addEnd(b) 

BankDocReq( win, b )

//-----------------------------------------------------------------------------
// Assign icon to window. TODO: icon doesn't set up
//win:setIcon( UIImage("icons/journal_bank_pp.xpm") )

// Put window to screen center
win:setPlacement( .T. )
// Set size to 600x450
win:setGeometry( { 600, 450, 35, 15 } )
//-----------------------------------------------------------------------------

/* show window */
win:show()

/* run infinitive application loop */
ws:run()
ws:quit()


/**================== FUNCTIONS ==================**/
static function quit()
	ws:quit()
return 0

/* Show/hide tool bar */
static function showToolBar(window, id, menu)
	if window:toolbar != NIL
		if menu:isChecked(window:widget[id])
			window:toolbar:show()
		else
			window:toolbar:hide()
		endif
	endif
return 0

/* Show/hide status bar */
static function showStatusBar(window, id, menu)
	if window:statusbar != NIL
		if menu:isChecked(window:widget[id])
			window:statusbar:show()
		else
			window:statusbar:hide()
		endif
	endif
return 0

/* Tree and table widgets */
static function BankRefReq( sp )
	local splitter, tree, table

	splitter := UISplitter(SPLITTER_HORIZONTAL)
	sp:add(splitter, .T., .T.)
	
	tree := UITree(, {"N1","N2"})
	
	node1  := tree:addNode({"Node1", "node1111"})
	node11 := tree:addNode({"Node2"})
	node2  := tree:addNode({"Leaf1"},, node1)
	node3  := tree:addNode({"Leaf2"},, node1)
	node5  := tree:addNode({"Leaf5", "Leaf5"},, node1)
	node4  := tree:addNode({"Leaf3"},, node1, node3)
	node44 := tree:addNode({"Leaf3333"},, node11)
	node55 := tree:addNode({"Leaf333"},, node44)
	node66 := tree:addNode({"Leaf33"},, node55)
	
	tree:setAction({|w,e| listEventTree(tree, e) })
	splitter:add( tree )
	
	table := UITable({"#","Date","Payee","Sum"})
	table:setAltRowColor("#cbe8ff")
	table:addRow({"1","20.10.03",'JSC "Lighthouse"',"20000.00"})
	table:addRow({"2","20.10.03",'JSC "Phoenix"',"5689.20"})
	table:addRow({"3","21.10.03",'JSC "Phoenix"',"1500.00"})
	table:addRow({"4","25.10.03",'JSC "Phoenix"',"99.00"})
	
	table:setAction({|w,e| listEvent(table, e) })
	splitter:addEnd( table )

return NIL

function listEvent(table, c)
	?? "Table selection:",c,chr(10)
return

/* Form widgets */
static function BankDocReq(w,grid)
	local drv, lab, data, top, bottomLine, t, f1, f2, t1, t2, b1, b2, b3, e1, e2, cb1, cb2, sum, hbsum, rs
	drv := getDriver()

	data := map()
	data:num  := "11"
	data:date :="20.10.03"
	data:client := 'JSC "Brown and son"'
	data:sum  := "20000.00"
	data:reason := "For delivered goods."

	plat := map()
	plat:name 	:= 'JSC "Brown and son"'
	plat:bank	:= 'JSC "MENATEP"'
	plat:bankCity	:= "Krasnoyarsk"
	plat:BIK	:= "54521724647"
	plat:korAccount := "86768348914"
	plat:account	:= "7683187443445276"
	plat:INN	:= "1234567890"

	pol := map()
	pol:name	:= 'JSC "Lighthouse"'
	pol:bank	:= 'JSC "MENATEP"'
	pol:bankCity	:= "Moscow"
	pol:BIK		:= "54521724647"
	pol:korAccount 	:= "86768348914"
	pol:account	:= "7683187443445276"
	pol:INN		:= "1212145436"

	w:setName("tax",grid:add(UICheckBox(.F.,"Use &tax")))

        // Title
	top := UIHBox(,0,3)
	lab := UILabel("Payment order N ")
	drv:setStyle(lab,"font.style","bold")
	drv:setStyle(lab,"font.size","16")
	
	drv:setStyle(lab,"color.bg","red")
	drv:setStyle(lab,"color.light","white")
	drv:setStyle(lab,"color.dark","white")
	drv:setStyle(lab,"color.mid","white")
	drv:setStyle(lab,"color.text","white")
	drv:setStyle(lab,"color.base","white")
	drv:setStyle(lab,"color.white","white")
	
	drv:setStyle(lab,"color.fg","#FF1790")
//	drv:setStyle(lab,"color.text","blue")
//	drv:setStyle(lab,"color.bg","#ff0000")
//	drv:setStyle(lab,"color.base","#0000ff")
	top:add(lab)
 	e1 := UIEdit()
	e1:setValue(data:num)
	e1:setGeometry(50)
        w:setName("number", e1)
	top:add(e1)
	top:add(UILabel(" from "))
	e2 := UIEdit()
	e2:setValue(data:date)
	e2:setGeometry(60)
	w:setName("date", e2)
	top:add(e2)
	grid:add(top)

        // Payer
	f1 := UIFrame()
	grid:add(f1)
	drv:setStyle(f1,"color.bg","darkblue")
	f1:setLabel("Payer")
	f1:setType(FRAME_RAISED)
        t1 := UIVBox(,,3)
	f1:add( t1 )
	cb1 := UIComboBox({'JSC "Brown and son"'},1)
	w:setName("payer", cb1)
	t1:add(cb1)
	t1:add(UILabel("Payer bank: "+plat:bank+" in "+plat:bankCity))
	t1:add(UILabel("Acc.: "+plat:account))

        // Payee
	f2 := UIFrame("Payee",FRAME_SUNKEN)
	grid:add(f2)
        t2 := UIVBox(,,3)
	f2:add( t2 )
	cb2 := UIComboBox()
	cb2:setList({'JSC "Lighthouse"','JSC "Ronal"','JSC "Porechnoye"'})
	cb2:setValue(2)
        w:setName("payee", cb2)
	t2:add(cb2)
	t2:add(UILabel("Payee bank: "+pol:bank+" in "+pol:bankCity))
	t2:add(UILabel("Acc.: "+pol:account))

	// Sum
	hbsum := UIHBox()
        hbsum:add(UILabel("&Sum: "))
        sum := UIEdit(data:sum)
	drv:setStyle(sum,"color.base","#C2D2FF")
	drv:setStyle(sum,"color.bg","red")
	
	w:setName("sum", sum)
	hbsum:add(sum)
	grid:add(hbsum)

	grid:add(UILabel("Description:"))
        rs := UIEditText(data:reason)
	w:setName("reason", rs)
	grid:add(rs, .T., .T.)

	// Bottom panel
	bottomLine := UIHBox()
	grid:addEnd(bottomLine)
	b1 := UIButton( "Save", {|o,e| pp_save(w) } )
	b2 := UIButton( "Print", NIL )
	b3 := UIButton( "Close", {|o,e| w_close(w) } )

	bottomLine:add(b1)
	bottomLine:add(b2)
	bottomLine:add(b3)
return NIL

/* Close specified window */
static function w_close(window)
	window:close()
return 0

/* Show all stored values from document */
static function pp_save(wnd)
	local val
	val := wnd:getValues()
	?? "Form values:"+CHR(10)
 	for i in val
		?? CHR(9)+i[1]+" =",i[2],CHR(10)
	next
return 0

function listEventTree(tree, c)
	?? "Select in tree:",c,"(id =",tree:getSelectionId(),")",chr(10)
return
