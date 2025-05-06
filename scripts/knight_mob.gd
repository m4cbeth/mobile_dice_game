extends CharacterBody2D
class_name Mob

@onready var state_machine: StateMachine = find_child("StateMachine")
var health = 10.0
var fake_floor := 800
var is_falling := false
var shitlist := [] # a list of people who've harmed me
var damage := 1.0
const mob_type = Groups.knights

func take_damage(attacker = null, damage := 1) -> void:
	shitlist.append(attacker)
	health -= damage
	if health <= 0:
		state_machine.transition_to("Death")
		return
	else:
		state_machine.transition_to("TakeDamage", {"attacker" = attacker, "damage" = damage})
	#"""
	#state transition to States.TakeDamage(entity, parameters)
	#parameters...
	#wait... who switches to takedamage?
	#ok, so take damage is a function that takes the target (e.g. slime) and
	#transis THAT to TakeDamage state, with parameters of the attacker and damage amount
	#(because eventually the slimes will track who has attacked them, not to mention this might be
	#important for calulating knockback direction later)
	#"""
