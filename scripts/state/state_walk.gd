extends State
class_name Walk

@onready var sprite: AnimatedSprite2D = owner.get_node("AnimatedSprite2D")
@onready var attack_area: Area2D = owner.get_node("DangerZone")


var target_coords: Vector2
var direction: Vector2
var avoiding: bool
var avoid_timer := 1.0
var avoid_duration: float
const DICE_COORDS = Vector2(41, 303)
var dice_coords := DICE_COORDS
var speed_modifier: float
const speed_modifiers = {
	Groups.slimes: 1.0,
	"knights": 0.5,
	"whateversnext": 2
}
var velocity
var fall_velocity = 0.0
const GRAVITY = 980 #* .7
const MAX_HEIGHT_MIN_Y = 745
var fake_floor: int

@export var speed := 12.0 # disagree w export, get based on type (knights faster than slimes)

func enter(_msg: Dictionary = {}) -> void:
	speed_modifier = 1.0 if get_parent().is_in_group(Groups.slimes) else 0.5
	if sprite:
		sprite.play("Walk")


func update(delta):
	if avoiding:
		avoid_timer -= delta
		if avoid_timer < 0:
			avoiding = false
func physics_update(delta):

	
	# Get dice coords on every frame
	dice_coords = get_dice_coords()
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
			target_coords = get_target_coords()
			if target_coords.y <  MAX_HEIGHT_MIN_Y:
				target_coords.y = MAX_HEIGHT_MIN_Y
			direction = target_coords - entity.global_position
			velocity = direction.normalized() * speed_modifier
			entity.velocity = velocity
			flip_body(entity)
			if velocity and sprite.animation != "Walk":
				sprite.play("Walk")
			var distance_to_target = entity.global_position.distance_to(target_coords)
			var is_in_y_range = abs(entity.global_position.y - target_coords.y) < 50
			var is_in_strike_range = distance_to_target < 110
			if is_in_strike_range and is_in_y_range and sprite.animation != "Attack":
				transition_to("Attack", {target = target_coords})
			var collision = entity.move_and_collide(velocity)
			if collision:
				var collider = collision.get_collider()
				if collider is not StaticBody2D:
					if collider.is_in_group(Groups.slimes):
						avoiding = true
						direction = (Vector2.UP if randi() % 2 == 0 else Vector2.DOWN)
					#else:
						#print(collision.get_collider())
	#keep below horizion
	if entity.global_position.y < MAX_HEIGHT_MIN_Y and !entity.is_falling:
		entity.global_position.y = MAX_HEIGHT_MIN_Y


func get_target_coords():
	if entity.is_in_group("slimes"):
		return get_dice_coords()
	if entity.is_in_group("knights"):
		var bad_guys = get_bad_guys()
		if bad_guys.size() > 0:
			var x_shift
			var shift_amount = 50
			if entity.global_position.x > target_coords.x:
				x_shift = 1 * shift_amount
			else:
				x_shift = -1 * shift_amount
			#x_shift
			return find_closest(bad_guys).position + Vector2(0, 40)
			# eventually we should change this to target.position.x +/- some distance,
			# depending on which side is closer...
			# this will make the target be the "front" or "back"
			# so doesn't get stuck in attack above or below while swinging at air
	return get_dice_coords()

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
	#if mob.is_in_group(Groups.knights):
		#print("target and mob x: ", target_coords.x, " ", mob.global_position.x)
		#if target_coords.x <= mob.global_position.x and mob.scale.x == 1:
			#mob.scale.x = -1
		#else:
			#mob.scale.x = 1
		#return
	#eventually, logic of "if more opposites(enemies/goodguys) are left/right"
	
	
	
	if velocity.x == 0:
		return
	if mob.is_in_group(Groups.good_guys):
		print("Target coords: ", target_coords.x)
		print("Mobs x coords: ", mob.global_position.x)
		print("Target less than: ", target_coords.x < mob.global_position.x)
		if target_coords.x < mob.global_position.x:
			mob.scale.x = -1
		else:
			mob.scale.x = 1
	else:
		if mob.velocity.x > 0:
			mob.scale.x = -4
		else:
			mob.scale.x = 4
	
	
	#if velocity.x == 0:
		#if not mob.is_in_group(Groups.good_guys):
			#return
		#if target_coords.x > mob.global_position.x:
			#mob.find_child("AnimatedSprite2D").flip_h = false
		#else:
			#mob.find_child("AnimatedSprite2D").flip_h = true
	#if mob.is_in_group(Groups.good_guys):
		#if mob.velocity.x < 0:
			#mob.find_child("AnimatedSprite2D").flip_h = true
		#else:
			#mob.find_child("AnimatedSprite2D").flip_h = false
	#else:
		#if mob.velocity.x > 0:
			#mob.find_child("AnimatedSprite2D").flip_h = true
		#else:
			#mob.find_child("AnimatedSprite2D").flip_h = false



"""
if hit, trans_to(groups.damage, damage_amount)
"""
