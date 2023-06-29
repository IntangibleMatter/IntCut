extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func toggle_bars(toggle: bool) -> void:
	if toggle:
		animation_player.play("show_bars")
	else:
		animation_player.play("hide_bars")

