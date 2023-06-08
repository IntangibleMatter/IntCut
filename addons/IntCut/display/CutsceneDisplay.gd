extends CanvasLayer

@onready var dialogue_display = $DialogueDisplay
@onready var cinebars_display = $CinebarsDisplay

@onready var icutils := IntCutUtils.new()

signal dialogue_line_done

func cinebars(toggle: bool) -> void:
	cinebars_display.toggle_bars(toggle)
#
#func say(actor: Node2D, line: String, continues: bool, pos: int, callables: Array[Callable] length: float) -> void:
#	var lines : PackedStringArray = line.split("`")
#	pass
