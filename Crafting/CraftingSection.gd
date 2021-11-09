extends CenterContainer


signal craft_clicked

func setItem(texture: Texture) -> void:
	$VBoxContainer/Item.texture = texture

func _on_Button_pressed() -> void:
	emit_signal("craft_clicked")
