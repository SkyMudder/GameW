extends Node
class_name Chunk

onready var ground = get_parent().get_node("Ground")
onready var background = get_parent().get_node("Background")

const CHUNK_SIZE: int = 10

var remove = false

func generate(noise: OpenSimplexNoise, wX: float, wY: float) -> void:
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			_generateTile(noise, x + wX * CHUNK_SIZE, y + wY * CHUNK_SIZE)
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			ground.update_bitmask_area(Vector2(x + wX * CHUNK_SIZE, y + wY * CHUNK_SIZE))

func _generateTile(noise: OpenSimplexNoise, x: float, y: float) -> void:
	var tmpNoise: float = noise.get_noise_2d(x, y)
	if tmpNoise <= 0:
		ground.set_cell(x, y, 0)
		if tmpNoise > -0.1:
			background.set_cell(x, y, 0)
	else:
		ground.set_cell(x, y, 1)
		if tmpNoise < 0.1:
			background.set_cell(x, y, 1)

func _removeTile(x: int, y: int) -> void:
	ground.set_cell(x, y, -1)

func remove(wX: int, wY: int) -> void:
	var a = 0
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			_removeTile(x + wX * CHUNK_SIZE, y + wY * CHUNK_SIZE)
	self.queue_free()
