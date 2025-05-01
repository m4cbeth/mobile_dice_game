extends CharacterBody2D
var health = 8
var fake_floor := 300
var is_falling: bool
@onready var state_machine = find_child("StateMachine")



func _ready():
	#print(state_machine)
	pass
