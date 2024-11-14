extends Node2D

var middleCentered := true
var margin := 200.0
var nextCardPos : Vector2 = Vector2.ZERO
var windowSize : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setNextCardPos() -> void:
	var Y := windowSize.y * 0.75
	if middleCentered:
		if nextCardPos == Vector2.ZERO:
			nextCardPos = Vector2(windowSize.x * 0.5, Y)
		else:
			nextCardPos = Vector2(windowSize.x - margin, Y)

func moveCardsAccordingly
