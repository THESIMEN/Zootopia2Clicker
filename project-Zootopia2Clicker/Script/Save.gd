extends Node

var savePath = "res://GameSaves/Save-file.cfg"
var config = ConfigFile.new()

var cloud_loaded := false
var cloud_data: Dictionary = {}


func _ready():
	config.load(savePath)


func SaveValue(section, key, value):
	config.set_value(section, key, value)
	config.save(savePath)


func LoadValue(section, key, default):
	return config.get_value(section, key, default)


func load_cloud() -> Dictionary:
	if not YandexSDK.is_working():
		return {}

	if not YandexSDK.is_player_initialized:
		YandexSDK.init_player()
		await YandexSDK.player_initialized

	cloud_loaded = false
	cloud_data = {}

	YandexSDK.data_loaded.connect(_on_cloud_data_loaded, CONNECT_ONE_SHOT)
	YandexSDK.load_all_data()

	await YandexSDK.data_loaded

	return cloud_data


func _on_cloud_data_loaded(data):
	cloud_data = data
	cloud_loaded = true


func save_cloud(data: Dictionary, force := true):
	if not YandexSDK.is_working():
		return

	if not YandexSDK.is_player_initialized:
		YandexSDK.init_player()
		await YandexSDK.player_initialized

	YandexSDK.save_data(data, force)


func save_game_cloud():
	if not YandexSDK.is_working():
		return

	var data := {
		"money": Global.money,
		"moneyPerSecond": Global.moneyPerSecond,
		"moneyPerClick": Global.moneyPerClick,
		"totalEarned": Global.total_earned,
		"playerLevel": Global.player_level,
		"upgrades": JSON.stringify(Global.upgrades)
	}

	await save_cloud(data, true)

	await save_cloud(data, true)
