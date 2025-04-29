extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}
var entity: CharacterBody2D

func _ready():
	await  owner.ready
	entity = owner
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self
			child.entity = entity
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name)
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
