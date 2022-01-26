extends "res://Inventory/SlotContainerMaster.gd"


var inventory: Inventory

func _ready() -> void:
	_setUpInventory()

func _setUpInventory() -> void:
	addSlots(self, 15)
	setColumns(5)

func _on_items_changed(indexes, inventories) -> void:
	for x in inventories.size():
		if inventories[x] == inventory:
			get_child(indexes[x]).setItem(inventory.items[indexes[x]])

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left"):
		if Gv.dragData is Dictionary:
			Gv.dragData.item.amount = Gv.dragData.oAmount
			Gv.dragData.inventory.setItem(Gv.dragData.index, Gv.dragData.item)
