extends CharacterBody2D
class_name Mob

var health = 8
var fake_floor := 300
var is_falling: bool
@onready var state_machine = find_child("StateMachine")



func _ready():
	#print(state_machine)
	pass

func _process(delta: float) -> void:
	#print(self.is_in_group(Groups.knights))
	var indexofcard = get_parent().get_parent().get_children().find(get_parent())
	if !self.is_in_group(Groups.knights):
		pass
		#print("card at index ", indexofcard, " is not a knight")
