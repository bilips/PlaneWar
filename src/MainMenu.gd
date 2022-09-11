extends Control

onready var animation_player = $UI/Menu/AnimationPlayer
onready var bgm_btn = $UI/Menu/SettingMenu/BGM
onready var sfx_btn = $UI/Menu/SettingMenu/SFX



func _on_Start_pressed():
	$AnimationPlayer.play_backwards("EnterGame")
	yield($AnimationPlayer, "animation_finished")
	return get_tree().change_scene("res://src/Game.tscn")


func _on_Setting_pressed():
	animation_player.play("ShowSetting")


func _on_GamePlay_pressed():
	OS.alert("""
按住 ↑ ↓ ← → 进行飞机的移动，子弹会自动进行发射，按 Enter/Space 进行炸弹发射。
子弹和炸弹补给会在战斗中发放，有一定间隔时间。
祝您游戏愉快！
	""", "游戏玩法")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Back_pressed():
	animation_player.play_backwards("ShowSetting")


func _ready():
	Global.load_data()
	AudioServer.set_bus_mute(Global.bgm_index, !Global.bgm_enabled)
	AudioServer.set_bus_mute(Global.sfx_index, !Global.sfx_enabled)
	fresh()


func fresh():
	bgm_btn.text = "音乐：" + ("开" if Global.bgm_enabled else "关")
	sfx_btn.text = "音效：" + ("开" if Global.sfx_enabled else "关")


func _on_BGM_pressed():
	Global.bgm_enabled = !Global.bgm_enabled
	fresh()
	Global.save_data()


func _on_SFX_pressed():
	Global.sfx_enabled = !Global.sfx_enabled
	fresh()
	Global.save_data()
