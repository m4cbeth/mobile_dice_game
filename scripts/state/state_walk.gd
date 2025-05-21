extends State
class_name Walk

@onready var sprite: AnimatedSprite2D = owner.get_node("AnimatedSprite2D")
@onready var attack_area: Area2D = owner.get_node("DangerZone")
@onready var nav_agent: NavigationAgent2D = owner.get_node("NavigationAgent2D")

@onready var castle_coords := Vector2(199, 907)
var target_coords: Vector2
var direction: Vector2
var avoiding: bool
var avoid_timer := 1.0
var avoid_duration: float
const DICE_COORDS = Vector2(41, 303)
var dice_coords := DICE_COORDS
var speed_modifier: float
const base_speed = 2
const speed_modifiers = {
	Groups.slimes: 1 * base_speed,
	"knights": 2 * base_speed,
	"whateversnext": 2 * base_speed
}
var velocity
var fall_velocity = 0.0
const GRAVITY = 980 #* .7
const MAX_HEIGHT_MIN_Y = 745
var fake_floor: int

func enter(_msg: Dictionary = {}) -> void:
	speed_modifier = speed_modifiers["knights"] if get_parent().is_in_group(Groups.slimes) else speed_modifiers[Groups.slimes]
	if sprite:
		sprite.play("Walk")
	nav_agent.velocity_computed.connect(_on_velocity_computed)

func exit():
	nav_agent.velocity_computed.disconnect(_on_velocity_computed)

func physics_update(delta):
	if entity.is_falling:
		fall_velocity += GRAVITY * delta
		entity.global_position.y += fall_velocity * delta
		if entity.fake_floor:
			if entity.global_position.y > entity.fake_floor:
				if entity.find_child("LandSound"): 
					entity.find_child("LandSound").play()
				entity.is_falling = false
	else:
		var target = get_target()
		if entity and target:
			if entity == target:
				target_coords = castle_coords
			else:
				target_coords = target.global_position
			if target_coords.y <  MAX_HEIGHT_MIN_Y: # DIDN'T SEE I STILL HAVE THIS
				target_coords.y = MAX_HEIGHT_MIN_Y # are these lines the thing keeping pathfinding inbound?
			nav_agent.target_position = target_coords
			direction = (nav_agent.get_next_path_position() - entity.global_position).normalized()
			velocity = direction * speed_modifier
			entity.velocity = velocity
			nav_agent.set_velocity_forced(velocity)
			flip_body(entity)
			if velocity and sprite.animation != "Walk":
				sprite.play("Walk")
			var distance_to_target = entity.global_position.distance_to(target_coords)
			var is_in_y_range = abs(entity.global_position.y - target_coords.y) < 50
			var is_in_strike_range = distance_to_target < 110
			"""
			THE BELOW IF:
				add if attack_area.overlapping_areas has bad guys for good guys (or vice versa)
			"""
			if is_in_strike_range and is_in_y_range and sprite.animation != "Attack":
				transition_to("Attack", {target = target_coords})
			if target == entity and is_in_strike_range and sprite.animation != "Idle":
				transition_to("Idle")
			var collision = entity.move_and_collide(direction * speed_modifier)


func _on_velocity_computed(safe_velocity: Vector2):
	entity.velocity = safe_velocity
	entity.move_and_slide()

func get_target_coords():
	if entity.is_in_group("slimes"):
		return get_dice_coords()
	if entity.is_in_group("knights"):
		var bad_guys = get_bad_guys()
		if bad_guys.size() > 0:
			var closest_guy = find_closest(bad_guys)
			var base_position = closest_guy.position
			var x_shift
			var y_shift = 40
			var shift_amount = 50
			if entity.global_position.x > target_coords.x:
				x_shift = 1 * shift_amount
			else:
				x_shift = -1 * shift_amount
			#x_shift
			return Vector2(base_position.x + x_shift, base_position.y + y_shift)
	if GameState.dice_level > 1:
		return get_dice_coords()
	else:
		return castle_coords

func get_target():
	if entity.is_in_group("slimes"):
		return get_dicedeck_ref()
	if entity.is_in_group("knights"):
		var bad_guys = get_bad_guys()
		if bad_guys.size() > 0:
			var closest_guy = find_closest(bad_guys)
			return closest_guy
		elif GameState.dice_level > 1:
			return get_dicedeck_ref()
		else:
			return entity

func get_dicedeck_ref():
	return get_tree().root.get_node("CardGame").find_child("DiceDeck")
func get_dice_coords():
	return get_tree().root.get_node("CardGame").find_child("DiceDeck").global_position

func get_bad_guys():
	return get_tree().get_nodes_in_group(Groups.bad_guys)

func find_closest(nodes: Array):
	var closest_distance = INF
	var closest_node = null
	for node in nodes:
		var distance = entity.global_position.distance_to(node.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_node = node
	return closest_node

func flip_body(mob: CharacterBody2D):
	if mob.is_in_group(Groups.good_guys):
		attack_area.scale.x = sign(mob.velocity.x)
		mob.find_child('CollisionPolygon2D').scale.x = sign(mob.velocity.x)
		if mob.velocity.x < 0:
			mob.find_child("AnimatedSprite2D").flip_h = true
		else:
			mob.find_child("AnimatedSprite2D").flip_h = false
	else:
		attack_area.scale.x = sign(mob.velocity.x) * -1 #enemies are opposite
		mob.find_child('CollisionPolygon2D').scale.x = sign(mob.velocity.x) * -1
		if mob.velocity.x > 0:
			mob.find_child("AnimatedSprite2D").flip_h = true
		else:
			mob.find_child("AnimatedSprite2D").flip_h = false
