extends Node

const TEST_RAYCAST = preload("res://data/equipment/projectile/test_raycast.tres")
const TEST_ABILITY_BEHAVIOUR = preload("res://data/equipment/projectile/test_ability_behaviour.tres")
const TEST_ABILITY_BEHAVIOUR_BODY = preload("res://data/equipment/projectile/test_ability_behaviour_body.tres")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("debug_f3"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("debug_f4"):
		var player = get_tree().get_first_node_in_group("player") as Entity_Vehicle
		var proj : ProjectileBase = TEST_ABILITY_BEHAVIOUR_BODY.build(player, Enums.HardpointType.PRIMARY)

		get_tree().get_root().add_child(proj)
		proj.global_position = player.get_hardpoint(Enums.HardpointType.PRIMARY).global_position
		proj.global_basis = player.get_hardpoint(Enums.HardpointType.PRIMARY).global_basis
		proj.start_behaviours()
		
