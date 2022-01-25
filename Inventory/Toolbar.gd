extends GridContainer


var Slot: PackedScene = preload("res://Inventory/InventorySlot.tscn")
var inventory: Inventory

func _ready() -> void:
	_setUpInventory()

func _setUpInventory() -> void:
	_addSlots(9)
	_setColumns(9)

func _addSlots(amount: int) -> void:
	inventory = Inventory.new(amount)
	inventory.connect("items_changed", self, "_on_items_changed")
	for _x in range(amount):
		var slot: Control = Slot.instance()
		add_child(slot)

func _setColumns(columns: int) -> void:
	self.columns = columns

func _on_items_changed(indexes, inventories) -> void:
	for x in inventories.size():
		if inventories[x] == inventory:
			get_child(indexes[x]).setItem(inventory.items[indexes[x]])
