extends Control


# Define file and directory names.
const PATH: String = "user://"
const DIR_NAME: String = "saves"  ## Save directory name.
const FILE_NAME: String = "save.dat"  ## Save file name.
const FILE_PATH: String = PATH + DIR_NAME + "/" + FILE_NAME

const PWD: String = "iddqd"  # Encryption password.

const CLASSES: Array = [
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
			_save_player_data(_get_player_data())
			console_print("Save file created.", true)
	else:  # Save directory does not exists.
		console_print("Save directory does not exists.", true)
		console_print("Creating a save directory...", false)
		data.dir_create(PATH, DIR_NAME)  # Create save directory,
		console_print("Save directory created.", true)
		console_print("Creating a save file...", false)
		_save_player_data(_get_player_data())
		console_print("Save file created.", true)
	
	console_print("READY!", true)


func _set_default_values() -> void:
	_player_name.text = ""
	_player_base.get_line_edit().text = "1"
	_player_job.get_line_edit().text = "1"
	_player_class.select(0)


func _on_Clear_pressed() -> void:
	_set_default_values()
	console_print("Cleared.", true)


func _on_SaveButton_pressed() -> void:
	if _player_name.text == "":  # If the player name is empty.
		console_print("Enter a player name.", false)
		_alert.dialog_text = "Enter a player name."
		_alert.popup()
	else:
		var _player_data = _get_player_data()
		_save_player_data(_player_data)
		console_print("Data saved.", false)
		console_print(str(_player_data), true)


func _on_LoadButton_pressed() -> void:
	var _player_data = data.load(FILE_PATH, PWD)  # Load player data from file.
	_player_name.text = _player_data["name"]
	_player_base.get_line_edit().text = str(_player_data["level"]["base"])
	_player_job.get_line_edit().text = str(_player_data["level"]["job"])
	_player_class.select(_player_data["class"])
	console_print("Data loaded.", false)
	console_print(str(_player_data), true)


# Collect player data.
func _get_player_data() -> Dictionary:
	return {
			"name": _player_name.text,
			"level": {
				"base": int(_player_base.get_line_edit().text),
				"job": int(_player_job.get_line_edit().text),
			},
			"class": _player_class.selected,
		}


# Save player data to file.
func _save_player_data(player_data: Dictionary) -> void:
	data.save(FILE_PATH, PWD, player_data)


# Print text on the console.
func console_print(value: String, with_separator: bool) -> void:
	var separator = "----------"
	print(value)
	_console.text += value + "\n"
	if with_separator:
		print(separator)
		_console.text += separator + "\n"
	_console.set_v_scroll(_console.get_line_count())  # Auto scroll
