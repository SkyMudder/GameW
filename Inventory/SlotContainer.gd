extends GridContainer


var Slot: PackedScene = preload("res://Inventory/InventorySlot.tscn")
var inventory: Inventory

func _ready() -> void:
	_setUpInventory()

func _setUpInventory() -> void:
	_addSlots(15)
	_setColumns(5)

func _addSlots(amount: int) -> void:
	inventory = Inventory.new(amount)
	inventory.connect("items_changed", self, "_on_items_changed")
	for _x in range(amount):
		var slot: Control = Slot.instance()
		add_child(slot)

func _setColumns(columns: int) -> void:
	self.columns = columns

func _on_items_changed(indexes) -> void:
	for x in indexes:
		get_child(x).setItem(inventory.items[x])

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left"):
		if inventory.dragData is Dictionary:
			inventory.setItem(inventory.dragData.index, inventory.dragData.item)
