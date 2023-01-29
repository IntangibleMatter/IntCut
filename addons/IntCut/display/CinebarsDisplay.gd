extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func toggle_bars(toggle: String) -> void:
	match toggle:
		"on":
			animation_player.play("show_bars")
		"off":
			animation_player.play("hide_bars")

