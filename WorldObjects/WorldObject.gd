extends Node


onready var player: KinematicBody2D = get_node("/root/Main/Player")
var rand : RandomNumberGenerator

var hp: float
var level: int
var drop: Item
var amountLow: int
var amountHigh: int

func _ready() -> void:
	rand = RandomNumberGenerator.new()
	rand.randomize()

func _process(delta: float) -> void:
	hp -= 1000 * delta
	if hp <= 0:
		_destroy()

func _destroy() -> void:
	drop.amount = rand.randi_range(amountLow, amountHigh)
	player.inventory.addItem(drop)
	queue_free()

func _on_HitBox_mouse_entered() -> void:
	set_process(true)

func _on_HitBox_mouse_exited() -> void:
	set_process(false)
