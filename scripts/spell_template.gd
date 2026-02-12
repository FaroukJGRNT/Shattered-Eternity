extends AttackState
class_name Spell

enum SpellType {
	FIRE,
	ICE,
	THUNDER,
	BUFF,
	MANA
}

enum SpellCategory {
	WEAPONBUFF,
	LIGHT,
	HEAVY
}

@export var mana_cost := 0
@export var spell_type : SpellType
@export var spell_cat : SpellCategory

@export var proj_to_spawn : PackedScene
var airborne_cast := false
var down_pressed := false

func spawn_proj():
	player.mana -= mana_cost
	var proj = Toolbox.spawn_projectile(player, proj_to_spawn)
	if spell_cat == SpellCategory.LIGHT:
		if airborne_cast and down_pressed:
			if proj.has_method("go_downwards"):
				proj.go_downwards()
	proj.facing = player.facing

func enter():
	down_pressed = false
	spawns_proj = true
	if spell_cat == SpellCategory.LIGHT:
		anim_name = "simple_cast"
		spawn_frame = 3

	super.enter()
	player.specialVFXPlayer.rotation_degrees = -46
	player.specialVFXPlayer.position.y = -30
	match spell_type:
		SpellType.FIRE:
			player.specialVFXPlayer.play_vfx("fire_cast")
		SpellType.ICE:
			player.specialVFXPlayer.play_vfx("ice_cast")
		SpellType.THUNDER:
			player.specialVFXPlayer.play_vfx("thunder_cast")
	if player.state_machine.old_state.name.to_lower() == "airborne":
		player.velocity.y -= 65
		player.velocity.x += 140 * player.facing * -1
		airborne_cast = true
		
func update(delta):
	if Input.is_action_pressed("down"):
		down_pressed = true
	if AnimPlayer.frame == spawn_frame and not proj_spawned:
		proj_spawned = true
		spawn_proj()

	var index = 0
	for frame in usable_mov_frames:
		if AnimPlayer.frame == frame:
			player.velocity += (usable_velocs[index]) * player.facing
			usable_mov_frames.pop_front()
			usable_velocs.pop_front()
			break
		index += 1

	if player.velocity.x > 0:
		player.velocity.x = max(player.velocity.x - deceleration * delta * 50, 0)
	if player.velocity.x < 0:
		player.velocity.x = min(player.velocity.x + deceleration * delta * 50, 0)
	if player.velocity.y > 0:
		player.velocity.y = max(player.velocity.y - deceleration * delta * 50, 0)
	if player.velocity.y < 0:
		player.velocity.y = min(player.velocity.y + deceleration * delta * 50, 0)
		
	if airborne_cast:
		player.handle_vertical_movement(player.get_gravity().y / 100)
	player.move_and_slide()

	if Input.is_action_just_pressed("attack") and AnimPlayer.frame >= (AnimPlayer.sprite_frames.get_frame_count(AnimPlayer.animation) / 2):
		attack_again = true
	if AnimPlayer.frame < active_frames[0] or AnimPlayer.frame >= dash_cancel_frame:
		# Initiating a jump or a slide or an attack
		if Input.is_action_just_pressed("jump") and player.is_on_floor():
			player.allowed_jumps = 0
			player.change_state("jumpstart")
			return
		if Input.is_action_just_pressed("guard") and player.is_on_floor():
			player.change_state("guard")
			return
		if Input.is_action_just_pressed("dash"):
			player.get_horizontal_input()
			if player.direction == 0 or player.direction * player.facing == -1:
				transitioned.emit("backdashing")
			else:
				transitioned.emit("dashing")
