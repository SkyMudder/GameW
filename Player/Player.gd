extends KinematicBody2D


onready var inventoryUI: CenterContainer = get_node("UI/Inventory")
onready var inventory: Reference = inventoryUI.get_node("SlotContainer").inventory
onready var toolBarSlotContainer: GridContainer = get_node("UI/Toolbar/SlotContainer")
onready var craftingUI: HBoxContainer = get_node("UI/CraftingContainer")
var velocity : = Vector2.ZERO

const MAX_SPEED : int = 100
const ACCELERATION : int = 500
const FRICTION : int = 500

var currentItem: Item

func _ready() -> void:
	toolBarSlotContainer.connect("item_equipped", self, "_onItemEquipped")

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventoryUI.visible = !inventoryUI.visible
	if event.is_action_pressed("crafting"):
		craftingUI.visible = !craftingUI.visible

func _onItemEquipped(item: Item) -> void:
	self.currentItem = item
	if item != null:
		$Player/TextureRect.texture = item.texture
	else:
		$Player/TextureRect.texture = null
