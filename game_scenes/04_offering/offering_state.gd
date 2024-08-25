class_name OfferingGameState extends GameState

var _make_off: OfferingScene
var _god_idx := -1

func _init(s: GameScene, god := 0) -> void:
	super(s)
	_god_idx = god
	_make_off = s
