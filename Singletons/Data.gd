extends Node


var items: Array = []
var allInventories: Array = []
var playerInventories: Array = []

func _ready() -> void:
	getAllItems()

func dir_contents(path: String, filter: String):
	var dir = Directory.new()
	var tmpItems: Array = []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if filter in file_name:
					tmpItems.push_back(path + file_name)
			file_name = dir.get_next()
		return tmpItems
	else:
		print("An error occurred when trying to access the path.")

func getAllItems() -> void:
	var dir: String = "res://Items/"
	for x in dir_contents(dir, ".tres"):
		var item: Item = load(x).duplicate()
		items.push_back(item)
