extends Area2D

var card_count_on_stack = 0
var glow
var blue_overlay

func _ready():
	glow = $"../Sprite2D2"
	blue_overlay = $"../Sprite2D3"

func _on_area_entered(_area: Area2D) -> void:
	glow.visible = true
	card_count_on_stack = card_count_on_stack + 1
	if card_count_on_stack > 1:
		$"../Sprite2D3".visible = true
	if card_count_on_stack > 2:
		$"../Sprite2D4".visible = true

func _on_area_exited(_area: Area2D) -> void:
	card_count_on_stack = card_count_on_stack - 1
	if card_count_on_stack < 2:
		$"../Sprite2D4".visible = false
	if card_count_on_stack < 1:
		blue_overlay.visible = false
	if card_count_on_stack == 0:
		glow.visible = false
