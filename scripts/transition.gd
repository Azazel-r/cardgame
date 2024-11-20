extends Node
const SECONDS := 0.66
signal handReached(card : Node2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func transToHand(handpos : Vector2) -> void:
	var card = get_child(0)
	var tweenToHand = create_tween()
	tweenToHand.tween_property(card, "position", handpos, SECONDS).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	card.flipCard(SECONDS)
	tweenToHand.parallel().tween_callback(card.makeMeInteractable).set_delay(SECONDS)
	tweenToHand.parallel().tween_callback(card.makeTransitionStop).set_delay(SECONDS)
	tweenToHand.parallel().tween_callback(handReached.emit.bind(card)).set_delay(SECONDS)

#func setCardZIndex(card : Node2D, n : int) -> void:
	#card.z_index = n
