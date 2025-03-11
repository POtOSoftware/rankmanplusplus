extends Control

@onready var item_label: Node = $Label

var list_position: int = 0

func initialize_string(_text: String, _index: int) -> void:
	item_label.text = str(_index) + ". " + _text
	list_position = _index - 1
	self.custom_minimum_size = Vector2(1080, 150)

func _on_delete_button_pressed() -> void:
	AppManager.remove_index_from_list(list_position)

func _on_edit_button_pressed() -> void:
	var _new_label: String = await AppManager.create_string_input("Edit item:")
	AppManager.update_index_in_list(list_position, _new_label)
