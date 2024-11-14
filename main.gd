extends Node

var window
const windowSize = Vector2i(1920,1080) #Vector2i(1280,720) #

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window = get_window()
	window.size = windowSize
	window.move_to_center()
	$DrawPile.setWindowSize(windowSize)
	$DrawPile.shuffle()
	$shuffleButton.position = Vector2(windowSize.x * 0.1, windowSize.y * 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$DrawPile.shuffle()


func _on_draw_pile_card_drawn_signal(card : Node2D, cardsDrawn : int) -> void:
	$Transition.add_child(card)
	$Transition.cardsDrawn = cardsDrawn
	
