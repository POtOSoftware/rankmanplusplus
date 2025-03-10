extends Control

@onready var header_label = $Box/HeaderLabel
@onready var string_edit = $Box/LineEdit

signal string_submit(value: String)

func initialize_header(_header_label: String) -> void:
	header_label.text = _header_label

func _on_submit_button_pressed() -> void:
	string_submit.emit(string_edit.text)
