extends Control

@onready var header_label = $Box/HeaderLabel

signal answer(value: bool)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		#print("should be going back but we aint?")
		#print(AppManager.current_app_state)
		#if AppManager.current_app_state == "POPUP":
		answer.emit(false)

func initialize_header(_header_label: String) -> void:
	header_label.text = _header_label

func _on_yes_button_pressed() -> void:
	answer.emit(true)

func _on_no_button_pressed() -> void:
	answer.emit(false)
