extends Area2D

var card_count_on_stack = 0
var glow
var blue_overlay

func _ready():
	# connect the enter/exit signals
	#self.area_entered.connect(_on_area_entered)
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
		
		




# INVOKE button (left side invisible area button)
func _on_button_button_down() -> void:
	#for area in $Area2D.get_overlapping_areas():
		#print("area")
	print($Area2D)
	#for i in range(0, player_hand.size()):
		#print(player_hand[i])
