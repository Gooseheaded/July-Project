/*
File:		Ability.dm
Author:		Gooseheaded
Created:	08/07/14

Edits:
*/

ability
	var
		name
		desc
		obj/display
		list/triggers

	proc
		activate()

	New(nam, des, ico, sta, list/tri=null)
		name = nam
		desc = des

		display = new()
		display.icon = ico
		display.icon_state = sta

		triggers = tri
		if(triggers)
			for(var/t in triggers)
				if(!(t in global.triggers))
					debug.sendMessage("[__FILE__]:[__LINE__] - '[name]' has an invalid trigger '[t]' and cannot be created.")
					del src