extends HBoxContainer


onready var player: KinematicBody2D = get_node("/root/Main/Player")
onready var craftingGrid: GridContainer = get_node("ScrollContainer/VBoxContainer/CraftingGrid")

var items: Array = []
var currentIndex: int

func _ready() -> void:
	var dir: String = "res://Items/"
	$CraftingSection.connect("craft_clicked", self, "_on_craft_clicked")
	for x in Directories.dir_contents(dir, ".tres"):
		var tmpItem: Item = load(dir + x).duplicate()
		if tmpItem is Tool:
			items.push_back(tmpItem)
	addItems()

func _on_craft_clicked() -> void:
	if currentIndex != null:
		player.inventory.addItem(items[currentIndex].duplicate())

func _on_item_selected(index: int) -> void:
	print("ASDAS")
	currentIndex = index
	$CraftingSection/VBoxContainer/Item.texture = items[index].texture

func addItems() -> void:
	for x in items.size():
		craftingGrid.addSlot()
		craftingGrid.get_child(x).get_node("Item").texture = items[x].texture
		craftingGrid.get_child(x).connect("item_selected", self, "_on_item_selected")
