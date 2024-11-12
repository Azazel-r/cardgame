extends Node2D

const cardScene := preload("res://card.tscn")
var cards := []
var cardsInDeck := []
var DECKPOS := Vector2(0,0)
var HANDPOS := Vector2(0,0)
var justDrawn := false
var drawnT : float = 0
const DOWNTIME := 0.66
var winSize := Vector2i(0,0)
var cardsDrawn := 0
const CARDCOUNT := 6
var tweener : Tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$deckArea/deckCollision.position = DECKPOS
	makeDeck()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if justDrawn:
		drawnT += delta
		if drawnT >= DOWNTIME:
			justDrawn = false
			#makeTopInteractable()

func makeDeck() -> void:
	for i in range(CARDCOUNT):
		var card = cardScene.instantiate()
		card.setSpriteNum((i%2)+1)
		card.setPos(DECKPOS, i)
		cards.append(card)
		cardsInDeck.append(true)
	
	for i in range(-1, -len(cards)-1, -1):
		add_child(cards[i])

func makeCardInteractable(n : int):
	cards[n].interactable = true

func _on_deck_area_on_deck_click() -> void:
	var topCard = cardsInDeck.find(true)
	if topCard != -1 and !justDrawn:
		cardsDrawn += 1
		# make top card come to hand
		cards[topCard].comeToHand(HANDPOS + Vector2(275 * (cardsDrawn-1), 0)) # TODO
		cardsInDeck[topCard] = false
		justDrawn = true
		drawnT = 0

func makeTopInteractable() -> void:
	var topCard = cardsInDeck.find(true)
	if topCard != -1:
		makeCardInteractable(topCard)

func _on_deck_area_on_deck_enter() -> void:
	tweener = create_tween()
	var idx = 0
	for i in range(CARDCOUNT):
		if cardsInDeck[i]:
			tweener.tween_callback(cards[i].hoverAnimation).set_delay(idx * 0.1)
			idx += 1

func _on_deck_area_on_deck_exit() -> void:
	if tweener != null:
		tweener.kill()
	for i in range(CARDCOUNT):
		if cardsInDeck[i]:
			cards[i].resetTweens()

func setWindowSize(v : Vector2i) -> void:
	winSize = v
	HANDPOS = Vector2(0.1 * winSize.x, 0.75 * winSize.y)
	DECKPOS = Vector2(0.8 * winSize.x, 0.2 * winSize.y)
