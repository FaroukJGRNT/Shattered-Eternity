extends Node
class_name Buff

var daddy : LivingEntity
var has_timer := true
var timer := 0.0
var timeout := 0.0
var trigger_event : LivingEntity.Event

var buff_name := ""
var buff_description := ""

var additional_ref

func activate(additional : Variant = null):
	pass
	
func desactivate():
	pass
