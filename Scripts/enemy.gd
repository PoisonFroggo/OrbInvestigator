extends CharacterBody3D

@export var movement_speed: float = 5.0
var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)

@export var waypoints_container: Node
var _waypoints: Array[Node]
var _current_waypoint: int
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	_waypoints = waypoints_container.get_children()
	_current_waypoint = 0
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(_waypoints[_current_waypoint].position)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		if _current_waypoint == waypoints_container.get_child_count() - 1:
			_current_waypoint = 0
		else:
			_current_waypoint += 1
		if _waypoints != []:
			set_movement_target(_waypoints[_current_waypoint].position)

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
