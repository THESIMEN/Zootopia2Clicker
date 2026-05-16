extends Node2D

@onready var label_money = $Control/LabelMoney
@onready var label_mps = $Control/LabelMoneyPerSecond
@onready var label_ad = $Control/AdButton/LabelAd
@onready var ad_button = $Control/AdButton

var ad_watch = false

func _ready():
	if YandexSDK.is_working():
		YandexSDK.init_game()
		await YandexSDK.game_initialized
		update_all_upgrades()
		update_ui()
		await get_tree().process_frame

		YandexSDK.game_ready()

	get_viewport().focus_entered.connect(_focus_in)
	get_viewport().focus_exited.connect(_focus_out)
	
	Ads.ad_start.connect(_ad_start)
	Ads.ad_end.connect(_ad_end)

	Ads.boost_started.connect(_on_boost_started)
	Ads.boost_ended.connect(_on_boost_ended)

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
	
	label_ad.text = tr("ad_double_click")

func _physics_process(_delta):
	update_ui()

func _process(_delta):
	update_ad_ui()
	
func _on_clicker_button_pressed() -> void:
	$ClickAudio.play()
	
	var click_value = Global.moneyPerClick

	if Ads.double_click_active:
		click_value *= 2

	Global.money += click_value
	
	Save.SaveValue("Main", "Money", Global.money)

	var click = load("res://Scene/Click_msg.tscn")
	var click_instance = click.instantiate()

	click_instance.set_value(click_value)

	click_instance.position = get_local_mouse_position()
	add_child(click_instance)

func _on_timer_timeout() -> void:
	Global.money += Global.moneyPerSecond
	Save.SaveValue("Main", "Money", Global.money)
	

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
