extends Camera2D

var shake_amount = 0.0
var shake_decay = 20.0


func trigger_shake(amount = 10.0):
	shake_amount = amount

# Called when the node enters the scene tree for the first time.
func _ready():
	# trigger_shake()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_amount > 0:
		offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		shake_amount = max(shake_amount - shake_decay * delta, 0)
	else:
		offset = Vector2.ZERO
