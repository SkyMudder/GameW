class_name Inventory


signal items_changed(indexes)
var items: Array = []

var dragData

func _init(size: int) -> void:
	for _x in size:
		items.push_back(null)

func setItem(index: int, item: Item) -> void:
	items[index] = item
	if item.amount < 1:
		removeItem(items.find(item))
	emit_signal("items_changed", [index])

func removeItem(index: int) -> void:
	items[index] = null
	emit_signal("items_changed", [index])

func switchItem(sourceIndex: int, targetIndex: int) -> void:
	var tmp: Item = items[sourceIndex]
	items[sourceIndex] = items[targetIndex]
	items[targetIndex] = tmp
	emit_signal("items_changed", [sourceIndex, targetIndex])
