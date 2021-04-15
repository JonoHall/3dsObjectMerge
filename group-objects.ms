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
	)
)