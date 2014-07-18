/*
File:		GUI.dm
Author:		Gooseheaded
Created:	17/07/14
*/


var/const
	GUI_LAYER = 500

client
	var
		GUI/gui// = new()

GUI
	var
		client/owner
		list/contents = new()

	proc
		update()
			var/list/objects = list()
			objects |= contents

			for(var/GUIObject/gui in objects)
				gui.update()
				owner.screen |= gui
				objects |= gui.children

	New(own)
		if(own && !istype(own, /client))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create GUI with arg '[own]' (must be a /client).")
			del src

		if(!own && !istype(usr,/client) && !istype(usr,/mob))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create GUI with arg '[own]' (must be a /client).")
			del src

		if(!own)
			if(istype(usr,/client)) own = usr
			if(istype(usr,/mob)) own = usr.client

		owner = own

		.=..()

GUIObject
	parent_type = /atom/movable

	var
		list/children
		GUI/owner

		onClick
		datum/context

		screenX
		screenY
		offsetX
		offsetY

	proc
		update()
			screen_loc = "[screenX]:[offsetX],[screenY]:[offsetY]"
			debug.sendMessage("Look at dis @ [screenX]:[offsetX],[screenY]:[offsetY]")
			for(var/GUIObject/gui in children)
				gui.update()

		setValues(scX=0, scY=0, ofX=0, ofY=0, lay=0)
			screenX = scX
			screenY = scY
			offsetX = ofX
			offsetY = ofY
			layer = lay

	New(ico=null, sta=null, lay=null, con=null, cli=null)
		world << "[__FILE__]:[__LINE__] - Creating new GUUIObject with args '[ico]','[sta]','[lay]','[con]','[cli]'."
		debug.sendMessage("[__FILE__]:[__LINE__] - Creating new GUUIObject with args '[ico]','[sta]','[lay]','[con]','[cli]'.")
		if(ico != null && !isfile(ico))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create GUIObject with arg '[ico]' (must be a file).")
			del src
		if(sta != null && sta != "" && !istext(sta))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create GUIObject with arg '[sta]' (must be text).")
			del src
		if(lay != null && !isnum(lay))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create GUIObject with arg '[lay]' (must be a number).")
			del src

		if(con != null && !istype(con, /datum))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create GUIObject with arg '[con]' (must be a /datum).")
			del src
		if(cli != null && cli != "" && !istext(cli))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create GUIObject with arg '[cli]' (must be text).")
			del src

		context = con
		onClick = cli

		icon = ico
		icon_state = sta
		setValues()

		children = list()

		.=..(null)

	Click()
		if(context != null && onClick != null)
			call(context, onClick)(args)