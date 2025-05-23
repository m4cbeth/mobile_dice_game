extends Node2D
class_name PlayerHand

@onready var dice_deck_node = $"../CardManager/DiceDeck"

# Number of starting cards
const HAND_COUNT = 2
# hand size ie max cards but part of game, can increase hand size
var hand_max := 3
#YETTOBE IMPLEMENTED CONST MAXCARDS
const CARD_SCENE_PATH = "res://scenes/card.tscn"
const HAND_Y_AXIS = 920
const CARD_WIDTH = 177
const center_screen_x = 1920.0 / 2.0 - 500
const CARD_OVERLAP = 75
const DEAL_SPEED = .3 # lower = faster
const DEAL_DELAY = 0.25
const ROTATION_AMOUNT = 5.0
var player_hand = []

func get_dice_deck_position():
	return get_parent().find_child("CardManager").find_child("DiceDeck").global_position

func _ready() -> void:
	var dice_deck_position = get_dice_deck_position()
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(HAND_COUNT):
		dice_deck_node.spawn_card()
		await get_tree().create_timer(DEAL_DELAY).timeout

func add_card_to_hand(card, pos):
	var val = pos if pos >= 0 else 0
	player_hand.insert(val, card)
	update_hand_positions()

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, DEAL_SPEED)
	await tween.finished

func update_hand_positions():
	var current_card_count = player_hand.size()
	var tweens = []
	for i in range(current_card_count):
		var card: PlayingCard = player_hand[i]
		card.z_index = 2 + current_card_count - i
		var new_position = Vector2(calculate_card_position(i), HAND_Y_AXIS)
		animate_card_to_position(card, new_position)
	if player_hand.size() > hand_max:
		var random_spot = randi_range(0, player_hand.size()-1)
		destroy_a_card(player_hand[random_spot])

func destroy_a_card(card: PlayingCard):
	if not is_instance_valid(card):
		return
	player_hand.erase(card)	
	await get_tree().create_timer(.5).timeout
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
	fire_sound.finished.connect(func(): card.queue_free())
	fire_sound.play()
	await get_tree().create_timer(0.5).timeout
	if card.find_child("CardBackground"):
		card.find_child("CardBackground").visible = false
	if card.find_child("Knight"):
		card.find_child("Knight").visible = false
	if burning_animation:
		burning_animation.play()
	for child in card_children:
		if is_instance_valid(child) and child.name != "FireWhoosh":
			child.queue_free()
	await get_tree().create_timer(.5).timeout
	update_hand_positions()

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
