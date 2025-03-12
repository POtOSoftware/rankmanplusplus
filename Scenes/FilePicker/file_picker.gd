extends Control

@onready var list_container = $ScrollContainer/VBoxContainer
@onready var credits_popup = $CreditsPopup
@onready var first_file_hint = $FirstFileHint
@onready var version_string = $CreditsPopup/Box/VersionString

func _ready() -> void:
	AppManager.file_list_container = list_container
	AppManager.working_file_name = ""
	AppManager.reset_main_list()
	AppManager.connect(AppManager.new_file_signal, self.display_all_files)
	
	if !DirAccess.dir_exists_absolute(AppManager.FILE_PATH):
		print("user://RankFiles/ doesn't exist!!! Creating it now though, so not a big deal nya :3")
		DirAccess.make_dir_absolute(AppManager.FILE_PATH)
	
	display_all_files()
	
	version_string.text = ProjectSettings.get_setting("application/config/version")

func _exit_tree() -> void:
	AppManager.file_list_container = null

func display_all_files() -> void:
	var found_files: int = 0
	
	get_tree().call_group("file_item", "queue_free")
	
	var dir = DirAccess.open(AppManager.FILE_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directiory: " + file_name)
			else:
				print("Found file: " + file_name)
				AppManager.create_file_item(file_name)
				found_files += 1
			file_name = dir.get_next()
		first_file_hint.visible = !(found_files > 0)
	else:
		printerr("SOMETHING FUCKY HAPPENED!")

func _on_new_button_pressed() -> void:
	var new_file_name = await AppManager.create_string_input("New file name:") + ".rank"
	
	print(new_file_name)
	AppManager.working_file_name = new_file_name
	AppManager.save_main_list_to_file(new_file_name)
	AppManager.load_main_list_from_file(new_file_name)
	
	get_tree().change_scene_to_file("res://Scenes/ListScene/ListScene.tscn")

func _on_credits_pressed() -> void:
	credits_popup.visible = true

func _on_close_button_pressed() -> void:
	credits_popup.visible = false
