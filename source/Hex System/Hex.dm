//This hex system uses a staggered Y axis, to try to preserve a box-like shape for the map.
//Otherwise, using highly slanted axes, we would get a very skewed map shape for a map that is rectangular in data.

var
	//These are vectors that are used to convert hex coordinates to 2d screen coordinates.
	vector
		hex_axis_x = 	vec2( 102 ,	-19, 	0)
		hex_axis_y = 	vec2( 24, 	61,  	0)
		hex_axis_z = 	vec3( 0,  	0,   	44)

		//hex_center is the offset from the bottom left of a standard hex icon to the center of the main face
		//If the hex in question is taller or shorter than the unit hex height, then use hex_axis_z accordingly
		hex_center = 	vec3(52, 77)

	const
		maxHexLayer = 200
		minHexLayer = 1

//A Hex is actually any object that lies within the hexagonal tile system
Hex
	icon = 'Hex Tile Reference Model.png'

	parent_type = /atom/movable

	var
		//Tile coordinates for hexes.
		//hex_x and hex_y are used as matrix indices for the HexMap, so they should be integer
		//hex_z can be decimal.
		hex_x
		hex_y
		hex_z

		hex_height //This is in the same units as hex_z

		hex_contents[0] //yep

		HexMap/map //This is a reference to the map that this hex belongs in
		Hex/hexLoc

		layer_mod //This is a flat number added to all computed layers for this hex

		hex_density //0 or 1


	New(hexMap, nx, ny, nz = 0)
		map = hexMap
		hex_x = nx
		hex_y = ny
		hex_z = nz

		#ifdef DEBUG
		name = "HEX: [nx], [ny], [nz]"
		#endif

		moveTo(hex_x, hex_y, hex_z)


	Click()
		.=..()

		var/vector/v = computeCoords(hex_x, hex_y, hex_z)

		world<<"== HEX: [hex_x], [hex_y], [hex_z] =="
		world<<"([x]: [pixel_x], [y]: [pixel_y]) [layer]"
		world<<"[v.toString()]"
		world<<"[map.screen_top], [map.screen_bottom], [map.screen_left], [map.screen_right]"

	proc
		computeCoords(hx, hy, hz)
			//This function returns a vector object that represents this hex's screen coordinates.
			var
				vector/coordinates = vec3(0, 0, 0)


			coordinates = coordinates.add(hex_axis_x.multiply(hex_x-1))
			if(hex_y % 2 == 0) coordinates = coordinates.add(hex_axis_x.multiply(0.5))

			coordinates = coordinates.add(hex_axis_y.multiply(hex_y-1))
			coordinates = coordinates.add(hex_axis_z.multiply(hex_z))

			coordinates.y -= map.screen_bottom

			return coordinates

		animatedMoveTo(new_x, new_y, new_z, duration = 1, animated_state = icon_state, finished_state = icon_state)
			//This function will use LERP tweening to smoothly animate src from the current coordinates
			//to the new specified coordinates
			//new_x, new_y, new_z corresponds to the new desired hex coordinates.
			//duration is the duration of the animation, in seconds
			//animated_state is the icon_state that will be used for the duration of this animation.
			//finished_state is the icon_state that will be set after the animation is completed

			//First compute the pixel difference between the two screen coordinates
			var/vector
				current = computeCoords(hex_x, hex_y, hex_z)
				newCoords = computeCoords(new_x, new_y, new_z)
				difference = newCoords.subtract(current)

			var
				currentLayer = src.layer
				newLayer = computeScreenLayer(newCoords)

			//Then apply the movement
			if(!moveTo(new_x, new_y, new_z)) return 0

			//Then apply the animation
			var/matrix/m = new()
			m.Translate(-difference.x, -difference.y - difference.z)

			transform = m

			icon_state = animated_state

			duration *= 0.1

			layer = currentLayer

			animate(src, layer = newLayer, transform = new/matrix(), time=duration)

			//Spawn a new thread: set the finished_state after animation is completed.
			spawn(duration)
				icon_state = finished_state

		moveTo(new_x, new_y, new_z)
			var/vector/coordinates = computeCoords(new_x, new_y, new_z)
			layer = computeScreenLayer(coordinates)

			hex_x = new_x
			hex_y = new_y
			hex_z = new_z

			var/px = coordinates.x
			var/py = coordinates.y + coordinates.z

			//add the map offset stuff to the px and py here
			var
				lx = round(px/icon_x) + 1
				ly = round(py/icon_y) + 1
				lz = map.map_z

			pixel_x = px%icon_x
			pixel_y = py%icon_y

			loc = locate(lx, ly, lz)

			if(pixel_x > icon_x / 2)
				x ++
				pixel_x -= icon_x

			if(pixel_y > icon_y / 2)
				y ++
				pixel_y -= icon_y

			. = 1

			hexLoc = map.getHex(new_x, new_y, new_z)
			if(hexLoc != src && hexLoc != null)
				hexLoc.entered(src)

		computeScreenLayer(vector/coordinates)
			var
				py = coordinates.y
				pz = coordinates.z

				newLayer

			//some function using the 3 of these variables
			//linearly interpolating between the two screen boundaries of the map.
			var/mapHeight = map.screen_top - map.screen_bottom
			var/deltaLayer = maxHexLayer - minHexLayer
			newLayer = deltaLayer * (1 - py / mapHeight) + minHexLayer

			newLayer += pz * 0.1 + layer_mod

			return newLayer

		canEnter(Hex/H)
			. = 1

		entered(Hex/H)


	turf
		canEnter(Hex/H)
			if(!H.hex_density) return 1
			if(H.hex_density && hex_density) return 0
			for(var/Hex/E in hex_contents)
				if(H.hex_density && E.hex_density) return 0

			return 1

	actor
		moveTo(new_x, new_y, new_z) //This returns a 0 if it failed.

			//do the collission detection first?
			var/Hex/turf
				newLoc = map.getHex(new_x, new_y)

			if(!newLoc.canEnter(src)) return 0
			else
				new_z = newLoc.hex_height
				..(new_x, new_y, new_z)