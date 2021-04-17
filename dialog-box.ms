rollout allControls "Combine Objects" (
	
	label lab1 "You are about to group up some objects. This CANNOT be undone." align:#left offset:[0,10]
	label lab2 "Sub-objects to be merged:" align:#left offset:[0,10]
	label objectCount align:#left style_sunkenedge:true height:18 width:130
	label lab3 "Final Objects:" align:#left
	label groupCount align:#left style_sunkenedge:true height:18 width:130
	label lab4 "Append the following to the final object name (Optional):" align:#left offset:[0,10]
	edittext appendText "Text:" height:20
	button confirm "Confirm" width:120 height:30 align:#left offset:[0,16]
	button close_btn "Cancel" width:120 height:30 offset:[140,-35] align:#left
	on confirm pressed do
		(
			DestroyDialog(allControls)
			ProgressBarTool = ProgressBarTool()
			ProgressBarTool.run()
			ProgressBarTool.SetProgress value:0 count:groups.count message:"Initializing"
			combineObjects groups
		)
	on close_btn pressed do DestroyDialog(allControls)
)