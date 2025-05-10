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

@export var is_rumbling = false
var rumble_time_left = 0.0
var initial_position: Vector2
var initial_rotation: float
var animated_sprite: AnimatedSprite2D

func reset_die_posrot(die: AnimatedSprite2D):
	die.position = initial_position
	die.rotation = initial_rotation

func _ready():
	animated_sprite = $BlueDie
	initial_position = $BlueDie.position
	initial_rotation = $BlueDie.rotation
	
func _process(delta: float) -> void:
	if not is_taking_damage:
		reset_die_posrot($BlueDie)
	if is_rumbling:
		rumble_time_left -= delta
		if rumble_time_left <= 0:
			is_rumbling = false
			animated_sprite.position = initial_position
			animated_sprite.rotation = initial_rotation
			animated_sprite.play("default")
		else:
			animated_sprite.position = initial_position + Vector2(
				randf_range(-rumble_intensity, rumble_intensity),
				randf_range(-rumble_intensity, rumble_intensity)
			)
			animated_sprite.rotation = initial_rotation + randf_range(-rotation_intensity, rotation_intensity)
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
	#start_rumble()

func is_clicked(e):
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		return true
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if is_clicked(event):
		start_roll()

func take_damage(msg):
	if is_taking_damage:
		return
	if msg.damage:
		is_taking_damage = true
		dice_health -= msg.damage
		start_rumble()
		get_tree().create_timer(.5).timeout
		is_taking_damage = false
		
