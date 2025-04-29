extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_area_2d_mouse_entered():
	print('entered')


func _on_area_2d_mouse_exited():
	print('exited')



func _input(event: InputEvent) -> void:
	# added "and false" to turn off
	# need to make this so it only triggers when clicking the card area.
	# also note there is an animated sprite2d here. Was thinking of using that instaed...
	# this is fine for now, but also don't delete just move on.
	# how to if click is on area?
		# we have that in the card manager "raycast check for card"
	if is_clicked(event) and false:
		var side = randi_range(0, 5)
		$Dice.frame = side
		match side + 1:
			1:
				print('one')
			2:
				print('two')
			3:
				print('three')
			4:
				print('4')
			5:
				print(side +1)
			6:
				print(6)
				


func is_clicked(e):
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
		return true
