class_name OfferingGameState extends GameState

var _make_off: OfferingScene
var _god_idx := -1
var _god_node: God

func _init(s: GameScene, god := 0, god_node: God = null) -> void:
	super(s)
	_god_idx = god
	_god_node = god_node
	_make_off = s
