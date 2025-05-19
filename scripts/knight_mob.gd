extends CharacterBody2D
class_name Mob

@onready var state_machine: StateMachine = find_child("StateMachine")

var health = 10.0
var fake_floor := 800
var is_falling := false
var shitlist := [] # a list of people who've harmed me
var damage := 1
const mob_type = Groups.knights

func take_damage(attacker = null, dmg := 1) -> void:
	if not shitlist.has(attacker):
		shitlist.append(attacker)
	health -= dmg
	if health <= 0:
		state_machine.transition_to("Death")
		return
	else:
		state_machine.transition_to("TakeDamage", {"attacker" = attacker, "damage" = dmg})
