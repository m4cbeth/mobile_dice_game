extends Node2D

@onready var dice_sprite = $BlueDie
var rolling := false
var tween: Tween
var faces := 6
var current_frame := 0
var dice_health := 10.0
var is_taking_damage := false


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
	animated_sprite = $BlueDie
	initial_position = $BlueDie.position
	initial_rotation = $BlueDie.rotation

func reset_die_position():
	animated_sprite.position = initial_position
	animated_sprite.rotation = initial_rotation
	
func _process(delta: float) -> void:
	pass
	
func start_rumble():
	is_rumbling = true
	rumble_time_left = rumble_duration
	initial_position = animated_sprite.position
	initial_rotation = animated_sprite.rotation
	animated_sprite.play('Hit')
			
func start_roll():
	if not rolling:
		roll_dice()

func roll_dice():
	if rolling:
		return
	rolling = true
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


func _on_button_button_down() -> void:
	start_roll()

func is_clicked(e):
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		return true
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if is_clicked(event):
		start_roll()

func take_damage(amount: int):
	# Don't start a new damage sequence if already taking damage
	if is_taking_damage:
		return
	
	print('taking damage on dice')
	
	is_taking_damage = true
	dice_health -= amount
	# Play damage animation
	animated_sprite.play("Hit")
	
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
	
