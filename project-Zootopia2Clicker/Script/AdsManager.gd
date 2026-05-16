extends Node

signal boost_started
signal boost_ended
signal ad_start
signal ad_end

var double_click_active := false

var boost_time := 30.0
var boost_time_left := 0.0
var reward_granted := false

func _ready():
	if YandexSDK and YandexSDK.has_signal("rewarded_ad"):
		YandexSDK.rewarded_ad.connect(_on_rewarded_ad)


func show_double_click_ad():
	if not YandexSDK.is_working():
		activate_boost()
		return

	YandexSDK.show_rewarded_ad()


func _on_rewarded_ad(result):
	match result:
		"opened":
			ad_start.emit()

		"rewarded":
			if not reward_granted:
				reward_granted = true
				activate_boost()

		"closed", "error":
			ad_end.emit()
			reward_granted = false

func activate_boost():
	ad_end.emit()
	if double_click_active:
		return

	reward_granted = false
	double_click_active = true
	boost_time_left = boost_time

	boost_started.emit()


	while boost_time_left > 0:
		await get_tree().create_timer(1.0).timeout
		boost_time_left -= 1

	double_click_active = false
	boost_ended.emit()
