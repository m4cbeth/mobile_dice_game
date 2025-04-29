extends State
class_name Walk

var direction: Vector2
var avoiding: bool
var avoid_timer: float
var avoid_duration: float
const CASTLE = Vector2(0, 200)

const SPEED = 120
const dir = Vector2.LEFT
const target = Vector2(-486, 60)

var is_falling = true
var fall_velocity = 0.0
const GRAVITY = 980
var fake_floor

@export var entity: CharacterBody2D
@export var speed := 12.0 # disagree, get based on type (knights faster than slimes)


func Enter():
	entity = get_parent().get_parent() #fix this!
	# target = castle if enity is badguy else get_target()

func Physics_Update(delta):
	var direction = 0 # get_target()
	"""
	if
	"""

#func Update():
	pass
	"""
	if avoiding keep avoiding
	if colliding avoid
	"""

func get_target():
	if null:
		return

"""
Walk
aim at target, walk
if collision
	stop
	match collision
	if sameguy
		go up/down randi() % 2 == 0
		for two seconds
	if guy is bad 
		send damage(guy, amount I damage)
	
"""
