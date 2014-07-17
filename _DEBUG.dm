#define DEBUG

var/HexMap/map

Hex/Actor/Tree
	Click()
		..()
		del src

Hex/RedGlow
	Click()
		..()
		del src

client
	lazy_eye = 0
	perspective = MOB_PERSPECTIVE

	New()
		.=..()

		winset(src, "_DEBUG", "is-visible=true")

	verb
		SAVEMAP()
			saveHexMap(map)

		LOADMAP(id as text)
			loadHexMap(id)

		CREATEMAP(x as num, y as num, id as text)
			worldInitialization()

			if(map != null)
				for(var/key in map.hexTurfs)
					del map.hexTurfs[key]
				del map

			map = new/HexMap(id, x, y, 1)

			for(var/i = 1, i <= map.size_x, i ++)
				for(var/j = 1, j <= map.size_y, j ++)
					map.createHexTurf(i, j, /Hex/Turf/Dirt)

			var/trees = sqrt(map.size_x * map.size_y)
			for(var/i = 1, i <= trees, i ++)
				map.hexes |= new /Hex/Actor/Tree(map, rand(1, map.size_x), rand(1,map.size_y))

			mob.loc = locate(1,1,1)

		TESTHEXES()
			var/HexMap/map = hexMaps[hexMaps[1]]
			world<<"TEST MAP:: [map]"
			world<<"HEX TURFS: [map.hexes.len]"

			var/Hex/H = map.hexTurfs[1][1]
			world<<"TEST TURF 1,1: [H.x], [H.y], [H.pixel_x], [H.pixel_y] | [H.z]"

			world<<"== WORLD DIMS =="
			world<<"[world.maxx], [world.maxy], [world.maxz]"

		CREATEHEX(x as num, y as num)
			world << "CREATING TEST HEX AT [x], [y]"

			var/HexMap/map = hexMaps[hexMaps[1]]

			map.createHexTurf(x, y, /Hex/Turf)

mob
	icon = 'Test.dmi'
	layer = 1000