extends CanvasLayer

@onready var dialogue_display = $DialogueDisplay
@onready var cinebars_display = $CinebarsDisplay

@onready var icutils := IntCutUtils.new()

signal dialogue_line_done

func cinebars(toggle: String) -> void:
	cinebars_display.toggle_bars(toggle)

func say(actor: Node2D, line: String, dialogue_continues: bool, length: float = -1) -> void:
	pass
