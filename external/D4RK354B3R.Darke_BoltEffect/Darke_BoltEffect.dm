//This is for drawing lightning bolt type of effects!
//It places a line of objects for the lightning bolt.

var
	boltLayer = 500

proc
	animatedBolt(tx1, ty1, tx2, ty2, px1=0, py1=0, px2=0, py2=0)
		spawn()
			var/boltObjects[0]

			boltObjects += DrawBoltEffect('BoltFade.dmi', tx1, ty1, tx2, ty2, px1, py1, px2, py2)
			boltObjects += DrawBoltEffect('BoltFade.dmi', tx1, ty1, tx2, ty2, px1, py1, px2, py2)


			boltObjects += DrawBoltEffect('Bolt.dmi', tx1, ty1, tx2, ty2, px1, py1, px2, py2, boltLayer-100, 32)

			sleep(2)
			boltObjects += DrawBoltEffect('Bolt.dmi', tx1, ty1, tx2, ty2, px1, py1, px2, py2, boltLayer-100, 32)

			sleep(2)

			for(var/i in boltObjects) del i

	boltWithFade(tx1, ty1, tx2, ty2, px1=0, py1=0, px2=0, py2=0, length = 2, icon/I)
		spawn()
			var/boltObjects[0]
			boltObjects += DrawBoltEffect(I, tx1, ty1, tx2, ty2, px1, py1, px2, py2, boltLayer-100, 32, length)

			sleep(2)

			for(var/i in boltObjects) del i

	DrawBoltEffect(icon/I, tx1, ty1, tx2, ty2, px1=0, py1=0, px2=0, py2=0, layer=boltLayer-100, pieceLength = 32,\
		boltMultiplier = 2, tz = 2)
	//Parameters are as follows:
	//Lightning bolt icon
	//tx and ty correspond to tile coordinates of the starting and ending position. So tx2 is x of the end
	//px and py correspond to pixel offsets of the starting and ending position. so py1 is the pixel y of the start.
	//layer is straightforward.
	//piece length is straightforward; it's just the length, in pixels, of the individual bolt pieces from the icon used.

	//bolt multiplier is a decimal value that determines how... smooth the lightning bolt is.
	//	Values for boltMultiplier:
	//		Less than 0.5 may cause problems
	//		0.5 to 1.0 will be almost beam-like
	//		1.0 to 1.5 will be somewhat jagged/random
	//		1.5 to 2.0 will be nicely jagged and random
	//		Above 2.0 will make the bolt feel a little too jagged or random

	//This function does not handle the cleanup for the placed bolt objects.
	//It will merely place the bolt objects and flick them
	//HOWEVER, it does return a list of all bolt objects placed...
	//so it is convenient to set up your own cleanup and deletion

	//If you want to make your own bolt icons, follow BoltBase.dmi as a guideline.
	//It has the basic shape and length and angles for bolt icons that can be used by this function
		var/dx, dy

		var/cx = tx1*icon_x + px1
		var/cy = ty1*icon_y + py1

		var/fx = tx2*icon_x + px2
		var/fy = ty2*icon_y + py2

		dx = fx-cx
		dy = fy-cy


		var/distance = dx*dx+dy*dy
		var/length = boltMultiplier * sqrt(distance)

		var/closeRange = pieceLength*0.7 - 1

		var/boltList[0]

		while(distance > closeRange*closeRange)
			//first create the next location
			//do this by creating the angular list.
			var/angle = round(arctan2(dy,dx), 22.5)
			var/drawAngle=0

			var/angleList[0]
			var/angRange = 67.5

			for(var/i=angle-angRange; i<=angle+angRange; i += 22.5)
				angleList += i

			var/tries

			repickAngle:
			tries ++
			drawAngle = pick(angleList)
			var/ux = cx + pieceLength*cos(drawAngle)
			var/uy = cy + pieceLength*sin(drawAngle)

			var/ud = dist(ux,fx,uy,fy)
			if(ud > length || ud > sqrt(distance) || ux < 0 || uy < 0 || ux > world.maxx*icon_x || uy > world.maxy * icon_y)
				if(tries < 5) goto repickAngle:
				else drawAngle = angle

			ux = cx + pieceLength*cos(drawAngle)
			uy = cy + pieceLength*sin(drawAngle)
			ud = dist(ux,fx,uy,fy)

			angle = drawAngle
			while(drawAngle >= 180) drawAngle -= 180
			while(drawAngle < 0) drawAngle += 180

			var/off_x = 16 * cos(angle)
			var/off_y = 16 * sin(angle)

			var/obj/O = new()
			O.x = round(cx/icon_x)
			O.y = round(cy/icon_y)
			O.z = tz
			O.pixel_x = cx%icon_x+off_x //add offets if necessary
			O.pixel_y = cy%icon_y+off_y //add offests if necessary
			O.density = 0
			O.icon = I
			O.icon_state = "[drawAngle]"
			O.layer = layer
			O.mouse_opacity = 0

			cx = ux
			cy = uy

			dx = fx-cx
			dy = fy-cy

			distance = dx*dx+dy*dy

			length -= pieceLength

			boltList += O

		return boltList