extends Control

@onready var text_input = $Box/LineEdit

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
