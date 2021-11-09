extends GridContainer


var CraftingSlot: PackedScene = preload("res://Crafting/CraftingSlot.tscn")

func addSlot() -> void:
	var craftingSlot: CenterContainer = CraftingSlot.instance()
	add_child(craftingSlot)
