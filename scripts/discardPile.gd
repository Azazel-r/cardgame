extends Node2D

var drawable := true
const DOWNTIME := 0.66
signal cardDrawnSignal(card : Node2D)
var discardPilePos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func drawCard() -> void:
	drawable = false
	var topCard = getTopChild()
	topCard.resetHover()
	var drawtweener = create_tween()
	drawtweener.tween_callback(makeDeckDrawable).set_delay(DOWNTIME)
	cardDrawnSignal.emit(topCard)

func getTopChild() -> Node2D:
	if len(get_children()) > 1:
		return get_children()[-1]
	return null

func makeDeckDrawable() -> void:
	drawable = true
	
func makeReady(v : Vector2) -> void:
	discardPilePos = v
	$discardPileArea.position = v
	
func receiveCard(card : Node2D) -> void:
	card.interactable = false
	card.z_index = get_child_count()-1

func _on_discard_pile_area_on_discard_pile_click() -> void:
	if drawable and get_child_count() > 1:
		drawCard() # TODO ?

func _on_discard_pile_area_on_discard_pile_enter() -> void:
	var card = getTopChild()
	if card != null:
		card.hoverAnimation()

func _on_discard_pile_area_on_discard_pile_exit() -> void:
	var card = getTopChild()
	if card != null:
		card.resetHover()
