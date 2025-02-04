extends Node

# Constants and Variables

# var cardSize := Vector2i(240,336)
const DRAW_DOWNTIME := 0.66
const TRANSITION_SECONDS := 0.33
const START_DRAW_DELAY := 0.66
const JUST_FLIP_SECONDS := 0.33
const NUM_HAND_CARDS := 4
const PLAYER_COUNT := 2 # min: 2 // max: 2 lol
var scale := 1.0
var playerTurn := 0
var cardScale := Vector2(1,1)
var margin := 450
var winSize : Vector2i
const playerCols = [Color8(255,0,0,127), Color8(0,0,255,127)]
var handPos1 := Vector2(0,0)
var handPos2 := Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
