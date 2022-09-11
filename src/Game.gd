extends Node2D

onready var enemies = [
	preload("res://src/enemies/EnemySmall.tscn"),
	preload("res://src/enemies/EnemyMiddle.tscn"),
	preload("res://src/enemies/EnemyLarge.tscn")
]
onready var supplies = [
	preload("res://src/supplies/Double.tscn"),
	preload("res://src/supplies/Bomb.tscn")
]
onready var timers = [
	$Timer/EnamySmallAddTimer,
	$Timer/EnamyMiddleAddTimer,
	$Timer/EnamyLargeAddTimer,
	$Timer/SupplyTimer
]
onready var score_label = $CanvasLayer/Control/Score
onready var life_label = $CanvasLayer/Control/Life/LifeLabel
onready var bomb_label = $CanvasLayer/Control/Bomb/BombLabel

var bombs = 3


var timer_wait_time = [
	[0.5, 1.5],
	[2.0, 3.0],
	[3.5, 4.5],
	[8, 10]
]
var score = 0


func _process(_delta):
	score_label.text = "Score:%d" % score
	life_label.text = str($Player.lives)
	bomb_label.text = "%d ×" % bombs
	if Input.is_action_just_pressed("ui_accept"):
		if bombs > 0:
			bombs -= 1
			$UseBomb.play()
			for enemy in $Enemies.get_children():
				enemy.kill()


func _ready():
	randomize()


func game_start():
	Global.load_data()
	update_wait_time()
	$BGM.play()


func game_over():
	$GameOver.play()
	$BGM.stop()
	for timer in timers:
		timer.stop()
	$Enemies.hide()
	$Supplies.hide()
	var _score_label = $CanvasLayer/Control/GameOver/UI/Score
	var best_score_label = $CanvasLayer/Control/GameOver/UI/BestScore
	_score_label.text = "Score:%d" % score
	if score > Global.best_score:
		Global.best_score = score
		Global.save_data()
		best_score_label.text = "BestScore:%d" % score
	else:
		best_score_label.text = "BestScore:%d" % Global.best_score
	$CanvasLayer/AnimationPlayer.play("GameOver")


func update_wait_time():
	for index in range(len(timers)):
		timers[index].wait_time = rand_range(timer_wait_time[index][0], timer_wait_time[index][1])
	for timer in timers:
		timer.start()


func update_wait_time_from_index(index):
	timers[index].wait_time = rand_range(timer_wait_time[index][0], timer_wait_time[index][1])
	timers[index].start()


func create_enemy_from_index(index):
	var enemy: Area2D = enemies[index].instance()
	enemy.connect("dead", self, "add_score")
	$Enemies.add_child(enemy)
	update_wait_time_from_index(index)


func _on_EnamySmallAddTimer_timeout():
	create_enemy_from_index(0)


func _on_EnamyMiddleAddTimer_timeout():
	create_enemy_from_index(1)


func _on_EnamyLargeAddTimer_timeout():
	create_enemy_from_index(2)


func add_score(_score):
	score += _score


func add_bomb():
	if bombs < 3:
		bombs += 1


func _on_SupplyTimer_timeout():
	var supply = supplies[randi() % 2].instance()
	$Supplies.add_child(supply)
	update_wait_time_from_index(3)


func _on_PlayAgain_pressed():
	$CanvasLayer/AnimationPlayer.play_backwards("GameOver")
	yield($CanvasLayer/AnimationPlayer, "animation_finished")
	$CanvasLayer/AnimationPlayer.play_backwards("Show")
	yield($CanvasLayer/AnimationPlayer, "animation_finished")
	get_tree().reload_current_scene()


func _on_BackMenu_pressed():
	$CanvasLayer/AnimationPlayer.play_backwards("GameOver")
	yield($CanvasLayer/AnimationPlayer, "animation_finished")
	$CanvasLayer/AnimationPlayer.play_backwards("Show")
	yield($CanvasLayer/AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://src/MainMenu.tscn")


func _on_Quit_pressed():
	get_tree().quit()
