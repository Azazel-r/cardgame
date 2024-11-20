extends Area2D

signal onDiscardPileClick
signal onDiscardPileEnter
signal onDiscardPileExit

func _input_event(viewport: Viewport, event: InputEvent, shapeIdx: int):
	
	if event.is_action("maus1"):
		onDiscardPileClick.emit()
		
func _mouse_enter() -> void:
	onDiscardPileEnter.emit()
	
func _mouse_exit() -> void:
	onDiscardPileExit.emit()
