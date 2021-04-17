/*
Credit: https://gist.github.com/JokerMartini/3e12ae1d8ef242c9d33c
*/
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