extends Node2D

@onready var dice_sprite = $BlueDie
var rolling := false
var tween: Tween
var faces := 6
var current_frame := 0


func _ready():
	pass # Replace with function body.

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
