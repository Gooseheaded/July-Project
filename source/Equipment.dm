/*
File:		Equipment.dm
Author:		Gooseheaded
Created:	08/07/14

Edits:
*/

equipment
	parent_type = /obj

	var
		slot
		list/costs
		list/effects
		character/equipped

	proc
		toString()
			var/_costs = ""
			for(var/c in costs)
				_costs += "[c] : [costs[c]],"
			return "([slot]) \[[_costs]] - " + (equipped == null ? "" : "(Equipped)")

		canEquip(character/char)
			var/hasStat
			for(var/cost in costs)
				hasStat = FALSE
				for(var/stat/s in char.stats)
					if(s.name == cost)
						hasStat = TRUE

						if(s.getValue() < costs[cost])
							return FALSE

					if(!hasStat)
						return FALSE

			return TRUE

		canStillEquip()
			if(equipped == null)
				debug.sendMessage("[__FILE__]:[__LINE__] - '[name]' is not equipped.")
				return FALSE

			for(var/stat/ss in equipped.stats)
				for(var/mod/m in ss.mods)
					if(m.source == src)
						ss.mods -= m
						del m
			var/cost
			var/hasStat
			for(var/c in costs)
				cost = c
				hasStat = FALSE
				for(var/stat/s in equipped.stats)
					if(s.name == c)
						hasStat = TRUE

						if(s.getValue() < costs[cost])
							debug.sendMessage("[__FILE__]:[__LINE__] - '[equipped.name]' cannot keep equipping '[name]', because he/she cannot pay the '[cost]' cost (has '[s.getValue()]', but '[costs[cost]]' are needed).")
							unequip()
							return

						s.addMod(new/mod(name, src, STAT_VALUE, MOD_FLAT, -costs[cost]))
						break

				if(!hasStat)
					debug.sendMessage("[__FILE__]:[__LINE__] - '[equipped.name]' cannot keep equipping '[name]', '[cost]([costs[cost]])' because he/she doesn't have the stat '[cost]'.")
					unequip()
					return

		equip(character/char)
			if(equipped != null)
				debug.sendMessage("[__FILE__]:[__LINE__] - '[name]' is already equipped (by '[equipped.name]').")
				return FALSE
			if(!(slot in char.slots))
				debug.sendMessage("[__FILE__]:[__LINE__] - '[char.name]' does not have a proper slot '[slot]' for '[name]'.")
				return FALSE
			if(char.slots[slot] != null)
				debug.sendMessage("[__FILE__]:[__LINE__] - '[char.name]' has '[slot]' occupied by '[char.slots[slot]]', and cannot equip '[name]'.")
				return FALSE

			var/hasStat
			var/cost
			for(var/c in costs)
				cost = c
				hasStat = FALSE
				for(var/stat/s in char.stats)
					if(s.name == c)
						hasStat = TRUE

						if(s.getValue() < costs[cost])
							debug.sendMessage("[__FILE__]:[__LINE__] - '[char.name]' cannot pay the '[cost]' cost of '[name]' (has '[s.getValue()]', but '[costs[cost]]' are needed).")

							for(var/stat/ss in char.stats)
								for(var/mod/m in ss.mods)
									if(m.source == src)
										ss.mods -= m
										del m
							return

						s.addMod(new/mod(name, src, STAT_VALUE, MOD_FLAT, -costs[cost]))
						break

				if(!hasStat)
					debug.sendMessage("[__FILE__]:[__LINE__] - '[char.name]' cannot pay the cost of '[name]', '[cost]([costs[cost]])' because he/she doesn't have the stat '[cost]'.")

					for(var/stat/ss in char.stats)
						for(var/mod/m in ss.mods)
							if(m.source == src)
								ss.mods -= m
								del m
					return

			equipped = char
			char.slots[slot] = src

		unequip()
			if(equipped == null)
				debug.sendMessage("[__FILE__]:[__LINE__] - '[name]' is not equipped.")
				return
			if(!(slot in equipped.slots))
				debug.sendMessage("[__FILE__]:[__LINE__] - '[equipped.name]' could not have equipped '[name]' in the first place because he/she does not have the slot '[slot]'.")
				return
			if(equipped.slots[slot] != src)
				debug.sendMessage("[__FILE__]:[__LINE__] - '[equipped.name]' has '[slot]' occupied by another item '[equipped.slots[slot]]', instead of '[name]'.")
				return

			for(var/stat/s in equipped.stats)
				for(var/mod/m in s.mods)
					if(m.source == src)
						s.mods -= m
						del m

			equipped.slots[slot] = null
			equipped = null

	New(nam, des, ico, sta, slo, list/cos=null, list/eff=null)
		..()
		icon = ico
		icon_state = sta

		name = nam
		desc = des

		slot = slo
		if(!(slot in global.slots))
			debug.sendMessage("[__FILE__]:[__LINE__] - '[name]' has an invalid slot value '[slo]'.")
			del src

		costs = cos
		if(cos == null)
			costs = list()
		for(var/c in costs)
			if(costs[c] <= 0)
				costs -= c

		effects = eff
		if(eff == null)
			effects = list()
