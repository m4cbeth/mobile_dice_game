extends Node2D

const slime_scene = preload("res://scenes/slime.tscn")

var num_of_slime: int
const TOP_OF_FIELD = 263
const BOT_OF_FIELD = 324
const ENEMEY_X_DROP_LEFT = 490
const ENEMEY_X_DROP_RIGHT = 585
const DROP_HEIGHT = 150

func spawn_slime():
	num_of_slime += 1
	if num_of_slime > 5: return
	var new_slime = slime_scene.instantiate()
	new_slime.fake_floor = randi_range(TOP_OF_FIELD, BOT_OF_FIELD)
	var enemey_x = randi_range(ENEMEY_X_DROP_LEFT, ENEMEY_X_DROP_RIGHT)
	new_slime.position = Vector2(enemey_x, DROP_HEIGHT)
	self.add_child(new_slime)
	
	$Timer.wait_time -= 0.01 * num_of_slime
	
	
# TIMER NODE attached to Enemines node
func _on_timer_timeout() -> void:
	spawn_slime()
	
	
