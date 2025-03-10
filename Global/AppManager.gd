extends Node

signal new_item_added

var pre_ListItem: PackedScene = preload("res://Prefabs/ListItem/ListItem.tscn")
var pre_ListInput: PackedScene = preload("res://Prefabs/ListInputPopup/ListInputPopup.tscn")

var list_container = null

var main_list: Array: set = set_main_list
var main_list_backup: Array

var new_item_signal = "new_item_added"

func create_list_item(_text: String, _index: int):
	var ListItemInstance = pre_ListItem.instantiate()
	
	list_container.add_child(ListItemInstance)
	ListItemInstance.initialize_string(_text, _index)

func create_list_item_input():
	var ListInputInstance = pre_ListInput.instantiate()
	
	get_tree().get_root().add_child(ListInputInstance)

func set_main_list(_new_list: Array):
	main_list_backup = main_list
	main_list = _new_list

func add_to_start(_input_item: String):
	main_list_backup = main_list
	
	main_list.insert(0, _input_item)
	new_item_added.emit()

func add_to_middle(_input_item: String):
	main_list_backup = main_list
	
	var list_middle: int = main_list.size() / 2
	main_list.insert(list_middle, _input_item)
	new_item_added.emit()

func add_to_end(_input_item: String):
	main_list_backup = main_list
	
	main_list.append(_input_item)
	new_item_added.emit()
