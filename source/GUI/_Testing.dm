
mob
	verb
		ADDGUI()
			if(!client.gui) client.gui = new/GUI()

			new/CharacterCreation/Main(client)
			/*
			var/GUIObject/o = new/GUIObject(ico='ccbg.png', lay=GUI_LAYER)
			o.setValues(2,2, 0,0, GUI_LAYER)
			client.gui.contents.Add(o)
			client.gui.update()
			*/