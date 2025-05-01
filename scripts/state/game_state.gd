extends Node

var flags = {}
var inventory = []
var health = 10
var event_counts = {}


func has_flag(name):
	return flags.get(name, false)

func set_flag(name, value = true):
	flags[name] = value
