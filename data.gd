class_name Data
extends Node

var player_data = {}  ## Player data.


## Check if the save directory exists.
func dir_exists(path: String, dir_name: String) -> bool:
	print("[Path: " + path + dir_name + "]")
	var dir: DirAccess = DirAccess.open(path)
	return dir.dir_exists(dir_name)


## Check if the save file exists.
func file_exists(path: String) -> bool:
	print("[Path: " + path + "]")
	return FileAccess.file_exists(path)


## Create the save directory.
func dir_create(path: String, dir_name: String):
	print("[Path: " + path + dir_name + "]")
	var dir: DirAccess = DirAccess.open(path)
	if dir:
		dir.make_dir_recursive(dir_name)
	else:
		printerr("An error occurred when trying to access the path.")


## Save data to file.
func save(path: String, password: String, data: Dictionary):
	print("[Path: " + path + "]")
	# Save player data with encryption pass
	var file: FileAccess = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, password)
	if file:
		file.store_var(data)
		file.close()


## Load data from file.
func load(path: String, password: String):
	var file: FileAccess = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, password)
	if file_exists(path):
		player_data = file.get_var()
		file.close()
		return player_data
	else:
		printerr("No saved data!")
