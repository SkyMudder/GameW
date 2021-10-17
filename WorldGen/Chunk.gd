extends Node
class_name Chunk

onready var ground = get_parent().get_node("Ground")
onready var background = get_parent().get_node("Background")

const CHUNK_SIZE: int = 10

var tree: PackedScene = preload("res://WorldObjects/Tree.tscn")
var rock: PackedScene = preload("res://WorldObjects/Rock.tscn")

var shouldRemove: bool = false
var ySort: YSort

func _ready() -> void:
	ySort = YSort.new()
	add_child(ySort)

func generate(noise: OpenSimplexNoise, noiseObj: OpenSimplexNoise, wX: float, wY: float) -> void:
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			var noise2D: float = noise.get_noise_2d(x + wX * CHUNK_SIZE, y + wY * CHUNK_SIZE)
			var noise2DObj: float = noiseObj.get_noise_2d(x + wX * CHUNK_SIZE, y + wY * CHUNK_SIZE)
			_generateFloor(noise2D, Vector2(x + wX * CHUNK_SIZE, y + wY * CHUNK_SIZE))
			_generateObjects(noise2D, noise2DObj, Vector2(x * 32 + wX * 320, y * 32 + wY * 320))

func _generateFloor(noise2D: float, position: Vector2) -> void:
	_generateTile(noise2D, position)
	ground.update_bitmask_area(position)

func _generateTile(noise2D: float, position: Vector2) -> void:
	if noise2D <= 0:
		ground.set_cellv(position, 1)
		if noise2D > -0.1:
			background.set_cellv(position, 1)
	else:
		ground.set_cellv(position, 0)
		if noise2D < 0.1:
			background.set_cellv(position, 0)

func _generateObjects(noise2D: float, noise2DObj: float, position: Vector2) -> void:
	if noise2D > 0 and noise2DObj > 0.35:
		_instantiateObject(tree, position)
	elif noise2D < 0 and noise2DObj < -0.35:
		_instantiateObject(rock, position)

func _removeTile(position: Vector2) -> void:
	ground.set_cellv(position, -1)
	background.set_cellv(position, -1)

func remove(wX: int, wY: int) -> void:
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			_removeTile(Vector2(x + wX * CHUNK_SIZE, y + wY * CHUNK_SIZE))
	self.queue_free()

func _instantiateObject(Obj: PackedScene, position: Vector2) -> void:
	var object: StaticBody2D = Obj.instance()
	object.position = position
	ySort.add_child(object)
