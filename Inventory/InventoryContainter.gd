extends CenterContainer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	self.rect_position = get_node("/root/Main/Player").position
