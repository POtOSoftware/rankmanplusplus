extends Node

var pre_ListItem: PackedScene = preload("res://Prefabs/ListItem/ListItem.tscn")
var list_container = null

var main_list: Array: set = set_main_list

func create_list_item(_text: String, _index: int):
	var ListItemInstance = pre_ListItem.instantiate()
	
	list_container.add_child(ListItemInstance)
	ListItemInstance.initialize(_text, _index)

func set_main_list(_new_list: Array):
	main_list = _new_list
	
