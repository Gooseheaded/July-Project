var
	hexMaps[0] //This contains all hex maps! This is an associated list
	//mapID = object reference

proc
	findUnusedMapZ()
		var/z = 1

		while(1)
			var/foundEmpty = 1
			for(var/i in hexMaps)
				var/HexMap/M = hexMaps[i]
				if(M.map_z == z)
					z++
					foundEmpty = 0
					break

			if(foundEmpty) return z

//This is a container for all of the hex objects within a single "map" or gamescreen.

HexMap
	var
		size_x
		size_y

		hexTurfs[0] //This is all hex Turfs in the map
		//This is a hash table

		hexes[0] //This is all hexes in this map

		//these four variables represent the raw pixel screen boundaries of the four edges of the map
		screen_top
		screen_bottom
		screen_right
		screen_left

		map_z

		mapID

		ready = 0

	New(ID, x, y, z, defaultHexType = /Hex/Turf)
		mapID = ID
		hexMaps[ID] = src

		map_z = z
		if(map_z > world.maxz) world.maxz = map_z

		initMap(x, y, defaultHexType)

		ready = 1

	proc
		getHex(hex_x, hex_y)
			if(hex_x <= 0 || hex_y <= 0) return
			if(hex_x > size_x || hex_y > size_y) return

			return hexTurfs["[hex_x],[hex_y]"]

		computeScreenBoundaries()
			var/vector
				bottomLeft	= vec3()
				bottomRight	= vec3()
				topLeft		= vec3()
				topRight	= vec3()

			bottomRight = bottomRight.add(hex_axis_x.multiply(size_x))
			topRight = topRight.add(hex_axis_x.multiply(size_x))

			topLeft = topLeft.add(hex_axis_y.multiply(size_y))
			topRight = topRight.add(hex_axis_y.multiply(size_y))

			screen_top = max(topLeft.y, topRight.y)
			screen_bottom = min(bottomLeft.y, bottomRight.y)
			screen_left = min(bottomLeft.x, topLeft.x)
			screen_right = max(topRight.x, bottomRight.x)

		initMap(x, y, defaultHexType = /Hex/Turf)
			disposeMap()

			size_x = x
			size_y = y

			computeScreenBoundaries()

			var/screen_width = screen_right - screen_left
			var/screen_height = screen_top - screen_bottom

			if(world.maxx * icon_x < screen_width + icon_x)
				world.maxx = (ceil(screen_width/icon_x))+1


			if(world.maxy * icon_y < screen_height + icon_y)
				world.maxy = (ceil(screen_height/icon_y))+1


			hexTurfs = new/list(x, y)

			for(var/i = 1; i <= x; i++)
				for(var/j = 1; j <= y; j++)
					createHexTurf(i, j, defaultHexType)

		createHexTurf(x, y, hexType)
			if(hexTurfs["[x],[y]"]) del hexTurfs["[x],[y]"]
			var/Hex/H = new hexType(src, x, y)
			hexTurfs["[x],[y]"] = H
			hexes += H

			return H


		readMap(file) //YEAH

		saveMap(file)

		disposeMap() //This is used for disposing objects and shit
			for(var/Hex/Turf/H in hexes)
				del H

		getHexLine(Hex/A, Hex/B)
			var/Hex/Start = getHex(A.hex_x, A.hex_y)
			var/Hex/End = getHex(B.hex_x, B.hex_y)

			var/Hex/Current = Start
			var/line[0]

			while(Current != End)
				line += Current

				var/vector/vectorTo = vec2(End.x - Current.x, End.y - Current.y)
				vectorTo = vectorTo.unit()

				var/highestDot = 0
				var/Hex/Next

				for(var/Hex/H in Current.getAdjacent())
					var/vector/temp = vec2(H.x - Current.x, H.y - Current.y)

					if(temp.dot(vectorTo) >= highestDot)
						highestDot = temp.dot(vectorTo)
						Next = H

				if(Next) Current = Next
				else break

			line += Current

			return line