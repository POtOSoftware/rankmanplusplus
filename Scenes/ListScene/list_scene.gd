extends Control

@onready var list_container = $ScrollContainer/VBoxContainer

var test_list: Array = ["item one", "item two", "item three", "item four"]
var test_two: Array = ["Grace", "Eternal Life", "Last Goodbye", "Mojo Pin", "Forget Her", "So Real", "Lover", "Lilac Wine", "Hallelujah", "Dream Brother", "Corpus Christi Carol"]
var test_three: Array = ["uh yeah", "woo hoo", "filling out a stinky lil list", "fuck you", "and fuck me", "and fuck yourself too", "shit head"]

func _ready() -> void:
	AppManager.list_container = list_container
	
	AppManager.connect(AppManager.new_item_signal, self.refresh_display)
	#refresh_display(test_list)

func _exit_tree() -> void:
	AppManager.list_container = null

func refresh_display(_input_list: Array = AppManager.main_list) -> void:
	print("REFRESHING LIST WITH LIST " + str(_input_list))
	get_tree().call_group("list_item", "queue_free")
	
	for item in _input_list:
		print("CREATING ITEM " + item)
		var list_index = _input_list.find(item, 0) + 1
		AppManager.create_list_item(item, list_index)
	
	print("REFRESH COMPLETE")

func _on_test_2_pressed() -> void:
	AppManager.set_main_list(test_two)
	refresh_display(test_two)

func _on_test_3_pressed() -> void:
	AppManager.set_main_list(test_three)
	refresh_display(test_three)

func _on_test_1_pressed() -> void:
	AppManager.set_main_list(test_list)
	refresh_display(test_list)
 
func _on_add_button_pressed() -> void:
	AppManager.create_list_item_input()
