extends Node2D


@onready var mob_scene = preload("res://scenes/Mob.tscn")


# INVOKE button (left side invisible area button)
func _on_button_button_down() -> void:
	for area in $Area2D.get_overlapping_areas():
		var card = area.get_parent()
		var card_back
		
		for child in card.get_children():
			match child.name:
				"CardBackground":
					card_back = child
		if card_back:
			destroy_card(card)
		


func summon_sprite(node):
	"""
	add to group
	state is already walking (is that true?)
	sprite.falling = true
	
	"""



func destroy_card(card):
	var destruction_animation
	var burning_animation
	var card_back
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
	destruction_animation.play()
	fire_sound.play()
	await get_tree().create_timer(0.5).timeout
	burning_animation.play()
	destruction_animation.animation_finished.connect(func(): card_back.queue_free())
	
	#func after_desctruction():
		# card_back.queue_free()
		# card var falling
		# card state walking
