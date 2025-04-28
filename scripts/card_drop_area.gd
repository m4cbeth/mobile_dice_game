extends Node2D

func p(x):
	print(x)

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
			print('Card Back found')
			destroy_card(card)
		
				

func destroy_card(card):
	var destruction_animation
	var burning_animation
	var card_back
	for child in card.get_children():
			match child.name:
				"Destruction":
					destruction_animation = child
				"Burning":
					burning_animation = child
				"CardBackground":
					card_back = child
	destruction_animation.play()
	await get_tree().create_timer(0.5).timeout
	burning_animation.play()
	print(card_back)
	destruction_animation.animation_finished.connect(func(): card_back.queue_free())
