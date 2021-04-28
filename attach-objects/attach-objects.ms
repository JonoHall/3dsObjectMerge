function cleanName oldName =
(
	validChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	
	s = ""
	for i = 1 to oldName.count do
	(
		if (oldName[i] == " " or oldName[i] == "-") then 
		(
			s += "_"
		) else (
			char = oldName[i] as String
			if findString validChars char != undefined then s += char
		)
	)
	s
)

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
			if gArray.count == 1 do
			(
				/* Convert to Editable Poly if it's not already */
				if classof gArray[1] != Editable_Poly then converttopoly gArray[j]
			)
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
			oldKeyName = g.key as String
			newKeyName = cleanName oldKeyName
			newKeyName = ("SM_" + appendTextVal + "_" + newKeyName)
			gArray[j].name = newKeyName as Name
			
			gArray[j].displayByLayer = true
			gArray[j].motionByLayer = true
			gArray[j].renderByLayer = true
			gArray[j].colorByLayer = true
			gArray[j].globalIlluminationByLayer = true
			
			setUserProp gArray[j] "orig_parent_name" (g.key as string)
			ProgressBarTool.SetProgress value:(progressBarIteration += 1) count:parents.count message:("Current group: "+g.key)
		)
	)
)