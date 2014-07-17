

mob
	verb
		ADDGUI()
			if(!client.gui) client.gui = new/GUI()

			var/atom/movable/bg = new()
			bg.icon = 'ccbg.png'

			new/GUIObject(client.gui, null, null, bg)
			client.gui.update()