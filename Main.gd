extends Node2D


var renderDistance: int = 5

var noise: OpenSimplexNoise
var chunks: Dictionary

func _ready() -> void:
	$Player/Camera2D.current = true
	noise = OpenSimplexNoise.new()
	noise.octaves = 4
	noise.period = 25

func _process(delta: float) -> void:
	_setChunksRemove()
	_checkGenerateChunk()
	_checkRemoveChunks()

func _checkGenerateChunk() -> void:
	for x in range($Player.position.x / 320 - renderDistance, $Player.position.x / 320 + renderDistance):
		for y in range($Player.position.y / 320 - renderDistance, $Player.position.y / 320 + renderDistance):
			var key: String = str(x) + " " + str(y)
			if !isChunkGenerated(key):
				chunks[key] = _generateChunk(x, y)
			chunks[key].remove = false
			

func _checkRemoveChunks() -> void:
	for x in chunks.keys():
		if chunks[x].remove:
			var xy: Array = x.split(" ")
			var wX: int = int(xy[0])
			var wY: int = int(xy[1])
			chunks[x].remove(wX, wY)
			chunks.erase(x)

func _setChunksRemove():
	for x in chunks.keys():
		chunks[x].remove = true

func _generateChunk(x: int, y: int) -> Node2D:
	var chunk = Chunk.new()
	$Chunks.add_child(chunk)
	chunk.generate(noise, x, y)
	return chunk

func isChunkGenerated(key: String) -> bool:
	for x in chunks.keys():
		if x == key:
			return true
	return false
