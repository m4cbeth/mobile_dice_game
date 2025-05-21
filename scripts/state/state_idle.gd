extends State
class_name Idle

@onready var sprite: AnimatedSprite2D = owner.get_node("AnimatedSprite2D")

func enter(_msg: Dictionary = {}) -> void:
	sprite.flip_h = false
	sprite.play("Idle")
func exit():
	sprite.stop()
func update(_delta):
	pass
func physics_update(_delta):
	pass
