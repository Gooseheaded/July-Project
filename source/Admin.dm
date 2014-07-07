/*
File:		Admin.dm
Author:		Gooseheaded
Created:	07/07/14

Edits:
*/

var
	list/admins

world
	New()
		..()
		admins = list()

		admins += "gooseheaded"