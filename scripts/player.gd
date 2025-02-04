extends Node

var index := 0
var polySize := gs.cardScale * Vector2(gs.NUM_HAND_CARDS * 300 + 60, 420)
var winSize := gs.winSize
signal handCardDiscarded(card: Node2D, player: int)
signal limboCardDiscarded(card: Node2D, player: int)

func setup(idx : int):
	winSize = get_window().size
	index = idx
	var polyVectors : PackedVector2Array
	polyVectors.resize(4)
	polyVectors[0] = -polySize/2
	polyVectors[1] =  Vector2(polySize.x/2, -polySize.y/2)
	polyVectors[2] = polySize/2
	polyVectors[3] =  Vector2(-polySize.x/2, polySize.y/2)
	
	$Hand.handPos = gs.handPos1 if idx == 0 else gs.handPos2
	$handAreaPoly.polygon = polyVectors
	$handAreaPoly.position = gs.handPos1 if idx == 0 else gs.handPos2
	$handAreaPoly.color = gs.playerCols[idx]
	$handAreaPoly.z_index = RenderingServer.CANVAS_ITEM_Z_MIN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getNextCardPos() -> Vector2:
	var pos : Vector2 = $Hand.getNextCardPos()
	return pos
	
func makeSpace() -> void:
	$Hand.makeSpace()
	
func receive_card(card: Node2D) -> void:
	$Hand.add_child(card)
	$Hand.receiveCard(card)
	
func limboCard(card: Node2D) -> void:
	$Limbo.receiveCard(card)
	$Limbo.add_child(card)

func _on_limbo_card_discarded(card: Node2D) -> void:
	$Limbo.remove_child(card)
	limboCardDiscarded.emit(card, index)

func _on_hand_card_discarded(card: Node2D) -> void:
	$Hand.remove_child(card)
	handCardDiscarded.emit(card, index)
	if $Hand.get_child_count() > 0:
		var tmpTween = create_tween()
		for c in $Hand.get_children():
			c.interactable = false
			tmpTween.parallel().tween_callback(c.makeMeInteractable).set_delay(gs.TRANSITION_SECONDS)
