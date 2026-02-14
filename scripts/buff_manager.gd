extends Node
class_name BuffManager

var buffs : Dictionary[String, Buff]
var active_buffs : Array[Buff]

func _ready() -> void:
	# Gather all different child buffs in a dictionnary
	for child in get_children():
		if child is Buff:
			buffs[child.name.to_lower()] = child
			child.daddy = owner

func _process(delta: float) -> void:
	# Running cooldowns
	for buff in active_buffs:
		if buff.has_timer:
			buff.timer -= delta
			if buff.timer <= 0:
				buff.desactivate()
				active_buffs.erase(buff)

# Is used to apply one shot buffs (potions, environment buffs)
func apply_one_shot_buff(buff : Buff, additional : Variant = null):
	buff.activate(additional)
	active_buffs.push_back(buff)

# Is used to activate occasional buffs =
func propagate_event(event : LivingEntity.Event, additional : Variant = null):
	for key in buffs:
		if buffs[key].trigger_event == event:
			# TODO: Pay attention to reapplicable buffs. Some buffs must not be renewable while they are still active
			if buffs[key] not in active_buffs:
				buffs[key].activate(additional)
				buffs[key].timer = buffs[key].timeout
				active_buffs.push_back(buffs[key])

func add_new_buff(buff : Buff, name : String):
	buffs[name] = buff
	buff.daddy = owner
