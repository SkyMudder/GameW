extends "res://Inventory/SlotContainerMaster.gd"


signal item_equipped(item)

var inventory: Inventory
var currentIndex: int = 0

func _ready() -> void:
	_setUpInventory()
	get_child(0).setHighlight(true)

func _setUpInventory() -> void:
	addSlots(self, 10)
	setColumns(10)

func _input(event):
	if event.is_action_pressed("mouse_wheel_up") or event.is_action_pressed("mouse_wheel_down"):
		get_child(currentIndex).setHighlight(false)
		if event.is_action_pressed("mouse_wheel_up"):
			if currentIndex == 0:
				currentIndex = 9
			else:
				currentIndex -= 1
		elif event.is_action_pressed("mouse_wheel_down"):
			if currentIndex == 9:
				currentIndex = 0
			else:
				currentIndex += 1
		get_child(currentIndex).setHighlight(true)
		emit_signal("item_equipped", get_child(currentIndex).item)

func _on_items_changed(indexes, inventories) -> void:
	for x in inventories.size():
		if inventories[x] == inventory:
			get_child(indexes[x]).setItem(inventory.items[indexes[x]])
	emit_signal("item_equipped", get_child(currentIndex).item)
