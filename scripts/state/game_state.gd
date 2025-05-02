extends Node

var flags = {}
var inventory = []
var health = 10
var event_counts = {}


func has_flag(flag_name):
	return flags.get(flag_name, false)

func set_flag(flag_name, value = true):
	flags[flag_name] = value
