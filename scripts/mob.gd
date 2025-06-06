extends CharacterBody2D
class_name Mob

var shitlist: Array
var is_attacking: bool

func add_to_shitlist(guy: Mob = null) -> void:
	print('adding guy')
	if not shitlist.has(guy):
		shitlist.append(guy)
	
