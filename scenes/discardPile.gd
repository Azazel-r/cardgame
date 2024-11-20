extends Node2D

var drawable := true
const DOWNTIME := 0.66
signal cardDrawnSignal(card)

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
	remove_child(topCard)
	var drawtweener = create_tween()
	drawtweener.tween_callback(makeDeckDrawable).set_delay(DOWNTIME)
	cardDrawnSignal.emit(topCard)
	# TODO

func getTopChild() -> Node2D:
	if len(get_children()) > 1:
		return get_children()[1]
	return null

func makeDeckDrawable() -> void:
	drawable = true
