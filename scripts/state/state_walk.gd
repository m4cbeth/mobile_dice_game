extends State
class_name Walk

#var direction: Vector2
var target_vector: Vector2
var avoiding: bool
var avoid_timer: float
var avoid_duration: float
const DICE_COORDS = Vector2(41, 303)
var dice_coords := DICE_COORDS


const SPEED = 12

var fall_velocity = 0.0
const GRAVITY = 980 * .7

var fake_floor: int
@export var speed := 12.0 # disagree, get based on type (knights faster than slimes)


func enter():
	
	pass

func update(delta):
	"""
	if avoiding keep avoiding, remove delta from timer
	"""
func physics_update(delta):
	dice_coords = get_tree().root.get_children()[0].find_child("DiceDeck").position
	print(dice_coords)
		
	if entity.is_falling:
		entity.velocity.x = 0 # do I need this line?
		fall_velocity += GRAVITY * delta
		entity.global_position.y += fall_velocity * delta
		if entity.fake_floor:
			if entity.global_position.y > entity.fake_floor:
				if entity.find_child("LandSound"): 
					entity.find_child("LandSound").play()
				entity.is_falling = false
	else:
		if entity:
			var target_coords = dice_coords
			var direction = target_coords - entity.global_position
			var dir_vect = direction.normalized()
			entity.get_child(0).flip_h = entity.velocity.x > 0 # reverse is true for protagonist sprites
			entity.move_and_collide(dir_vect)




func get_target_coords():
	if entity.is_in_group("slimes"):
		return DICE_COORDS
	if entity.is_in_group("knights"):
		var slimes = get_tree().get_nodes_in_group("slimes")
		if slimes.size() > 0:
			return find_closest(slimes).position

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
