extends Node
# var cardSize := Vector2i(240,336)

# -----------------------------------------------------------------
# Constants and Variables
# -----------------------------------------------------------------

# Time constants (delays, etc)
const DRAW_DOWNTIME := 0.66
const TRANSITION_SECONDS := 0.33
const START_DRAW_DELAY := 0.66
const JUST_FLIP_SECONDS := 0.33
const HOVER_TIME := 0.33

# Position constants (Vector2Ds usually)
var handPos1 := Vector2.ZERO
var handPos2 := Vector2.ZERO
var limboPos := Vector2.ZERO
var drawPilePos := Vector2.ZERO
var discardPilePos := Vector2.ZERO

# other constants
const NUM_HAND_CARDS := 4
const PLAYER_COUNT := 2 # min: 2 // max: 2 lol
const CARD_COUNT := 24
var scale := 1.0
var playerTurn := 0
var cardScale := Vector2(1,1)
var margin := 450
var winSize : Vector2i
const playerCols = [Color8(255,0,0,127), Color8(0,0,255,127)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
