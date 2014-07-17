var
	charLimit = 200 //Character limit per chat message
	chatLimit = 8 //number of spammable lines before mute delay
	chatDelay = 2 //mute cooldown delay in seconds

	lineLength = 30 //Character limit per line

	//The following sound variables are used for chat events.
	systemSound
	chatSound
	loginSound
	logoutSound

//Default font size: 36
//Announcement: 70
//Font: tahoma

client
	var
		chatCount
		chatTimer

		chatColor = "#FFFFFF"

		chatBox/chat

	New()
		.=..()

		//make a chat box


		if(loginSound) world<<sound(loginSound)

	Del()
		//delete the chat box

		if(logoutSound) world<<sound(logoutSound)

		.=..()

	verb
		say(t as text)
			if(!t) return 0
			if(chatCount >= chatLimit) return 0

			if(!findtext(t, " ") && length(t) > lineLength)
				t = copytext(t,1,lineLength)

			if(!length(ckeyEx(t))) t = copytext(t,1,round(charLimit/3))

			if(length(t) > charLimit) t = copytext(t,1,charLimit)

			t = html_encode(t)

			var/text = "<b><font color = [src.chatColor]>[src.key]:</b></font> <font color = white>[t]</font>"

			chatCount++
			chatTimer = serverTime + chatDelay

			globalChat(text)

			if(chatSound) world<<sound(chatSound)

	Tick()
		if(chatCount > 0 && serverTime >= chatTimer)
			chatTimer = serverTime + chatDelay
			chatCount --

proc
	globalChat(string, tag = "Global Chat")
		for(var/chatBox/C)
			if(tag == "Global Chat" && !C.tag)
				//send the line
				C.addLine(string)

			else
				if(tag == C.tag)
					//send the line
					C.addLine(string)

/*

Tokenizing of the input string has been removed due to lag concerns...

CHAT OBJECT
- list of line objects
- associated team or list of clients
- max lines

*/

chatBox
	var
		lines[0]

		clients[0]

		maxLines = 10

		screen_x
		screen_y

		px=0
		py=0

		chatDelay = 10

		HUDObj/hud


	New(sx,sy,pix,piy) //parameters:
		//sx - X tile-coordinate on screen
		//sy - Y tile-coordinate on screen
		//pix - X pixel offset
		//piy - Y pixel offset

		screen_x = sx
		screen_y = sy
		px = pix
		py = piy

		hud = new()
		hud.screen_loc = "[sx]:[pix],[sy]:[piy]"
		hud.maptext_width = 200
		hud.maptext_height = 345

		hud.layer = HUD_LAYER+10

	Tick()
		pruneLine()
		update()

		tickTimer = serverTime + chatDelay/2

	proc
		pruneLine()
			if(lines.len)
				lines.Remove(lines[1])

		addLine(text)
			lines += text
			while(lines.len > maxLines)
				pruneLine()

			//If tokenizing is appropriate here, then tokenize

			tickTimer = serverTime + chatDelay

			update()

		update()
			var/text = "<font align = left valign = top>"
			for(var/i in lines)
				text += "[i]\n"

			hud.maptext = text

		addClient(client/C)

			C.screen.Add(hud)
			clients += C

		removeClient(client/C)

			C.screen.Remove(hud)
			clients -= C