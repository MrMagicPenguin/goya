extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}



#ONSTART - Get all child nodes of State Machine and Check if States. Add to States Dict.
#When Transistion signal occurs, call on_child_transition
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transistioned.connect(on_child_transition)
			
			
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	
			
#ONFRAMEUPDATE - If there is a value for current_state call current_state.Update func
func _process(delta):
	if current_state:
		current_state.Update(delta)
		
#ONPHYSICSTICK - If there is a value for current_state call current_state.Physics_Update func
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)
		
#ONTRANSITIONSIGNAL - Check that transition state is not current_state 
func on_child_transition(state, new_state_name):
	if state != current_state:
		return
		
		#Look for new_state in states dict
	var new_state = states.get(new_state_name.to_lower())
	
	#TODO Add Error Handling Here
	if !new_state:
		return
	
	#Shuts Down current_state
	if current_state:
		current_state.Exit()
		
		#Starts Up new_state
	new_state.Enter()
	#Assigns new_state value to current_state
	current_state = new_state
