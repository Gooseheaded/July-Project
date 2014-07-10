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
		heuristic

		Hex/hex
		PathNode/parent

	New(Hex/h, s)
		src.hex = h
		src.score = s

proc
	findHexPath(Hex/Actor/actor, Hex/end, pathLength = PATH_MAX_LEN)/*
		var/list/potentialEnds = end.getAdjacent()
		while(!end.canEnter(actor))
			end = pick(potentialEnds)
			potentialEnds -= end
			potentialEnds |= end.getAdjacent()*/

		var/list/open = list(actor.hexLoc = new/PathNode(actor.hexLoc, 0))
		var/list/closed = list()
		var/score = 0
		var/endNodeDense = !end.canEnter(actor)

		var/PathNode/currentNode
		var/PathNode/neighborNode

		currentNode = open[open[1]]
		currentNode.length = 1
		currentNode.heuristic = currentNode.hex.getHexDist(end)

		while(currentNode.hex != end)
			currentNode = open[open[1]]

			if(currentNode.length > pathLength)
				break

			if(endNodeDense && currentNode.heuristic <= 1)
				break

			open -= currentNode.hex
			closed[currentNode.hex] = currentNode

			for(var/Hex/hex in (currentNode.hex.getAdjacent() - closed))
				var/heuristic = hex.getHexDist(end)
				score = currentNode.score + PATH_COST + hex.path_cost
				neighborNode = open[hex]

				if(neighborNode)
					if(score < neighborNode.score)
						neighborNode.score = score
						neighborNode.parent = currentNode
						neighborNode.length = currentNode.length+1
						neighborNode.heuristic = heuristic

						open -= hex
						insertNodeToList(open, neighborNode)
						continue

				else
					if(!hex.canEnter(actor))
						continue

					neighborNode = new/PathNode(hex, score)
					neighborNode.parent = currentNode
					neighborNode.length = currentNode.length+1
					neighborNode.heuristic = heuristic

					insertNodeToList(open, neighborNode)

					continue

		var/length = currentNode.length
		var/list/path = new/list(length)
		var/index = length

		while(currentNode.hex != actor.hexLoc)
			path[index --] = currentNode.hex
			currentNode = currentNode.parent

		return path

	insertNodeToList(list/open, PathNode/node)
		var/index = 0
		var/value = node.score + node.heuristic

		//use linear search to find the index
		for(index = 1; index <= open.len; index++)
			var/PathNode/checkNode = open[open[index]]
			var/checkScore = checkNode.score + checkNode.heuristic
			if(checkScore > value)
				break

		/*
		var/iMin = 1
		var/iMax = open.len+1

		//use binary search to find the index
		while(iMax > iMin)
			index = round(0.5 * (iMax + iMin))

			if(index > open.len) break

			var/PathNode/checkNode = open[open[index]]
			var/checkScore = checkNode.score + checkNode.heuristic

			if(checkScore == value)
				break
			else if(checkScore < value)
				iMin = index + 1
			else if(checkScore > value)
				iMax = index - 1

		//but iMin == iMax indicates that's where it should be.

		//now insert it
		*/
		open.Insert(index, node.hex)
		open[node.hex] = node

		/*
		//This commented bit of code checks if the list is sorted
		//and if the list isn't sorted, then it will print out the whole list and the values of each element

		var/verified = 1
		for(var/i=1;i<open.len;i++)

			var/PathNode/checkNode = open[open[i]]
			var/checkScore = checkNode.score + checkNode.heuristic

			var/PathNode/nextNode = open[open[i+1]]
			var/nextScore = nextNode.score + nextNode.heuristic

			if(checkScore > nextScore)
				verified = 0

		if(!verified)
			world<<"SHIT ISN'T SORTED"

			for(var/i=1;i<open.len;i++)

				var/PathNode/checkNode = open[open[i]]
				var/checkScore = checkNode.score + checkNode.heuristic

				world<<"[i]: [checkScore]"
		*/