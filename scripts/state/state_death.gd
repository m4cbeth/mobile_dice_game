extends State
class_name Death

@onready var sprite: AnimatedSprite2D = owner.get_node("AnimatedSprite2D")

func enter(_msg: Dictionary = {}) -> void:
	entity.remove_from_group(Groups.bad_guys) # stops targeting immediately instead of after queue_free
	sprite.stop()
	sprite.play("Death")

func exit():
	pass

func update(_delta):
	if sprite and sprite.frame >= sprite.sprite_frames.get_frame_count("Death") - 1 :
		entity.queue_free()
