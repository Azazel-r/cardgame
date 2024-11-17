extends Node2D

var middleCentered := true
var margin := 200.0
var windowSize : Vector2i
const SHIFTTIME := 0.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getNextCardPos() -> Vector2:
	var Y := windowSize.y * 0.75
	if (get_child_count() == 0):
		return Vector2(windowSize.x * 0.5, Y)
	else:
		return Vector2(windowSize.x - margin, Y)

func makeSpace() -> void:
	var Y := windowSize.y * 0.75
	var children := get_children()
	var count := get_child_count()
	for i in range(count):
		var pos = remap(i, 0, count, margin, windowSize.x - margin)
		var tweener = create_tween()
		tweener.tween_property(children[i], "position", Vector2(pos, Y), SHIFTTIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
func receiveCard(card : Node2D) -> void:
	add_child(card)
	card.onEnter.connect(cardHover)
	card.onExit.connect(cardHoverReset)
	card.onClick.connect(cardClicked)
	cardHover(card)

func cardHover(card : Node2D) -> void:
	if card.hovering and card.interactable:
		card.hoverAnimation(get_child_count())

func cardHoverReset(card : Node2D) -> void:
	if card.interactable:
		card.resetHover(get_child_count())
	
func cardHoverResetNoEase(card : Node2D) -> void:
	if card.interactable:
		card.resetHoverNoEase(get_child_count())

func cardClicked(card : Node2D) -> void:
	if card.interactable:
		cardHoverResetNoEase(card)
		const FLIPTIME := 5
		card.interactable = false
		card.flipCard(FLIPTIME)
		var tmpTween = create_tween()
		tmpTween.tween_callback(card.makeMeInteractable).set_delay(FLIPTIME)
		tmpTween.parallel().tween_callback(cardHover.bind(card)).set_delay(FLIPTIME)
