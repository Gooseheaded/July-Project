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
