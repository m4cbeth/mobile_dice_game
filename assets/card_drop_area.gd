extends Node2D

@onready var enemies_node: Node2D = $"../Enemies"
@onready var glyph_drop_circle: Area2D = $"Area2D"

# INVOKE button
func _on_button_button_down() -> void:
	#if $Area2D.get_overlapping_areas().size() == 0:
	enemies_node.spawn_slime()
	
	print(glyph_drop_circle.get_overlapping_areas())
	for area in glyph_drop_circle.get_overlapping_areas():
		enemies_node.spawn_slime()
		var card = area.get_parent()
		var card_back
		for child in card.get_children():
			match child.name:
				"CardBackground":
					card_back = child
		if card_back:
			destroy_card(card)

func destroy_card(card):
	var destruction_animation: AnimatedSprite2D
	var burning_animation: AnimatedSprite2D
	var card_back: Node
	var sprite: CharacterBody2D
	var fire_sound: AudioStreamPlayer
	var card_children = card.get_children()
	
	for child in card_children:
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
	knight.add_to_group(Groups.knights)
	knight.add_to_group(Groups.good_guys)
	knight.is_falling = true
	knight.find_child("StateMachine").transition_to("Walk")
