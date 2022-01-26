extends GridContainer


var Slot: PackedScene = preload("res://Inventory/InventorySlot.tscn")

func setColumns(columns: int) -> void:
	self.columns = columns

func addSlots(slotContainer: GridContainer, amount: int) -> void:
	slotContainer.inventory = Inventory.new(amount)
	slotContainer.inventory.connect("items_changed", self, "_on_items_changed")
	for _x in range(amount):
		var slot: Control = Slot.instance()
		add_child(slot)
