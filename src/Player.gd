extends Area2D

const speed = 300

var lives = 3

export var double = false
export var invincible = false

onready var animated_sprite = $AnimatedSprite
onready var shoot = $Shoot
onready var shoot_timer = $ShootTimer
onready var shoot_position = $ShootPosition
onready var mst = preload("res://src/Missile.tscn")


func _ready():
	set_process(false)


func hit():
	if !invincible:
		lives -= 1
		if lives == 0:
			$ShootTimer.stop()
			animated_sprite.play("dead")
			set_deferred("monitoring", false)
			set_deferred("monitorable", false)
			yield(animated_sprite, "animation_finished")
			hide()
			set_process(false)
			get_parent().game_over()
			return
		$AnimationPlayer.play("Hit")

func game_start():
	set_process(true)
	shoot_timer.start()


func _process(delta):
	var h_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var v_direction = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var direction = Vector2(h_direction, v_direction).normalized()
	
	position += direction * delta * speed
	
	var half_width = animated_sprite.frames.get_frame("idle", 0).get_width() / 2 - 12
	var half_height = animated_sprite.frames.get_frame("idle", 0).get_height() / 2
	var window_width = OS.window_size.x
	var window_height = OS.window_size.y
	
	position.x = clamp(position.x, half_width, window_width - half_width)
	position.y = clamp(position.y, half_height, window_height - half_height)


func _on_ShootTimer_timeout():
	var missiles = get_parent().get_node("Missiles")
	var missile = mst.instance()
	missile.global_position = shoot_position.global_position
	if double:
		missiles.add_child(missile)
		var _ms = mst.instance()
		_ms.global_position = shoot_position.global_position
		missiles.add_child(_ms)
		missile.set_target(25)
		_ms.set_target(-25)
	else:
		missiles.add_child(missile)
	shoot.play()

