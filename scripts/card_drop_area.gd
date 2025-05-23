extends Node2D

@onready var enemies_node: Node2D = $"../Enemies"
@onready var glyph_drop_circle: Area2D = $"Area2D"

# INVOKE button
func _on_button_button_down() -> void:
	#oooo interestingthought: dice_health -= 1 && update_hearts()
	
	var over_lapping_areas = glyph_drop_circle.get_overlapping_areas()
	var cards := []
	var knights := []
	for area in over_lapping_areas:
		if area.is_in_group(Groups.good_guys):
			cards.append(area.owner)
	for card: PlayingCard in cards:
		if card.cards_mob_type == Groups.knights:
			knights.append(card)
		
	
	# while more than two knights
	# take two knights, vector2++/2, remove one mob, position the other,
	# scale up and change internal stats, ie damage health
	
	
	
	
	#enemies_node.spawn_slime()
	#
	#for area in glyph_drop_circle.get_overlapping_areas():
		#enemies_node.spawn_slime()
		#var card = area.get_parent()
		#var card_back
		#for child in card.get_children():
			#match child.name:
				#"CardBackground":
					#card_back = child
		#if card_back:
			#destroy_card(card)

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
	summon_sprite(card)

func summon_sprite(card: PlayingCard):
	var knight = card.get_children().filter(func(node): return node is CharacterBody2D)[0]
	#need to generalize (i.e. get mob, then mob is diff depending on card...)
	knight.add_to_group(Groups.knights)
	knight.add_to_group(Groups.good_guys)
	var curscale = knight.scale
	var curpos = knight.global_position
	card.remove_child(knight)
	enemies_node.add_child(knight)
	knight.scale = Vector2(4,4)
	knight.global_position = curpos
	knight.is_falling = true
	knight.is_off_card = true
	knight.find_child("StateMachine").transition_to("Walk")
	var echo: AudioStreamPlayer
	var remaining_children = card.get_children()
	for child in remaining_children:
		if child is  AudioStreamPlayer:
			echo = child
		else:
			child.queue_free()
	if echo:
		await echo.finished
		await get_tree().create_timer(.2).timeout
		card.queue_free()
	else:
		card.queue_free()
