extends Node
signal posReached(card : Node2D, end : String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func transToPosition(card : Node2D, pos : Vector2, flip : bool, end : String) -> void:
	print("transitioning ", card, " to endpos ", end)
	add_child(card)
	var tweenToHand = create_tween()
	tweenToHand.tween_property(card, "position", pos, gs.TRANSITION_SECONDS).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	if flip:
		card.flipCard(gs.TRANSITION_SECONDS)
	tweenToHand.parallel().tween_callback(posReached.emit.bind(card, end)).set_delay(gs.TRANSITION_SECONDS)
