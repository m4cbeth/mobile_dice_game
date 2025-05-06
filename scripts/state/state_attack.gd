extends State
class_name Attack

@onready var sprite: AnimatedSprite2D = owner.get_node("AnimatedSprite2D")
@onready var attack_area: Area2D = owner.get_node("DangerZone")
@onready var damage : float = owner.damage
var attack_damage: int
var attack_timer := 0.0
var target
var attack_in_progress := false
@export var can_attack := true
@export var attack_cooldown := 0.5
@export var attack_target := []

func enter(msg: Dictionary = {}) -> void:
	if msg.has("target"):
		target = msg.target
	if !sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	attack_in_progress = true
	if sprite:
		sprite.play('Attack')

func exit():
	if sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.disconnect(_on_animation_finished)
	attack_in_progress = false

func _on_animation_finished():
	#for body in attack_area.get_overlapping_bodies():
		#if body.is_in_group("bad_guys"):
			#body.take_damage(entity, damage)
	if sprite.animation == "Attack":
		if attack_in_progress:
			transition_to("Walk")

func perform_attack():
	if attack_in_progress:
		return
	attack_timer = 0.0
	attack_in_progress = true
	if sprite:
		sprite.play("Attack")

func update(delta):
	if attack_in_progress and sprite.frame == 1:
		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("bad_guys"):
				body.take_damage(entity, damage)
	if not is_instance_valid(target): #or entity.global_position.distance_to(target) > 95:
		if !attack_in_progress:
			transition_to("Walk")
		return
	if !attack_in_progress:
		attack_timer += delta
		if attack_timer > attack_cooldown:
			perform_attack()
		

func physics_update(_delta):
	pass

#helper function so can call trans in state
func transition_to(state_name: String, msg: Dictionary = {}) -> void:
	state_machine.transition_to(state_name, msg)
