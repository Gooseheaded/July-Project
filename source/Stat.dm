/*
File:		Stat.dm
Author:		Gooseheaded
Created:	07/07/14

Edits:
*/

/*
Stats are a controlled way of managing buffs and debuffs on a character.

Stat datums (/stat) have a simple value that you can modify using
	stat.shift(amount), which is simple addition/subtraction;
	stat.scale(amount), which is multiplication;
	stat.setValue(amount), for hard-core value setup.

What really matter here is the following:
	stat.getValue(), which returns this stat's "post-computation" value.

To understand what "post-computation" means, read about Mods, down below.
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

	/*
	INCOMPLETE

	This works exactly like a stat, but uses other stats' values to
	 calculate its own.
	*/
	subStat
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

	/*
	Bar stats (/stat/bar) behave slightly different to stats.

	Whereas stats have a single value that is modified, bar stats also have
	 a minimum and a maximum value. As such, it also has new procs:
		bar.getMaxValue(),
		bar.getMinValue(),
		bar.setMaxValue(), and
		bar.setMinValue().

	It's important to note that a maximum value can never be less than the minimum.
	Attempting to do this results in an error, and the values do not change.

	Using
		bar.shift(amount), or
		bar.scale(amount), or
		bar.setValue(amount)
	 always assures that the bar's value is clamped between the "post-computation"
	 minimum and maximum values.
	*/
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
			setMaxValue(amt)
				if(amt < minValue)
					debug.sendMessage("[__FILE__]:[__LINE__] - '[name]' cannot set maxValue ([maxValue]) to a value ([amt]) less than minValue ([minValue]).")
					return
				maxValue = amt
				src.setValue(src.value)

			getMaxValue()
				var/linear = 0
				var/multi = 1
				for(var/mod/m in mods)
					if(m.targetVar == MAX_VALUE)
						if(m.kind == FLAT)
							linear += m.value
						else if(m.kind == MULTI)
							multi += m.value

				return round((maxValue + linear) * multi)

			setMinValue(amt)
				if(amt > maxValue)
					debug.sendMessage("[__FILE__]:[__LINE__] - '[name]' cannot set minValue ([minValue]) to a value ([amt]) greater than maxValue ([maxValue]).")
					return
				minValue = amt
				src.setValue(src.value)

			getMinValue()
				var/linear = 0
				var/multi = 1
				for(var/mod/m in mods)
					if(m.targetVar == MIN_VALUE)
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

/*
You can link Mod datums (/mod) to stats, and act as buffs and debuffs.

To create a mod, use the default constructor:
	var/mod/m = new/mod(a, b, c, d, e)

	a: Name for this mod. (eg "Slowed", "Enraged", "Intimidation")
	b: The source of this mod.
	 Used for clarity purposes (eg "Warlock #5 is casting Slow on you.")
	c: The target variable this mod will be modifying.
	 For stats, it can only be set to VALUE.
	 For bars, it can also be set to MAX_VALUE or MIN_VALUE.
	d: Either FLAT or MULTI.
	 FLAT means the value will be added/subtracted. (eg +5 Strength)
	 Multi means it will be multiplied. (eg +10% Wisdom)
	e: The value by which this mod will be adding/multiplying the stat it's linked to.

For example, the following mod would lower a target's maximum strength by 10%:
	assume var/stat/strength belongs to a PC,
	and that src is an NPC.

	var/mod/weaken = new/mod("Weakened", src, MAX_VALUE, MULTI, -0.10)
	strength.mods += weaken

To link a mod to a stat, simply do
	stat.mods += mod.

Mods are taken into consideration whenever
	stat.getValue()
 is used.

Mods can also change a bar's minimumm and maximum values. Again,
	bar.getValue(),
	bar.getMinValue(), and
	bar.getMaxValue()
 will return proper "post-computation" values.
*/
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