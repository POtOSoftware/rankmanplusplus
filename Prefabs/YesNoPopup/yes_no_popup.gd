extends Control

@onready var header_label = $Box/HeaderLabel
@onready var string_edit = $Box/LineEdit

signal answer(value: bool)

func initialize_header(_header_label: String) -> void:
	header_label.text = _header_label

func _on_yes_button_pressed() -> void:
	answer.emit(true)

func _on_no_button_pressed() -> void:
	answer.emit(false)
