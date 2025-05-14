extends State
class_name Death

@onready var sprite: AnimatedSprite2D = owner.get_node("AnimatedSprite2D")

func enter(_msg: Dictionary = {}) -> void:
	entity.remove_from_group(Groups.bad_guys) # stops targeting immediately instead of after queue_free
	sprite.stop()
	sprite.play("Death")
	#sprite.animation_finished.connect(func(): entity.queue_free(), CONNECT_ONE_SHOT)

func exit():
	pass

func update(_delta):
	print("Sprite: ",sprite)
	print("death has n frames: n=", sprite.sprite_frames.get_frame_count("Death"))
	print(sprite.frame, " is spiteframe.")
	if sprite and sprite.frame >= sprite.sprite_frames.get_frame_count("Death") - 1 :
		entity.queue_free()
