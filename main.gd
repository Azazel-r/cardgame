extends Node

const deck := preload("res://deck.tscn")
var newDeck
var window
const windowSize = Vector2i(1920,1080) #Vector2i(1280,720) #

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window = get_window()
	window.size = windowSize
	window.move_to_center()
	newDeck = deck.instantiate()
	newDeck.setWindowSize(windowSize)
	add_child(newDeck)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
