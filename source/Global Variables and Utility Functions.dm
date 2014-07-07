/*
File:		Global Vaiables and Utility Functions.dm
Author:		D4RK3 54B3R
Created:	07/07/14

Edits:
*/

var
	//These are the tile dimensions for the game world.
	icon_x = 32
	icon_y = 32

	//These are variables pertaining to the game screen dimensions//
	//All of these pixel coordinates are relative to the bottom left corner of the screen
	screen_x //The width of the screen in tiles
	screen_y //The height of the screen in tiles

	screen_px //The width of the screen in pixels
	screen_py //The height of the screen in pixels

	center_x //The X tile-coordinate of the center of the screen
	center_y //The Y tile-coordinate of the center of the screen

	center_px //The X pixel-coordinate of the center of the screen
	center_py //The Y pixel-coordinate of the center of the screen

var
	pi = 3.1415297 //ya


//Utility functions
proc
	arctan(x)
		return arcsin(x/sqrt(1+x*x))

	arctan2(y, x)
		var/ang=0
		if(x == 0)
			if(y > 0) ang= 90
			if(y < 0) ang= 270
		else ang = arctan(y / x)
		if(x<0) ang+=180
		if(ang < 0) ang += 360
		if(ang >=360) ang -= 360
		return ang

	tan(x)
		return sin(x)/cos(x)

	cot(x)
		return cos(x)/sin(x)

	substringTo(string,char)
		//Returns a substring of "string" from the beginning of the string to the first instance of "char"
		var/i = findtext(string,char)
		if(!i) return string
		else return copytext(string,1,i)//+length(char))

	substringPast(string,char)
		//Returns a substring of "string" from the end of the first instance of "char" to the end of the string
		var/i = findtext(string,char)
		if(!i) return null
		else return copytext(string,i+length(char),0)

	dist(x1, x2, y1, y2)
		return sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1))