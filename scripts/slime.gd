extends CharacterBody2D
var fake_floor := 295
var is_falling: bool
#
#const SPEED = 120
#const dir = Vector2.LEFT
#const target = Vector2(-486, 60)
#
#var is_falling = true
#var fall_velocity = 0.0
#const GRAVITY = 980
#var fake_floor
 #
#func _ready() -> void:
	#pass
#
#var is_avoiding: bool
#var avoid_timer: float
#var avoid_dir: Vector2
#const avoid_delay = 2
#
#func _physics_process(delta: float) -> void:
	#walk(delta)
#
#func walk(delta):
	#return
	#@warning_ignore("unreachable_code")
	#if is_avoiding:
		#velocity = avoid_dir
		#move_and_collide(velocity * delta)
		#return
	#else:
		#var dir_vect = (target - global_position).normalized()
		#velocity = dir_vect * SPEED
		#var collision = move_and_collide(velocity * delta)
			#
		#if collision:
			#if collision.get_collider().name == "Slime":
				#velocity = Vector2.RIGHT # if randf() > 0.5 else Vector2.DOWN
				#is_avoiding = true
			#else:
				#velocity = Vector2.ZERO
#
##func handleCollision():
	##for i in get_slide_collision_count():
		##var collision = get_slide_collision(i)
		##var collider = collision.get_collider()
