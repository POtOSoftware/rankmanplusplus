extends Control

@onready var header_label = $Box/HeaderLabel
@onready var string_edit = $Box/LineEdit

signal string_submit(value: String)

#func _ready():
#	connect("focus_entered", self.js_text_entry)

#func js_text_entry():
#	string_edit.text = JavaScriptBridge.eval(
#			"prompt('%s', '%s');" % ["Please enter text:", string_edit.text], 
#			true
#			)
#	
#	release_focus()

func initialize_header(_header_label: String) -> void:
	header_label.text = _header_label
	string_edit.grab_focus()

func _on_submit_button_pressed() -> void:
	string_submit.emit(string_edit.text)

func _on_close_button_pressed() -> void:
	AppManager.current_app_state = AppManager.APP_STATES.IDLE
	self.queue_free()
