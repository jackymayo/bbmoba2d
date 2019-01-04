extends Node

func _ready():
	var fredUlt = preload('res://Scripts/fredUlt.gd').new()
	fredUlt.name = 'fredUlt'
	add_child(fredUlt)
