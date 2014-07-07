/*
File:		Stat.dm
Author:		Gooseheaded
Created:	07/07/14

Edits:
*/

stat
	var
		name
		value
		list/mods
	proc
		shift(amt)
			value += amt

		scale(amt)
			value *= amt

		setValue(amt)
			value = amt

		getValue()
			var/linear = 0
			var/multi = 1
			for(var/mod/m in mods)
				if(m.targetVar == VALUE)
					if(m.kind == FLAT)
						linear += m.value
					else if(m.kind == MULTI)
						multi += m.value

			return round((value + linear) * multi)

	New(nam, val)
		if(nam == null)
			nam = "Unnamed Stat"

		mods = list()
		name = nam
		value = val

	sub_stat
		var
			list/stats

		getValue()
			var/linear = 0
			var/multi = 1
			var/result

			for(var/mod/m in mods)
				if(m.targetVar == VALUE)
					if(m.kind == FLAT)
						linear += m.value
					else if(m.kind == MULTI)
						multi += m.value

			var/stat/s
			for(var/data/d in stats)
				s = d.data[1]
				result += s.getValue() * d.data[2]

			return round((result + linear) * multi)

		New(list/l)
			stats = l

	bar
		var
			minValue
			maxValue

		shift(amt)
			value = max(getMinValue(), min(getMaxValue(), getValue()+amt))

		scale(amt)
			value = max(getMinValue(), min(getMaxValue(), getValue()*amt))

		setValue(amt)
			value = max(getMinValue(), min(getMaxValue(), amt))

		getValue()
			var/linear = 0
			var/multi = 1
			for(var/mod/m in mods)
				if(m.targetVar == VALUE)
					if(m.kind == FLAT)
						linear += m.value
					else if(m.kind == MULTI)
						multi += m.value

			return max(getMinValue(), min(getMaxValue(), round((value + linear) * multi)))

		proc
			set_maxValue(amt)
				if(amt < minValue)
					debug.sendMessage("[__FILE__]:[__LINE__] - '[name]' cannot set maxValue ([maxValue]) to a value ([amt]) less than minValue ([minValue]).")
					return
				maxValue = amt
				src.setValue(src.value)

			getMaxValue()
				var/linear = 0
				var/multi = 1
				for(var/mod/m in mods)
					if(m.targetVar == MAXVALUE)
						if(m.kind == FLAT)
							linear += m.value
						else if(m.kind == MULTI)
							multi += m.value

				return round((maxValue + linear) * multi)

			set_minValue(amt)
				if(amt > maxValue)
					debug.sendMessage("[__FILE__]:[__LINE__] - '[name]' cannot set minValue ([minValue]) to a value ([amt]) greater than maxValue ([maxValue]).")
					return
				minValue = amt
				src.setValue(src.value)

			getMinValue()
				var/linear = 0
				var/multi = 1
				for(var/mod/m in mods)
					if(m.targetVar == MINVALUE)
						if(m.kind == FLAT)
							linear += m.value
						else if(m.kind == MULTI)
							multi += m.value

				return round((minValue + linear) * multi)

		New(nam, min, val, max)
			if(nam == null)
				nam = "Unnamed Stat"

			if(min > max)
				debug.sendMessage("[__FILE__]:[__LINE__] - '[nam]' cannot be created with a minValue ([min]) greater than maxValue ([max]).")
				return

			mods = list()

			name = nam
			minValue = min
			maxValue = max
			src.setValue(val)

mod
	var
		name
		atom/source
		targetVar
		kind
		value

	New(nam, sou, tgt, kin, val)
		name = nam
		source = sou
		targetVar = tgt
		kind = kin
		value = val