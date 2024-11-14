extends Node2D

# signals
signal whichSprite
signal flipToBack
signal flipToFront

# general variables
var spriteNum := 1
var cardNumber : int
var zindexchange : int

# transform variables
var startPos := Vector2(0,0)
const SECONDS := 0.66
const FLIPTIME := 0.5
var addSkew : float = 0

# bools
var back := false
var inTransition := false
var interactable := false
var hovering := false
var onStack : bool

# tween stuff
var tween : Tween = null
var tween2 : Tween = null
var tweenTurn : Tween = null
var tweenScale : Tween = null
var tweenToHand : Tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = startPos
	emit_signal("whichSprite", spriteNum)
	flipToBack.emit()
	back = true
	skew = PI
	onStack = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func makeMeInteractable() -> void:
	interactable = true

func makeTransitionStop() -> void:
	inTransition = false

func setSpriteNum(n : int) -> void:
	spriteNum = n

func setPos(start : Vector2, num : int, z : int) -> void:
	startPos = start
	cardNumber = num
	zindexchange = z
	
func flipCard(secs : float) -> void:
	if !back:
		tweenTurn = create_tween()
		tweenScale = create_tween()
		tweenTurn.tween_property($cardArea, "skew", 0, secs).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tweenTurn.parallel().tween_callback(flipToBack.emit).set_delay(secs/2)
		tweenScale.tween_property($cardArea, "scale", Vector2(0.5,1), secs/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tweenScale.tween_property($cardArea, "scale", Vector2(1,1), secs/2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		addSkew = 0
		back = true
	else:
		tweenTurn = create_tween()
		tweenTurn.tween_property($cardArea, "skew", PI, secs).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tweenTurn.parallel().tween_callback(flipToFront.emit).set_delay(secs/2)
		addSkew = PI
		back = false

func hoverAnimation() -> void:
	if hovering:
		tween = create_tween()
		tween.tween_property($cardArea, "scale", Vector2(1.2,1.2), 0.15).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		tween.parallel().tween_property($cardArea, "skew", addSkew - PI/16, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween2 = create_tween()
		tween2.tween_property($cardArea, "skew", addSkew + PI/16, 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween2.tween_property($cardArea, "skew", addSkew - PI/16, 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween2.set_loops()
		if !onStack:
			z_index += zindexchange

func resetTweens() -> void:
	if tween != null:
		tween.kill()
	if tween2 != null:
		tween2.kill()
	tween = create_tween()
	tween.tween_property($cardArea, "skew", addSkew, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property($cardArea, "scale", Vector2(1,1), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	if !onStack:
		z_index -= zindexchange

func resetTweensNoEase() -> void:
	if tween != null:
		tween.kill()
	if tween2 != null:
		tween2.kill()
	$cardArea.skew = addSkew
	$cardArea.scale = Vector2(1,1)
	if !onStack:
		z_index -= zindexchange
	

func _on_card_area_on_click() -> void:
	if !onStack and interactable:
		resetTweens()
		flipCard(FLIPTIME)
		interactable = false
		var tmpTween = create_tween()
		tmpTween.tween_callback(makeMeInteractable).set_delay(FLIPTIME)
		tmpTween.parallel().tween_callback(hoverAnimation).set_delay(FLIPTIME)

func _on_card_area_on_enter() -> void:
	hovering = true
	if interactable and !onStack:
		hoverAnimation()
	#print(cardNumber, " skew: ", $cardArea.skew)

func _on_card_area_on_exit() -> void:
	hovering = false
	if inTransition:
		resetTweensNoEase()
	elif interactable and !onStack:
		resetTweens()
