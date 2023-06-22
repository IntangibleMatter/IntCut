extends CanvasLayer

@onready var dialogue_display = $DialogueDisplay
@onready var cinebars_display = $CinebarsDisplay

@onready var icutils := IntCutUtils.new()

signal dialogue_line_done

func cinebars(toggle: bool) -> void:
	cinebars_display.toggle_bars(toggle)
#

func say(actor: Node2D, line: String, pos: int, callables: Array[Callable]) -> void:
	pass


func say_multi(actor: Node2D, lines: PackedStringArray, pos: PackedInt32Array, callables: Array[Callable]) -> void:
	pass
