class_name Utils
extends Object


class RayCastResult:
	var collider: Node
	var normal: Vector2
	var data: Dictionary
	
	static func create(from: Dictionary) -> RayCastResult:
		assert("collider" in from and "normal" in from)
		var result: RayCastResult = RayCastResult.new()
		@warning_ignore("unsafe_cast")
		result.collider = from.collider as Node
		@warning_ignore("unsafe_cast")
		result.normal = from.normal as Vector2
		result.data = from
		return result

# TODO unused right now
class ShapeCastResult:
	var collider: Node
	var data: Dictionary
	
	static func create(from: Dictionary) -> ShapeCastResult:
		assert("collider" in from)
		var result: ShapeCastResult = ShapeCastResult.new()
		@warning_ignore("unsafe_cast")
		result.collider = from.collider as Node
		result.data = from
		return result


static func get_children_of_group(node: Node, group: String) -> Array:
	var result: Array = []
	for child: Node in node.get_children():
		if child.get_child_count() > 0:
			result += Utils.get_children_of_group(child, group)
		if child is Node and child.is_in_group(group):
			result.append(child)
	return result


static func get_children_of_type(node: Node, type: Variant) -> Array:
	var result: Array = []
	for child: Node in node.get_children():
		if child.get_child_count() > 0:
			result += Utils.get_children_of_type(child, type)
		if is_instance_of(child, type):
			result.append(child)
	return result


static func cast_ray(from: Node2D, motion: Vector2, mask: int = 0xff_ff_ff_ff) -> RayCastResult:
	var space_state: PhysicsDirectSpaceState2D = from.get_world_2d().direct_space_state
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		from.position,
		from.position + motion,
		mask
	)
	var collision: Dictionary = space_state.intersect_ray(query)
	if not collision:
		return null
	return RayCastResult.create(collision)

# TODO unused right now
static func cast_shape(from: Node2D, shape: Shape2D, mask: int = 0xff_ff_ff_ff) -> ShapeCastResult:
	var space_state: PhysicsDirectSpaceState2D = from.get_world_2d().direct_space_state
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.shape = shape
	query.collision_mask = mask
	var collisions: Array[Dictionary] = space_state.intersect_shape(query, 1)
	if collisions.size() == 0:
		return null
	return ShapeCastResult.create(collisions[0])
