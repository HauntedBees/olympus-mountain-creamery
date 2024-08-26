class_name OfferingGameState extends GameState

const _GODS: Array[PackedScene] = [
	preload("res://game_scenes/04_offering/gods/meus.tscn"),
	preload("res://game_scenes/04_offering/gods/demilker.tscn")
]

var _make_off: OfferingScene
var _god_idx := -1
var _god_node: God

func _init(s: GameScene, god := 0, god_node: God = null) -> void:
	super(s)
	_god_idx = god
	_god_node = god_node
	_make_off = s

func _unlock_gods() -> void:
	if Player.data.gods_unlocked > _GODS.size():
		Player.data.gods_unlocked = _GODS.size()
	while Player.data.gods_unlocked > Player.data.god_details.size():
		var god: God = _GODS[Player.data.god_details.size()].instantiate()
		var desire := god.requirements[0].get_quest(0)
		Player.data.god_details.append(desire)
		god.queue_free()

func _check_for_end_game() -> bool:
	_unlock_gods()
	var all_failed := true
	var all_complete := true
	for p in Player.data.god_details:
		if !p.failed:
			all_failed = false
		if !p.completed:
			all_complete = false
	if all_complete:
		change_scene.emit("res://game_scenes/05_endings/win_scene.tscn")
		return true
	elif all_failed:
		change_scene.emit("res://game_scenes/05_endings/lose_scene.tscn")
		return true
	return false
