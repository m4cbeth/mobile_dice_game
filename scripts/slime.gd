extends CharacterBody2D


@onready var sprite: AnimatedSprite2D = find_child("AnimatedSprite2D")
@onready var state_machine: StateMachine = find_child("StateMachine")

var fake_floor
var health = 2.0
var is_falling: bool
const mob_type = Groups.slimes
var shitlist := [] # a list of people who've harmed me
var damage := 1

func take_damage(attacker = null, dmg := 1) -> void:
	if not shitlist.has(attacker):
		shitlist.append(attacker)
	if health <= 0:
		state_machine.transition_to("Death")
		return
	else:
		state_machine.transition_to("TakeDamage", {"attacker" = attacker, "damage" = dmg})
