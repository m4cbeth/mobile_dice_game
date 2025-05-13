extends Node2D

@onready var infoglypho: Label = $Label
@onready var base_position = $Label.position

const duration = 0.5
const y_offset = 10
const y_goto = 30

#func _ready() -> void:
	#doathing()

func show_number():
	var label_position = infoglypho.position
	var start_pos = Vector2(label_position.x, label_position.y + y_offset)
	var endin_pos = Vector2(label_position.x, label_position.y - y_goto)
	infoglypho.position = start_pos
	infoglypho.modulate.a = 1.0
	var tween = get_tree().create_tween()
	tween.tween_property(infoglypho, "position:x", endin_pos, duration)
	tween.tween_property(infoglypho, "modulate:a", 0, duration)
	infoglypho.position = base_position
	
#func doathing():
	#var timer = get_tree().create_timer(1)
	#show_number()
	#timer.timeout.connect(doathing)
	
	
