
var/const
	FLAT = 1
	MULTI = 2

	VALUE	 = 1
	MIN_VALUE = 2
	MAX_VALUE = 3

var
	serverTime //server-time in seconds
	deltaTime //duration of each server tick, in seconds.

	maxServerTime //If the servertime reaches this threshhold, then the serverTime is at risk of timer errors.
	//A server reboot at this point is necessary to prevent these errors

	pauseGame //This is a bool that will pause the game
	tickSpeedMult = 1 //A tick speed multiplier. x1.0 is 100% game speed. x2.0 is 200% game speed.

	activeClients[0]
	activeDatums[0]

world

	mob = /player

	New()
		.=..()

		worldInitialization()

		gameLogicLoop()

proc
	worldInitialization()

	gameLogicLoop()
		while(1)
			if(pauseGame)
				sleep(0)
				sleep(world.tick_lag)

			sleep(0)

			deltaTime = world.tick_lag/10 * tickSpeedMult
			serverTime += deltaTime

			sleep(world.tick_lag)

			for(var/client/C in activeClients)
				if(C.tickTimer <= serverTime)
					C.Tick()

			for(var/datum/D in activeDatums)
				if(D.tickTimer <= serverTime)
					D.Tick()

datum
	var
		isActive = 0
		tickTimer

	New()
		.=..()
		if(isActive) activeDatums += src

	Del()
		if(isActive) activeDatums -= src
		.=..()

	proc
		Tick()


client
	var
		tickTimer


	New()
		.=..()
		activeClients += src

	Del()
		activeClients -= src
		.=..()

	proc
		Tick()