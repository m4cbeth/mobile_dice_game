extends Node2D
class_name PlayerHand

const HAND_COUNT = 1
#YETTOBE IMPLEMENTED CONST MAXCARDS
const CARD_SCENE_PATH = "res://scenes/card.tscn"
const HAND_Y_AXIS = 920
const CARD_WIDTH = 177
const center_screen_x = 2020.0 / 2.0
const CARD_OVERLAP = 75
const DEAL_SPEED = .3 # lower = faster
const DEAL_DELAY = 0.25
const ROTATION_AMOUNT = 5.0
var player_hand = []


func _ready() -> void:
	var dice_deck_position = get_parent().find_child("CardManager").find_child("DiceDeck").global_position
	var card_scene = preload(CARD_SCENE_PATH)
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
	print('has run')
	for i in range(player_hand.size()):
		# z index based off some base num + index of card in hand
		
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
	var hand_size = player_hand.size()
	if hand_size == 0:
		return center_screen_x
	var total_width = CARD_WIDTH + (hand_size - 1) * (CARD_WIDTH - CARD_OVERLAP)
	var start_x = center_screen_x - total_width / 2.0
	return start_x + index * (CARD_WIDTH - CARD_OVERLAP)


func calculate_card_rotation(index):
	var count = player_hand.size()
	if count <= 1:
		return 0.0
	var t = index / float(count -1) * 2.0 - 1.0
	return t * ROTATION_AMOUNT

#func raycast_check_for_card():
	#var space_state = get_world_2d().direct_space_state
	#var parameters = PhysicsPointQueryParameters2D.new()
	#parameters.position = get_global_mouse_position()
	#parameters.collide_with_areas = true
	#parameters.collision_mask = COLLISION_CARD_MASK
	#var result = space_state.intersect_point(parameters)
	#if result.size() > 0:
	##	return result[0].collider.get_parent()
		#return get_card_with_highest_z_index(result)
	#return null
