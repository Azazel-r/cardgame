extends Node
const SECONDS := 0.66
signal posReached(card : Node2D, end : String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func transToPosition(pos : Vector2, flip : bool, end : String) -> void:
	var card = get_child(0)
	var tweenToHand = create_tween()
	tweenToHand.tween_property(card, "position", pos, SECONDS).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	if flip:
		card.flipCard(SECONDS)
	tweenToHand.parallel().tween_callback(posReached.emit.bind(card, end)).set_delay(SECONDS)
