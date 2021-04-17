FileIn("progress-bar.ms")
FileIn("dialog-box.ms")
FileIn("group-objects.ms")
/* Create an associated array of all objects or "DataPair" */ 
groups = Dictionary()

/* Get all objects */
allObjects = $*

/* Create Group Dictionary */
for OBJ in allObjects do(
	
	/* Get object name i.e. "box001 [10239]" becomes "box001" */
	objectName = filterString OBJ.name "["
	objectName = trimRight objectName[1] as Name
	
	/* Set up group in Group Dictionary if it doesn't already exist	*/
	if groups[objectName] == undefined then groups[objectName] = #()

	/* Add object to Group Dictionary */
	append groups[objectName] OBJ
)

difference = allObjects.count - groups.count

if(difference > 0) then
	(
		createDialog allControls width:600
		allControls.groupCount.text = groups.count as String
		allControls.objectCount.text = difference as String
		
	) else (
		messageBox "Could not find any matching objects to group together." title:"No matching objects found"
	)