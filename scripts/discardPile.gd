extends Node2D

# diverse st8ff
var drawable := false
var tweener : Tween = null
signal cardDrawnSignal(card : Node2D, player : int, limbo: bool)

# -----------------------------------------------------------------
# Important functions or smth idk
# -----------------------------------------------------------------

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func drawCard(player: int = gs.playerTurn, limbo: bool = true) -> void:
	drawable = false
	var topCard = getTopChild()
	topCard.resetHover()
	# var drawtweener = create_tween()
	# drawtweener.tween_callback(makeDeckDrawable).set_delay(gs.DRAW_DOWNTIME)
	cardDrawnSignal.emit(topCard, player, limbo)
	
func hoverDeck() -> void:
	var children = getCardChildren()
	if len(children) > 0:
		tweener = create_tween()
		for i in range(len(children)):
			tweener.tween_callback(children[i].hoverAnimation).set_delay(1.0 * i/len(children) * gs.HOVER_TIME)
			
func receiveCard(card: Node2D) -> void:
	add_child(card)
	# TODO: z index change bla bla
	# TODO: make hovering work

# -----------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------

func makeDeckDrawable() -> void:
	drawable = true
	
func getTopChild() -> Node2D:
	if len(get_children()) > 1:
		return get_children()[1]
	return null

func makeReady() -> void:
	$discardPileArea.position = gs.discardPilePos

func getCardChildren() -> Array:
	return get_children().slice(1,get_child_count())

# -----------------------------------------------------------------
# Signal Functions
# -----------------------------------------------------------------

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
