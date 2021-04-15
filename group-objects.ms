/* Create an associated array of all objects or "DataPair" */ 
groups = Dictionary()

/* Get all objects */
allObjects = $*

for OBJ in allObjects do(
	
	/* 
	Break the name of the object into parts where the [ character is into an array of parts ie.
	("item001 ","[1]")
	*/
	objectName = filterString OBJ.name "["
	
	/* 
	Grab the first element of the array (we don't need the rest) trim off the whitespace at the end ie.
	"item001"
	Also make it into a "Name" object. Dunno why it can't be a string, but MaxScript is quite specific about it
	*/
	objectName = trimRight objectName[1] as Name
	
	/* 
	Check if the associated array doesn't already have a key with the same value, 
	if not make it with an empty array.
	DataPair key:#item001 value:
	*/
	if groups[objectName] == undefined then groups[objectName] = #()
	
	/*
	Add the OBJECT to the array under the approriate key
	DataPair key:#item001
		value:#($item001 [1] @ [-10.000000,10.000000,0.000000]
		value:#($item001 [2] @ [-30.000000,30.000000,0.000000]
	*/
	append groups[objectName] OBJ
)

/* 
Loop through our new associated array and group all the values (objects) in each key 

Credit: ivanisavich
Source: https://forums.cgsociety.org/t/fast-attach-algorithm/1459667
*/
function combineObjects groups =
(
	for g in groups do(
		gArray = g.value as Array
		j = 1
		count = gArray.count

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
			gArray[j].name = g.key
		)
	)
)


rollout allControls "Combine Objects" (
	
	label lab1 "You are about to group up some objects. This CANNOT be undone." align:#left offset:[0,10]
	label lab2 "Sub-objects to be merged:" align:#left offset:[0,10]
	label objectCount align:#left style_sunkenedge:true height:18 width:130
	label lab3 "Final Objects:" align:#left
	label groupCount align:#left style_sunkenedge:true height:18 width:130
	button confirm "Confirm" width:120 height:30 align:#left offset:[0,16]
	button close_btn "Cancel" width:120 height:30 offset:[140,-35] align:#left
	on confirm pressed do
		(
			combineObjects groups
			DestroyDialog(allControls)
		)
	on close_btn pressed do DestroyDialog(allControls)
)

createDialog allControls width:600
difference = allObjects.count - groups.count
print difference
allControls.groupCount.text = groups.count as String
allControls.objectCount.text = difference as String