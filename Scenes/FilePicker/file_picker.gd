extends Control

@onready var list_container = $ScrollContainer/VBoxContainer
@onready var credits_popup = $CreditsPopup
@onready var first_file_hint = $FirstFileHint
@onready var version_string = $CreditsPopup/Box/VersionString

func _ready() -> void:
	#AppManager.current_app_state = "IDLE"
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
	var files: Array = []
	
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
				files.append(file_name)
				#AppManager.create_file_item(file_name)
				found_files += 1
			file_name = dir.get_next()
		first_file_hint.visible = !(found_files > 0)
	else:
		printerr("SOMETHING FUCKY HAPPENED!")
	
	# long ass line to sort the files by their last modified time
	files.sort_custom(func(a, b): return FileAccess.get_modified_time(AppManager.FILE_PATH + a) > FileAccess.get_modified_time(AppManager.FILE_PATH + b))
	
	for file in files:
		# then create da files in the newly sorted array nya :3
		AppManager.create_file_item(file)

func _on_new_button_pressed() -> void:
	var new_file_name = await AppManager.create_string_input("New file name:") + AppManager.RANK2_EXTENSION
	
	print(new_file_name)
	AppManager.working_file_name = new_file_name # let the app know that this is the file name it's going to be working in and modifying
	AppManager.save_rank2_file(new_file_name) # create that new file
	AppManager.load_rank2_file(new_file_name) # then load that file
	
	# then switch on over to the list scene
	get_tree().change_scene_to_file("res://Scenes/ListScene/ListScene.tscn")

func _on_credits_pressed() -> void:
	credits_popup.visible = true

func _on_close_button_pressed() -> void:
	credits_popup.visible = false

func _on_git_hub_link_pressed() -> void:
	OS.shell_open("https://github.com/POtOSoftware/rankmanplusplus")

func _on_itch_link_pressed() -> void:
	OS.shell_open("https://poto-software.itch.io/")
