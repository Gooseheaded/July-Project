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

	proc
		equip(player/ply)
			if(!(slot in ply.slots))
				debug.sendMessage("[__FILE__]:[__LINE__] - '[ply.name]' does not have a proper slot '[slot]' for item '[name]'.")
				return
			if(ply.slots[slot] != null)
				debug.sendMessage("[__FILE__]:[__LINE__] - '[ply.name]' has '[slot]' occupied by '[ply.slots[slot]]', and cannot equip '[name]'.")
				return

			ply.slots[slot] = src

		unequip(player/ply)
			if(!(slot in ply.slots))
				debug.sendMessage("[__FILE__]:[__LINE__] - '[ply.name]' could not have equipped '[name]' in the first place because he/she does not have the slot '[slot]'.")
				return
			if(ply.slots[slot] != src)
				debug.sendMessage("[__FILE__]:[__LINE__] - '[ply.name]' has '[slot]' occupied by another item '[ply.slots[slot]]', instead of '[name]'.")
				return

			ply.slots[slot] = null

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

		effects = eff
		if(eff == null)
			effects = list()
