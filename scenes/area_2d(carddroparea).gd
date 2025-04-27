extends Area2D

var card_count_on_stack = 0
var glow
var blue_overlay

func _ready():
	# connect the enter/exit signals
	self.area_entered.connect(_on_area_entered)
	glow = $"../Sprite2D2"
	blue_overlay = $"../Sprite2D3"

func _on_area_entered(area: Area2D) -> void:
	print(area)
	print($"../Sprite2D2")
	glow.visible = true
	card_count_on_stack = card_count_on_stack + 1
	if card_count_on_stack > 1:
		$"../Sprite2D3".visible = true
	if card_count_on_stack > 2:
		$"../Sprite2D4".visible = true
	


func _on_area_exited(area: Area2D) -> void:
	print(area, "leaving")
	card_count_on_stack = card_count_on_stack - 1
	if card_count_on_stack < 2:
		$"../Sprite2D4".visible = false
	if card_count_on_stack < 1:
		blue_overlay.visible = false
	if card_count_on_stack == 0:
		print('zero')
		glow.visible = false
	
