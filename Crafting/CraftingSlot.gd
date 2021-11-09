extends CenterContainer


signal item_selected(index)

func setItem(texture: Texture) -> void:
	$Item.texture = texture

func _on_Button_pressed() -> void:
	emit_signal("item_selected", get_index())
