/*
*
*
*/


var/const
	MOD_FLAT = 1
	MOD_PROP = 2

	STAT_VALUE = 1
	STAT_MIN_VALUE = 2
	STAT_MAX_VALUE = 3

	PATH_COST = 10
	PATH_MAX_LEN =	8

var
	serverTime //server-time in seconds
	deltaTime //duration of each server tick, in seconds.

	maxServerTime = 1000000//If the servertime reaches this threshhold, then the serverTime is at risk of timer errors.
	//A server reboot at this point is necessary to prevent these errors

	pauseGame //This is a bool that will pause the game
	tickSpeedMult = 1 //A tick speed multiplier. x1.0 is 100% game speed. x2.0 is 200% game speed.

	activeClients[0]
	activeDatums[0]

	list/triggers
	list/slots

	list/admins

	list/chatGroups
	chatGroup/debug
	chatGroup/world_

world
	icon_size = 64

	fps = 30

	mob = /player

	New()
		worldInitialization()
		.=..()
		gameLogicLoop()

proc
	worldInitialization()
		// Trigger initialization
		triggers = list(
			"Physical Offense",
			"Physical Defense",
			"Magical Offense",
			"Magical Defense",
			"Kill",
			"Death",
			"Move",
			"Opportunity Offense",
			"Opportunity Defense")

		// Slots initialization
		slots = list(
			"Helmet",
			"Armor",
			"Belt",
			"Left Hand",
			"Right Hand",
			"Left Ring",
			"Right Ring",
			"Amulet")

		// Chat groups initialization
		chatGroups = list()

		debug = new /chatGroup("Debug")
		world_ = new /chatGroup("World")

		chatGroups += debug
		chatGroups += world_

		// Admins initialization
		admins = list("gooseheaded", "d4rk354b3r")

		world.maxx = 1
		world.maxy = 1
		world.maxz = 1

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
		view = "[screen_x]x[screen_y]"
		activeClients += src

	Del()
		activeClients -= src
		.=..()

	proc
		Tick()