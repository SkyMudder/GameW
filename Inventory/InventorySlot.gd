extends CenterContainer


onready var inventory: Inventory = get_parent().inventory
var item: Item

func setItem(newItem: Item) -> void:
	if newItem != null:
		item = newItem
		print(str(inventory) + newItem.name)
		$Item.texture = newItem.texture
		if newItem.amount != 1:
			$Item/Amount.text = str(newItem.amount)
		else:
			$Item/Amount.text = ""
	else:
		item = null
		$Item.texture = null
		$Item/Amount.text = ""

func get_drag_data(_position: Vector2) -> Dictionary:
	var data: Dictionary = {}
	var dragPreview: TextureRect
	if item != null:
		data.inventory = inventory
		data.item = item.duplicate()
		data.oAmount = item.amount
		data.index = get_index()
		dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		set_drag_preview(dragPreview)
		if Input.is_action_pressed("ctrl"):
			if item.amount % 2 == 0:
				data.item.amount = item.amount / 2
			else:
				data.item.amount = item.amount / 2 + 1
			item.amount /= 2
		else:
			item.amount = 0
		inventory.setItem(data.index, item)
		Gv.dragData = data
	return data

func can_drop_data(_position, data: Dictionary) -> bool:
	return data is Dictionary and data.has("item")

func drop_data(_position: Vector2, data: Dictionary) -> void:
	var thisIndex: int = get_index()
	var thisItem: Item = item
	if thisItem != null:
		if thisItem.name != data.item.name:
			data.item.amount = data.oAmount
			inventory.setItem(thisIndex, data.item)
			data.inventory.setItem(data.index, thisItem)
		elif thisItem.name == data.item.name:
			if thisItem.amount + data.item.amount > thisItem.amountMax:
				var rest: int = thisItem.amountMax - thisItem.amount
				thisItem.amount += rest
				data.item.amount = data.oAmount - rest
				data.inventory.setItem(data.index, data.item)
			else:
				thisItem.amount += data.item.amount
			inventory.setItem(thisIndex, thisItem)
	else:
		inventory.setItem(thisIndex, data.item)
	Gv.dragData = null
