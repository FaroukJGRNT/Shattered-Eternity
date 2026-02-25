extends Node2D
class_name Connector

enum ConnectorType {
	INPUT,
	OUTPUT
}

@export var connector_type := ConnectorType.OUTPUT
@export var linked_room : Node2D = null
@export var input_spawn_point : Marker2D
@export var transition_zone : Area2D
var output_position : Vector2

func _ready() -> void:
	transition_zone.connect("body_entered", body_entered)

func transition_to_zone():
	if not Toolbox.transitioning:
		Toolbox.load_level(linked_room, output_position)

func _process(delta: float) -> void:
	if Toolbox.transitioning:
		transition_zone.monitoring = false
	else:
		transition_zone.monitoring = true

func body_entered(body: Node2D) -> void:
	if body is Player:
		if get_tree() == null:
			return
		if owner != get_tree().get_first_node_in_group("Level"):
			return  # on est dans une vieille room, ignore
		transition_to_zone()
