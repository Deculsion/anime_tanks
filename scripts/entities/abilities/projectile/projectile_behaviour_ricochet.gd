class_name ProjectileBehaviourRicochet
extends ProjectileBehaviour

const COLLISION_MASK_HITBOX = 8

var ricochets_left : int
var queried_shape : SphereShape3D = SphereShape3D.new()
var _shape_query : PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
var _rid_exclusions : Array[RID]
var _world_space : PhysicsDirectSpaceState3D

func _ready_behaviour() -> void:
	projectile_origin.projectile_collided.connect(reproject_projectile)
	_world_space = get_world_3d().direct_space_state
	
	ricochets_left = projectile_behaviour_data.ricochet_count
	
	queried_shape.radius = projectile_behaviour_data.ricochet_search_radius
	_shape_query.shape = queried_shape
	_shape_query.collide_with_areas = true
	_shape_query.collision_mask = COLLISION_MASK_HITBOX
	_rid_exclusions.append_array(projectile_origin.shooter.get_hitboxes().map(
		func (x): return x.get_rid())
		)
	_shape_query.exclude = _rid_exclusions
	
	return

func reproject_projectile(collision_result : Dictionary, behaviour : ProjectileBehaviour) -> void:
	var target_results : Array[Dictionary] = _world_space.intersect_shape(_shape_query, 16)
	if target_results.is_empty() or ricochets_left == 0:
		ricochets_left = 0
		get_tree().create_timer(1.0).timeout.connect(_end_behaviour)
		#behaviour_ended.emit()
		return
	
	var nearest_target : Dictionary = target_results[0]
	var measure_distance : Callable = _get_distance.bind(collision_result.collider.position)
	var shortest_distance : float = measure_distance.call(nearest_target.collider)
	
	for r in target_results:
		var check_dist : float = measure_distance.call(r.collider)
		if  check_dist < shortest_distance:
			nearest_target = r
			shortest_distance = check_dist
			#print("Intersected {0} : Distance {1}".format([r.collider.get_entity(), measure_distance.call(r.collider)]))
	
	print("Ricocheting to {0}".format([nearest_target.collider.get_entity()]))
	
	var new_behaviour = behaviour.projectile_behaviour_data.build()
	projectile_origin.add_child(new_behaviour)
	new_behaviour.global_position = collision_result.position
	new_behaviour.global_basis = Basis.looking_at(
		nearest_target.collider.global_position - collision_result.position, 
		Vector3.UP, 
		true)
	new_behaviour.rid_exclusions.append(nearest_target.rid)
	new_behaviour._ready_behaviour()
	projectile_origin.add_active_behaviour(new_behaviour)
	ricochets_left -= 1
	
	return

func _get_distance(hitbox : Hitbox, origin_position : Vector3):
	return origin_position.distance_squared_to(hitbox.global_position)
