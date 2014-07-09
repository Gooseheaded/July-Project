#define DEBUG

client
	lazy_eye = 0
	perspective = MOB_PERSPECTIVE

	New()
		.=..()

		winset(src, "_DEBUG", "is-visible=true")

	verb
		CREATEMAP(x as num, y as num)
			worldInitialization()

			new/HexMap("TEST", x, y, 1)

			mob.loc = locate(1,1,1)

		TESTHEXES()
			var/HexMap/map = hexMaps["TEST"]
			world<<"TEST MAP:: [map]"
			world<<"HEX TURFS: [map.hexes.len]"

			var/Hex/H = map.hexTurfs[1][1]
			world<<"TEST TURF 1,1: [H.x], [H.y], [H.pixel_x], [H.pixel_y] | [H.z]"

			world<<"== WORLD DIMS =="
			world<<"[world.maxx], [world.maxy], [world.maxz]"

		CREATEHEX(x as num, y as num)
			world << "CREATING TEST HEX AT [x], [y]"

			var/HexMap/map = hexMaps["TEST"]

			var/Hex/H = map.createHexTurf(x, y, /Hex/Turf)

mob
	icon = 'Test.dmi'
	layer = 1000