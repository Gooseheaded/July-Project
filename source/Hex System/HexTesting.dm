
client
	var
		Hex/Actor/TestMob/hexMob

	verb
		createHexMob()
			world<<"creating hex mob"
			if(hexMob)
				del hexMob

			var/HexMap/map = hexMaps[hexMaps[1]]

			hexMob = new(map, 1, 1, 0)
			hexMob.name = "[src.key]"

			world<<"created hex mob: [hexMob]"

		hexMobDebug()
			world<<"::HEX MOB::"
			world<<"\<[hexMob.hex_x], [hexMob.hex_y], [hexMob.hex_z]> [hexMob.layer]"
			world<<"\<[hexMob.x]: [hexMob.pixel_x], [hexMob.y]: [hexMob.pixel_y]>"

Hex

	Turf
		Click()
			.=..()

			if(usr.client.hexMob)
				world<<"MOVING HEX MOB TO [src]"

				usr.client.hexMob.animatedMoveTo(hex_x, hex_y, hex_z, 0.25, "animated", "")

				//usr.client.hexMob.moveTo(src.hex_x, src.hex_y, src.hex_z)


	Actor
		TestMob
			layer_mod = 50

			icon = 'TestMob.dmi'

			offset_x = -32
			offset_y = -4

			hex_density = 1

			var
				client/c