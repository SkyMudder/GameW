extends "res://Inventory/SlotContainerMaster.gd"


var inventory: Inventory

func _ready() -> void:
	_setUpInventory()

func _setUpInventory() -> void:
	addSlots(self, 9)
	setColumns(9)

func _on_items_changed(indexes, inventories) -> void:
	for x in inventories.size():
		if inventories[x] == inventory:
			get_child(indexes[x]).setItem(inventory.items[indexes[x]])
