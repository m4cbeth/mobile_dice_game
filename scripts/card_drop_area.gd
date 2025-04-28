extends Node2D

# INVOKE button (left side invisible area button)
func _on_button_button_down() -> void:
	for area in $Area2D.get_overlapping_areas():
		var card = area.get_parent()
		var children = card.get_children()
		var card_back = children[0]
		var destruction_animation = children[3]
		var burning_animation = children[4]
		destruction_animation.play()
		await get_tree().create_timer(0.5).timeout
		burning_animation.play()
		destruction_animation.animation_finished.connect(func(): card_back.queue_free())
		
