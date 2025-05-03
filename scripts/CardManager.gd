extends Node2D

var card_being_dragged
var drag_offset = Vector2.ZERO
var screen_size
var is_hovering_on_card
var most_recent_z_index
var card_return_position

const COLLISION_CARD_MASK = 1
const HOVER_SCALE_AMOUNT = 4.5
const DEFAULT_SCALE_AMOUNT = Vector2(4,4)
const HOVER_TWEEEN_SPEED = 0.2
const MAX_X = 1920
const MAX_Y = 1080

func clamp_mouse(mouse_pos: Vector2):
	return Vector2(clamp(mouse_pos.x, 0, MAX_X), clamp(mouse_pos.y, 0, MAX_Y))

# Called when the node enters the scene tree for the first times.
func _ready():
	screen_size = get_viewport_rect().size
	most_recent_z_index = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position() + drag_offset
		card_being_dragged.global_position = clamp_mouse(mouse_pos)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card()
			if card:
				drag_offset = card.global_position - get_global_mouse_position()
				start_drag(card)
			else:
				if card_being_dragged:
					finish_drag()
		else:
			if card_being_dragged:
				$"../Camera2D".trigger_shake()
				$"../CardDropSound".play()
			card_being_dragged = null

func start_drag(card):
	card_return_position = card.position
	#most_recent_z_index += 1
	#card.z_index = most_recent_z_index
	card_being_dragged = card
	card.scale = DEFAULT_SCALE_AMOUNT

func finish_drag():
	card_being_dragged.scale = Vector2(HOVER_SCALE_AMOUNT, HOVER_SCALE_AMOUNT)
	card_being_dragged = null



func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)


func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)
	
func on_hovered_off_card(card):
	if !card_being_dragged:		
		highlight_card(card, false)
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false
	

func highlight_card(card, hovered):
	var target_scale = Vector2(HOVER_SCALE_AMOUNT, HOVER_SCALE_AMOUNT) if hovered else DEFAULT_SCALE_AMOUNT
	var target_z = 2 if hovered else 1
	card.z_index = target_z
	var tween = card.create_tween()
	tween.tween_property(card, "scale", target_scale, HOVER_TWEEEN_SPEED).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_CARD_MASK
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
	#	return result[0].collider.get_parent()
		return get_card_with_highest_z_index(result)
	return null

func get_card_with_highest_z_index(cards):
	# Assume first is highest
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	# Loop through rest checking for higher
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
