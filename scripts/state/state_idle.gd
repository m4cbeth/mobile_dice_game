extends State
class_name Idle

@onready var sprite: AnimatedSprite2D = owner.get_node("AnimatedSprite2D")

func enter(_msg: Dictionary = {}) -> void:
	sprite.flip_h = false
	sprite.play("Idle")

func exit():
	sprite.stop()

func update(_delta):
	if entity.is_in_group(Groups.good_guys) and entity.is_off_card:
		var bad_guy_count: Array = get_tree().get_nodes_in_group(Groups.bad_guys)
		if bad_guy_count.size() > 0:
			transition_to("Walk")

func physics_update(_delta):
	pass
