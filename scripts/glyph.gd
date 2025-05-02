extends Sprite2D

var time := 0.0
var wave

func _ready() -> void:
	self_modulate = Color(2,2,2)

func _process(delta: float) -> void:
	time += delta
	var x = time * 1.4
	wave = sin(time)*.8 + sin(time)
	wave = (sin(time+1) + sin(2*time) + sin(3*time)) / 3
	wave = (sin(x)+sin(2*x-5)+sin(3*x-2))/3
	const amt = 1.4
	self_modulate = Color(wave+amt, wave+amt, wave+amt)
