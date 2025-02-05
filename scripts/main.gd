extends Node

var turn := 0
var started := false

var window
const windowSize := Vector2i(1920,1080) #Vector2i(1280,720) #
const drawPilePos := Vector2(0.9 * windowSize.x, 0.2 * windowSize.y)
const discardPilePos := Vector2(0.1 * windowSize.x, 0.2 * windowSize.y)

const playerScene := preload("res://scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window = get_window()
	window.size = windowSize
	gs.winSize = windowSize
	window.move_to_center()
	scaleEverythingAccordingly(0.66) # juhu
	
	#Playerstuff
	var gap = remap(clampf(gs.scale,0.0,1.0), 0, 1, 0, 0.25)
	gs.handPos1 = Vector2(windowSize.x * 0.5, windowSize.y * (1-gap))
	gs.handPos2 = Vector2(windowSize.x * 0.5, windowSize.y * gap)
	gs.limboPos = 0.5 * windowSize
	for i in range(gs.PLAYER_COUNT):
		var playerInstance := playerScene.instantiate()
		$Players.add_child(playerInstance)
		playerInstance.setup(i)
		playerInstance.handCardDiscarded.connect(_on_hand_card_discarded)
		playerInstance.limboCardDiscarded.connect(_on_limbo_card_discarded)
	
	gs.drawPilePos = drawPilePos
	gs.discardPilePos = discardPilePos
	$DrawPile.makeReady()
	$DrawPile.shuffle()
	$DiscardPile.makeReady()
	$startButton.position = Vector2(windowSize.x * 0.1, windowSize.y * 0.5)
	
	gameStart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	showCards([0,1],[0,3],2)
	# toggleTurn()
	
func gameStart() -> void:
	# give 4 cards to each player
	var dtime = gs.START_DRAW_DELAY
	var drawtweener = create_tween()
	# drawtweener.tween_callback(showCards.bind())
	for i in range(gs.NUM_HAND_CARDS):
		drawtweener.parallel().tween_callback($DrawPile.drawCard.bind(0, false)).set_delay((2*i*dtime) + dtime)
		drawtweener.parallel().tween_callback($DrawPile.makeDeckDrawable).set_delay((2*i*dtime) + dtime + 0.01)
		#
		drawtweener.parallel().tween_callback($DrawPile.drawCard.bind(1, false)).set_delay((2*i*dtime) + 2*dtime)
		drawtweener.parallel().tween_callback($DrawPile.makeDeckDrawable).set_delay((2*i*dtime) + 2*dtime + 0.01)
		
func showCards(players: Array, cardIdx: Array, seconds: float) -> void:
	for p in players:
		$Players.get_child(p).get_child(0).showCards(cardIdx, seconds)

func toggleTurn() -> void:
	if gs.playerTurn == 0:
		gs.playerTurn = 1
		$Label.text = "NOT your turn."
		
	elif gs.playerTurn == 1:
		gs.playerTurn = 0
		$Label.text = "It's YOUR turn."

func _on_draw_pile_card_drawn_signal(card : Node2D, player: int, limbo: bool) -> void:
	var destination : String
	$DrawPile.remove_child(card)
	if limbo:
		destination = "limbo1" if player == 0 else "limbo2"
		$Transition.transToPosition(card, gs.limboPos, true, destination)
	else:
		destination = "hand1" if player == 0 else "hand2"
		var pos = $Players.get_child(player).getNextCardPos()
		$Players.get_child(player).makeSpace()
		$Transition.transToPosition(card, pos, false, destination)
	
func _on_discard_pile_card_drawn_signal(card: Node2D) -> void:
	# TODO ZU ÜBERARBEITEN!!
	$DiscardPile.remove_child(card)
	var pos = $Players.get_children()[gs.playerTurn].getNextCardPos()
	$Players.get_children()[gs.playerTurn].makeSpace()
	$Transition.transToPosition(card, pos, false, "hand")

func _on_transition_pos_reached(card: Node2D, end: String) -> void:
	$Transition.remove_child(card)
	if end == "hand1":
		$Players.get_child(0).receive_card(card)
	elif end == "hand2":
		$Players.get_child(1).receive_card(card)
	elif end == "limbo1":
		$Players.get_child(0).limboCard(card)
	elif end == "limbo2":
		$Players.get_child(1).limboCard(card)
	elif end == "discardPile":
		$DiscardPile.receiveCard(card)

func _on_hand_card_discarded(card: Node2D, player: int, limbocard: Node2D) -> void:
	var pos = gs.discardPilePos
	var pos2 = card.position
	$Transition.transToPosition(card, pos, true, "discardPile")
	$Players.get_child(player).get_child(1).remove_child(limbocard)
	$Transition.transToPosition(limbocard, pos2, true, "hand1" if player == 0 else "hand2") # TODO iwas geht nicht wenn 2x ausgetauscht wird oder so
	$DrawPile.drawable = true

func _on_limbo_card_discarded(card: Node2D, player: int) -> void:
	var pos = gs.discardPilePos
	$Transition.transToPosition(card, pos, false, "discardPile")
	$DrawPile.drawable = true

func scaleEverythingAccordingly(scale: float) -> void:
	# gs.cardSize = Vector2i(int(floorf(scale * gs.cardSize.x)), int(floorf(scale * gs.cardSize.y)))
	gs.cardScale = Vector2(scale, scale)
	gs.margin *= scale
	gs.scale = scale
	
	#const cardScale := (1.0 * windowSize.y / 5) / 336 # 336 = card height!!!!!
	#gs.cardSize = Vector2i(int(floorf(cardScale * 240)),int(floorf(cardScale * 336)))
	#gs.margin = Vector2i(int(1.0 * windowSize.x / 50), int(1.0 * windowSize.y / 40))
