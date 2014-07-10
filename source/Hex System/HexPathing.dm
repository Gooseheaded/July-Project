/*
File:		HexPathing.dm
Author:		Gooseheaded
Created:	08/07/14

Edits:
	09/07/14 @ 03:48AM(CST)
*/

//getAdjacent()
//getHexDist(Hex target)

PathNode
	var
		score
		length

		Hex/hex
		PathNode/parent

	New(Hex/h, s)
		src.hex = h
		src.score = s

proc
	findHexPath(Hex/Actor/actor, Hex/end)/*
		var/list/potentialEnds = end.getAdjacent()
		while(!end.canEnter(actor))
			end = pick(potentialEnds)
			potentialEnds -= end
			potentialEnds |= end.getAdjacent()*/

		var/list/open = list(actor.hexLoc = new/PathNode(actor.hexLoc, 0))
		var/list/closed = list()
		var/list/path = list()
		var/score = 0

		var/PathNode/currentNode
		var/PathNode/neighborNode

		currentNode = findLowest(open, end)
		currentNode.length = 1

		while(currentNode.hex != end)
			currentNode = findLowest(open, end)

			if(currentNode.length > PATH_MAX_LEN)
				break

			if(!end.canEnter(actor) && (currentNode.hex.getHexDist(end) <= 1))
				break

			open -= currentNode.hex
			closed[currentNode.hex] = currentNode

			for(var/Hex/hex in currentNode.hex.getAdjacent())
				neighborNode = null
				score = currentNode.score + PATH_COST

				if(hex in open)
					neighborNode = open[hex]

				if(neighborNode == null)
					if(!hex.canEnter(actor))
						continue
					neighborNode = new/PathNode(hex, score)
					neighborNode.parent = currentNode
					neighborNode.length = currentNode.length+1
					open[hex] = neighborNode
					continue

				if((neighborNode.hex in open) && (score < neighborNode.score))
					open -= hex

		while(currentNode.hex != actor.hexLoc)
			path += currentNode.hex
			currentNode = currentNode.parent

		var/list/result = list()
		for(var/i = path.len, i > 0, i--)
			result += path[i]	// need a dispenser here

		return result

	findLowest(list/list, Hex/end)
		var/PathNode/candidate = list[list[1]]
		var/PathNode/node

		for(var/Hex/hex in list)
			node = list[hex]
			if((node.score + hex.getHexDist(end)) < (candidate.score + candidate.hex.getHexDist(end)))
				candidate = node

		return candidate