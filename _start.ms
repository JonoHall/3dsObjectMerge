FileIn("progress-bar\progress-bar.ms")

appendTextVal = ""

rollout startDialog "Attach Objects" (
	
	label lab1 "Step 1: Attach objects with similar names." align:#left offset:[0,10]
	label appendTextLabel "Project name ie. OCK08" align:#left
	edittext appendText
	button startAttach "Attach Objects" width:120 height:30 align:#left
	label lab2 "Step 2: Merge files that have been through the attach step." align:#left offset:[0,10]
	button startMerge "Merge Files" width:120 height:30 align:#left
	label lab3
	
	on startAttach pressed do
	(
		appendTextVal = appendText.text
		DestroyDialog(startDialog)
		filein("attach-objects\_start.ms")
	)
	
	on startMerge pressed do
	(
		DestroyDialog(startDialog)
		filein("merge-replace\_start.ms")
	)
)

CreateDialog startDialog width:600