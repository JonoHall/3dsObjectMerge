rollout attachObjectsDialog "Attach Objects" (
	
	label lab1 "You are about to attach objects with the same names. This CANNOT be undone." align:#left offset:[0,10]
	label lab2 "Child objects to be attached to parent objects:" align:#left offset:[0,10]
	label objectCount align:#left style_sunkenedge:true height:20 width:130
	label lab3 "Final parent objects:" align:#left
	label parentCount align:#left style_sunkenedge:true height:20 width:130
	button confirm "Confirm" width:120 height:30 align:#left offset:[0,10]
	button cancel "Cancel" width:120 height:30 align:#left offset:[140,-35]

	on confirm pressed do
	(
		DestroyDialog(attachObjectsDialog)
		ProgressBarTool = ProgressBarTool()
		ProgressBarTool.run()
		ProgressBarTool.SetProgress value:0 count:parents.count message:"Initializing"
		attachChildren parents
	)

	on cancel pressed do
	(
		DestroyDialog(attachObjectsDialog)
	)
)