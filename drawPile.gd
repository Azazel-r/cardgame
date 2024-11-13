extends Node2D

const cardScene := preload("res://card.tscn")
var cards := []
var cardsInDeck := []
var DECKPOS := Vector2(0,0)
var HANDPOS := Vector2(0,0)
var drawable := true
const DOWNTIME := 0.66
var winSize := Vector2i(0,0)
var cardsDrawn := 0
const CARDCOUNT := 12
var tweener : Tween = null
const CARDWIDTH := 120

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$deckArea/deckCollision.position = DECKPOS
	makeDeck()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func makeDeck() -> void:
	for i in range(CARDCOUNT):
		var card = cardScene.instantiate()
		card.setSpriteNum((i%2)+1)
		card.setPos(DECKPOS, i, CARDCOUNT)
		cards.append(card)
		cardsInDeck.append(true)
	
	for i in range(-1, -len(cards)-1, -1):
		add_child(cards[i])

func getCardIdxInDeck() -> Array:
	var erg := []
	for i in range(CARDCOUNT):
		if cardsInDeck[i]:
			erg.append(i)
	return erg

func shuffle() -> void:
	var idx := getCardIdxInDeck()
	for i in idx:
		var rnd = randi_range(0, len(idx)-1)
		var temp = cards[idx[rnd]]
		cards[idx[rnd]] = cards[i]
		cards[i] = temp
	for i in idx:
		cards[i].z_index = CARDCOUNT - i

func makeCardInteractable(n : int):
	cards[n].interactable = true

func _on_deck_area_on_deck_click() -> void:
	var topCard = cardsInDeck.find(true)
	if topCard != -1 and drawable:
		drawable = false
		# make top card come to hand
		cards[topCard].comeToHand(HANDPOS + Vector2(remap(cardsDrawn, 0, CARDCOUNT-1, CARDWIDTH, winSize.x - CARDWIDTH), 0), cardsDrawn) # TODO
		cardsInDeck[topCard] = false
		cardsDrawn += 1
		var drawtweener = create_tween()
		drawtweener.tween_callback(makeDeckDrawable).set_delay(DOWNTIME)
		
func makeDeckDrawable() -> void:
	drawable = true

func _on_deck_area_on_deck_enter() -> void:
	const HOVERTIME := 0.33
	tweener = create_tween()
	var deckIdx := getCardIdxInDeck()
	var idx : float = 0
	for i in deckIdx:
		tweener.tween_callback(cards[i].hoverAnimation).set_delay(idx/len(deckIdx) * HOVERTIME)
		idx += 1

func _on_deck_area_on_deck_exit() -> void:
	if tweener != null:
		tweener.kill()
	for i in range(CARDCOUNT):
		if cardsInDeck[i]:
			cards[i].resetTweens()

func setWindowSize(v : Vector2i) -> void:
	winSize = v
	HANDPOS = Vector2(0, 0.75 * winSize.y)
	DECKPOS = Vector2(0.8 * winSize.x, 0.2 * winSize.y)
