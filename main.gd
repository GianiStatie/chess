extends Node2D

@onready var unit_manager = $UnitManager


func _ready():
	unit_manager.init_board()
