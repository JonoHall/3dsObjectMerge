fn Initialise = 
(
	/* Create Group Dictionary */
	for obj in allObjects do(
		/* Get object name i.e. "box001 [10239]" becomes "box001" */
		objectName = filterString obj.name "["
		if objectName.count != 1 then
		(
			objectName = trimRight objectName[1] as Name
			
			/* Set up group in Group Dictionary if it doesn't already exist	*/
			if parents[objectName] == undefined then parents[objectName] = #()
			
			/* Add object to Group Dictionary */
			append parents[objectName] obj
		) else (
			originalParentName = (getUserProp obj "orig_parent_name")
			if originalParentName != undefined then
			(
				children[originalParentName as Name] = obj.handle
			)
		)
	)
)