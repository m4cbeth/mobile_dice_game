extends Node2D

const slime_scene = preload("res://scenes/slime.tscn")

var num_of_slime: int

func spawn_slime():
	num_of_slime += 1
	if num_of_slime > 5: return
	var new_slime = slime_scene.instantiate()
	self.add_child(new_slime)
	$Timer.wait_time += 0.01 * num_of_slime
	
	
# TIMER NODE attached to Enemines node
func _on_timer_timeout() -> void:
	spawn_slime()
	pass # Replace with function body.
	
	
	
