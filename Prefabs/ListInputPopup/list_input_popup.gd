extends Control

func _on_add_button_pressed() -> void:
	var _new_string = $LineEdit.text
	
	AppManager.add_to_end(_new_string)
	self.queue_free()
