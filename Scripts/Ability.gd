extends Node

class Ability:
	""" Virtual ability class
	Extend this script to use this interface. Does not need
	to be instanced.
	"""
	
	func _init():
		print("Don't init me bro")

	func validate(player):
		""" Returns whether or not the ability cast was valid. """
		print("Can't fire a non-existent ability")
		return false

	func construct_actor(player):
		""" Returns an actor to be constructed by a child of the scene tree. """
		print("Can't construct nothing")
		return null

	func spawn_particles(player):
		""" Returns collection of particles to be constructed by child of scene tree. """
		pass