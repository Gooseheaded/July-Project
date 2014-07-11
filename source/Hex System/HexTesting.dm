
client
	var
		Hex/Actor/Testmob/hexmob

	verb
		createHexmob()
			world<<"creating hex mob"
			if(hexmob)
				del hexmob

			var/HexMap/map = hexMaps[hexMaps[1]]

			hexmob = new(map, 1, 1, 0)
			hexmob.name = "[src.key]"

			world<<"created hex mob: [hexmob]"

		hexmobDebug()
			world<<"::HEX mob::"
			world<<"\<[hexmob.hex_x], [hexmob.hex_y], [hexmob.hex_z]> [hexmob.layer]"
			world<<"\<[hexmob.x]: [hexmob.pixel_x], [hexmob.y]: [hexmob.pixel_y]>"

Hex

	Turf
		Click()
			.=..()

			if(usr.client.hexmob)
				world<<"MOVING HEX mob TO [src]"

				//usr.client.hexmob.animatedMoveTo(hex_x, hex_y, hex_z, 0.25, "animated", "")
				var/list/path = findHexPath(usr.client.hexmob, src)
				for(var/Hex/h in path)
					usr.client.hexmob.animatedMoveTo(h.hex_x, h.hex_y, h.hex_z, 0.25, "animated", "")
					sleep(4)

	Actor
		Testmob

			icon = 'Testmob.dmi'

			offset_x = -32
			offset_y = -4
			layer_mod = 1

			hex_density = 1

			var
				client/c

		Tree
			icon = 'tree.png'
			offset_x = -32
			offset_y = -28
			hex_density = 1
			layer_mod = 1

			mouse_opacity = 0