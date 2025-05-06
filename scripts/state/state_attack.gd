extends State
class_name Attack

@onready var sprite = owner.get_node("AnimatedSprite2D")
@onready var attack_area = owner.get_node("DangerZone")
var attack_timer := 0.0
var target
var attack_damage: int
@export var attack_cooldown := 0.5
@export var can_attack := true
@export var attack_target := []

func enter(msg: Dictionary = {}) -> void:
	if msg.has("target"):
		target = msg.target
	if !sprite.animation_finished.is_connected(Callable(self, "_on_animation_finished")):
		sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	if sprite:
		sprite.play("Attack")
		print(sprite.animation)
	attack_timer = 0.0
	#perform_attack()

func exit():
	if sprite.animation_finished.is_connected(Callable(self, "_on_animation_finished")):
		sprite.disconnect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_animation_finished(anim_name):
	if anim_name == "Attack":
		transition_to("Walk")

func perform_attack():
	attack_timer = 0.0
	#if target.has_method("take_damage"): # fuck "target" should be "characterbody" not "vector"
		#target.take_damage(attack_damage)
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("bad_guys"):
			body.take_damage()
	if sprite:
		sprite.play("Attack")

func update(delta):
	if not is_instance_valid(target) or entity.global_position.distance_to(target) > 100:
		transition_to("Walk")
		return
	attack_timer += delta
	if attack_timer > attack_cooldown:
		perform_attack()

func physics_update(_delta):
	pass

#helper function so can call trans in state
func transition_to(state_name: String, msg: Dictionary = {}) -> void:
	state_machine.transition_to(state_name, msg)
