extends Node2D

# card scene
const cardScene := preload("res://card.tscn")

# just some general variables
const DOWNTIME := 0.66
const HOVERTIME := 0.33
var cardsDrawn := 0
const CARDCOUNT := 12
const CARDWIDTH := 120

# vectors
var winSize := Vector2i(0,0)
var DECKPOS := Vector2(0,0)
var HANDPOS := Vector2(0,0)

# diverse st8ff
var drawable := true
var tweener : Tween = null
signal cardDrawnSignal(card : Node2D, drawn : int)

# -----------------------------------------------------------------
# Important functions or smth idk
# -----------------------------------------------------------------

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$drawPileArea.position = DECKPOS
	makeDeck()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func makeDeck() -> void:
	for i in range(CARDCOUNT):
		var card = cardScene.instantiate()
		card.setSpriteNum((i%2)+1)
		card.setPos(DECKPOS, i, CARDCOUNT)
		add_child(card)

func shuffle() -> void:
	var children := get_children()
	var idxList := Array(range(len(children)))
	randomize()
	idxList.shuffle()
	for i in range(len(children)):
		children[i].z_index = idxList[i]

func drawCard() -> void:
	drawable = false
	var topCard = getTopChild()
	cardsDrawn += 1
	var drawtweener = create_tween()
	drawtweener.tween_callback(makeDeckDrawable).set_delay(DOWNTIME)
	cardDrawnSignal.emit(topCard, cardsDrawn)
	remove_child(topCard)

# -----------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------

func makeDeckDrawable() -> void:
	drawable = true
	
func getTopChild() -> Node2D:
	var children := get_children()
	var erg := children[0]
	for card in children:
		if card.z_index > erg:
			erg = card
	return erg

func setWindowSize(v : Vector2i) -> void:
	winSize = v
	HANDPOS = Vector2(0, 0.75 * winSize.y)
	DECKPOS = Vector2(0.8 * winSize.x, 0.2 * winSize.y)
	

# -----------------------------------------------------------------
# Signal Functions
# -----------------------------------------------------------------

func _on_draw_pile_area_on_draw_pile_click() -> void:
	if cardsDrawn < CARDCOUNT and drawable:
		drawCard()


func _on_draw_pile_area_on_draw_pile_enter() -> void:
	tweener = create_tween()
	var children = get_children()
	for i in range(len(children)):
		tweener.tween_callback(children[i].hoverAnimation).set_delay(i/len(children) * HOVERTIME)


func _on_draw_pile_area_on_draw_pile_exit() -> void:
	if tweener != null:
		tweener.kill()
	for card in get_children():
		card.resetTweens()
