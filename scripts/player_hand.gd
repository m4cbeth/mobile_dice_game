extends Node2D

const HAND_COUNT = 0
#YETTOBE IMPLEMENTED CONST MAXCARDS
const CARD_SCENE_PATH = "res://scenes/card.tscn"
const HAND_Y_AXIS = 900
const CARD_WIDTH = 177
const center_screen_x = 1920.0 / 2.0
const DEFAULT_POSITION = Vector2(1, 280)
const CARD_OVERLAP = 75
const DEAL_SPEED = .75
const DEAL_DELAY = 0.75
const ROTATION_AMOUNT = 5.0

var player_hand = []


func _ready() -> void:
	var dice_deck_position = get_parent().find_child("CardManager").find_child("DiceDeck").global_position
	var card_scene = preload("res://scenes/card.tscn")
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
		new_card.position = dice_deck_position
		new_card.z_index = 3 + i
		new_card.name = "Card" + str(i+1)
		$"../CardManager".add_child(new_card)
		add_card_to_hand(new_card)
		await get_tree().create_timer(DEAL_DELAY).timeout

func add_card_to_hand(card):
	player_hand.insert(0, card)
	update_hand_positions()
	
func update_hand_positions():
	for i in range(player_hand.size()):
		var card = player_hand[i]
		var new_position = Vector2(calculate_card_position(i), HAND_Y_AXIS)
		animate_card_to_position(card, new_position)
		#card.rotation_degrees = calculate_card_rotation(i)
		#await get_tree().create_timer(.5)

func animate_card_to_position(card, new_position):
	#card.position = new_position
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, DEAL_SPEED)

func calculate_card_position(index):
	var total_width = (player_hand.size() - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2.0 - CARD_OVERLAP * index
	return x_offset

func calculate_card_rotation(index):
	var count = player_hand.size()
	if count <= 1:
		return 0.0
	var t = index / float(count -1) * 2.0 - 1.0
	return t * ROTATION_AMOUNT
