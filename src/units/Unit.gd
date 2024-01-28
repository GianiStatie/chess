extends Node2D
class_name Unit

@onready var sprites = $Sprites
@onready var player = $AnimationPlayer

var unit_type = "pawn"
var unit_side = "blue"

var is_selected = false
var is_hovered = false

var has_moved = false

signal was_selected(unit)
signal was_unselected(unit)


func _input(event):
	if event is InputEventMouseButton:
		if not is_hovered and is_selected:
			unselect()

func init(unit_info):
	unit_type = unit_info["unit_type"]
	unit_side = unit_info["unit_side"]

func _ready():
	sprites.update_sprites(
		Constants.UNITS[unit_type]["sprites"],
		Constants.PALETTES[unit_side]
	)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("LeftMouseClick"):
		is_selected = true
		player.play("Idle")
		emit_signal("was_selected", self)

func unselect():
	is_selected = false
	player.play("RESET")
	emit_signal("was_unselected", self)

func _on_area_2d_mouse_entered():
	is_hovered = true

func _on_area_2d_mouse_exited():
	is_hovered = false
