extends Control

@onready var item_label: Node = $FileButton

func initialize_string(_text: String) -> void:
	item_label.text = _text
	self.custom_minimum_size = Vector2(1080, 150)

func _on_delete_button_pressed() -> void:
	if await AppManager.create_yes_no_input("Are you sure?"):
		AppManager.delete_list_file(item_label.text)

func _on_file_button_pressed() -> void:
	AppManager.working_file_name = item_label.text
	AppManager.load_main_list_from_file(item_label.text)
	get_tree().change_scene_to_file("res://Scenes/ListScene/ListScene.tscn")
