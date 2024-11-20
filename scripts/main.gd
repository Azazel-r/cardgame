extends Node

var turn := 0
var playerTurn := true
var started := false

var window
const windowSize := Vector2i(1920,1080) #Vector2i(1280,720) #
const drawPilePos := Vector2(0.8 * windowSize.x, 0.2 * windowSize.y)
const discardPilePos := Vector2(0.6 * windowSize.x, 0.2 * windowSize.y)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window = get_window()
	window.size = windowSize
	window.move_to_center()
	$DrawPile.makeReady(drawPilePos)
	$DrawPile.shuffle()
	$DiscardPile.makeReady(discardPilePos)
	$Hand.windowSize = windowSize
	$startButton.position = Vector2(windowSize.x * 0.1, windowSize.y * 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	startGame()
	
func startGame() -> void:
	started = true
	$Label.text = "Hat gestartet!"

func _on_draw_pile_card_drawn_signal(card : Node2D) -> void:
	$DrawPile.remove_child(card)
	var pos = $Hand.getNextCardPos()
	$Transition.add_child(card)
	$Hand.makeSpace()
	$Transition.transToPosition(pos, true, "hand")
	
func _on_discard_pile_card_drawn_signal(card: Node2D) -> void:
	$DiscardPile.remove_child(card)
	var pos = $Hand.getNextCardPos()
	$Transition.add_child(card)
	$Hand.makeSpace()
	$Transition.transToPosition(pos, false, "hand")

func _on_transition_pos_reached(card: Node2D, end: String) -> void:
	$Transition.remove_child(card)
	if end == "hand":
		$Hand.add_child(card)
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
	pass # TODO
