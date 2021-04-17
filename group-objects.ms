/* 
Loop through our new associated array and group all the values (objects) in each key 

Credit: ivanisavich
Source: https://forums.cgsociety.org/t/fast-attach-algorithm/1459667
*/
function combineObjects groups =
(
	appendText = ""
	
	if allControls.appendText.text != "" do
	(
		appendText = allControls.appendText.text as String
		appendText = " [" + appendText + "]"
	)
	
	progressBarIteration = 0
	
	for g in groups do(
		gArray = g.value as Array
		j = 1
		
		count = gArray.count
		currObjName = gArray[j].name

		/* Turns undo off for performance enhancement */
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
			
			key = g.key as String
			parentName = key + appendText
			
			gArray[j].name = parentName
			
			setUserProp gArray[j] "orig_parent_name" (g.key as string)
			ProgressBarTool.SetProgress value:(progressBarIteration += 1) count:groups.count message:("Current group: "+g.key)
		)
	)
)