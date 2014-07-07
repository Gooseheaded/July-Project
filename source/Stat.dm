
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

		set_value(amt)
			value = amt

		get_value()
			var/linear = 0
			var/multi = 1
			for(var/mod/m in mods)
				if(m.target_var == VALUE)
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

		get_value()
			var/linear = 0
			var/multi = 1
			var/result

			for(var/mod/m in mods)
				if(m.target_var == VALUE)
					if(m.kind == FLAT)
						linear += m.value
					else if(m.kind == MULTI)
						multi += m.value

			var/stat/s
			for(var/data/d in stats)
				s = d.data[1]
				result += s.get_value() * d.data[2]

			return round((result + linear) * multi)

		New(list/l)
			stats = l

	bar
		var
			min_value
			max_value

		shift(amt)
			value = max(get_min_value(), min(get_max_value(), get_value()+amt))

		scale(amt)
			value = max(get_min_value(), min(get_max_value(), get_value()*amt))

		set_value(amt)
			value = max(get_min_value(), min(get_max_value(), amt))

		get_value()
			var/linear = 0
			var/multi = 1
			for(var/mod/m in mods)
				if(m.target_var == VALUE)
					if(m.kind == FLAT)
						linear += m.value
					else if(m.kind == MULTI)
						multi += m.value

			return max(get_min_value(), min(get_max_value(), round((value + linear) * multi)))

		proc
			set_max_value(amt)
				if(amt < min_value)
					debug.send_message("[__FILE__]:[__LINE__] - '[name]' cannot set max_value ([max_value]) to a value ([amt]) less than min_value ([min_value]).")
					return
				max_value = amt
				src.set_value(src.value)

			get_max_value()
				var/linear = 0
				var/multi = 1
				for(var/mod/m in mods)
					if(m.target_var == MAX_VALUE)
						if(m.kind == FLAT)
							linear += m.value
						else if(m.kind == MULTI)
							multi += m.value

				return round((max_value + linear) * multi)

			set_min_value(amt)
				if(amt > max_value)
					debug.send_message("[__FILE__]:[__LINE__] - '[name]' cannot set min_value ([min_value]) to a value ([amt]) greater than max_value ([max_value]).")
					return
				min_value = amt
				src.set_value(src.value)

			get_min_value()
				var/linear = 0
				var/multi = 1
				for(var/mod/m in mods)
					if(m.target_var == MIN_VALUE)
						if(m.kind == FLAT)
							linear += m.value
						else if(m.kind == MULTI)
							multi += m.value

				return round((min_value + linear) * multi)

		New(nam, min, val, max)
			if(nam == null)
				nam = "Unnamed Stat"

			if(min > max)
				debug.send_message("[__FILE__]:[__LINE__] - '[nam]' cannot be created with a min_value ([min]) greater than max_value ([max]).")
				return

			mods = list()

			name = nam
			min_value = min
			max_value = max
			src.set_value(val)

mod
	var
		name
		atom/source
		target_var
		kind
		value

	New(nam, sou, tgt, kin, val)
		name = nam
		source = sou
		target_var = tgt
		kind = kin
		value = val