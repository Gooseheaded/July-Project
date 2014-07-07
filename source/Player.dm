
player
	parent_type = /mob

	var
		stat/bar
			health
			energy

			experience

		stat
			health_regen
			energy_regen

			strength
			agility
			wisdom

	New()
		..()
		health =	new("Health", 0, 50, 50)
		health_regen =	new("Health Regeneration", 1)

		energy =	new("Energy", 0, 10, 10)
		energy_regen =	new("Energy Regeneration", 1)

		experience =new("Experience", 0, 0, 100)

		strength =	new("Strength", 0)
		agility =	new("Agility", 0)
		wisdom =	new("Wisdom", 0)

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
		stat("Health: ", "[health.get_value()] | [health.get_max_value()]")

		for(var/mod/m in health.mods)
			if(m.target_var == VALUE)
				if(m.kind == FLAT)
					if(m.value < 0)
						stat("	Modifier:", "[m.value]")
					else
						stat("	Modifier:", "+[m.value]")
				else if(m.kind == MULTI)
					stat("	Modifier:", "[m.value*100]%")

		for(var/mod/m in health.mods)
			if(m.target_var == MAX_VALUE)
				if(m.kind == FLAT)
					if(m.value < 0)
						stat("	Max Modifier:", "[m.value]")
					else
						stat("	Max Modifier:", "+[m.value]")
				else if(m.kind == MULTI)
					stat("	Max Modifier:", "[m.value*100]%")

		stat("Energy: ", "[energy.value] | [energy.get_max_value()]")

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

			health.mods += new/mod("Yay", src, target, kind, value)