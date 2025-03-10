extends Control

@onready var item_label: Node = $Label

func initialize(_text: String, _index: int):
	item_label.text = str(_index) + ". " + _text
	self.custom_minimum_size = Vector2(1080, 150)
