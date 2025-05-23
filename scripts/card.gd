extends Node2D
class_name PlayingCard

signal hovered
signal hovered_off

# assume card is a knight until otherwise told
var cards_mob_type := Groups.knights

# Called when the node enters the scene tree for the first time.
func _ready():
	#
	get_parent().connect_card_signals(self)


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_area_2d_mouse_entered():
	emit_signal("hovered", self)

func _on_area_2d_mouse_exited():
	emit_signal("hovered_off", self)
