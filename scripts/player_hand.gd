extends Node2D
class_name PlayerHand

@onready var dice_deck_node = $"../CardManager/DiceDeck"

# Number of starting cards
const HAND_COUNT = 1
# hand size ie max cards but part of game, can increase hand size
var hand_max := 4
#YETTOBE IMPLEMENTED CONST MAXCARDS
const CARD_SCENE_PATH = "res://scenes/card.tscn"
const HAND_Y_AXIS = 920
const CARD_WIDTH = 177
const center_screen_x = 1920.0 / 2.0
const CARD_OVERLAP = 75
const DEAL_SPEED = .3 # lower = faster
const DEAL_DELAY = 0.25
const ROTATION_AMOUNT = 5.0
var player_hand = []


func _ready() -> void:
	var dice_deck_position = get_parent().find_child("CardManager").find_child("DiceDeck").global_position
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(HAND_COUNT):
		dice_deck_node.spawn_card()
		await get_tree().create_timer(DEAL_DELAY).timeout

func add_card_to_hand(card, pos):
	var val = pos if pos >= 0 else 0
	player_hand.insert(val, card)
	update_hand_positions()
	print('playerhand: ', player_hand)

func update_hand_positions():
	var current_card_count = player_hand.size()
	for i in range(current_card_count):
		var card: Node2D = player_hand[i]
		card.z_index = 2 + current_card_count - i
		var new_position = Vector2(calculate_card_position(i), HAND_Y_AXIS)
		animate_card_to_position(card, new_position)
		"""
		#card.rotation_degrees = calculate_card_rotation(i)
		#would need a tween?
		"""
		

func destroy_a_card(card: Node2D):
	var destruction_animation: AnimatedSprite2D
	var burning_animation: AnimatedSprite2D
	var sprite: CharacterBody2D
	var fire_sound: AudioStreamPlayer
	
	var card_children = card.get_children()	
	for child in card_children:
			match child.name:
				"Destruction":
					destruction_animation = child
				"Burning":
					burning_animation = child
				"FireWhoosh":
					fire_sound = child
	destruction_animation.play()
	fire_sound.play()
	await get_tree().create_timer(0.5).timeout
	burning_animation.play()
	destruction_animation.animation_finished.connect(func(): card.queue_free())

func animate_card_to_position(card, new_position):
	#card.position = new_position
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, DEAL_SPEED)
	await tween.finished
	if player_hand.size() > hand_max:
		var random_spot = randi_range(0, player_hand.size()-1)
		print("randomspot ", random_spot)
		
		
	#while player_hand.size() > hand_max:
		#var card_to_destroy = player_hand[random_spot]
		#destroy_a_card(card_to_destroy)

func calculate_card_position(index):
	var hand_size = player_hand.size()
	if hand_size == 0:
		return center_screen_x
	var total_width = CARD_WIDTH + (hand_size - 1) * (CARD_WIDTH - CARD_OVERLAP)
	var start_x = 95 + center_screen_x - total_width / 2.0
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
