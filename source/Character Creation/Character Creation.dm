/*
File:		Character Creation.dm
Author:		Gooseheaded
Created:	18/07/14
*/


CharacterCreation

	Main
		var/index = 1
		var/client/client

		var/GUIObject/GUI //This is going to be the parent of the character creation GUI. It will contain errthang.

		var/GUIObject/children[0]

		proc
			shiftLeft()
				if(index == selectableClasses.len) return

				var/PlayerClass/class = selectableClasses[index]
				var/PlayerClass/nextClass = selectableClasses[index+1]

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
			if(!cli) del src
			client = cli

			if(!selectableClasses.len) initializeClasses()

			//instead what this should do is, it should create GUI objects and selections

			//based upon player class prototypes that are created at world initialization
			//The reason why is: Classes are too complex to just pass some parameters to through the constructor
			//There's a bunch of information besides a short string, a name, and a portrait, that I'd like to display to the player

			//If classes haven't been initialized yet, then I guess initialize all of them here.

			//then it should loop through every actual player class object, and it should create GUI objects for them

			//When the player selects a class and  creates his/her character,
			//the character either gets a new class object built from the selected class
			//or the character's vars are initialized to reflect the selected class

			cli.gui.update()


			/*
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
			*/