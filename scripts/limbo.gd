extends Node
signal cardDiscarded(card : Node2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func receiveCard(card: Node2D) -> void:
	card.interactable = true
	card.z_index = 0
	card.onEnter.connect(cardHover)
	card.onExit.connect(cardHoverReset)
	card.onClick.connect(cardClicked)
	cardHover(card)
	
func cardHover(card: Node2D) -> void:
	if card.hovering and card.interactable:
		card.hoverAnimation(0)

func cardHoverReset(card : Node2D) -> void:
	if card.interactable:
		card.resetHover(0)

func cardHoverResetNoEase(card : Node2D) -> void:
	if card.interactable:
		card.resetHoverNoEase(0)

func cardClicked(card : Node2D) -> void:
	if card.interactable:
		discardCard(card)
		#cardHoverReset(card)
		#card.flipCard(gs.JUST_FLIP_SECONDS)
		#card.interactable = false
		#var tmpTween := create_tween()
		#tmpTween.tween_callback(card.makeMeInteractable).set_delay(gs.JUST_FLIP_SECONDS)
		#tmpTween.parallel().tween_callback(cardHover.bind(card)).set_delay(gs.JUST_FLIP_SECONDS)

func discardCard(card: Node2D) -> void:
	cardHoverResetNoEase(card)
	card.onEnter.disconnect(cardHover)
	card.onExit.disconnect(cardHoverReset)
	card.onClick.disconnect(cardClicked)
	cardDiscarded.emit(card)
