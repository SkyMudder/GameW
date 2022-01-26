class_name Inventory


signal items_changed(indexes, inventories)

var items: Array = []

func _init(size: int) -> void:
	for _x in size:
		items.push_back(null)
	Data.playerInventories.push_front(self)

func setItem(index: int, item: Item) -> void:
	var tmp: Item = item.duplicate()
	items[index] = tmp
	if tmp.amount < 1:
		removeItem(index)
	emit_signal("items_changed", [index], [self])

func removeItem(index: int) -> void:
	items[index] = null
	emit_signal("items_changed", [index], [self])
	
func addItem(item: Item) -> bool:
	#Checks if there are available Slots with the same Item deeper in the Inventories
	for x in Data.playerInventories:
		for y in range(x.items.size()):
			if x.items[y] != null:
				if x.items[y].name == item.name:
					var amount: int = _addToSlot(x, item, y)
					if amount == -1:
						return true
					else:
						item.amount = amount
	
	#Fills the Inventories from the start
	for x in Data.playerInventories:
		for y in range(x.items.size()):
			var amount: int = item.amount
			if x.items[y] == null:
				amount = _addToSlotEmpty(x, item, y)
			elif x.items[y].name == item.name:
				amount = _addToSlot(x, item, y)
			
			if amount == -1:
				return true
			else:
				item.amount = amount
	return false

func _addToSlotEmpty(inventory: Inventory, item: Item, itemIndex: int) -> int:
	if item.amount > item.amountMax:
		var tmp: Item = item.duplicate()
		tmp.amount = item.amountMax
		item.amount -= item.amountMax
		inventory.setItem(itemIndex, tmp)
		return item.amount
	else:
		inventory.setItem(itemIndex, item)
		return -1

func _addToSlot(inventory: Inventory, item: Item, itemIndex: int) -> int:
	var rest: int = inventory.items[itemIndex].amountMax - inventory.items[itemIndex].amount
	if item.amount > rest:
		inventory.items[itemIndex].amount += rest
		item.amount -= rest
		inventory.setItem(itemIndex, inventory.items[itemIndex])
		return item.amount
	else:
		inventory.items[itemIndex].amount += item.amount
		inventory.setItem(itemIndex, inventory.items[itemIndex])
		return -1

#----------------------------------DEPRECATED--------------------------------------------#
func switchItem(sourceInventory: Inventory, sourceIndex: int, targetIndex: int) -> void:
	var tmp: Item = sourceInventory.items[sourceIndex]
	sourceInventory.items[sourceIndex] = items[targetIndex]
	items[targetIndex] = tmp
	emit_signal("items_changed", [sourceIndex, targetIndex], [sourceInventory, self])
#----------------------------------DEPRECATED--------------------------------------------#
