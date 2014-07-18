/*
File:		Character Creation.dm
Author:		Gooseheaded
Created:	18/07/14
*/

CharacterCreation

	Main
		var/list/classes
		var/index = 1

		proc
			shiftLeft()
				if(index == classes.len) return

				var/Class/class = classes[index]
				var/Class/nextClass = classes[index+1]

				animate(class.portrait, transform = matrix()/2, alpha = 0, time = 5, pixel_x = -100)

				nextClass.portrait.transform = matrix()/2
				nextClass.portrait.alpha = 0
				nextClass.portrait.pixel_x = 100
				animate(nextClass.portrait, transform = matrix(), alpha = 255, time = 5, pixel_x = 0)

				index ++

			shiftRight()
				if(index == 1) return

				index --

		New(client/cli)
			classes = new()
			classes += new/Class("Archer", "Long-range combat specialists.", 'Portrait.png')
			classes += new/Class("Warrior", "Spray and pray at melee range.", 'Portrait.png')
			classes += new/Class("Mage", "Fragile, but can definitely fuck some of your shit up.", 'Portrait.png')

			var/GUIObject/className = new/GUIObject(ico='className.png', lay=GUI_LAYER+1, con=null, cli=null)
			className.setValues(6,11, -16,12, GUI_LAYER)
			cli.gui.contents.Add(className)

			var/GUIObject/classDesc = new/GUIObject(ico='classDesc.png', lay=GUI_LAYER+1, con=null, cli=null)
			classDesc.setValues(3,1, 0,8, GUI_LAYER)
			cli.gui.contents.Add(classDesc)

			var/GUIObject/leftArrow = new/GUIObject(ico='leftArrow.png', lay=GUI_LAYER+1, con=src, cli="shiftRight")
			leftArrow.setValues(2,11, 0,12, GUI_LAYER)
			cli.gui.contents.Add(leftArrow)

			var/GUIObject/rightArrow = new/GUIObject(ico='rightArrow.png', lay=GUI_LAYER+1, con=src, cli="shiftLeft")
			rightArrow.setValues(16,11, 0,12, GUI_LAYER)
			cli.gui.contents.Add(rightArrow)

			cli.gui.update()

	Protrait