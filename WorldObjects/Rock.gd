extends "res://WorldObjects/WorldObject.gd"


func _ready() -> void:
	set_process(false)
	hp = 1000
	level = 0
	type = 1
	drop = preload("res://Items/Stone.tres").duplicate()
	amountLow = 3
	amountHigh = 5
