groups = #()

allObjects = $*
for OBJ in allObjects do(
	objectName = filterString OBJ.name "["
	objectName = objectName[1]
	appendIfUnique groups objectName
)
for groupName in groups do(
	nodeCollection = execute ("$'"+groupName+"'*")
	group nodeCollection name:groupName
)