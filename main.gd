extends Control

# Define nodes
@onready var player_name = $MainContainer/DataContainer/DataPanel/Container/Name
@onready var player_base = $MainContainer/DataContainer/DataPanel/Container/Base
@onready var player_job = $MainContainer/DataContainer/DataPanel/Container/Job
@onready var player_class = $MainContainer/DataContainer/DataPanel/Container/Class
@onready var console = $MainContainer/ConsolePanel/Container/Console
@onready var alert = $DialogContainer/Alert


func _ready():
	# Check for existing save data
	console_println("Check for existing save data...")
	var data_dir_exist = Data.data_dir_check()
	print("Data directory exist = " + str(data_dir_exist))
	var data_file_exist = Data.data_file_check()
	print("Data file exist = " + str(data_file_exist))
	# Save directory existed
	if data_dir_exist:
		console_print("Save directory existed.")
		# Save file existed
		if data_file_exist:
			console_println("Save file existed.")
		# Save file does not exist
		else:
			console_print("Save file does not exist.")
			console_print("Creating a save file...")
			# Create a save file
			collect_player_data()
			Data.data_save()
			console_println("Save file created.")
	# Save directory does not exist
	else:
		console_print("Save directory does not exist.")
		console_print("Creating a save directory...")
		# Create a save directory
		Data.data_dir_create()
		console_print("Save directory created.")
		# Create a save file
		collect_player_data()
		Data.data_save()
		console_println("Save file created.")
	
	console_println("READY!")


func _on_Clear_pressed():
	player_name.text = ""
	player_base.get_line_edit().text = "1"
	player_job.get_line_edit().text = "1"
	player_class.text = "Acolyte"
	console_println("Cleared.")


func _on_SaveButton_pressed():
	# If player name is empty
	if player_name.text == "":
		alert.dialog_text = "Please enter a player name."
		alert.popup()
	else:
		collect_player_data()
		Data.data_save()
		console_print("Data saved.")
		console_println(Data.player_data)


func _on_LoadButton_pressed():
	Data.data_load()
	player_name.text = Data.player_data["name"]
	player_base.get_line_edit().text = str(Data.player_data["level"]["base"])
	player_job.get_line_edit().text = str(Data.player_data["level"]["job"])
	player_class.text = Data.player_data["class"]
	console_print("Data loaded.")
	console_println(Data.player_data)


# Collect player data
func collect_player_data():
	Data.player_data = {
			"name": player_name.text,
			"level": {
				"base": int(player_base.get_line_edit().text),
				"job": int(player_job.get_line_edit().text),
			},
			"class": player_class.text,
		}


# Console print
func console_print(value):
	console.text += str(value) + "\n"
	# Auto scroll
	console.scroll_vertical = INF


# Console print with separator
func console_println(value):
	console.text += str(value) + "\n"
	console.text += "----------\n"
	# Auto scroll
	console.scroll_vertical = INF
