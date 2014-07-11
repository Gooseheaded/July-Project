
var/const
	TAG_SECTION = "\[section]"
	TAG_INFO =	"\[info]"
	TAG_HEX =	"\[hex]"
	TAG_FIELD = "\[field]"
	SECTIONS = 1

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

		text2file(save, hmap.mapID + ".hmf")

		/*
		save += TAG_SECTION
		for(var/Hex/hex in hmap.hexTurfs)
			save += TAG_HEX
			save += TAG_FIELD + "[hex.hex_x]"
			save += TAG_FIELD + "[hex.hex_y]"
		*/

	loadHexMap(hmap)
		if(!(length(file(hmap + ".hmf"))))
			debug.sendMessage("[__FILE__]:[__LINE__] - Map file '[hmap].hmf' does not exist.")
			return

		if(map != null)
			for(var/key in map.hexTurfs)
				del map.hexTurfs[key]
			del map

		var/list/sections =	split(file2text(hmap), TAG_SECTION)
		var/list/section
		var/list/fields

		if(sections == null)
			debug.sendMessage("[__FILE__]:[__LINE__] - Map file '[hmap].hmf' could not be opened (no sections were read).")
			return
		if(section.len < SECTIONS)
			debug.sendMessage("[__FILE__]:[__LINE__] - Map file '[hmap].hmf' is malformed (has [section.len] sections, [SECTIONS] were espected).")
			return

		// Map info
		var/mapSizeX
		var/mapSizeY
		section =	split(sections[2], TAG_INFO)
		fields = split(section, TAG_FIELD)
		mapSizeX = fields[2]
		mapSizeY = fields[3]

		/*
		// Hexes
		var/list/mapHexes = list()
		section = split(sections[3], TAG_HEX)
		for(var/i = 2, i < hexes.len, i ++)
			fields = split(hexes[i], TAG_FIELD)
			...
		*/

		debug.sendMessage("[__FILE__]:[__LINE__] - Map file '[hmap].hmf' was successfully loaded.")
		map = new/HexMap(hmap, mapSizeX, mapSizeY, 1)
		for(var/client/c)
			c.mob.loc = locate(1,1,1)
