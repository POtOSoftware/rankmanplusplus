extends Control

@onready var list_container = $ScrollContainer/VBoxContainer
@onready var file_name_label = $TopBar/WorkingFileName
@onready var first_time_hints = $FirstTimeHints

var test_list: Array = ["item one", "item two", "item three", "item four"]
var test_two: Array = ["Grace", "Eternal Life", "Last Goodbye", "Mojo Pin", "Forget Her", "So Real", "Lover", "Lilac Wine", "Hallelujah", "Dream Brother", "Corpus Christi Carol"]
var test_three: Array = ["uh yeah", "woo hoo", "filling out a stinky lil list", "fuck you", "and fuck me", "and fuck yourself too", "shit head", "really long", "still more to go", "yep", "this is somehow boring", "not really", "AA", "AAA!", "nyaa~", "mrrp", "meoww~ :3", "mrrow", "gotta add more", "and even more", "cause apparently my shit dont work", "the end!"]

func _ready() -> void:
	AppManager.list_container = list_container
	AppManager.connect(AppManager.new_item_signal, self.refresh_display)
	
	file_name_label.text = AppManager.working_file_name
	#AppManager.load_main_list_from_file(AppManager.working_file_name)
	refresh_display()
	AppManager.clear_undo_list()

	#refresh_display(test_list)

func _exit_tree() -> void:
	AppManager.list_container = null

#func _notification(what: int) -> void:
#	if what == NOTIFICATION_WM_GO_BACK_REQUEST && AppManager.current_app_state == AppManager.APP_STATES.IDLE:
#		back_to_file_picker()

func back_to_file_picker() -> void:
	AppManager.save_main_list_to_file(AppManager.working_file_name)
	get_tree().change_scene_to_file("res://Scenes/FilePicker/FilePicker.tscn")

func refresh_display(_input_list: Array = AppManager.main_list) -> void:
	print("REFRESHING LIST WITH LIST " + str(_input_list))
	get_tree().call_group("list_item", "queue_free")
	
	file_name_label.text = AppManager.working_file_name
	
	for item in _input_list:
		print("CREATING ITEM " + item)
		var list_index = _input_list.find(item, 0) + 1
		AppManager.create_list_item(item, list_index)
	
	first_time_hints.visible = !(AppManager.main_list.size() > 0)
	
	AppManager.save_main_list_to_file(AppManager.working_file_name)
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

func _on_v_box_container_reordered(from: int, to: int) -> void:
	var _main_list_copy: Array = AppManager.main_list
	var _item_to_move: String = _main_list_copy[from]
	print("MOVING ITEM " + _item_to_move)
	AppManager.update_undo_list(_main_list_copy)
	
	_main_list_copy.remove_at(from)
	_main_list_copy.insert(to, _item_to_move)
	
	print(_main_list_copy)
	
	AppManager.set_main_list(_main_list_copy)
	#refresh_display()

func _on_copy_button_pressed() -> void:
	AppManager.save_main_list_to_file(AppManager.working_file_name)
	
	var _copy_string: String = ""
	var index: int = 1
	
	for item in AppManager.main_list:
		var _rank: String = str(index) + ". "
		_copy_string += _rank + item + "\n"
		
		index += 1
	
	print(_copy_string)
	DisplayServer.clipboard_set(_copy_string)

func _on_back_button_pressed() -> void:
	back_to_file_picker()

func _on_undo_button_pressed() -> void:
	AppManager.undo_main_list()

func _on_file_rename_pressed() -> void:
	var _old_file_name: String = AppManager.working_file_name
	# to prevent the user from removing the .rank extension, the input doesn't include it but then adds it after the fact
	var _new_file_name: String = await AppManager.create_string_input("Rename file:", AppManager.working_file_name.replace(".rank", "")) + ".rank"
	
	AppManager.rename_file(_old_file_name, _new_file_name)

func _on_add_note_pressed() -> void:
	AppManager.create_note_input()
