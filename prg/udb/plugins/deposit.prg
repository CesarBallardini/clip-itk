/*
    Copyright (C) 2002  ITK
    Author   : Uri (uri@itk.ru)
    License : (GPL) http://www.itk.ru/clipper/license.html
*/

/*
  fun-ctions for view and edit DEPOSIT information
*/

#include "box.ch"

/* Can`t defined MAIN function name */

local ret := NIL
parameters query_key
	query_key := alltrim(upper(query_key))
	do case
		case query_key == "VIEW_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_dep_view_card(p1,p2,p3,p4,p5)}
		case query_key == "EDIT_CARD"
			ret:={|p1,p2,p3,p4,p5| ab_dep_edit_card(p1,p2,p3,p4,p5)}
		otherwise
			ret:=[DEPOSIT plugins not supported function:]+query_key
	end
return ret

************************************************************
static function ab_dep_view_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec)
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	@ x1++,y1 say padc([Depository parameters],y2-y1)
	@ x1++,y1 say replicate("�",y2-y1) // utf-8: "─"
	if empty(data)
		@ x1++,y1 say [Can`t display information]
		dispend()
		return .f.
	endif
	@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	@ x1++,y1 say [Name............]+data:name
	@ x1++,y1 say [Cluster size....]+alltrim(str(data:memosize))
	@ x1++,y1 say [Number..........]+data:number

	dispend()
	setcolor(oldcol)
return ret
************************************************************
static function ab_dep_edit_card(oDep,data,oBox,colorSpec)
	local ret:=.t.,oldcol:=setcolor(colorSpec),scr
	local x1:=oBox:nTop,y1:=oBox:nleft, y2:=oBox:nRight
	local getlist:={},pic

	dispbegin()
	@ x1,y1,oBox:nBottom,y2 box B_DOUBLE+" "
	x1++;y1++

	@ x1++,y1 say padc([Depository parameters],y2-y1)
	@ x1++,y1 say replicate("�",y2-y1) // utf-8: "─"
	if empty(data)
		@ x1++,y1 say [Can`t edit information]
		dispend()
		return .f.
	endif

	ab_padrBody(data,codb_info("CODB_DEPOSIT_BODY"))

	if empty(data:id)
		@ x1++,y1 say [Identification..]+[Generation avtomatically ]
	else
		@ x1++,y1 say [Identification..]+padr(data:id,y2-y1-16)
	endif
	@ x1++,y1 say [Name............]
	@ x1++,y1 say [Cluster size....]

	setcolor(set("ab_colors_dialog"))
	x1:=oBox:nTop+4; y1:=oBox:nLeft+17
	pic:="@S"+alltrim(str(y2-y1,3,0))
	@ x1++,y1 get data:name     picture (pic)
	@ x1++,y1 get data:memosize picture (pic) range 8,1024
	dispend()
	read
	setcolor(oldcol)
return ret

