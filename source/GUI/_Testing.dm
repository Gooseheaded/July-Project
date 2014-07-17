
mob
	verb
		ADDGUI()
			if(!client.gui) client.gui = new/GUI()

			var/GUIObject/o = new/GUIObject(client.gui, null, null, 'ccbg.png', null, GUI_LAYER)
			o.setValues(2,2, 0,0, GUI_LAYER)
			client.gui.update()