#define DEBUG

var/HexMap/map

Hex/Turf
	Click(location,control,params)
		..()

		//map.hexes |= new /Hex/Actor/Tree(map, hex_x, hex_y)

		var/param[] = params2list(params)

		world<<params

		if(param["right"])
			world<<"TOGGLE PERIMETER MAN"

			if(locate(/Hex/RedGlow) in hex_contents)
				del locate(/Hex/RedGlow)
			else
				map.hexes |= new /Hex/RedGlow(map, hex_x, hex_y)

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
					if(prob(50))
						map.createHexTurf(i, j, /Hex/Turf/Dirt)
					else
						map.createHexTurf(i, j, /Hex/Turf/Grass)

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