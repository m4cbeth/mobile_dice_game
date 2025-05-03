extends Node2D

const slime_scene = preload("res://scenes/slime.tscn")

var num_of_slime = 0
const TOP_OF_FIELD = 730
const BOT_OF_FIELD = 1030
const ENEMEY_X_DROP_LEFT = 1440
const ENEMEY_X_DROP_RIGHT = 1890
const DROP_HEIGHT = 300
const MAX_SLIMES = 5

func spawn_slime():
	num_of_slime += 1
	if num_of_slime > MAX_SLIMES: return
	var new_slime = slime_scene.instantiate()
	new_slime.add_to_group(Groups.slimes)
	new_slime.add_to_group(Groups.bad_guys)
	var EnterAnimation = new_slime.get_child(1)
	EnterAnimation.play()
	new_slime.fake_floor = randi_range(TOP_OF_FIELD, BOT_OF_FIELD)
	new_slime.is_falling = true
	var enemey_x = randi_range(ENEMEY_X_DROP_LEFT, ENEMEY_X_DROP_RIGHT)
	new_slime.position = Vector2(enemey_x, new_slime.fake_floor - DROP_HEIGHT)
	self.add_child(new_slime)
	
	if $Timer.wait_time > 1:
		$Timer.wait_time -= 0.001 * num_of_slime

# TIMER NODE attached to Enemines node
func _on_timer_timeout() -> void:
	if num_of_slime < MAX_SLIMES:
		spawn_slime()
	
	
