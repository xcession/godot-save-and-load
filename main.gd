extends Control


# Define file and directory names.
const PATH = "user://"
const DIR_NAME = "saves"  ## Save directory name.
const FILE_NAME = "save.dat"  ## Save file name.
const FILE_PATH = PATH + DIR_NAME + "/" + FILE_NAME

const PWD = "iddqd"  # Encryption password.

const CLASSES = [
	"Swordman",
	"Acolyte",
	"Mage",
	"Thief",
	"Archer",
]

# Instantiate data object.
var data = Data.new()


# Export nodes.
@export var _player_name: LineEdit
@export var _player_base: SpinBox
@export var _player_job: SpinBox
@export var _player_class: OptionButton
@export var _alert: AcceptDialog
@export var _console: TextEdit


func _ready() -> void:
	for c in CLASSES:  # Populate the class option button.
		_player_class.add_item(c)
	
	_set_default_values()
	
	console_print("Checking for existing save data...", true)
	if data.dir_exists(PATH, DIR_NAME):  # Save directory already exists.
		console_print("Save directory already exists.", true)
		if data.file_exists(FILE_PATH):  # Save file already exists.
			console_print("Save file already exists.", true)
		else:  # Save file does not exists.
			console_print("Save file does not exists.", true)
			console_print("Creating a save file...", false)
			_collect_player_data()
			_save_player_data()
			console_print("Save file created.", true)
	else:  # Save directory does not exists.
		console_print("Save directory does not exists.", true)
		console_print("Creating a save directory...", false)
		data.dir_create(PATH, DIR_NAME)  # Create save directory,
		console_print("Save directory created.", true)
		console_print("Creating a save file...", false)
		_collect_player_data()
		_save_player_data()
		console_print("Save file created.", true)
	
	console_print("READY!", true)


func _set_default_values():
	_player_name.text = ""
	_player_base.get_line_edit().text = "1"
	_player_job.get_line_edit().text = "1"
	_player_class.select(0)


func _on_Clear_pressed():
	_set_default_values()
	console_print("Cleared.", true)


func _on_SaveButton_pressed():
	if _player_name.text == "":  # If the player name is empty.
		console_print("Enter a player name.", false)
		_alert.dialog_text = "Enter a player name."
		_alert.popup()
	else:
		_collect_player_data()
		_save_player_data()
		console_print("Data saved.", false)
		console_print(str(data.player_data), true)


func _on_LoadButton_pressed():
	data.load(FILE_PATH, PWD)  # Load player data from file.
	_player_name.text = data.player_data["name"]
	_player_base.get_line_edit().text = str(data.player_data["level"]["base"])
	_player_job.get_line_edit().text = str(data.player_data["level"]["job"])
	_player_class.select(data.player_data["class"])
	console_print("Data loaded.", false)
	console_print(str(data.player_data), true)


# Collect player data.
func _collect_player_data():
	data.player_data = {
			"name": _player_name.text,
			"level": {
				"base": int(_player_base.get_line_edit().text),
				"job": int(_player_job.get_line_edit().text),
			},
			"class": _player_class.selected,
		}


# Save player data to file.
func _save_player_data():
	data.save(FILE_PATH, PWD, data.player_data)


# Print text on the console.
func console_print(value: String, with_separator: bool) -> void:
	var separator = "----------"
	print(value)
	_console.text += value + "\n"
	if with_separator:
		print(separator)
		_console.text += separator + "\n"
	_console.scroll_vertical = INF  # Auto scroll
