extends Node

signal exp_vial_collected(number: float)
signal ability_upgrades_added(upgrade: AbilityUpgrade, current_upgrade : Dictionary)
signal player_damage

func emit_exp_vital_collected(number: float):
	exp_vial_collected.emit(number)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrade : Dictionary):
	ability_upgrades_added.emit(upgrade, current_upgrade)

func emit_player_damage():
	player_damage.emit()
