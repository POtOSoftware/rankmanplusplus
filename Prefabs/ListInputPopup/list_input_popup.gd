extends Control

func _on_add_button_pressed() -> void:
	var _new_string = $LineEdit.text
	
	AppManager.add_to_end(_new_string)
	self.queue_free()

func _on_add_to_start_pressed() -> void:
	var _new_string = $LineEdit.text
	
	AppManager.add_to_start(_new_string)
	self.queue_free()

func _on_add_to_middle_pressed() -> void:
	var _new_string = $LineEdit.text
	
	AppManager.add_to_middle(_new_string)
	self.queue_free()
