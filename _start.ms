FileIn("progress-bar\progress-bar.ms")
FileIn("attach-objects.ms")

fn Initialize = 
(
	/* Create an associated array of all objects or "DataPair" */ 
	groups = Dictionary()

	/* Get all objects */
	allObjects = $*

	/* Create Group Dictionary */
	for OBJ in allObjects do(
		
		/* Get object name i.e. "box001 [10239]" becomes "box001" */
		objectName = filterString OBJ.name "["
		if objectName.count != 1 then
		(
			objectName = trimRight objectName[1] as Name
			
			/* Set up group in Group Dictionary if it doesn't already exist	*/
			if groups[objectName] == undefined then groups[objectName] = #()
			
			/* Add object to Group Dictionary */
			append groups[objectName] OBJ
		)
	)
)

Initialize()
if allObjects.count == 0 then
(
	messageBox "Empty file, not sure what you want me to do?" title:"No objects in file" beep:true
) else (
	FileIn("dialog-box.ms")
)