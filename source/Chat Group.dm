/*
File:		Chat Group.dm
Author:		Gooseheaded
Created:	07/07/14

Edits:
*/

var
	list/chatGroups
	chatGroup/debug
	chatGroup/world_

world
	New()
		..()
		chatGroups = list()

		debug = new /chatGroup("Debug")
		world_ = new /chatGroup("World")

		chatGroups += debug
		chatGroups += world_

chatGroup
	var
		name
		list/members

	proc
		add(atom/a)
			if(!(a in members))
				members += a

		remove(atom/a)
			if(a in members)
				members -= a

		sendMessage(txt)
			for(var/a in members)
				a << "\[[name]] [txt]"

	New(nam)
		name = nam
		members = list()

////////////////////////////////////////////////////////////////////////////////