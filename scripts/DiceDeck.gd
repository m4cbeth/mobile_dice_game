extends Node2D

@onready var card_scene = preload("res://scenes/card.tscn")
@onready var wolf_mob_scene = preload("res://scenes/wolf_mob.tscn")
@onready var mob_die = $RedDie # RedDie.play_her("won") ("ready player one") ("RedDee" maybe?)
@onready var health_display = $HealthNumber
@onready var green_smoke: AnimatedSprite2D = $GreenSmoke
@onready var hearts_container: HBoxContainer = owner.find_child("HeartContainer")
@onready var player_hand: PlayerHand = owner.find_child("PlayerHand")

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
var blue_die: AnimatedSprite2D
var current_die: AnimatedSprite2D

func _ready():
	randomize()
	update_hearts()
	blue_die = $BlueDie
	initial_position = $BlueDie.position
	initial_rotation = $BlueDie.rotation
	current_die = blue_die

func reset_die_position():
	blue_die.position = initial_position
	blue_die.rotation = initial_rotation

func start_roll():
	if rolling:
		return
	rolling = true
	blue_die.stop()
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
	var final_result = randi_range(0, 5)
	frames_to_show.append({
		"time": roll_duration,
		"frame": final_result
	})
	# Schedule all frame changes
	for frame_data in frames_to_show:
		tween.tween_callback(func(): blue_die.frame = frame_data["frame"]).set_delay(frame_data["time"])
	# End rolling state when complete
	tween.tween_callback(func(): rolling = false).set_delay(roll_duration)
	# Update current_frame to match the final result
	tween.tween_callback(func(): current_frame = final_result).set_delay(roll_duration)
	
	tween.tween_callback(func(): handle_deal(final_result)).set_delay(roll_duration)
	
	tween.tween_callback(visual_feedback)

func handle_deal(result_number: int):
	# incoming numb is die face array num i.e. 0-5
	if GameState.dice_level == 1:
		#result_number is just number of cards
		deal_cards(result_number + 1)
	elif GameState.dice_level > 1:
		var test = 5
		match result_number:
			0, 2, 4:
				deal_cards(1)
			1:
				deal_cards(99)
			3:
				deal_cards(2)
			5:
				var current_card_count = player_hand.player_hand.size()
				if current_card_count > 0:
					current_card_count = player_hand.player_hand.size()
					var pick_a_spot = randi_range(0, current_card_count - 1)
					var to_destroy = player_hand.player_hand[pick_a_spot]
					print("todestroy: ", to_destroy)
					player_hand.destroy_a_card(to_destroy)
					blue_die.play()

func visual_feedback():
	var original_scale = blue_die.scale
	var scale_up = original_scale * 1.75
	var animation_time := 0.93
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(blue_die, "scale", scale_up, animation_time)
	tween.tween_property(blue_die, "scale", original_scale, animation_time)

func deal_cards(number_of_cards: int) -> void:
	if number_of_cards == 99:
		spawn_card(Groups.wolves)
		return
	var counter = number_of_cards
	while counter > 0:
		counter -= 1
		spawn_card()
		await get_tree().create_timer(.1).timeout
		print(counter)
		if counter == 0:
			blue_die.play()

func _on_button_button_down() -> void:
	start_roll()

func hit_by_slime(slime_hit_by: CharacterBody2D):
	take_damage(-1)
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
	for heart in range(hearts.size()-1):
		hearts[heart].visible = heart + 1 <= dice_health

func take_damage(damage: int):
	# don't start if already taking damage
	if is_taking_damage:
		return
	# add/minus damage and put in damage state
	is_taking_damage = true
	dice_health -= damage
	player_hand.hand_max -= damage
	# Play damage animation
	health_display.show_number(damage)
	if damage > 0:
		blue_die.play("Hit")
	else:
		blue_die.play('green')
	# EVOLVE
	if GameState.dice_level == 1 and  dice_health - damage > dice_transform_threshold:
		current_die = mob_die
		GameState.dice_level = 2
		green_smoke.play_backwards("eight_reveal")
		await green_smoke.animation_finished
		blue_die.stop()
		blue_die.play("mob_die")
		# THIS HACK WORKS; BUT SPRITE NEEDS TO BE REEXPORTED (I.E. MOB_DIE) FROM PHOTOSHOP AT RIGHT SIZE
		blue_die.scale = Vector2(.5, .5)
		green_smoke.play("eight_reveal")
	# DEVOLVE
	if GameState.dice_level == 2 and dice_health - damage < dice_transform_threshold:
		GameState.dice_level = 1
		green_smoke.play_backwards("eight_reveal")
		await green_smoke.animation_finished
		blue_die.scale = Vector2(1, 1)
		blue_die.play("default")
		green_smoke.play("eight_reveal")
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
		tween.tween_property(blue_die, "position", 
			initial_position + offset, shake_duration)
			
		# Random rotation
		var rot_offset = randf_range(-current_rotation, current_rotation)
		tween.tween_property(blue_die, "rotation", 
			initial_rotation + rot_offset, shake_duration)
	# Final reset to ensure no drift
	tween.chain().tween_property(blue_die, "position", initial_position, 0.1)
	tween.tween_property(blue_die, "rotation", initial_rotation, 0.1)
	# When done, reset state and play default animation
	tween.finished.connect(func():
		is_taking_damage = false
		if GameState.dice_level > 1:
			blue_die.play("mob_die")
		else:
			blue_die.play("default")
		reset_die_position())
	
	update_hearts()

func spawn_card(mob_type: String = Groups.knights):
	var card_manager = get_parent()
	var player_hand: PlayerHand = owner.find_child("PlayerHand")
	var deck_coords = self.global_position
	var new_card: PlayingCard = card_scene.instantiate()
	if mob_type == Groups.wolves:
	# remove knight from card
		var knightmob = new_card.find_child("Knight")
		knightmob.queue_free()
	# add wolf mob to card
		var new_wolf = wolf_mob_scene.instantiate()
		new_card.add_child(new_wolf)
		new_card.cards_mob_type = Groups.wolves
	new_card.add_to_group("playing_cards")
	new_card.global_position = deck_coords
	card_manager.add_child(new_card)
	player_hand.add_card_to_hand(new_card, 0)
	player_hand.update_hand_positions()
