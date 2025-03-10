extends Control

@onready var list_container = $ScrollContainer/VBoxContainer

var test_list: Array = ["item one", "item two", "item three", "item four"]
var test_two: Array = ["Grace", "Eternal Life", "Last Goodbye", "Mojo Pin", "Forget Her", "So Real", "Lover", "Lilac Wine", "Hallelujah", "Dream Brother", "Corpus Christi Carol"]
var test_three: Array = ["uh yeah", "woo hoo", "filling out a stinky lil list", "fuck you", "and fuck me", "and fuck yourself too", "shit head"]

func _ready() -> void:
	AppManager.list_container = list_container
	
	refresh_display(test_list)

func _exit_tree() -> void:
	AppManager.list_container = null

func refresh_display(_input_list: Array) -> void:
	print("REFRESHING LIST WITH LIST " + str(_input_list))
	get_tree().call_group("list_item", "queue_free")
	
	for item in _input_list:
		print("CREATING ITEM " + item)
		AppManager.create_list_item(item)
	
	print("REFRESH COMPLETE")

func _on_test_2_pressed() -> void:
	refresh_display(test_two)

func _on_test_3_pressed() -> void:
	refresh_display(test_three)

func _on_test_1_pressed() -> void:
	refresh_display(test_list)
