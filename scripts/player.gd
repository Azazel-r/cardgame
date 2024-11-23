extends Node

var index := 0
var polySize := Vector2(GameState.numCards * 300 + 60, 420)
var winSize = get_window().size
var handPos := Vector2(winSize.x * 0.5, winSize.y * 0.75)

func setup(idx : int):
	print(polySize)
	index = idx
	var polyVectors : PackedVector2Array
	polyVectors.resize(4)
	polyVectors[0] = -polySize/2
	polyVectors[1] =  Vector2(polySize.x/2, -polySize.y/2)
	polyVectors[2] = polySize/2
	polyVectors[3] =  Vector2(-polySize.x/2, polySize.y/2)
	
	$handAreaPoly.polygon = polyVectors
	$handAreaPoly.position = handPos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup(0) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
