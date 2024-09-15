class_name Utils
extends Object


static func get_children_of_group(node: Node, group: String) -> Array:
	var result: Array = []
	for child: Node in node.get_children():
		if child.get_child_count() > 0:
			result += Utils.get_children_of_group(child, group)
		if child is Node and child.is_in_group(group):
			result.append(child)
	return result
