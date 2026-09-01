extends CanvasLayer


@onready var main = $"../"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_resume_pressed() -> void:
	main.pauseMenu()


func _on_return_pressed() -> void:
	SceneTransition.transition("res://hubWorldPlayable.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
