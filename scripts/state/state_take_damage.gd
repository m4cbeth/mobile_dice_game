extends State
class_name TakeDamage

@onready var sprite: AnimatedSprite2D = owner.get_node("AnimatedSprite2D")
 
var attacker = null
var damage_amount := 0.0
var knockback_direction := Vector2.ZERO
var knockback_strength := 750
var damage_in_progress := false

func enter(msg: Dictionary = {}) -> void:
	print('entered takedamge state')
	if msg.has("damage"):
		damage_amount = msg.damage
	if msg.has("attacker") and msg.attacker != null:
		attacker = msg.attacker
		knockback_direction = (entity.global_position - attacker.global_position).normalized()
	else:
		knockback_direction = Vector2(-1 if entity.sprite.fiip_h else 1, 0)
	if !sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	if sprite and not damage_in_progress:
		damage_in_progress = true
		sprite.play('Hit')
	apply_knockback()
	pass
func exit():
	if sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.disconnect(_on_animation_finished)
	damage_in_progress = false

func update(_delta):
	pass

func physics_update(_delta):
	entity.velocity *= 0.9
	entity.move_and_slide()

func apply_knockback():
	entity.velocity = knockback_direction * knockback_strength

func _on_animation_finished():
	damage_in_progress = false
	transition_to("Walk")
