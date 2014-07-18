
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
			world<<"[hexMob.hexLoc]"

Hex

	Turf
		Dirt
			icon = 'dirtHex.png'


		Click(location,control,params)
			.=..()

			var/param[] = params2list(params)

			if(usr.client.hexMob && param["left"])
				world<<"MOVING HEX MOB TO [src]"


				var/path[] = findHexPath(usr.client.hexMob, src)
				for(var/Hex/H in path)
					usr.client.hexMob.animatedMoveTo(H.hex_x, H.hex_y, H.hex_z, 0.25, "animated", "")
					sleep(3)

				//usr.client.hexMob.moveTo(src.hex_x, src.hex_y, src.hex_z)


			if(param["right"])
				if(locate(/Hex/Doodad/grass) in hex_contents)
					var/Hex/Doodad/grass/G = locate(/Hex/Doodad/grass) in hex_contents
					hex_contents -= G

					G.AutoJoin()
					del G
				else
					world<<"CREATING GRASS AT [src]"

					var/HexMap/map = hexMaps[hexMaps[1]]
					var/Hex/Doodad/grass/G = new(map, hex_x, hex_y)
					map.hexes |= G

	Doodad
		Tree
			icon = 'tree.png'

			hex_density = 1
			hex_height = 1


			offset_x = -32
			offset_y = -28

		grass
			hex_height = 0.2
			icon = 'ThickGrass-joined.dmi'
			icon_state = "0"


			offset_x = -32
			offset_y = -22

			New()
				.=..()
				AutoJoin()

			proc
				AutoJoin()
					JoinFlags()

					for(var/Hex/Turf/H in getAdjacent())
						var/Hex/G = locate(src.type) in H.hex_contents
						if(G) G:JoinFlags()

				JoinFlags()
					var/flags = 0

					for(var/Hex/Turf/H in getAdjacent())
						if(locate(src.type) in H.hex_contents)
							flags |= src.getHexDir(H)

					icon_state = "[flags]"

	Actor
		TestMob
			layer_mod = 0

			icon = 'TestMob.dmi'

			offset_x = -32
			offset_y = -4

			hex_density = 1
			hex_height = 1

			var
				client/c



			offset_x = -32
			offset_y = -9

			mouse_opacity = 0