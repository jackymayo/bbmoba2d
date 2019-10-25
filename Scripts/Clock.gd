extends Node

""" Unused utility. """

"""
Clock interface for unified timing and pausing or reconnection etc.

@pre assumes the OS.get_ticks_msec() return does not overflow
"""

var is_active = false
var clock_offset = 0
var ticks_clock_paused_at = 0


func time_ms():
	return OS.get_ticks_msec() - clock_offset

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	clock_offset = OS.get_ticks_msec()
	is_active = true

func _pause():
	if !is_active:
		print("Clock warning: pausing already paused clock")
	# Save time at which pause was called
	ticks_clock_paused_at = OS.get_ticks_msec()
	is_active = false

func _resume():
	if is_active:
		print("Clock warning: resuming already active clock")
	# Update clock offset due to paused duration
	clock_offset += OS.get_ticks_msec() - ticks_clock_paused_at
	is_active = true

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
