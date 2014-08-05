/*
File:		Class.dm
Author:		Gooseheaded
Created:	18/07/14
*/
var
	selectableClasses[0]

PlayerClass
	var
		name
		desc
		atom/movable/portrait //I'm not sure how I feel about a portait for classes...


		isPlayable = 0//This bool describes whether or not this class should be selectable in character creation.

		//icon maybe?

		//base stats

		//starting items

		//abilities


		//Perhaps an items table for different corresponding levels
		//For example, a level 10 archer that's brand new should have different gear
		//than a level 1 archer that's brand new?


	proc
		buildMob()
			//This builds a character mob of this class, and returns it.
			//It should initialize...
			//Abilities
			//Items & Inventory & Equipment
			//Stats

			//It should NOT initialize...
			//character race
			//character appearance


/*
	New(nam, des, por)
		if(nam != null && !istext(nam))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create Class with arg '[nam]' (must be text).")
			del src
		if(des != null && !istext(des))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create Class with arg '[des]' (must be text).")
			del src
		if(por != null && !isfile(por))
			debug.sendMessage("[__FILE__]:[__LINE__] - Cannot create Class with arg '[por]' (must be a file).")
			del src

		name = nam
		desc = des
		portrait = new()
		portrait.icon = por
*/

proc
	initializeClasses()
		var/paths[] = typesof(/PlayerClass) - /PlayerClass
		for(var/t in paths)
			var/PlayerClass/C = new t ()
			if(C.isPlayable) selectableClasses += C