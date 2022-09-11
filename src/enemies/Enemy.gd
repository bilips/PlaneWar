extends Area2D

export var lives = 1
export var fly_speed = 500
export var score = 10

onready var animated_sprite = $AnimatedSprite
onready var progress_bar = $ProgressBar
onready var fly_down = $FlyDown
onready var dead = $dead

onready var styles = [
	preload("res://res/styles/PB_Green.tres"),
	preload("res://res/styles/PB_Yellow.tres"),
	preload("res://res/styles/PB_Red.tres")
]

signal dead(score)

func _ready():
	progress_bar.max_value = lives
	
	var window_width = OS.window_size.x
	
	var half_width = animated_sprite.frames.get_frame("idle", 0).get_width() / 2
	var full_height = animated_sprite.frames.get_frame("idle", 0).get_height()
	
	position.x = rand_range(half_width, window_width - half_width)
	position.y = -full_height
	
	if fly_down.stream:
		fly_down.play()

func hit():
	lives -= 1
	progress_bar.value = lives
	
	if lives == 0:
		emit_signal("dead", score)
		set_deferred("monitorable", false)
		dead.play()
		animated_sprite.play("dead")
		yield(animated_sprite, "animation_finished")
		queue_free()
		return
	
	var percent = lives / progress_bar.max_value
	if percent > 0.7:
		progress_bar.set("custom_styles/fg", styles[0])
	elif percent > 0.4:
		progress_bar.set("custom_styles/fg", styles[1])
	else:
		progress_bar.set("custom_styles/fg", styles[2])
	
	if animated_sprite.frames.has_animation("hit"):
		animated_sprite.play("hit")
		yield(get_tree().create_timer(0.1), "timeout")
		animated_sprite.play("idle")

func _process(delta):
	position.y += fly_speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Enemy_area_entered(area):
	area.hit()
	lives = 1
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	hit()


func kill():
	lives = 1
	score = 0
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	hit()
