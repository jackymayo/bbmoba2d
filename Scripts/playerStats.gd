extends Node

# List of variables that have some base or no base value
export (int) var movementSpeed = 150

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