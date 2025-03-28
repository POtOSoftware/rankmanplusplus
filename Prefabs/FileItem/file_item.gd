extends Control

@onready var item_label: Node = $Label

var full_file_name: String = ""

func initialize_string(_text: String) -> void:
	full_file_name = _text
	item_label.text = _text.get_basename()
	self.custom_minimum_size = Vector2(1080, 150)

func _on_delete_button_pressed() -> void:
	if await AppManager.create_yes_no_input("Are you sure?"):
		AppManager.delete_list_file(full_file_name)

func _on_file_button_pressed() -> void:
	AppManager.working_file_name = full_file_name
	if AppManager.working_file_name.contains(".rank2"):
		AppManager.load_rank2_file(AppManager.working_file_name)
	elif AppManager.working_file_name.contains(".rank"):
		AppManager.load_main_list_from_file(AppManager.working_file_name)
	else:
		printerr("INVALID FILE EXTENSION! HOW DID THAT EVEN SHOW UP ANYWAYS?")
	
	get_tree().change_scene_to_file("res://Scenes/ListScene/ListScene.tscn")
