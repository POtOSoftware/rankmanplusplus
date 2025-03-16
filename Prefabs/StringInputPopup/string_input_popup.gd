extends Control

@onready var header_label = $Box/HeaderLabel
@onready var string_edit = $Box/LineEdit

signal string_submit(value: String)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		exit_popup()

func initialize_header(_header_label: String, _default_text: String) -> void:
	header_label.text = _header_label
	string_edit.text = _default_text
	
	# set the cursor to the end of the string for convenience
	string_edit.set_caret_column(_default_text.length())
	string_edit.grab_focus()

func _on_submit_button_pressed() -> void:
	string_submit.emit(string_edit.text)

func _on_close_button_pressed() -> void:
	exit_popup()

func exit_popup() -> void:
	#AppManager.current_app_state = AppManager.APP_STATES.IDLE
	self.queue_free()
