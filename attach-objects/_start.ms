allObjects = $*
parents = Dictionary()
children = Dictionary()

FileIn("attach-objects.ms")
FileIn("initialise.ms")
FileIn("dialog-box.ms")

Initialise()

if allObjects.count == 0 then
(
	messageBox "Empty file, not sure what you want me to do?" title:"No objects in file" beep:true
) else (
	difference = allObjects.count - parents.count
	if parents.count > 0 then
	(
		createDialog attachObjectsDialog width:600
		attachObjectsDialog.parentCount.text = parents.count as String
		attachObjectsDialog.objectCount.text = difference as String
	) else (
		messageBox "Can't find any objects with similar names." title:"No attachable objects" beep:true
	)
)