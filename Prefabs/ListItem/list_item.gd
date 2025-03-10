extends Control

@onready var item_label: Node = $Label

func initialize(_text: String):
	item_label.text = _text
	self.custom_minimum_size = Vector2(1080, 150)
