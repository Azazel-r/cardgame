extends Node

var turn := 0
var started := false

var window
const windowSize := Vector2i(1920,1080) #Vector2i(1280,720) #
const drawPilePos := Vector2(0.8 * windowSize.x, 0.2 * windowSize.y)
const discardPilePos := Vector2(0.6 * windowSize.x, 0.2 * windowSize.y)
const playerCount := 1

const playerScene := preload("res://scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window = get_window()
	window.size = windowSize
	window.move_to_center()
	
	#Playerstuff
	for i in range(playerCount):
		var playerInstance := playerScene.instantiate()
		$Players.add_child(playerInstance)
		
	
	$DrawPile.makeReady(drawPilePos)
	$DrawPile.shuffle()
	$DiscardPile.makeReady(discardPilePos)
	$startButton.position = Vector2(windowSize.x * 0.1, windowSize.y * 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	toggleTurn()
	
func toggleTurn() -> void:
	if gs.playerTurn == 0:
		gs.playerTurn = 1
		$Label.text("NOT your turn.")
		
	elif gs.playerTurn == 1:
		gs.playerTurn = 0
		$Label.text("Its YOUR turn.")

func _on_draw_pile_card_drawn_signal(card : Node2D) -> void:
	$DrawPile.remove_child(card)
	var pos = $Players.get_children()[gs.playerTurn].getNextCardPos()
	$Transition.add_child(card)
	$Players.get_children()[gs.playerTurn].makeSpace()
	$Transition.transToPosition(pos, true, "hand", gs.playerTurn)
	
func _on_discard_pile_card_drawn_signal(card: Node2D) -> void:
	$DiscardPile.remove_child(card)
	var pos = $Players.get_children()[gs.playerTurn].getNextCardPos()
	$Transition.add_child(card)
	$Players.get_children()[gs.playerTurn].makeSpace()
	$Transition.transToPosition(pos, false, "hand", gs.playerTurn)

func _on_transition_pos_reached(card: Node2D, end: String) -> void:
	$Transition.remove_child(card)
	if end == "hand":
		$Hand.add_child(card) # TODO remove $Hand everywhere and stuff
		$Hand.receiveCard(card)
	elif end == "discardPile":
		$DiscardPile.add_child(card)
		$DiscardPile.receiveCard(card)

func _on_hand_card_discarded(card: Node2D) -> void:
	$Hand.remove_child(card)
	var pos = $DiscardPile.discardPilePos
	$Transition.add_child(card)
	$Transition.transToPosition(pos, false, "discardPile")

func scaleEverythingAccordingly() -> void:
	const cardScale := (1.0 * windowSize.y / 5) / 336 # 336 = card height!!!!!
	gs.cardSize = Vector2i(int(floorf(cardScale * 240)),int(floorf(cardScale * 336)))
	gs.margin = Vector2i(int(1.0 * windowSize.x / 50), int(1.0 * windowSize.y / 40))
