extends CharacterBody2D

const SPEED = 12
const dir = Vector2.LEFT
const target = Vector2(-486, 60)

var is_falling = true
var fall_velocity = 0.0
const GRAVITY = 980
var fake_floor
 
func _ready() -> void:
	var fall_distance = 50
	fake_floor = global_position.y
	global_position.y -= 50

# sprite will be spawn in between some range of y, such that... yes it will fall the same amount

func _process(delta: float) -> void:
	if is_falling:
		fall_velocity += GRAVITY * delta
		global_position.y += fall_velocity * delta
		if global_position.y > fake_floor:
			is_falling = false
	else:
		var dir_vect = (target - global_position).normalized()
		velocity = dir_vect * SPEED
		move_and_slide()
