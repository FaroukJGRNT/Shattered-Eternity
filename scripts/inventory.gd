extends Node
class_name Inventory

var spells : Array[Spell] = []

func add_to_inventory(item):
	if item is Spell:
		spells.append(item)
