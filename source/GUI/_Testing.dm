

mob
	verb
		ADDGUI()
			client.gui = new/GUI()

			var/atom/movable/bg = new()
			bg.icon = 'ccbg.png'

			client.gui.contents.Add(new/GUIObject(client.gui, null, null, bg))
			client.gui.update()