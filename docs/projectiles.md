Projectiles

Overview
- New projectile types added: `IceShard`, `LightningBolt`, `SplitterProjectile`.

How to spawn (example):

```
var scene : PackedScene = load("res://scenes/ice_shard_projectile.tscn")
var proj = scene.instantiate()
proj.global_position = owner.global_position
proj.rotation = some_direction_angle
proj.set_premade_damage(owner)
get_tree().current_scene.add_child(proj)
```

Notes
- All projectiles accept `set_premade_damage(entity: LivingEntity)` to let their HitBox use a damage container derived from `entity`.
- `HitBox.on_hit()` now forwards the hit event to its owner (if the owner exposes `on_hit()`), so projectiles can react to hits (apply statuses, split, chain, etc.).
- `IceShard` tries to apply `freeze`, `LightningBolt` applies `shock` and chains to nearby enemies, `SplitterProjectile` spawns split projectiles on destroy.