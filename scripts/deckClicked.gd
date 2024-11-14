extends Area2D

signal onDrawPileClick
signal onDrawPileEnter
signal onDrawPileExit

func _input_event(viewport: Viewport, event: InputEvent, shapeIdx: int):
	
	if event.is_action("maus1"):
		onDrawPileClick.emit()
		
func _mouse_enter() -> void:
	onDrawPileEnter.emit()
	
func _mouse_exit() -> void:
	onDrawPileExit.emit()
