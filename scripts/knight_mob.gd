extends CharacterBody2D
class_name Mob

var health = 8
var fake_floor := 730
var is_falling := false
const mob_type = Groups.knights
@onready var state_machine = find_child("StateMachine")

# attack logic variables and constants
@onready var sprite = $AnimatedSprite2D
@onready var attack_area := $DangerZone
enum State { IDLE, ATTACK, WALK }
var state = State.IDLE
var attack_cooldown := 0.5
var can_attack := true
var attack_target := []

func _ready() -> void:
	sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	attack_area.connect("body_entered", Callable(self, "_on_attack_area_body_entered"))

func _process(delta) -> void:
	if state == State.IDLE and can_attack:
		attack()

func _on_attack_area_body_entered():
	pass

func attack():
	can_attack = false
	sprite.play("attack")

func _on_animation_finished(): #shouldn't maybe this happen on frame 3? (i.e. the fourth frame?)
	if sprite.animation == "attack":
		do_damage()
		await get_tree().create_timer(attack_cooldown).timeout
		state_machine.transition_to("Walk")
		can_attack = true
		sprite.play("idle")

func do_damage():
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("bad_guys"):
			body.take_damage()
