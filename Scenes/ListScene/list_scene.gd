extends Control

@onready var list_container = $ScrollContainer/VBoxContainer

var test_list: Array = ["item one", "item two", "item three", "item four"]

func _ready() -> void:
	AppManager.list_container = list_container
	
	refresh_display()

func _exit_tree() -> void:
	AppManager.list_container = null

func refresh_display() -> void:
	for item in test_list:
		AppManager.create_list_item(item)
