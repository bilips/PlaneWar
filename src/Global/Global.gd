extends Node

const save_path = "user://data.cfg"
const bgm_index = 1
const sfx_index = 2

var bgm_enabled = true setget set_bgm_enabled, is_bgm_enabled
var sfx_enabled = true setget set_sfx_enabled, is_sfx_enabled
var best_score = 0 setget set_best_score, get_best_score

func load_data():
	var config = ConfigFile.new()
	var err = config.load(save_path)
	
	if err != OK:
		return
	
	bgm_enabled = config.get_value("Audio", "BGM")
	sfx_enabled = config.get_value("Audio", "SFX")
	best_score = config.get_value("Game", "BestScore")


func save_data():
	var config = ConfigFile.new()
	config.set_value("Audio", "BGM", bgm_enabled)
	config.set_value("Audio", "SFX", sfx_enabled)
	config.set_value("Game", "BestScore", best_score)
	config.save(save_path)


func set_bgm_enabled(value: bool):
	AudioServer.set_bus_mute(bgm_index, !value)
	bgm_enabled = value


func is_bgm_enabled():
	return bgm_enabled


func set_sfx_enabled(value: bool):
	AudioServer.set_bus_mute(sfx_index, !value)
	sfx_enabled = value


func is_sfx_enabled():
	return sfx_enabled


func set_best_score(value: int):
	best_score = value
	save_data()


func get_best_score():
	return best_score

