extends Node2D
const HAND_COUNT = 4
const CARD_SCENE_PATH = "res://scenes/card.tscn"

func _ready() -> void:
	var card_scene = preload("res://scenes/card.tscn")
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
		new_card.z_index = 3
		$"../CardManager".add_child(new_card)
