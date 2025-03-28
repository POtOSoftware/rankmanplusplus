extends Node

signal new_item_added
signal new_file_added

var working_file_name: String

#region Prefab variables
var pre_ListItem: PackedScene = preload("res://Prefabs/ListItem/ListItem.tscn")
var pre_FileItem: PackedScene = preload("res://Prefabs/FileItem/FileItem.tscn")
var pre_ListInput: PackedScene = preload("res://Prefabs/ListInputPopup/ListInputPopup.tscn")
var pre_StringInput: PackedScene = preload("res://Prefabs/StringInputPopup/StringInputPopup.tscn")
var pre_YesNoInput: PackedScene = preload("res://Prefabs/YesNoPopup/YesNoPopup.tscn")
var pre_NoteInput: PackedScene = preload("res://Prefabs/NoteInput/NoteInput.tscn")
#endregion

var list_container: Node = null
var file_list_container: Node = null

var main_list: Array: set = set_main_list
var main_list_backup: Array[String]

var note: String = ""

var new_item_signal: String = "new_item_added"
var new_file_signal: String = "new_file_added"

#enum APP_STATES {IDLE, POPUP}
# enums wont work the way they're supposed to so im doing the butt fuckery
#var current_app_state: String:
#	set(value):
#		print("CHANGING APP STATE TO " + value)

#region Save file handling
const FILE_PATH: String = "user://RankFiles/"
const RANK2_EXTENSION: String = ".rank2"
const RANK_EXTENSION: String = ".rank"
var rank2_file = ConfigFile.new()

# cant believe i have to rewrite the whole bullshit ass file system because now i decided to save notes to da file
# twas inevitable but whatever still annoying
func save_main_list_to_file(_file_name: String) -> void:
	printerr("!THIS SHOULDN'T BE USED ANYMORE!")
	print("SAVING/CONVERTING TO RANK2 ANYWAYS")
	#print("SAVING FILE TO " + FILE_PATH + _file_name)
	
	#var list_file = FileAccess.open(FILE_PATH + _file_name, FileAccess.WRITE)
	#list_file.store_string(str(main_list))
	#list_file.store_string(note)
	
	# i couldnt really be fucked to go through each script and change them all to rank2, so...
	# enjoy this hot shit of jank! :3c
	save_rank2_file(_file_name)
	
	#new_file_added.emit()

func load_main_list_from_file(_file_name: String) -> void:
	var list_file = FileAccess.open(FILE_PATH + _file_name, FileAccess.READ)
	print("LOADING FILE FROM " + FILE_PATH + _file_name)
	
	if list_file:
		reset_main_list()
		main_list = str_to_var(list_file.get_as_text())
	else:
		printerr("SOMETHING FUCKY HAPPENED!")
	#new_file_added.emit()

func save_rank2_file(_file_name: String) -> void:
	print("SAVING RANK2 FILE TO " + FILE_PATH + _file_name)
	rank2_file.set_value("rank2", "main_list", self.main_list)
	rank2_file.set_value("rank2", "note", self.note)
	
	if _file_name.get_extension() == "rank":
		rename_file(_file_name, _file_name.replace(".rank", ".rank2"))
		_file_name = _file_name.replace(".rank", ".rank2")
	
	if rank2_file.save(FILE_PATH + _file_name) == OK:
		print("SUCCESSFULLY SAVED RANK2 FILE " + FILE_PATH + _file_name)
	else:
		printerr("SOMETHING FUCKY HAPPENED!")
	
	new_file_added.emit()

func load_rank2_file(_file_name: String) -> void:
	if rank2_file.load(FILE_PATH + _file_name) == OK:
		print("LOADING RANK2 FILE FROM " + FILE_PATH + _file_name)
	else:
		printerr("COULDN'T LOAD THE FUCKING RANK2 FILE " + FILE_PATH + _file_name)
		return
	
	self.main_list = rank2_file.get_value("rank2", "main_list")
	self.note = rank2_file.get_value("rank2", "note")
	
	print("LOADED RANK2 FILE")

