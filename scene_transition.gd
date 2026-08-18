extends ColorRect

@onready var anim: AnimationPlayer = $AnimationPlayer


func transition(scene : String):
	anim.play("transition")
	await anim.animation_finished
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(scene)
	await get_tree().create_timer(1).timeout
	anim.play_backwards("transition")
	
	
