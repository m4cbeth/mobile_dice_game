extends CharacterBody2D

const SPEED = 12
var dir = Vector2.LEFT

func _ready():
	pass
	
func _process(delta: float) -> void:
	move(delta)

func move(delta):
	velocity = dir * SPEED
	move_and_slide()
