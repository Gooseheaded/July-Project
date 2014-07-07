//easing functions!
//you input a time, and you will get an X output
//input is between 0-1 and output is between 0-1

proc
	easeInQuadratic(t)
		return t*t

	easeOutQuadratic(t)
		return 1 - (1-t) * (1-t)

	easeInOutQuadratic(t)
		if(t < 0.5) return 0.5*easeInQuadratic(t*2)
		else return 0.5 + 0.5*easeOutQuadratic((t-0.5)*2)

	easeInSine(t)
		return sin(t*90)

	easeOutSine(t)
		return 1-sin(90-t*90)

	easeInOutSine(t)
		if(t < 0.5) return 0.5*easeInSine(t*2)
		else return 0.5 + 0.5*easeOutSine((t-0.5)*2)