/*
File:		GUI.dm
Author:		Gooseheaded
Created:	08/07/14
*/

client
	var
		GUI/gui

GUI
	var
		client/owner
		list/contents

	proc
		update()
			for(var/GUIObject/gui in contents)
				gui.update()
			owner.images |= contents

	New(own)
		if(!istype(own, /client))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create GUI with arg '[own]' (must be a /client).")
			del src

		contents = new/list()

GUIObject
	parent_type = /atom/movable

	var
		GUI/owner
		atom/movable/display

		onClick
		datum/context

		screenX
		screenY
		offsetX
		offsetY

	proc
		update()
			if(display)
				display.screen_loc = "[screenX]:[offsetX], [screenY]:[offsetY]"
				display.layer = layer

		setValues(scX=0, scY=0, ofX=0, ofY=0, lay=0)
			screenX = scX
			screenY = scY
			offsetX = ofX
			offsetY = ofY
			layer = lay
			update()

		shift(scX=0, scY=0, ofX=0, ofY=0, lay=0)
			screenX += scX
			screenY += scY
			offsetX += ofX
			offsetY += ofY
			layer += lay
			update()

	New(GUI/gui, con=null, cli=null, dis=null)
		if(!istype(gui, /GUI))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create GUIObject with arg '[gui]' (must be a /GUI).")
			del src
		if(con != null && !istype(con, /atom)	)
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create GUIObject with arg '[con]' (must be an /atom).")
			del src
		if(cli != null && !istext(cli))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create GUIObject with arg '[cli]' (must be text).")
			del src
		if(dis != null && !istype(dis, /atom/movable))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create GUIObject with arg '[dis]' (must be an /atom/movable).")
			del src

		owner = gui
		owner.contents |= src
		context = con
		onClick = cli
		display = dis
		if(display == null)
			display = new/atom/movable()

	Click()
		call(context, text2path(onClick))(args)