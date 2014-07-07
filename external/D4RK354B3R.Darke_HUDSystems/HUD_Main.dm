//This is the HUD system I end up using in almost every game!
var
	const
		HUD_LAYER = 1000+EFFECTS_LAYER


HUDObj
	parent_type = /obj

	maptext_width = 600
	maptext_height = 600
	layer = HUD_LAYER

	//isShaded = 0

	var
		client/client
		atom/clickAtom //This, when set, will call clickAtom.Click().
		atom/overAtom //This, when set, will pass MouseEntered() to overAtom
		param //Just some generic variable.
		param2 //just another generic variable

		//If clickAtom.Click() doesn't provide the functionality you want,
		//there's some metacoding functionality here that will allow you to call any
		//function upon Click().

		//By default, the following will run upon click
		//call(callContext,callFunction)(callParams)
		callContext = null
		callFunction = null
		callParams = null

		dblCallContext = null
		dblCallFunction = null
		dblCallParams = null

		children[0]
		HUDObj/parent

		enteredIcon

	mouse_opacity = 0

	Click()
		if(clickAtom)
			return clickAtom:Click()

		if(callContext && callFunction)
			if(!callParams)
				return call(callContext,callFunction)(usr)
			else
				return call(callContext,callFunction)(callParams)

		if(!callContext && callFunction)
			if(!callParams)
				return call(callFunction)(usr)
			else
				return call(callFunction)(callParams)
		..()

	DblClick()
		if(clickAtom)
			return clickAtom:DblClick()

		if(dblCallContext && dblCallFunction)
			if(!dblCallParams)
				return call(dblCallContext,dblCallFunction)(usr)
			else
				return call(dblCallContext,dblCallFunction)(dblCallParams)

		..()

	MouseDrop(o,src_loc,over_loc,src_con,over_con,params)
		if(clickAtom)
			return clickAtom:MouseDrop(o,src_loc,over_loc,src_con,over_con,params)
		else
			return ..()

	MouseEntered(loc,con,params)
		if(overAtom)
			return overAtom:MouseEntered(loc, con, params)
		else
			.=..()

	MouseExited(loc,con,params)
		if(overAtom)
			return overAtom:MouseExited(loc, con, params)
		else
			.=..()

	proc
		addChild(HUDObj/O)
			children += O
			O.parent = src

		addParent(HUDObj/O)
			O.children += src
			parent = O

	Del()
		if(client)
			client.hud -= src.tag

		for(var/HUDObj/O in children - parent)
			del O

		..()
mob
	proc
		addHUD(t,sx,sy,icon/i,istate,tsx=center_x,tsy=center_y,nlayer=HUD_LAYER,smap="",param)
			if(!client) return
			return client.addHUD(t,sx,sy,i,istate,tsx,tsy,nlayer,smap,param)

		removeHUD(t)
			if(!client) return
			return client.removeHUD(t)

		clearHUDGroup(t)
			if(!client) return
			return client.clearHUDGroup(t)


client
	var/tmp
		hud[0] //List of HUD objects


	proc
		addHUD(t,sx,sy,icon/i,istate,tsx=center_x,tsy=center_y,nlayer=HUD_LAYER,smap="",param) //Add an HUD object
			//t is the hud object tag. It allows you to access hud objects by a string,
			//	so you don't have to keep a reference to every one.
			//sx and sy are pixel offsets
			//icon/I and istate are the icon and icon state for this HUD Object
			//tsx and tsy refer to tile screen x and tile screen y.
			//	the default values, center_x and center_y, are intended to be the screen's center coordinates in tiles.
			//	If you don't want to use center coordinates every time, feel free to add your own.
			//nlayer represents new layer
			//smap is the dmf map element tag. Or just leave it null to use the default.
			//param is just the arbitrary param assigned to this;
			//	it's just one of those useful variables available for use in case you need to keep references or
			//	arbitrary values

			sx=round(sx,1)
			sy=round(sy,1)

			var/sl = "[tsx]:[sx],[tsy]:[sy]"

			if(smap!=null && smap != "") sl = "[smap]:[sl]"

			if(hud[t])
				var/HUDObj/O = hud[t]
				O.client = src
				O.tag = t

				O.icon = i
				O.icon_state = istate

				O.screen_loc = sl

				if(param) O.param = param

				if(O.layer!=nlayer) O.layer = nlayer

				return O

			var/HUDObj/O = new()
			O.client = src
			O.tag = t

			O.icon = i
			O.icon_state = istate

			O.screen_loc = sl

			if(O.layer!=nlayer) O.layer = nlayer

			screen += O

			if(param) O.param = param

			hud[t] = O

			return O

		removeHUD(t) //Remove an HUD object
			//t is the string tag of the HUD Object
			if(!(t in hud)) return

			var/HUDObj/O = hud[t]
			hud -= t
			if(O) del O

		getHUD(t) //This returns the HUD object by t tag.
			return hud[t]

		clearHUD()
			//This removes every HUD Object for the mob
			for(var/t in hud)
				var/HUDObj/O = hud[t]
				del O

			hud.Cut()
			//screen.Cut()

		initHUD()
			//This is intended to be an "initialize HUD" function.
			clearHUD()
			//add shit

		clearPopup()
			clearHUDGroup("popup")

		clearHUDGroup(t)
			//This removes every HUD Object whose tag contains string t
			for(var/i in hud)
				if(findtext(i,t))
					removeHUD(i)
