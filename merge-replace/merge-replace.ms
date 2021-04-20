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
	copyMergeObjects = #()
	for obj in mergeObjects do(
		append copyMergeObjects obj.handle
	)

	countMerge = 0
	countNoMatch = 0
	
	for i = mergeObjects.count to 1 by -1 do
	(
		print "i="
		print i
		print "mergeObjects[i]"
		print mergeObjects[i]
		match = originalNames[mergeObjects[i].name as name]
		print "match"
		print match
		if match != undefined then
		(
			oldObj =maxOps.getNodeByHandle match
			deleteFaces oldObj
			oldObjName = oldObj.name
			polyop.attach mergeObjects[i] oldObj
			mergeObjects[i].name = oldObjName
			countMerge += 1
		) else (
			mergeObjects[i].name = (mergeObjects[i].name + " [new]")
			countNoMatch += 1
		)
	)
	resultMessage = ((countMerge as string) + " objects merged.")
	if(countNoMatch > 0) then resultMessage = resultMessage + " " + (countNoMatch as string) + " objects had no match and has been marked [new]."
	messageBox resultMessage title:"Objects merged"
)