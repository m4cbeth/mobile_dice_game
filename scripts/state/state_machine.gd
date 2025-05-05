extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}
var entity: CharacterBody2D

func _ready():
	await  owner.ready
	entity = get_parent()
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

func transition_to(state_name: String, msg: Dictionary = {}):
	if current_state and current_state.name == state_name:
		return	
	if not states.has(state_name):
		return
	
	if current_state:
		current_state.exit()
	
	current_state = states[state_name]
	current_state.enter(msg)
