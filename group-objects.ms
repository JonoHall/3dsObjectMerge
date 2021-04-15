groups = Dictionary()

allObjects = $*
for OBJ in allObjects do(
	objectName = filterString OBJ.name "["
	objectName = trimRight objectName[1] as Name
	
	if groups[objectName] == undefined then groups[objectName] = #()
	appendIfUnique groups[objectName] OBJ
)

for g in groups do(
	gArray = g.value as Array
	j = 1
	count = gArray.count

	undo off
	(
		while gArray.count > 1 do
		(				
			if classof gArray[j] != Editable_Poly then converttopoly gArray[j]
				
			polyop.attach gArray[j] gArray[j+1]
			deleteItem gArray (j+1)
				
			j += 1
				
			if (j + 1) > gArray.count then j = 1
			
		)
	)
)