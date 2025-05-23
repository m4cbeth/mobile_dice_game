extends Mob
class_name WolfMob

@onready var state_machine: StateMachine = find_child("StateMachine")

var health := 13
var fake_floor := 800
var is_falling := false
var shitlist := [] # a list of people who've harmed me
var damage := 4
var is_off_card := false
const mob_type = Groups.wolves
