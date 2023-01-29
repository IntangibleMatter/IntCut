extends CanvasLayer

@onready var dialogue_display = $DialogueDisplay
@onready var cinebars_display = $CinebarsDisplay

@onready var icutils := IntCutUtils.new()

func cinebars(toggle: String) -> void:
	cinebars_display.toggle_bars(toggle)

func say(actor: Node2D, line: String, length: float = -1) -> void:
	pass
