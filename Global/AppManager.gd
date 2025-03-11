extends Node

signal new_item_added
signal new_file_added

var working_file_name: String

var pre_ListItem: PackedScene = preload("res://Prefabs/ListItem/ListItem.tscn")
var pre_FileItem: PackedScene = preload("res://Prefabs/FileItem/FileItem.tscn")
var pre_ListInput: PackedScene = preload("res://Prefabs/ListInputPopup/ListInputPopup.tscn")
var pre_StringInput: PackedScene = preload("res://Prefabs/StringInputPopup/StringInputPopup.tscn")
var pre_YesNoInput: PackedScene = preload("res://Prefabs/YesNoPopup/YesNoPopup.tscn")

var list_container: Node = null
var file_list_container: Node = null

var main_list: Array: set = set_main_list
var main_list_backup: Array

var new_item_signal: String = "new_item_added"
var new_file_signal: String = "new_file_added"

#region Save file handling
const FILE_PATH: String = "user://RankFiles/"

func save_main_list_to_file(_file_name: String) -> void:
	print("SAVING FILE TO " + FILE_PATH + _file_name)
	
	var list_file = FileAccess.open(FILE_PATH + _file_name, FileAccess.WRITE)
	list_file.store_string(str(main_list))
	
	new_file_added.emit()

func load_main_list_from_file(_file_name: String) -> void:
	var list_file = FileAccess.open(FILE_PATH + _file_name, FileAccess.READ)
	print("LOADING FILE FROM " + FILE_PATH + _file_name)
	
	if list_file:
		reset_main_list()
		main_list = str_to_var(list_file.get_as_text())
	else:
		printerr("SOMETHING FUCKY HAPPENED!")
	#new_file_added.emit()

func delete_list_file(_file_name: String) -> void:
	print("DELETING " + _file_name)
	
	DirAccess.remove_absolute(FILE_PATH + _file_name)
	new_file_added.emit()
#endregion

#region Create item functions
func create_list_item(_text: String, _index: int) -> void:
	var ListItemInstance = pre_ListItem.instantiate()
	
	list_container.add_child(ListItemInstance)
	ListItemInstance.initialize_string(_text, _index)

func create_file_item(_text: String) -> void:
	print("Creating file item " + _text)
	var FileItemInstance = pre_FileItem.instantiate()
	
	file_list_container.add_child(FileItemInstance)
	FileItemInstance.initialize_string(_text)
	print("Created file item " + _text)
#endregion

#region Input Popups
func create_yes_no_input(_header_label: String = "PLACEHOLDER") -> bool:
	var YesNoInstance = pre_YesNoInput.instantiate()
	
	get_tree().get_root().add_child(YesNoInstance)
	YesNoInstance.initialize_header(_header_label)
	
	var result: bool = await YesNoInstance.answer
	
	get_tree().get_root().remove_child(YesNoInstance)
	
	return result

func create_list_item_input() -> void:
	var ListInputInstance = pre_ListInput.instantiate()
	
	get_tree().get_root().add_child(ListInputInstance)

func create_string_input(_header_label: String = "PLACEHOLDER") -> String:
	var StringInputInstance = pre_StringInput.instantiate()
	
	get_tree().get_root().add_child(StringInputInstance)
	StringInputInstance.initialize_header(_header_label)
	
	var result: String = await StringInputInstance.string_submit

	get_tree().get_root().remove_child(StringInputInstance)
	
	return result
#endregion

#region Main List manipulation
func set_main_list(_new_list: Array) -> void:
	main_list_backup = main_list
	main_list = _new_list

func reset_main_list() -> void:
	main_list_backup = main_list
	main_list = []

func add_to_start(_input_item: String) -> void:
	main_list_backup = main_list
	
	main_list.insert(0, _input_item)
	new_item_added.emit()

func add_to_middle(_input_item: String) -> void:
	main_list_backup = main_list
	
	var list_middle: int = main_list.size() / 2
	main_list.insert(list_middle, _input_item)
	new_item_added.emit()

func add_to_end(_input_item: String) -> void:
	main_list_backup = main_list
	
	main_list.append(_input_item)
	new_item_added.emit()

func remove_index_from_list(_item_to_remove: int) -> void:
	main_list_backup = main_list
	
	main_list.remove_at(_item_to_remove)
	new_item_added.emit()

func update_index_in_list(_index: int, _new_string: String) -> void:
	main_list_backup = main_list
	
	main_list.remove_at(_index)
	main_list.insert(_index, _new_string)
	new_item_added.emit()
#endregion
