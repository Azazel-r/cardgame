extends Node2D

# card scene
const cardScene := preload("res://scenes/card.tscn")

# just some general variables
const DOWNTIME := 0.66
const HOVERTIME := 0.33
const CARDCOUNT := 12
const CARDWIDTH := 120

# vectors
var drawPilePos := Vector2(0,0)

# diverse st8ff
var drawable := true
var tweener : Tween = null
signal cardDrawnSignal(card : Node2D, drawn : int)

# -----------------------------------------------------------------
# Important functions or smth idk
# -----------------------------------------------------------------

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func makeDeck() -> void:
	for i in range(CARDCOUNT):
		var card = cardScene.instantiate()
		card.setSpriteNum((i%2)+1)
		card.makeReady(drawPilePos, i)
		add_child(card)

func shuffle() -> void:
	var children := getCardChildren()
	var idxList := Array(range(len(children)))
	var tempChilds := []
	tempChilds.resize(len(children))
	randomize()
	idxList.shuffle()
	for i in range(len(children)):
		children[i].z_index = idxList[i]
		tempChilds[children[i].z_index] = children[i]
	for i in range(len(tempChilds)-1, -1, -1):
		move_child(tempChilds[len(tempChilds)-i-1], i+1)
	

func drawCard() -> void:
	drawable = false
	var topCard = getTopChild()
	topCard.resetHover()
	remove_child(topCard)
	var drawtweener = create_tween()
	drawtweener.tween_callback(makeDeckDrawable).set_delay(DOWNTIME)
	cardDrawnSignal.emit(topCard)
	
func hoverDeck() -> void:
	var children = getCardChildren()
	if len(children	) > 0:
		tweener = create_tween()
		for i in range(len(children)):
			tweener.tween_callback(children[i].hoverAnimation).set_delay(1.0 * i/len(children) * HOVERTIME)

# -----------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------

func makeDeckDrawable() -> void:
	drawable = true
	
func getTopChild() -> Node2D:
	if len(get_children()) > 1:
		return get_children()[1]
	return null

func makeReady(v : Vector2) -> void:
	drawPilePos = v
	$drawPileArea.position = drawPilePos
	makeDeck()

func getCardChildren() -> Array:
	return get_children().slice(1,get_child_count())

# -----------------------------------------------------------------
# Signal Functions
# -----------------------------------------------------------------

func _on_draw_pile_area_on_draw_pile_click() -> void:
	if get_child_count() > 1 and drawable:
		drawCard()

func _on_draw_pile_area_on_draw_pile_enter() -> void:
	hoverDeck()

func _on_draw_pile_area_on_draw_pile_exit() -> void:
	if tweener != null:
		tweener.kill()
	for card in getCardChildren():
		card.resetHover()
