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
	var dir: DirAccess = DirAccess.open(DATA_DIR)
	if !dir.dir_exists(DATA_DIR):
		return false
	else:
		return true


# Check for existing save file
func data_file_check():
	var file: FileAccess = FileAccess.open(FILE_NAME, FileAccess.READ)
	if !file.file_exists(FILE_NAME):
		file.close()
		return false
	else:
		file.close()
		return true


# Create a save directory
func data_dir_create():
	var dir: DirAccess = DirAccess.open(DATA_DIR)
	if !dir.dir_exists(DATA_DIR):
		dir.make_dir_recursive(DATA_DIR)


# Save data
func data_save():
	# Save player data with encryption pass
	var file: FileAccess = FileAccess.open_encrypted_with_pass(FILE_NAME, FileAccess.WRITE, PWD)
	if file:
		file.store_var(player_data)
		file.close()


# Load data
func data_load():
	var file: FileAccess = FileAccess.open_encrypted_with_pass(FILE_NAME, FileAccess.READ, PWD)
	if file.file_exists(FILE_NAME):
		player_data = file.get_var()
		file.close()
	else:
		printerr("No saved data!")
