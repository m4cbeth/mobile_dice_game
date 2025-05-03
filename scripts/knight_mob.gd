extends CharacterBody2D
class_name Mob

var health = 8
var fake_floor := 255
var is_falling := false
const mob_type = Groups.knights
@onready var state_machine = find_child("StateMachine")
