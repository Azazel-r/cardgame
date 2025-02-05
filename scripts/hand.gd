extends Node2D

var middleCentered := true
var windowSize : Vector2i
var handPos := Vector2(0,0)
signal cardDiscarded(card : Node2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getNextCardPos() -> Vector2:
	if (get_child_count() == 0):
		return handPos
	else:
		return Vector2(handPos.x + gs.margin, handPos.y)

func makeSpace() -> void:
	var children := get_children()
	var count := get_child_count()
	for i in range(count):
		var pos = remap(i, 0, count, handPos.x - gs.margin, handPos.x + gs.margin)
		var tweener = create_tween()
		tweener.tween_property(children[i], "position", Vector2(pos, handPos.y), gs.SHIFT_TIME).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func receiveCard(card : Node2D) -> void:
	card.interactable = false
	card.z_index = get_child_count()-1
	card.onEnter.connect(cardHover)
	card.onExit.connect(cardHoverReset)
	card.onClick.connect(cardClicked)
	cardHover(card)
	
func receiveLimboCard(card: Node2D) -> void:
	card.interactable = false
	card.z_index = 0 # TODO mach endlich mal was mit den z indexen
	card.onEnter.connect(cardHover)
	card.onExit.connect(cardHoverReset)
	card.onClick.connect(cardClicked)
	print("signals connected, card received from limbo")
	card.resetHover() # here!!
	
func discardCard(card: Node2D) -> void:
	cardHoverResetNoEase(card)
	card.onEnter.disconnect(cardHover)
	card.onExit.disconnect(cardHoverReset)
	card.onClick.disconnect(cardClicked)
	cardDiscarded.emit(card)
	
func showCards(cardIdx: Array, seconds: float) -> void:
	for i in cardIdx:
		get_child(i).flipCard(gs.JUST_FLIP_SECONDS)
		var temptween = create_tween()
		temptween.tween_callback(get_child(i).flipCard.bind(gs.JUST_FLIP_SECONDS)).set_delay(seconds + gs.JUST_FLIP_SECONDS)

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
	print("interactable: ", card.interactable)
	print("discarding card ", card)
	if card.interactable:
		discardCard(card)
