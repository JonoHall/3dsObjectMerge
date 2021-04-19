function getOriginalNames =
(
	allObjects = $*

	for obj in allObjects do(
		(
			originalParentName = getUserProp obj "orig_parent_name"
			if originalParentName != undefined do
			(
				originalNames[originalParentName as Name] = obj.handle
			)
		)
	)
)

fn deleteFaces obj =
(
	faceNum = getNumFaces obj
	if faceNum > 0 then
	(
		s = #{1 .. faceNum}
		polyop.deleteFaces obj s \
		delIsoVerts:true
	)
)

function matchAndReplace mergeObjects =
(
	countMerge = 0
	countNoMatch = 0
	for obj in mergeObjects do(
		match = originalNames[obj.name as name]
		if match != undefined then
		(
			oldObj =maxOps.getNodeByHandle match
			deleteFaces oldObj
			oldObjName = oldObj.name
			polyop.attach obj oldObj
			obj.name = oldObjName
			countMerge += 1
		) else (
			obj.name = (obj.name + " [new]")
			countNoMatch += 1
		)
	)
	resultMessage = ((countMerge as string) + " objects merged.")
	if(countNoMatch > 0) then resultMessage = resultMessage + " " + (countNoMatch as string) + " objects had no match and has been marked [new]."
	messageBox resultMessage title:"Objects merged"
)