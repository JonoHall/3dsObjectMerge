rollout startDialog "Merge Objects" (
	
	label lab1 "Do you want to crush objects in this file, or in another file and merge with this one?" align:#left offset:[0,10]
	button thisFile "This File" width:120 height:30 align:#left offset:[0,16]
	button otherFile "Another File" width:120 height:30 offset:[130,-35] align:#left
	button cancel "Cancel" width:120 height:30 offset:[260,-35] align:#left
	on thisFile pressed do
		(
			DestroyDialog(startDialog)
			createDialog allControls width:600
		)
	on otherFile pressed do
		(
			DestroyDialog(startDialog)
			createDialog allControls width:600
		)
	on cancel pressed do DestroyDialog(startDialog)
)