extends Area2D

signal onDeckClick
signal onDeckEnter
signal onDeckExit

func _input_event(viewport: Viewport, event: InputEvent, shapeIdx: int):
	
	if event.is_action("maus1"):
		onDeckClick.emit()
		
func _mouse_enter() -> void:
	onDeckEnter.emit()
	
func _mouse_exit() -> void:
	onDeckExit.emit()
