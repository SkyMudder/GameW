extends Node2D


var renderDistance: int = 6

var noise: OpenSimplexNoise
var noiseObj: OpenSimplexNoise
var chunks: Dictionary

func _ready() -> void:
	dir_contents("res://WorldObjects/")
	$Player/Camera2D.current = true
	#$Player/Camera2D.zoom = Vector2(5, 5)
	noise = OpenSimplexNoise.new()
	noise.octaves = 4
	noise.period = 25
	noiseObj = OpenSimplexNoise.new()
	noiseObj.octaves = 7
	noiseObj.period = 2

func _process(_delta: float) -> void:
	_setChunksRemove()
	_checkGenerateChunk()
	_checkRemoveChunks()

func _checkGenerateChunk() -> void:
	print(int($Player.position.x / 320 - renderDistance))
	for x in range($Player.position.x / 320 - renderDistance, $Player.position.x / 320 + renderDistance):
		for y in range($Player.position.y / 320 - renderDistance, $Player.position.y / 320 + renderDistance):
			var key: String = str(x) + " " + str(y)
			if !isChunkGenerated(key):
				chunks[key] = _generateChunk(x, y)
			chunks[key].shouldRemove = false
			

func _checkRemoveChunks() -> void:
	for x in chunks.keys():
		if chunks[x].shouldRemove:
			var xy: Array = x.split(" ")
			var wX: int = int(xy[0])
			var wY: int = int(xy[1])
			chunks[x].remove(wX, wY)
			chunks.erase(x)

func _setChunksRemove():
	for x in chunks.keys():
		chunks[x].shouldRemove = true

func _generateChunk(x: int, y: int) -> Node2D:
	var chunk = Chunk.new()
	$Chunks.add_child(chunk)
	chunk.generate(noise, noiseObj, x, y)
	return chunk

func isChunkGenerated(key: String) -> bool:
	for x in chunks.keys():
		if x == key:
			return true
	return false

func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if ".tscn" in file_name:
					print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
