/*
File:		Chat Group.dm
Author:		Gooseheaded
Created:	07/07/14

A chat group is simply a datum that contains a list of atoms (its "members").

You can send a message to the members by using
	chatGroup.sendMessage(text).

You can add and remove members using
	chatGroup.add(member), chatGroup.remove(member).

Edits:
*/

chatGroup
	var
		name
		list/members

	proc
		add(atom/a)
			if(!(a in members))
				members += a

		remove(atom/a)
			if(a in members)
				members -= a

		sendMessage(txt)
			for(var/a in members)
				a << "\[[name]] [txt]"

	New(nam)
		name = nam
		members = list()