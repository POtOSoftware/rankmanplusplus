extends Control

@onready var text_input = $Box/LineEdit

func _ready():
	connect("focus_entered", self.js_text_entry)

func js_text_entry():
	text_input.text = JavaScriptBridge.eval(
			"prompt('%s', '%s');" % ["Please enter text:", text_input.text], 
			true
			)
	
	release_focus()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		self.queue_free()

func _on_add_button_pressed() -> void:
	var _new_string = text_input.text
	
	AppManager.add_to_end(_new_string)
	self.queue_free()

func _on_add_to_start_pressed() -> void:
	var _new_string = text_input.text
	
	AppManager.add_to_start(_new_string)
	self.queue_free()

func _on_add_to_middle_pressed() -> void:
	var _new_string = text_input.text
	
	AppManager.add_to_middle(_new_string)
	self.queue_free()

func _on_close_button_pressed() -> void:
	self.queue_free()
