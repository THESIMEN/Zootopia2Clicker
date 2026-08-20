extends Node2D

@onready var label_money = $Control/LabelMoney
@onready var label_mps = $Control/LabelMoneyPerSecond
@onready var label_ad = $Control/AdButton/LabelAd
@onready var ad_button = $Control/AdButton
@onready var level_label = $Control/LevelLabel
@onready var level_progress = $Control/LevelProgress
var ad_watch = false
var last_level := 0
var cloud_save_timer := 0.0

func _ready():
	get_viewport().focus_entered.connect(_focus_in)
	get_viewport().focus_exited.connect(_focus_out)
	
	Ads.ad_start.connect(_ad_start)
	Ads.ad_end.connect(_ad_end)

	Ads.boost_started.connect(_on_boost_started)
	Ads.boost_ended.connect(_on_boost_ended)

	if YandexSDK.is_working():
		YandexSDK.game_ready()
		await YandexSDK.game_initialized

		var cloud_data = await Save.load_cloud()

		if cloud_data.size() > 0:
			load_cloud_save(cloud_data)
		else:
			await Save.save_game_cloud()

	update_all_upgrades()
	update_ui()
	update_level_progress()
	update_character()
	update_background()

	await get_tree().process_frame

func _ad_start():
	ad_watch = true
	
	YandexSDK.gameplay_stopped()
	get_tree().paused = true

func _ad_end():
	ad_watch = false

	YandexSDK.gameplay_started()
	get_tree().paused = false
	$AudioStreamPlayer.play()

func _focus_in():
	if ad_watch == true:
		return

	YandexSDK.gameplay_started()
	get_tree().paused = false
	$AudioStreamPlayer.play()

func _focus_out():
	YandexSDK.gameplay_stopped()
	
	Save.save_game_cloud()
	
	get_tree().paused = true

func _on_boost_started():
	ad_button.disabled = true

func _on_boost_ended():
	ad_button.disabled = false

func update_all_upgrades():
	for cell in $Control/MenuShop/ShopPerClick/ScrollContainer/VBoxContainer.get_children():
		cell.update_ui()

	for cell in $Control/MenuShop/ShopPerSecond/ScrollContainer/VBoxContainer.get_children():
		cell.update_ui()

func update_ad_ui():
	if Ads.double_click_active:
		label_ad.text = tr("ad_double_click_active").format({
			"time": int(Ads.boost_time_left)
		})
	else:
		label_ad.text = tr("ad_double_click")

func update_ui():
	label_money.text = tr("money").format({"amount": Global.money})
	label_mps.text = tr("mps").format({"value": Global.moneyPerSecond})
	level_label.text = tr("level").format({"level": Global.player_level})
	label_ad.text = tr("ad_double_click")

func _physics_process(_delta):
	update_ui()

func _process(_delta):
	update_ad_ui()
	update_level_progress()
	update_character()
	update_background()

	cloud_save_timer += _delta

	if cloud_save_timer >= 5.0:
		cloud_save_timer = 0.0
		Save.save_game_cloud()
	
func _on_clicker_button_pressed() -> void:
	$ClickAudio.play()
	
	var click_value = Global.moneyPerClick

	if Ads.double_click_active:
		click_value *= 2

	Global.add_money(click_value)

	var click = load("res://Scene/Click_msg.tscn")
	var click_instance = click.instantiate()

	click_instance.set_value(click_value)

	click_instance.position = get_local_mouse_position()
	add_child(click_instance)

func _on_timer_timeout() -> void:
	Global.add_money(Global.moneyPerSecond)
	

func _on_close_shop_button_pressed() -> void:
	$Control/MenuShop.hide()
	$Control/ShopButton.show()


func _on_shop_button_pressed() -> void:
	$Control/ShopButton.hide()
	$Control/MenuShop.show()


func _on_money_per_click_button_pressed() -> void:
	$Control/MenuShop/ShopPerClick.show()
	$Control/MenuShop/ShopPerSecond.hide()


func _on_money_per_second_button_pressed() -> void:
	$Control/MenuShop/ShopPerSecond.show()
	$Control/MenuShop/ShopPerClick.hide()


func _on_ad_button_pressed() -> void:
	Ads.show_double_click_ad()
	print("AD BUTTON PRESSED")


func _on_volume_value_changed(value: float) -> void:
	var volume_db = linear_to_db(value / 100.0)
	$AudioStreamPlayer.volume_db = volume_db
	if value == 0:
		$Control/Volume/VolumeYes.visible = false
	else:
		$Control/Volume/VolumeYes.visible = true

func update_level_progress():
	var level = Global.player_level
	var earned = Global.total_earned
	
	var level_start := 0
	var level_end := 100
	
	match level:
		1:
			level_start = 0
			level_end = 250
		2:
			level_start = 250
			level_end = 2000
		3:
			level_start = 2000
			level_end = 50000
		4:
			level_start = 50000
			level_end = 200000
		5:
			level_start = 200000
			level_end = 750000
		6:
			level_start = 750000
			level_end = 2000000
		7:
			level_start = 2000000
			level_end = 5000000
		8:
			level_start = 5000000
			level_end = 12000000
		9:
			level_start = 12000000
			level_end = 50000000
		10:
			level_start = 50000000
			level_end = 150000000
	
	level_progress.min_value = 0
	level_progress.max_value = level_end - level_start
	
	var current_progress = earned - level_start
	
	level_progress.value = clamp(current_progress, 0, level_end - level_start)

func update_character():
	if Global.player_level == last_level:
		return
	
	last_level = Global.player_level
	
	var texture_path = "res://Assets/Sprunki/спрунки%d.png" % Global.player_level
	
	if ResourceLoader.exists(texture_path):
		$Control/ClickerButton.texture_normal = load(texture_path)

func update_background():
	var background_level = min(Global.player_level, 6)
	
	var texture_path = "res://Assets/Background/фон%d.png" % background_level
	
	if ResourceLoader.exists(texture_path):
		$UI/BG.texture = load(texture_path)

func load_cloud_save(data: Dictionary):
	Global.money = int(data.get("money", Global.money))
	Global.moneyPerSecond = int(data.get("moneyPerSecond", Global.moneyPerSecond))
	Global.moneyPerClick = int(data.get("moneyPerClick", Global.moneyPerClick))
	Global.total_earned = int(data.get("totalEarned", Global.total_earned))
	Global.player_level = int(data.get("playerLevel", Global.player_level))

	var cloud_upgrades = data.get("upgrades", "")

	if cloud_upgrades is String and not cloud_upgrades.is_empty():
		var parsed_upgrades = JSON.parse_string(cloud_upgrades)

		if parsed_upgrades is Dictionary:
			Global.upgrades = parsed_upgrades

	Save.SaveValue("Main", "Money", Global.money)
	Save.SaveValue("Main", "MoneyPerSecond", Global.moneyPerSecond)
	Save.SaveValue("Main", "MoneyPerClick", Global.moneyPerClick)
	Save.SaveValue("Main", "TotalEarned", Global.total_earned)
	Save.SaveValue("Main", "PlayerLevel", Global.player_level)
	Save.SaveValue("Shops", "Upgrades", Global.upgrades)
