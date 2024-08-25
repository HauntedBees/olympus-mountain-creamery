class_name Desire extends Resource

enum Flavor { Any, Sweet, Rich, Refreshing, Savory, Luxurious, Earthy, Floral, Fruity, Bitter, Sour, Quality }

## The amount of yogurts they want.
@export var yogurt_amount := 1

## The flavor they want for these yogurts.
@export var flavor := Flavor.Any

## Minutes until the mission is failed.
@export var time_limit := 3600.0

## The reward received for the desire.
@export var reward: Array[ItemCount] = []

static func get_flavors(p: MilkPotData) -> Array[Flavor]:
	var f: Array[Flavor] = [Flavor.Any]
	if p.fermentation_time >= MilkPotData.SOUR_LIMIT:
		f.append(Flavor.Sour)
	match p.flavoring:
		ItemCount.Type.Honey: f.append_array([Flavor.Sweet, Flavor.Rich])
		ItemCount.Type.Mint: f.append_array([Flavor.Refreshing, Flavor.Savory])
		ItemCount.Type.Saffron: f.append_array([Flavor.Luxurious, Flavor.Earthy, Flavor.Floral])
		ItemCount.Type.Pomegranate: f.append_array([Flavor.Fruity, Flavor.Rich, Flavor.Floral])
		ItemCount.Type.Walnut: f.append_array([Flavor.Bitter, Flavor.Earthy, Flavor.Savory])
	if p.quality_multiplier >= 1.5:
		f.append(Flavor.Quality)
	return f

func is_match(p: MilkPotData) -> bool:
	return get_flavors(p).has(flavor)

func get_quest(idx: int) -> QuestDetails:
	var q := QuestDetails.new()
	q.desire_idx = idx
	q.time_remaining = time_limit
	return q
