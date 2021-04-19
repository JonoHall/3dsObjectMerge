rollout mergeReplace "Merge and Replace Objects" (
	
	label lab1 "You are about to merge objects with the same names. This CANNOT be undone." align:#left offset:[0,10]
	label filenameLabel "Selected File:" align:#left height:24 width:200 offset:[0,10]
	label filename align:#left style_sunkenedge:true height:20 width:420
	button openFileDialog "Open File" align:#left width:120 height:30 align:#left offset:[438,-30]
	button confirmMergeReplace "Confirm" width:120 height:30 align:#left
	button cancel "Cancel" width:120 height:30 align:#left offset:[140,-35]
	on cancel pressed do
	(
		DestroyDialog(mergeReplace)
	)
	on openFileDialog pressed do
	(
		f = getOpenFileName caption:"Open a file to merge into currently opened file:" \
		types:"Max Files (*.max)|*.max"
		mergeReplace.filename.text = f
	)
	on confirmMergeReplace pressed do
	(
		mergeMAXFile mergeReplace.filename.text #mergeDups #select
		matchAndReplace selection
		DestroyDialog(mergeReplace)
	)
)