extends PanelContainer


@onready var name_label = $MarginContainer/VBoxContainer/PanelContainer/NameLabel
@onready var description_label = $MarginContainer/VBoxContainer/DescriptionLabel
@onready var animation_player = $AnimationPlayer
@onready var progress_bar = $MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/ProgressBar
@onready var purchase_button = $MarginContainer/VBoxContainer/PurchaseButton
@onready var progress_label = %ProgressLabel
@onready var count_label = %CountLabel


var upgrade : MetaUpgrade

func set_meta_upgrade(u: MetaUpgrade):
	self.upgrade = u
	name_label.text = u.title
	description_label.text = u.description
	progress_bar.value = u.experience_cost
	update_progress()
	
	
func update_progress():
	var data = MetaProgression.save_data
	var quantity = 0
	if data[MetaProgression.META_UPGRADE_KEY].has(upgrade.id):
		quantity = data[MetaProgression.META_UPGRADE_KEY][upgrade.id]["quantity"]
	var is_maxed = quantity == upgrade.max_quantity
	var currency = data[MetaProgression.META_UPGRADE_CURRENCY_KEY]
	var percent = currency  / upgrade.experience_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	count_label.text = "x%d" % quantity
	
	progress_label.text = str(currency) + "/"+ str(upgrade.experience_cost)
	purchase_button.disabled = percent < 1 || is_maxed
	
	if is_maxed:
		purchase_button.text = "Max"	


func play_in(delay : float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")


func select_card():
	animation_player.play("selected")
	


func _on_purchase_button_pressed():
	if not upgrade:
		return
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data[MetaProgression.META_UPGRADE_CURRENCY_KEY] -= upgrade.experience_cost
	MetaProgression.save()
	update_progress()
	
	get_tree().call_group("meta_upgrade_card","update_progress")
	animation_player.play("selected")
