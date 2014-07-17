/*
File:		Character.dm
Author:		Gooseheaded
Created:	08/07/14

Edits:
*/

character
	parent_type = /mob

	var
		list/stats
		list/slots

	New()
		..()
		stats = list()
		slots = list()