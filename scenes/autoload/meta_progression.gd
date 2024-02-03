extends Node


const META_UPGRADE_CURRENCY_KEY = "meta_upgrade_currency"
const META_UPGRADE_KEY = "meta_upgrades"

var save_data : Dictionary = {
	META_UPGRADE_CURRENCY_KEY : 0,
	META_UPGRADE_KEY : {},
}

#"2DSurvivorsCourse"
const SAVE_FILE_PATH = "user://game.save"

func _ready():
	GameEvents.exp_vial_collected.connect(on_collected)
	load_saved_file()
	
	
func load_saved_file():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()
	

func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)
	

func add_meta_upgrade(upgrade : MetaUpgrade):
	if not save_data[META_UPGRADE_KEY].has(upgrade.id):
		save_data[META_UPGRADE_KEY][upgrade.id] = {
			"quantity" : 0
		} 
	save_data[META_UPGRADE_KEY][upgrade.id]["quantity"] += 1
	save()
	
func get_upgrade_count(id: String):
	if save_data[META_UPGRADE_KEY].has(id):
		return save_data[META_UPGRADE_KEY][id]["quantity"]
	return 0

		
func on_collected(number : float):
	save_data[META_UPGRADE_CURRENCY_KEY] += number

