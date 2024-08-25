class_name MakeYogGameState extends GameState

var _make_yog: MakeYogurtScene
var _pot: MilkPotData

func _init(s: GameScene, pot: MilkPotData) -> void:
	super(s)
	_pot = pot
	_make_yog = s
