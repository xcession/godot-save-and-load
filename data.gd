extends Node

# Define save directory
const DATA_DIR = "user://saves/"

# Define save file name
const FILE_NAME = DATA_DIR + "save.dat"

# Define encryption password
const PWD = "iddqd"

# Initialize empty player data dictionary
var player_data = {}


func _ready():
	pass


# Check for existing save directory
func data_dir_check():
	var dir = Directory.new()
	if !dir.dir_exists(DATA_DIR):
		return false
	else:
		return true


# Check for existing save file
func data_file_check():
	var file = File.new()
	if !file.file_exists(FILE_NAME):
		file.close()
		return false
	else:
		file.close()
		return true


# Create a save directory
func data_dir_create():
	var dir = Directory.new()
	if !dir.dir_exists(DATA_DIR):
		dir.make_dir_recursive(DATA_DIR)


# Save data
func data_save():
	var file = File.new()
	# Save player data with encryption pass
	var error = file.open_encrypted_with_pass(FILE_NAME, File.WRITE, PWD)
	if error == OK:
		file.store_var(player_data)
		file.close()


# Load data
func data_load():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		var error = file.open_encrypted_with_pass(FILE_NAME, File.READ, PWD)
		if error == OK:
			player_data = file.get_var()
			file.close()
	else:
		printerr("No saved data!")
