extends CharacterBody2D
class_name Mob

var health = 8
var fake_floor := 730
var is_falling := false
const mob_type = Groups.knights
@onready var state_machine = find_child("StateMachine")

var attack_cooldown := 0.5
var can_attack := true
var attack_target := []


func take_damage():
	"""
	state transition to States.TakeDamage(entity, parameters)
	parameters...
	wait... who switches to takedamage?
	ok, so take damage is a function that takes the target (e.g. slime) and
	transis THAT to TakeDamage state, with parameters of the attacker and damage amount
	(because eventually the slimes will track who has attacked them, not to mention this might be
	important for calulating knockback direction later)
	"""
