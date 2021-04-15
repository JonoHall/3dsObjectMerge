try(destroyDialog ProgressBarTool.instUI;ProgressBarTool.instUI=undefined)catch()

--Structure containing the tool
struct ProgressBarTool
(
	/********************************************************
	Variables
	********************************************************/
	instUI = undefined,
	message = "",
	count = 0,
	value = 0,
	
	/********************************************************
	Functions
	********************************************************/
	fn SetProgress value:0 count:0 message:"" =
	(		
		ProgressBarTool.count = count
		ProgressBarTool.value = value
		ProgressBarTool.message = message

		--Update the UI
		if instUI != undefined do 
		(
			instUI.UpdateProgress()
		)
	),
	
	/********************************************************
	Rollouts
	********************************************************/
	fn UI =
	(
		rollout ProgressBarToolRO "Progress..."
		(
			dotnetcontrol uiMessage "Label" width:(ProgressBarToolRO.width-28) align:#center offset:[0,5]
			progressbar uiProgressBar color:(color 20 150 240) width:(ProgressBarToolRO.width-28) height:12  align:#center
			dotnetcontrol uiIterations "Label" width:(ProgressBarToolRO.width-28) align:#center
			button uiOk "OK" width:100 align:#right enabled:false
						
			fn StyleLabel ctrl:undefined align:#left =
			(	
				colMax = (colorMan.getColor #background)*255
				colorClass = dotNetClass "system.drawing.color"
				ctrl.Font = dotNetObject "System.Drawing.Font" "Verdana" 11 (dotNetClass "System.Drawing.FontStyle").Regular (dotNetClass "System.Drawing.GraphicsUnit").Pixel
				ctrl.Backcolor = colMax = colorClass.fromArgb colMax[1] colMax[2] colMax[3]
				ctrl.Forecolor = ctrl.Forecolor.fromARGB 240 240 240
				ctrl.TextAlign = ctrl.TextAlign.TopLeft
			)

			fn UpdateProgress =
			(
				uiMessage.text = ProgressBarTool.message
				uiProgressBar.value = 100.0 * ProgressBarTool.value / ProgressBarTool.count as float
				uiIterations.text = ProgressBarTool.value as string + "/" + ProgressBarTool.count as string
				windows.processPostedMessages()

				uiOk.enabled = ProgressBarTool.value == ProgressBarTool.count
			)
			
			on uiOk pressed do
			(
				try(destroyDialog ::ProgressBarToolRO)catch()
			)
			
			on ProgressBarToolRO open do
			(
				StyleLabel ctrl:uiMessage
				StyleLabel ctrl:uiIterations
			)
		)
	),
	
	fn run=
	(
		if instUI==undefined then
		(
			instUI=UI()
			createDialog instUI width:500 style:#(#style_titlebar, #style_border)
		)else
		(
			destroyDialog instUI
			instUI=undefined
		)
	),

	fn getRollouts = #(ui())
)

/* Create an associated array of all objects or "DataPair" */ 
groups = Dictionary()

/* Get all objects */
allObjects = $*

totalIterations = 0
totalObjects = allObjects.count

for OBJ in allObjects do(
	
	/* 
	Break the name of the object into parts where the [ character is into an array of parts ie.
	("item001 ","[1]")
	*/
	objectName = filterString OBJ.name "["
	
	/* 
	Grab the first element of the array (we don't need the rest) trim off the whitespace at the end ie.
	"item001"
	Also make it into a "Name" object. Dunno why it can't be a string, but MaxScript is quite specific about it
	*/
	objectName = trimRight objectName[1] as Name
	
	/* 
	Check if the associated array doesn't already have a key with the same value, 
	if not make it with an empty array.
	DataPair key:#item001 value:
	*/
	if groups[objectName] == undefined then groups[objectName] = #()
	
	/*
	Add the OBJECT to the array under the approriate key
	DataPair key:#item001
		value:#($item001 [1] @ [-10.000000,10.000000,0.000000]
		value:#($item001 [2] @ [-30.000000,30.000000,0.000000]
	*/
	append groups[objectName] OBJ
)

/* 
Loop through our new associated array and group all the values (objects) in each key 

Credit: ivanisavich
Source: https://forums.cgsociety.org/t/fast-attach-algorithm/1459667
*/
function combineObjects groups =
(
	appendText = ""
	print allControls.appendText.text
	if allControls.appendText.text != "" do
	(
		appendText = allControls.appendText.text as String
		appendText = " [" + appendText + "]"
	)
	print appendText
	for g in groups do(
		gArray = g.value as Array
		j = 1
		count = gArray.count
		currObjName = gArray[j].name

		/* Turns undo off for performance enhancement */
		undo off
		(
			while gArray.count > 1 do
			(
				/* Convert to Editable Poly if it's not already */
				if classof gArray[j] != Editable_Poly then converttopoly gArray[j]
					
				polyop.attach gArray[j] gArray[j+1]
				deleteItem gArray (j+1)
					
				j += 1
					
				if (j + 1) > gArray.count then j = 1
				totalIterations += 1
			)
			
			key = g.key as String
			parentName = key + appendText
			
			gArray[j].name = parentName
			
			orig_parent_name = g.key as string
			setUserProp gArray[j] "orig_parent_name" orig_parent_name
			
			ProgressBarTool.SetProgress value:totalIterations count:totalObjects message:currObjName
			
		)
	)
)


rollout allControls "Combine Objects" (
	
	label lab1 "You are about to group up some objects. This CANNOT be undone." align:#left offset:[0,10]
	label lab2 "Sub-objects to be merged:" align:#left offset:[0,10]
	label objectCount align:#left style_sunkenedge:true height:18 width:130
	label lab3 "Final Objects:" align:#left
	label groupCount align:#left style_sunkenedge:true height:18 width:130
	label lab4 "Append the following to the final object name (Optional):" align:#left offset:[0,10]
	edittext appendText "Text:" height:18
	button confirm "Confirm" width:120 height:30 align:#left offset:[0,16]
	button close_btn "Cancel" width:120 height:30 offset:[140,-35] align:#left
	on confirm pressed do
		(
			DestroyDialog(allControls)
			ProgressBarTool = ProgressBarTool()
			ProgressBarTool.run()
			combineObjects groups
		)
	on close_btn pressed do DestroyDialog(allControls)
)

createDialog allControls width:600
difference = allObjects.count - groups.count
totalObjects = difference
allControls.groupCount.text = groups.count as String
allControls.objectCount.text = difference as String