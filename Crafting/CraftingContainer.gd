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
		if _seekItem(tmpItems, player.inventory, 0):
			player.inventory.addItem(items[currentIndex].duplicate())

func _on_item_selected(index: int) -> void:
	currentIndex = index
	$CraftingSection/VBoxContainer/Item.texture = items[index].texture

func _addItems() -> void:
	for x in items.size():
		craftingGrid.addSlot()
		craftingGrid.get_child(x).get_node("Item").texture = items[x].texture
		craftingGrid.get_child(x).connect("item_selected", self, "_on_item_selected")

func _seekItem(seekItems: Array, inventory: Inventory, index: int) -> bool:
	for x in range(index, inventory.items.size()):
		if inventory.items[x] != null:
			if inventory.items[x].name == seekItems[0].name:
				if inventory.items[x].amount >= seekItems[0].amount:
					var tmp: int = seekItems[0].amount
					seekItems.pop_front()
					if seekItems.size() == 0:
						inventory.items[x].amount -= tmp
						inventory.setItem(x, inventory.items[x])
						return true
					elif _seekItem(seekItems, inventory, 0):
						inventory.items[x].amount -= tmp
						inventory.setItem(x, inventory.items[x])
						return true
					else:
						return false
				else:
					seekItems[0].amount -= inventory.items[x].amount
					if _seekItem(seekItems, inventory, x + 1):
						inventory.removeItem(x)
						return true
					else:
						return false
	return false
