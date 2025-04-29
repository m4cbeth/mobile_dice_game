extends State
class_name Walk

var direction: Vector2
var target
var avoiding: bool
var avoid_timer: float
var avoid_duration: float
const DICE_COORDS = Vector2(41, 303)

const SPEED = 120

var is_falling = true
var fall_velocity = 0.0
const GRAVITY = 980

var fake_floor: int
@export var speed := 12.0 # disagree, get based on type (knights faster than slimes)


func enter():
	#print(entity.global_position)
	pass

func update(delta):
	"""
	if avoiding keep avoiding, remove delta from timer
	"""
func physics_update(delta):
	if is_falling:
		entity.velocity.x = 0 # do I need this line?
		fall_velocity += GRAVITY * delta
		entity.global_position.y += fall_velocity * delta
		print(entity)
		print(entity.fake_floor)
		print(entity.position.y)
		if entity.fake_floor:
			if entity.global_position.y > entity.fake_floor:
				is_falling = false
	else:
		# get target
		target = get_target()
		# get direction
		 #get_sprite().flip_h = velocity.x < 0
		# move and collide




func get_target():
	if entity.is_in_group("slimes"):
		return DICE_COORDS
	if entity.is_in_group("knights"):
		var slimes = get_tree().get_nodes_in_group("slimes")
		if slimes.size() > 0:
			return find_closest(slimes)
	return null

func find_closest(nodes: Array[Node2D]) -> Node2D:
	var closest_distance = INF
	var closest_node = null
	for node in nodes:
		var distance = entity.global_position.distance_to(node.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_node = node
	return closest_node

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
func exit():
	pass
