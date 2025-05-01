extends Node
class_name State

var entity: CharacterBody2D
var state_machine: StateMachine

func enter():
	pass
func exit():
	pass
func update(delta):
	pass
func physics_Update(delta):
	pass
func transition_to(state_name: String, params: Dictionary = {}) -> void:
	state_machine.transition_to(state_name, params)
