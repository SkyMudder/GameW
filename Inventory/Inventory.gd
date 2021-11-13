class_name Inventory


signal items_changed(indexes)

var items: Array = []

var dragData

func _init(size: int) -> void:
	for _x in size:
		items.push_back(null)

func setItem(index: int, item: Item) -> void:
	var tmp: Item = item.duplicate()
	items[index] = tmp
	if tmp.amount < 1:
		removeItem(index)
	emit_signal("items_changed", [index])

func removeItem(index: int) -> void:
	items[index] = null
	emit_signal("items_changed", [index])

func switchItem(sourceIndex: int, targetIndex: int) -> void:
	var tmp: Item = items[sourceIndex]
	items[sourceIndex] = items[targetIndex]
	items[targetIndex] = tmp
	emit_signal("items_changed", [sourceIndex, targetIndex])

func addItem(item: Item) -> bool:
	for x in range(items.size()):
		if items[x] == null:
			setItem(x, item)
			return true
		elif items[x].name == item.name and items[x].amount != items[x].amountMax:
			var rest: int = items[x].amountMax - items[x].amount
			if item.amount > rest:
				items[x].amount += rest
				item.amount -= rest
				setItem(x, items[x])
			else:
				items[x].amount += item.amount
				setItem(x, items[x])
				return true
	return false
