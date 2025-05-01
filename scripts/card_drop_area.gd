extends Node2D


@onready var mob_scene = preload("res://scenes/Mob.tscn")


# INVOKE button (left side invisible area button)
func _on_button_button_down() -> void:
	for area in $Area2D.get_overlapping_areas():
		var card = area.get_parent()
		var card_back
		var knight
		
		for child in card.get_children():
			match child.name:
				"CardBackground":
					card_back = child
				"Knight":
					knight = child
		if card_back:
			destroy_card(card)
		



func destroy_card(card):
	var destruction_animation: AnimatedSprite2D
	var burning_animation: AnimatedSprite2D
	var card_back: Node
	var sprite: CharacterBody2D
	var fire_sound: AudioStreamPlayer
	
	for child in card.get_children():
			match child.name:
				"Destruction":
					destruction_animation = child
				"Burning":
					burning_animation = child
				"CardBackground":
					card_back = child
				"FireWhoosh":
					fire_sound = child
				"Area2D":
					child.queue_free()
				"CardBody":
					child.queue_free()
				"Knight":
					sprite = child
	destruction_animation.play()
	fire_sound.play()
	await get_tree().create_timer(0.5).timeout
	burning_animation.play()
	destruction_animation.animation_finished.connect(func(): card_back.queue_free())
	summon_sprite(sprite)


func summon_sprite(knight: CharacterBody2D):
	knight.add_to_group("knights")
	knight.is_falling = true
	knight.get_node("StateMachine").transition_to("Walk")
	"""
	add to group
	state is already walking (is that true?)
	sprite.falling = true
	
	"""
