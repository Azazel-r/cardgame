extends Area2D

signal onClick
signal onEnter
signal onExit

func _input_event(viewport: Viewport, event: InputEvent, shapeIdx: int):
	
	if event.is_action("maus1"):
		onClick.emit()
		
func _mouse_enter() -> void:
	onEnter.emit()
	
func _mouse_exit() -> void:
	onExit.emit()
