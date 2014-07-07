/*
File:		Player.dm
Author:		Gooseheaded
Created:	07/07/14

Edits:
*/

player
	parent_type = /mob

	var
		list/stats

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

	Login()
		..()
		world_.add(src)
		if(ckey in admins)
			debug.add(src)

	Logout()
		..()
		world_.remove(src)
		debug.remove(src)

	Stat()
		var/stat/bar/health = null
		for(var/stat/s in stats)
			if(s.name == "Health")
				health = s
				break

		stat("Health: ", "[health.getValue()] | [health.getMaxValue()]")

		for(var/mod/m in health.mods)
			if(m.targetVar == VALUE)
				if(m.kind == FLAT)
					if(m.value < 0)
						stat("	Modifier:", "[m.value]")
					else
						stat("	Modifier:", "+[m.value]")
				else if(m.kind == MULTI)
					stat("	Modifier:", "[m.value*100]%")

		for(var/mod/m in health.mods)
			if(m.targetVar == MAX_VALUE)
				if(m.kind == FLAT)
					if(m.value < 0)
						stat("	Max Modifier:", "[m.value]")
					else
						stat("	Max Modifier:", "+[m.value]")
				else if(m.kind == MULTI)
					stat("	Max Modifier:", "[m.value*100]%")

	verb
		new_modifier()
			var/kind = input("Kind") in list("Flat", "Multiplicative")
			var/target = input("Target") in list("Value", "Min", "Max")
			var/value = input("Value") as num

			if(kind == "Flat") kind = FLAT
			else if(kind == "Multiplicative") kind = MULTI

			if(target == "Value") target = VALUE
			else if(target == "Min") target = MIN_VALUE
			else if(target == "Max") target = MAX_VALUE

			var/stat/bar/health = null
			for(var/stat/s in stats)
				if(s.name == "Health")
					health = s
					break
			health.mods += new/mod("Yay", src, target, kind, value)