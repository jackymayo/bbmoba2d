extends Node

func _ready():
	var AA = preload('res://Scripts/Abilities/AutoAttack.gd').new()
	AA.name = 'AutoAttack'
	add_child(AA)
