extends Node2D

@onready var card_scene = preload("res://scenes/card.tscn")
@onready var dice_sprite: AnimatedSprite2D = $BlueDie
@onready var mob_die = $RedDie # RedDie.play_her("won") ("ready player one")
@onready var health_display = $HealthNumber
@onready var green_smoke: AnimatedSprite2D = $GreenSmoke
@onready var hearts_container: HBoxContainer = owner.find_child("HeartContainer")

var rolling := false
var tween: Tween
var faces := 6
var current_frame := 0
var dice_transform_threshold := 4
var is_taking_damage := false

var dice_health := 3
var die_health_transform_threshold := 4

@export var rumble_duration: float = 0.5  # How long the rumble lasts
@export var rumble_intensity: float = 3.0  # How strong the position rumble is (in pixels)
@export var rotation_intensity: float = 0.1  # How much rotation in the rumble (in radians)
var num_shakes = 4

@export var is_rumbling = false
var rumble_time_left = 0.0
var initial_position: Vector2
var initial_rotation: float
var animated_sprite: AnimatedSprite2D

func _ready():
	update_hearts()
	animated_sprite = $BlueDie
	initial_position = $BlueDie.position
	initial_rotation = $BlueDie.rotation

func reset_die_position():
	animated_sprite.position = initial_position
	animated_sprite.rotation = initial_rotation

func start_roll():
	if rolling:	
		return
	rolling = true
	animated_sprite.stop()
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	var start_interval := 0.01
	var end_interval := 0.05
	var roll_duration := 0.25
	var start_time := 0.0
	var current_time := 0.0
	var frames_to_show := []
	while current_time < roll_duration:
		var progress = current_time / roll_duration
		var interval = lerp(start_interval, end_interval, progress)
		current_frame = (current_frame + 1) % faces
		frames_to_show.append({
			"time": current_time,
			"frame": current_frame
		})
		current_time += interval
	var final_result = randi() % faces
	frames_to_show.append({
		"time": roll_duration,
		"frame": final_result
	})
	# Schedule all frame changes
	for frame_data in frames_to_show:
		tween.tween_callback(func(): dice_sprite.frame = frame_data["frame"]).set_delay(frame_data["time"])
	# End rolling state when complete
	tween.tween_callback(func(): rolling = false).set_delay(roll_duration)
	# Update current_frame to match the final result
	tween.tween_callback(func(): current_frame = final_result).set_delay(roll_duration)
	tween.tween_callback(func(): deal_cards(final_result)).set_delay(roll_duration)
	tween.tween_callback(visual_feedback)

func visual_feedback():
	var original_scale = dice_sprite.scale
	var scale_up = original_scale * 1.75
	var animation_time := 0.93
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(dice_sprite, "scale", scale_up, animation_time)
	tween.tween_property(dice_sprite, "scale", original_scale, animation_time)

func deal_cards(number_of_cards: int) -> void:
	var counter = number_of_cards
	while counter + 1 > 0:
		counter -= 1
		spawn_card()
		await get_tree().create_timer(.1).timeout
		if counter == 0:
			animated_sprite.play()

func _on_button_button_down() -> void:
	start_roll()

func hit_by_slime(slime_hit_by: CharacterBody2D):
	take_damage(-1)
	update_hearts()
	if dice_health > dice_transform_threshold:
		slime_hit_by.state_machine.transition_to("Death")
	# if health is at threashold, transform into new die
	if dice_health == 4:
		#green_smoke.play_backwards("eight_reveal")
		#await green_smoke.animation_finished
		## hide old die // disable if needed (collision etc)
		#dice_sprite.visible = false
		#mob_die.visible = true
		## show new dice // enable etc if needed
		#green_smoke.play("eight_reveal")		
		return

func update_hearts():
	var hearts = hearts_container.get_children()
	for heart in range(hearts.size()):
		if heart + 1 <= dice_health:
			hearts[heart].visible = true

func take_damage(damage: int):
	# don't start if already taking damage
	if is_taking_damage:
		return
	# add/minus damage and put in damage state
	is_taking_damage = true
	if GameState.dice_level == 2 and dice_health - damage < dice_transform_threshold:
		print('transform down')
		GameState.dice_level = 1
		green_smoke.play_backwards("eight_reveal")
		await green_smoke.animation_finished
		# hide old die // disable if needed (collision etc)
		dice_sprite.visible = true
		mob_die.visible = false
		# show new dice // enable etc if needed
		green_smoke.play("eight_reveal")	
	if GameState.dice_level == 1 and  dice_health - damage > dice_transform_threshold:
		print('evolve dice')
		GameState.dice_level = 2
		green_smoke.play_backwards("eight_reveal")
		await green_smoke.animation_finished
		# hide old die // disable if needed (collision etc)
		dice_sprite.visible = false
		mob_die.visible = true
		# show new dice // enable etc if needed
		green_smoke.play("eight_reveal")	
	dice_health -= damage
	# Play damage animation
	health_display.show_number(damage)
	if damage > 0:
		animated_sprite.play("Hit")
	else:
		animated_sprite.play('green')
	
	# Create a tween for the rumble effect
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Define rumble parameters
	var rumble_duration = 0.6
	var rumble_intensity = 15.0
	var rotation_intensity = 0.1
	var num_shakes = 6
	
	# Add position and rotation shakes that diminish over time
	for i in range(num_shakes):
		var progress = float(i) / num_shakes
		var shake_duration = rumble_duration / num_shakes
		var current_intensity = rumble_intensity * (1.0 - progress)
		var current_rotation = rotation_intensity * (1.0 - progress)
		
		# Random position offset
		var offset = Vector2(
			randf_range(-current_intensity, current_intensity),
			randf_range(-current_intensity, current_intensity)
		)
		tween.tween_property(animated_sprite, "position", 
			initial_position + offset, shake_duration)
			
		# Random rotation
		var rot_offset = randf_range(-current_rotation, current_rotation)
		tween.tween_property(animated_sprite, "rotation", 
			initial_rotation + rot_offset, shake_duration)
	
	# Final reset to ensure no drift
	tween.chain().tween_property(animated_sprite, "position", initial_position, 0.1)
	tween.tween_property(animated_sprite, "rotation", initial_rotation, 0.1)
	
	# When done, reset state and play default animation
	tween.finished.connect(func():
		is_taking_damage = false
		animated_sprite.play("default")
		reset_die_position())

func spawn_card():
	var card_manager = get_parent()
	var player_hand: PlayerHand = owner.find_child("PlayerHand")
	var deck_coords = self.global_position
	var new_card = card_scene.instantiate()
	new_card.add_to_group("playing_cards")
	new_card.global_position = deck_coords
	card_manager.add_child(new_card)
	player_hand.add_card_to_hand(new_card, 0)
	player_hand.update_hand_positions()
