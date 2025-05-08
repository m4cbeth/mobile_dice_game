extends Sprite2D

@onready var normal_scale = self.scale

func make_tween():
	var tween = get_tree().create_tween()
	var color_val = 2.0
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	return tween

func _on_button_button_down() -> void:
	var small_scale = normal_scale * .95
	var big_scale = normal_scale *1.9
	var tween = get_tree().create_tween()
	var color_val = 2.0
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", small_scale, .05)
	tween.tween_property(self, "self_modulate", Color(1,2,1), .1)
	tween.tween_property(self, "self_modulate", Color(1,2,4), .05)
	tween.tween_property(self, "self_modulate", Color(7,7,7), .01)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "self_modulate", Color(1,1,1), 1.1)


func _on_button_button_up() -> void:
	var tween = make_tween()
	tween.tween_property(self, "scale", normal_scale, .01)



	#tween.tween_interval(0.6)
