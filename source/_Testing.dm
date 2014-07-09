var
	list/equipmentPrefixes = list("Elven", "Orcish", "Heavenly", "Hellish", "Cursed", "Holy", "Enchanted")
	list/materials = list("Chain", "Studded", "Plate", "Copper", "Silver", "Gold", "Diamond")
	list/weaponNames = list("Sword", "Greatsword", "Longsword", "Battleaxe", "Axe", "Hammer", "Warhammer")

equipment
	verb
		_equip()
			set name = "equip"
			equip(usr)
		_unequip()
			set name = "unequip"
			unequip()

player
	verb

		new_modifier()
			var/stat/stat = input("Stat") in stats
			var/kind = input("Kind") in list("Flat", "Proportional")
			var/target = input("Target") in list("Value", "Minimum Value", "Maximum Value")
			var/value = input("Value") as num

			if(kind == "Flat") kind = MOD_FLAT
			else if(kind == "Proportional") kind = MOD_PROP

			if(target == "Value") target = STAT_VALUE
			else if(target == "Minimum Value") target = STAT_MIN_VALUE
			else if(target == "Maximum Value") target = STAT_MAX_VALUE

			stat.mods += new/mod("Player-made", src, target, kind, value)


		shift_stats()
			var/str = input("Strength bonus") as num
			var/agi = input("Agility bonus") as num
			var/wis = input("Wisdom bonus") as num

			for(var/stat/s in stats)
				if(s.name == "Strength")
					s.shift(str)
				else if(s.name == "Agility")
					s.shift(agi)
				else if(s.name == "Wisdom")
					s.shift(wis)

			var/equipment/e
			for(var/s in slots)
				if(slots[s] != null)
					e = slots[s]
					e.canStillEquip()

	Login()
		..()
		for(var/stat/s in stats)
			if(s.name == "Strength")
				s.shift(20)
			else if(s.name == "Agility")
				s.shift(20)
			else if(s.name == "Wisdom")
				s.shift(20)

		for(var/count = 0, count < 50, count ++)
			var/equipName = ""
			equipName += pick(equipmentPrefixes) + " "
			equipName += pick(materials) + " "

			var/slot = pick("Helmet", "Armor", "Left Hand", "Right Hand", "Left Ring", "Right Ring", "Amulet")

			if(slot == "Left Hand" || slot == "Right Hand")
				if(prob(50))
					equipName += pick(weaponNames)
				else
					equipName += "Shield"
			else if(slot == "Left Ring" || slot == "Right Ring")
				equipName += "Ring"
			else
				equipName += slot

			var/equipment/e = new/equipment(equipName, null, 'Hex Tile Reference Model.png', null, slot, list("Strength" = rand(-5, 10), "Agility" = rand(-5, 10),"Wisdom" = rand(-5, 10)))
			contents += e

	Stat()
		if(statpanel("Stats"))
			stat("NAME2", "VALUE2")
			stat("NAMEORVALUE")

			for(var/stat/s in stats)
				if(istype(s, /stat/bar))
					var/stat/bar/b = s
					stat(s.name, "[b.getValue()] / [b.getMaxValue()]")
				else
					stat(s.name, "[s.getValue()] / [s.value]")

				for(var/mod/m in s.mods)
					if(m.kind == MOD_FLAT)
						stat(">[m.source.name]: [m.targetVar] -> [m.value]")
					else if(m.kind == MOD_PROP)
						stat(">[m.source.name]: [m.targetVar] -> [m.value*100]%")

		if(statpanel("Inventory"))
			var/equipment/e
			for(var/slot in slots)
				if(slots[slot] != null)
					e = slots[slot]
					stat(slot, e)
					stat(list2params(e.costs))
				else
					stat(slot , "(nothing)")

		if(statpanel("Blacksmith"))
			for(var/equipment/q in contents)
				stat(q)
				stat(list2params(q.costs))