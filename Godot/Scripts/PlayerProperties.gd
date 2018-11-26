""" Suggested design:

	All objects would have a form of property script to simulate member variables.
	Therefore, we can properly separate the implementation with different child scripts
	which simply calls the getters and setters.
	
	e.g.

	var properties = get_parent()
	movementSpeed = properties.get("movementSpeed") 
	
	This approach might be a bit overkill with all the getters and settings
	so I'm open for suggestions. (But it ensures that correct assumptions and restrictions
	are made)
	

	We'd also have to ensure constant tracking of those variables.
	(Possibly on change events in specific cases)

"""
extends Node

# List of variables that have some base or no base value
var movementSpeed = 150

func get(variable):
	""" Apply any rules that is needed for a getter
	
	Args:
		string name of variable that needs to be access
		
	Return:
		the variable name
	""" 
	
	match variable: 
		"movementSpeed":
			return movementSpeed
		_: # Default case
			# logErrorAndCrashGame()
			print()
	

func set(variable):
	""" Apply any rules that is needed for a getter
	
	Args:
		string name of variable that needs to be access
		
	"""
	
	match variable:
		"movementSpeed":
			return movementSpeed
		_: 
			# logErrorAndCrashGame()
			print()

func _ready():
	pass