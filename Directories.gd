extends Node

func dir_contents(path: String, filter: String):
	var dir = Directory.new()
	var items: Array = []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if filter in file_name:
					items.push_back(file_name)
			file_name = dir.get_next()
		return items
	else:
		print("An error occurred when trying to access the path.")
