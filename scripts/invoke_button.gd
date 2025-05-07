extends Sprite2D


func _on_button_button_down() -> void:
	var normal_scale = self.scale
	var small_scale = Vector2(.1,.1)
	var big_scale = normal_scale *1.9
	var tween = get_tree().create_tween()
	var color_val = 2.0
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "self_modulate", Color(1,2,1), .1)
	tween.tween_property(self, "self_modulate", Color(1,2,4), .05)
	tween.tween_property(self, "self_modulate", Color(7,7,7), .01)
	tween.tween_property(self, "self_modulate", Color(1,1,1), 1.1)
	
	
	
	
	#tween.tween_property(self, 'scale', big_scale, 1)
	#tween.tween_property(self, 'scale', normal_scale, .05)
	#tween.tween_property(self, "self_modulate", Color(1.0,1,1), 1.0)
	#tween.tween_interval(0.6)
	#tween.tween_property(self, "self_modulate", Color(0,0,0), 1.0)
