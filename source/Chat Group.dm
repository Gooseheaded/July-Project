
var
	list/chat_groups
	chat_group/debug
	chat_group/world_

world
	New()
		..()
		chat_groups = list()

		debug = new /chat_group("Debug")
		world_ = new /chat_group("World")

		chat_groups += debug
		chat_groups += world_

chat_group
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

		send_message(txt)
			for(var/a in members)
				a << "\[[name]] [txt]"

	New(nam)
		name = nam
		members = list()

////////////////////////////////////////////////////////////////////////////////