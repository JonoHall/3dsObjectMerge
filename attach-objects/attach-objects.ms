/* 
Loop through our new associated array and group all the values (objects) in each key 

Credit: ivanisavich
Source: https://forums.cgsociety.org/t/fast-attach-algorithm/1459667
*/

/*
function attachChildren parents appendText:"" =
*/
function attachChildren parents =
(
	progressBarIteration = 0
	timeStampKey = timeStamp() as String
	for g in parents do(
		gArray = g.value as Array
		j = 1
		
		count = gArray.count
		currObjName = gArray[j].name
		
		/* Turns undo off for performance optimisation */
		undo off
		(
			while gArray.count > 1 do
			(
				/* Convert to Editable Poly if it's not already */
				if classof gArray[j] != Editable_Poly then converttopoly gArray[j]
				
				polyop.attach gArray[j] gArray[j+1]
				deleteItem gArray (j+1)
				
				j += 1
				
				if (j + 1) > gArray.count then j = 1
			)
			
			/*
			keyName = g.key as String
			if appendText != "" then keyName = keyName + appendText
			*/
			keyName = (g.key as String)
			gArray[j].name = keyName
			gArray[j].displaybylayer = true
			gArray[j].motionByLayer = true
			gArray[j].renderByLayer = true
			
			setUserProp gArray[j] "orig_parent_name" (g.key as string)
			ProgressBarTool.SetProgress value:(progressBarIteration += 1) count:parents.count message:("Current group: "+g.key)
		)
	)
)