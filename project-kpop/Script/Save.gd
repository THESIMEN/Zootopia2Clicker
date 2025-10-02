extends Node

var savePath = "res://GameSaves/save-file.cfg"
var config = ConfigFile.new()
var loadRespone = config.load(savePath)

func SaveValue(section, key, value):
	config.set_value(section, key, value)
	config.save(savePath)
	
func LoadValue(section, key, default):
	return config.get_value(section, key, default)
	
