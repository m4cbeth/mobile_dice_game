extends State
class_name TakeDamage

@onready var sprite: AnimatedSprite2D = owner.get_node("AnimatedSprite2D")
 
var attacker = null
var damage_amount := 0.0
var knockback_direction := Vector2.ZERO
var knockback_strength := 750.0
var damage_in_progress := false
var knockback_timer := 0.0
var knockback_duration := 0.3  # Duration of knockback effect in seconds

func enter(msg: Dictionary = {}) -> void:
	#print('Entered TakeDamage state')
	# Reset state variables
	damage_in_progress = true
	knockback_timer = 0.0
	# Get damage info from message
	if msg.has("damage"):
		damage_amount = msg.damage
	# Set knockback direction based on attacker or facing direction
	if msg.has("attacker") and msg.attacker != null:
		attacker = msg.attacker
		knockback_direction = (entity.global_position - attacker.global_position).normalized()
	else:
		# Fallback direction based on sprite facing
		knockback_direction = Vector2(-1 if sprite.flip_h else 1, 0)
	# Connect animation finished signal
	if !sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	# Apply initial knockback
	apply_knockback()
	
	# Play damage animation and take health
	if sprite:
		#print("Playing Hit animation")
		sprite.play("Hit")
		entity.health -= damage_amount

func exit() -> void:
	#print("Exiting TakeDamage state")
	
	# Clean up signal connection
	if sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.disconnect(_on_animation_finished)
	
	damage_in_progress = false

func update(delta: float) -> void:
	# Track knockback duration
	knockback_timer += delta
	
	# Debug animation state
	#if sprite:
		#if int(knockback_timer * 10) % 10 == 0:  # Print roughly every 1 second
			#print("Current animation: ", sprite.animation, " Frame: ", sprite.frame)
	
	# Transition to Walk if animation finished but signal didn't fire
	if knockback_timer > 1.0 and damage_in_progress:
		#print("Fallback transition - animation may have completed without signal")
		damage_in_progress = false
		transition_to("Walk")

func physics_update(delta: float) -> void:
	# Gradually slow down knockback
	entity.velocity *= 0.9
	
	# Use move_and_slide for movement
	var collision = entity.move_and_slide()
	
	# Debug collision info
	#if collision:
		#print("Collision during knockback")

func apply_knockback() -> void:
	#print("Applying knockback: ", knockback_direction * knockback_strength)
	entity.velocity = knockback_direction * knockback_strength

# Fixed function name - was "*on*animation_finished"
func _on_animation_finished() -> void:
	#print("Animation finished signal received!")
	damage_in_progress = false
	transition_to("Walk")

# Helper function for state transition  
#func transition_to(state_name: String, msg: Dictionary = {}) -> void:
	#print("Transitioning from TakeDamage to ", state_name)
	#state_machine.transition_to(state_name, msg)
