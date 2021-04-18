/* 
Loop through our new associated array and group all the values (objects) in each key 

Credit: ivanisavich
Source: https://forums.cgsociety.org/t/fast-attach-algorithm/1459667
*/
function attachChildren parents mergeTag:false =
(
	progressBarIteration = 0
	
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

			if mergeTag == false then
			(
				gArray[j].name = g.key as String
				setUserProp gArray[j] "orig_parent_name" (g.key as string)
			) else (
				gName = (g.key as String) + " [new]"
				gArray[j].name = gName
			)
			
			ProgressBarTool.SetProgress value:(progressBarIteration += 1) count:parents.count message:("Current group: "+g.key)
		)
	)
)