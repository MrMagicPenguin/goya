extends PanelContainer

@onready var property_container = $MarginContainer/VBoxContainer

var frames_per_second : String

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Set global reference to self in Global Singleton
	Global.debug = self
	
	# Hide Debug Panel on load
	visible = false

	#add_debug_property("FPS","frames_per_second")

func _process(delta):
	# Check if Debug Panel is active before checking FPS
	if visible:
		frames_per_second = "%.2f" % (1.0/delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	#Toggle Debug Panel
	if event.is_action_pressed("debugPanelToggle"):
		visible = !visible

func add_property(title: String, value, order):
	var target
	target = property_container.find_child(title, true, false) #Try to find label node with same name
	if !target: # If there is no current label node for property (ie. inital load)
		target = Label.new() # Create new Label node
		property_container.add_child(target) # Add new node as a child to Vbox Container
		target.name = title # Set name to title
		target.text = target.name + ": " + str(value) # Set text value
	elif visible:
		target.text = title + ": " + str(value) # Update text value
		property_container.move_child(target, order) # Reorder property based on given order value 
