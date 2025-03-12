extends Control

@onready var text_input = $Box/LineEdit

func _ready():
	text_input.grab_focus()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		exit_popup()

func _on_add_button_pressed() -> void:
	var _new_string = text_input.text
	
	AppManager.add_to_end(_new_string)
	exit_popup()

func _on_add_to_start_pressed() -> void:
	var _new_string = text_input.text
	
	AppManager.add_to_start(_new_string)
	exit_popup()

func _on_add_to_middle_pressed() -> void:
	var _new_string = text_input.text
	
	AppManager.add_to_middle(_new_string)
	exit_popup()

func _on_close_button_pressed() -> void:
	exit_popup()

func exit_popup() -> void:
	#AppManager.current_app_state = AppManager.APP_STATES.IDLE
	self.queue_free()