func rename_file(_old_name: String, _new_name: String):
	print("RENAMING " + _old_name + " TO " + _new_name)
	
	save_rank2_file(_new_name)
	working_file_name = _new_name
	
	delete_list_file(_old_name)
	# Then emit new item added to refresh the main scene just for visuals
	# since behind the scenes everything worked, but users complain a lot
	new_item_added.emit()

func delete_list_file(_file_name: String) -> void:
	print("DELETING " + _file_name)
	
	if DirAccess.remove_absolute(FILE_PATH + _file_name) == OK:
		print("SUCESSFULLY DELETED " + _file_name)
	else:
		printerr("ERROR DELETING " + _file_name)
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
	#current_app_state = "POPUP"
	YesNoInstance.initialize_header(_header_label)
	
	var result: bool = await YesNoInstance.answer
	
	get_tree().get_root().remove_child(YesNoInstance)
	
	return result

func create_list_item_input() -> void:
	var ListInputInstance = pre_ListInput.instantiate()
	
	get_tree().get_root().add_child(ListInputInstance)

func create_string_input(_header_label: String = "PLACEHOLDER", _default_text: String = "") -> String:
	var StringInputInstance = pre_StringInput.instantiate()
	
	get_tree().get_root().add_child(StringInputInstance)
	#current_app_state = "POPUP"
	StringInputInstance.initialize_header(_header_label, _default_text)
	
	var result: String = await StringInputInstance.string_submit
	
	get_tree().get_root().remove_child(StringInputInstance)
	
	return result

func create_note_input() -> void:
	var NoteInputInstance = pre_NoteInput.instantiate()
	
	get_tree().get_root().add_child(NoteInputInstance)
	NoteInputInstance.initialize_note(self.note)
#endregion

#region Main List manipulation
func set_main_list(_new_list: Array) -> void:
	#update_undo_list()

	main_list = _new_list
	new_item_added.emit()

func reset_main_list() -> void:
	#update_undo_list(main_list)

	main_list = []

func add_to_start(_input_item: String) -> void:
	update_undo_list()
	
	main_list.insert(0, _input_item)
	new_item_added.emit()

func add_to_middle(_input_item: String) -> void:
	update_undo_list()
	
	var list_middle: int = main_list.size() / 2
	main_list.insert(list_middle, _input_item)
	new_item_added.emit()

func add_to_end(_input_item: String) -> void:
	update_undo_list()
	
	main_list.append(_input_item)
	new_item_added.emit()

func remove_index_from_list(_item_to_remove: int) -> void:
	update_undo_list()
	
	main_list.remove_at(_item_to_remove)
	new_item_added.emit()

func update_index_in_list(_index: int, _new_string: String) -> void:
	update_undo_list()
	
	main_list.remove_at(_index)
	main_list.insert(_index, _new_string)
	new_item_added.emit()
#endregion

#region Undoing functions
func update_undo_list(_list_to_add: Array = main_list) -> void:
	print("BACKING UP " + str(_list_to_add) + " TO UNDO LIST")
	# I have to convert the array to a string because that's the only way appending the array would work properly
	main_list_backup.append(str(_list_to_add))
	print("UPDATED UNDO LIST: " + str(main_list_backup))

func undo_main_list() -> void:
	# Grab the last list state from the main list backup
	var previous_list_state: String
	if main_list_backup.size() != 0: # check if the backup list isn't empty
		previous_list_state = main_list_backup[-1] # set it if so
	else:
		print("Nothing to undo!")
		return # exit function if no
	
	#print(previous_list_state)
	print("UNDOING " + str(main_list) + " TO " + str(previous_list_state))
	
	# Can't use set_main_list() since that makes a backup too, so we doing this directly nya
	main_list = str_to_var(previous_list_state) # Convert the string back to array
	new_item_added.emit()
	
	# Remove the last undo state so we can roll back even further
	main_list_backup.pop_back()

func clear_undo_list() -> void:
	# this is only really gonna be needed right at the start after loading in a rank file
	print("CLEARING UNDO LIST")
	main_list_backup = []
#endregion
