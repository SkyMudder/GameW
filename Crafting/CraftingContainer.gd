extends HBoxContainer


onready var player: KinematicBody2D = get_node("/root/Main/Player")
onready var craftingGrid: GridContainer = get_node("ScrollContainer/VBoxContainer/CraftingGrid")

var items: Array = []
var currentIndex: int


func _ready() -> void:
	var dir: String = "res://Items/"
	$CraftingSection.connect("craft_clicked", self, "_on_craft_clicked")
	for x in Data.dir_contents(dir, ".tres"):
		var item: Item = load(x).duplicate()
		if item is Tool:
			items.push_back(item)
	_addItems()

func _on_craft_clicked() -> void:
	if currentIndex != null:
		var tmpItems: Array = (items[currentIndex].resources).duplicate()
		for x in items[currentIndex].resources.size():
			tmpItems[x].amount = items[currentIndex].resourceAmounts[x]
		if _seekItem(tmpItems, Data.playerInventories):
			player.inventory.addItem(items[currentIndex].duplicate())

func _on_item_selected(index: int) -> void:
	currentIndex = index
	$CraftingSection/VBoxContainer/Item.texture = items[index].texture

func _addItems() -> void:
	for x in items.size():
		craftingGrid.addSlot()
		craftingGrid.get_child(x).get_node("Item").texture = items[x].texture
		craftingGrid.get_child(x).connect("item_selected", self, "_on_item_selected")

func _seekItem(seekItems: Array, inventories: Array) -> bool:
	var queue: Array = []
	for item in seekItems:
		for x in range(inventories.size()):
			for y in range(inventories[x].items.size()):
				if inventories[x].items[y] != null:
					if item.name == inventories[x].items[y].name:
						if inventories[x].items[y].amount >= item.amount:
							queue.append(_queueItemSet(inventories[x], inventories[x].items[y], y, inventories[x].items[y].amount - item.amount))
							item.amount = 0
						else:
							queue.append(_queueItemSet(inventories[x], inventories[x].items[y], y, 0))
							item.amount -= inventories[x].items[y].amount
	for x in seekItems:
		if x.amount != 0:
			return false
	for x in queue:
		x.resume()
	return true

func _queueItemSet(inventory: Inventory, item: Item, index: int, amount: int) -> void:
	yield()
	item.amount = amount
	inventory.setItem(index, item)
