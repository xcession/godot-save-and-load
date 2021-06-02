extends Control

const SAVE_DIR = "user://saves/"

onready var console_label = $VBoxContainer/PanelContainer/VBoxContainer/ConsoleLabel

var save_path = SAVE_DIR + "save.dat"

func _ready():
	console_write("Ready!")

func _on_SaveButton_pressed():
	var data = {
		"name" : "Paw Bearer",
		"jump_height" : 2.5,
		"max_health" : 6,
		"health" : 4,
		"strengh" : 11,
	}
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "iddqd")
	if error == OK:
		file.store_var(data)
		file.close()
	
	console_write("Data saved.")

func _on_LoadButton_pressed():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, "iddqd")
		if error == OK:
			var player_data = file.get_var()
			file.close()
			console_write(player_data)

	console_write("Data loaded.")

func console_write(value):
	console_label.text += str(value) + "\n"
