rollout allControls "Attach Objects" (
	
	label lab1 "You are about to attach objects with the same names. This CANNOT be undone." align:#left offset:[0,10]
	
	groupBox group1 "Attach objects in this file:" pos:[12,35] height:160
	label lab2 "Child objects to be attached to parent objects:" align:#left offset:[5,-140]
	label objectCount align:#left style_sunkenedge:true height:20 width:130 offset:[5,0]
	label lab3 "Final parent objects:" align:#left offset:[5,0]
	label groupCount align:#left style_sunkenedge:true height:20 width:130 offset:[5,0]
	button confirmThisFile "Confirm" width:120 height:30 align:#left offset:[5,10]
	
	groupBox group2 "Attach and merge objects from another file:" pos:[12,200] height:110
	
	label filenameLabel "Selected File:" align:#left height:24 width:200 offset:[5,-94]
	label filename align:#left style_sunkenedge:true height:20 width:420 offset:[5,-10]
	button openFileDialog "Open File" align:#left width:120 height:30 align:#left offset:[438,-30]
	button confirmAnotherFile "Confirm" width:120 height:30 align:#left offset:[5,0]
	
	on confirmThisFile pressed do
	(
		DestroyDialog(allControls)
		ProgressBarTool = ProgressBarTool()
		ProgressBarTool.run()
		ProgressBarTool.SetProgress value:0 count:groups.count message:"Initializing"
		combineObjects groups
	)
	
	on openFileDialog pressed do
	(
		f = getOpenFileName caption:"Open a file to merge into currently opened file:" \
		types:"Max Files (*.max)|*.max"
		allControls.filename.text = f
	)
	
	on confirmAnotherFile pressed do
	(
		DestroyDialog(allControls)
		mergeMAXFile allControls.filename.text
		Initialize()
		ProgressBarTool = ProgressBarTool()
		ProgressBarTool.run()
		ProgressBarTool.SetProgress value:0 count:groups.count message:"Initializing"
		result = combineObjects groups mergeTag:true
		print groups
	)

	/*
	label lab2 "Sub-objects to be merged:" align:#left offset:[0,10]
	label objectCount align:#left style_sunkenedge:true height:20 width:130
	label lab3 "Final Objects:" align:#left
	label groupCount align:#left style_sunkenedge:true height:20 width:130
	label lab4 "Append the following to the final object name (Optional):" align:#left offset:[0,10]
	edittext appendText "Text:" height:20
	*/
)

createDialog allControls width:600

difference = allObjects.count - groups.count

if difference != 0 then
	(
		allControls.groupCount.text = groups.count as String
		allControls.objectCount.text = difference as String
	) else (
		allControls.groupCount.text = "No objects attachable"
		allControls.objectCount.text = "No objects attachable"
		allControls.confirmThisFile.enabled = false
	)