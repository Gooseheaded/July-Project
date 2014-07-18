/*
File:		Class.dm
Author:		Gooseheaded
Created:	18/07/14
*/

Class
	var
		name
		desc
		atom/movable/portrait

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