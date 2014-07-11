
var/const
	TAG_SECTION = "\[section]"
	TAG_INFO =	"\[info]"
	TAG_HEX =	"\[hex]"
	TAG_FIELD = "\[field]"
	SECTIONS = 2
	DEBUG_MAP =	FALSE

proc
	saveHexMap(HexMap/hmap)
		if(length(file(hmap.mapID)))
			debug.sendMessage("[__FILE__]:[__LINE__] - Map file '[hmap.mapID].hmf' already exists, and will not be overwritten.")
			return

		var/save = ""

		save += TAG_SECTION
		save += TAG_INFO
		save += TAG_FIELD + "[hmap.size_x]"
		save += TAG_FIELD + "[hmap.size_y]"

		save += TAG_SECTION
		for(var/i = 1, i <= hmap.size_x, i ++)
			for(var/j = 1, j <= hmap.size_y, j ++)
				var/Hex/hex = hmap.getHex(i, j)
				if(hex)
					save += TAG_HEX
					save += TAG_FIELD + "[hex.type]"
					save += TAG_FIELD + "[hex.hex_x]"
					save += TAG_FIELD + "[hex.hex_y]"

		text2file(save, hmap.mapID + ".hmf")
		debug.sendMessage("[__FILE__]:[__LINE__] - Map file '[hmap.mapID].hmf' was successfully saved.")

	loadHexMap(hmap)
		if(!(length(file(hmap + ".hmf"))))
			debug.sendMessage("[__FILE__]:[__LINE__] - Map file '[hmap].hmf' does not exist.")
			return

		if(map != null)
			for(var/key in map.hexTurfs)
				del map.hexTurfs[key]
			del map

		if(DEBUG_MAP)
			debug.sendMessage("Map contents:")
			debug.sendMessage(file2text(hmap + ".hmf"))

		var/list/sections = dd_text2list(file2text(hmap + ".hmf"), TAG_SECTION)
		var/list/section
		var/list/fields

		if(sections == null)
			debug.sendMessage("[__FILE__]:[__LINE__] - Map file '[hmap].hmf' could not be opened (no sections were read).")
			return
		if(sections.len < SECTIONS)
			debug.sendMessage("[__FILE__]:[__LINE__] - Map file '[hmap].hmf' is malformed (has [section.len] sections, [SECTIONS] were espected).")
			return

		sections -= sections[1]
		if(DEBUG_MAP)
			debug.sendMessage("Sections ([sections.len]):")
			for(var/a in sections)
				debug.sendMessage("\t>[a]")

		// Map info
		var/mapSizeX
		var/mapSizeY

		section = dd_text2list(sections[1], TAG_INFO)
		section -= section[1]
		if(DEBUG_MAP)
			debug.sendMessage("Contents of section #1:")
			for(var/a in section)
				debug.sendMessage("\t>[a]")

		fields = dd_text2list(section[1], TAG_FIELD)
		fields -= fields[1]
		if(DEBUG_MAP)
			debug.sendMessage("Fields in section #1 ([fields.len]):")
			for(var/a in fields)
				debug.sendMessage("\t>[a]")

		mapSizeX = text2num(fields[1])
		mapSizeY = text2num(fields[2])

		map = new/HexMap(hmap, mapSizeX, mapSizeY, 1)
		for(var/client/c)
			c.mob.loc = locate(1,1,1)

		// Hexes
		section = dd_text2list(sections[2], TAG_HEX)
		section -= section[1]
		if(DEBUG_MAP)
			debug.sendMessage("Hexes in section #2 ([section.len]):")
			for(var/a in section)
				debug.sendMessage("\t>[a]")
		for(var/hex in section)
			fields = dd_text2list(hex, TAG_FIELD)
			fields -= fields[1]
			map.createHexTurf(text2num(fields[2]), text2num(fields[3]), text2path(fields[1]))

		debug.sendMessage("[__FILE__]:[__LINE__] - Map file '[hmap].hmf' was successfully loaded.")
