extends Control

@onready var note_input: Node = $TextEdit

func initialize_note(_note: String = ""):
	note_input.text = _note

func _on_save_button_pressed() -> void:
	print(note_input.text)
	AppManager.note = note_input.text
	AppManager.save_rank2_file(AppManager.working_file_name)
	self.queue_free()

func _on_cancel_pressed() -> void:
	# only warn the user if the note has actually been modified
	if note_input.text != AppManager.note:
		# quit note input without saving if user presses yes on da popup
		if await AppManager.create_yes_no_input("Unsaved changes will be lost! Are you sure?"):
			self.queue_free()
	else:
		self.queue_free()
