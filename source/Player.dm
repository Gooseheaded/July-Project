/*
File:		Player.dm
Author:		Gooseheaded
Created:	07/07/14

Edits:
*/

player
	parent_type = /character

	New()
		..()
		stats = list()

		stats += new/stat/bar("Health", 0, 50, 50)
		stats += new/stat("Health Regeneration", 1)

		stats += new/stat/bar("Energy", 0, 10, 10)
		stats += new/stat("Energy Regeneration", 1)

		stats += new/stat/bar("Experience", 0, 0, 100)

		stats += new/stat("Strength", 0)
		stats += new/stat("Agility", 0)
		stats += new/stat("Wisdom", 0)

		slots = global.slots.Copy()

	Login()
		..()
		world_.add(src)
		if(ckey in admins)
			debug.add(src)

	Logout()
		..()
		world_.remove(src)
		debug.remove(src)
