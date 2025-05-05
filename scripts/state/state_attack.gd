extends State
class_name Attack

@onready var sprite = owner.get_node("AnimatedSprite2D")
@onready var attack_area = owner.get_node("DangerZone")

var attack_timer := 0.0
@export var attack_cooldown := 0.5
@export var can_attack := true
@export var attack_target := []

func enter(msg: Dictionary = {}) -> void:
	pass

func exit():
	pass

func update(delta):
	pass

func physics_update(delta):
	pass

#helper function so can call trans in state
func transition_to(state_name: String, msg: Dictionary = {}) -> void:
	state_machine.transition_to(state_name, msg)

#func do_damage():
	#for body in attack_area.get_overlapping_bodies():
		#if body.is_in_group("bad_guys"):
			#body.take_damage()
