extends ColorRect

@onready var anim: AnimationPlayer = $AnimationPlayer


func transition():
	anim.play("transition")
	await anim.animation_finished
	Global.respawning = true
	Global.lives -= 1
	$Label.text = "Lives: " + str(Global.lives)
	anim.play_backwards("transition")
