extends KinematicBody2D


onready var inventoryUI: CenterContainer = get_node("UI/Inventory")
onready var inventory: Reference = inventoryUI.get_node("SlotContainer").inventory
onready var craftingUI: HBoxContainer = get_node("UI/CraftingContainer")
var velocity : = Vector2.ZERO

const MAX_SPEED : int = 100
const ACCELERATION : int = 500
const FRICTION : int = 500


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
		if inventoryUI.visible:
			inventoryUI.visible = false
		else:
			inventoryUI.visible = true
	if event.is_action_pressed("crafting"):
		if craftingUI.visible:
			craftingUI.visible = false
		else:
			craftingUI.visible = true
