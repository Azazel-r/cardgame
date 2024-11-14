extends Sprite2D

var number := 1

const VARIATIONS := [
	preload("res://assets_real/back3.png"),
	preload("res://assets_real/card0.png"), 
	preload("res://assets_real/card1.png")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func changeTexture(n: int):
	texture = VARIATIONS[n]


func _on_card_flip_to_back() -> void:
	changeTexture(0)


func _on_card_flip_to_front() -> void:
	changeTexture(number)

func _on_card_which_sprite(n : int) -> void:
	number = n
	changeTexture(n)
