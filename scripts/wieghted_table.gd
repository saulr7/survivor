class_name WeightedTable



var items : Array[Dictionary] = []
var weight_sum : int = 0


func add_items(item, weight: int):
	items.append({"item": item, "weight": weight})
	weight_sum += weight


func remove_item(item_to_remove):
	items = items.filter(func (i): return i["item"] != item_to_remove)
	weight_sum = 0
	
	for i in items:
		weight_sum += i["weight"]
	

func pick_item(exclude : Array = []):
	var adjusted_items : Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for i in items:
			if i["item"] in exclude:
				continue
			adjusted_items.append(i)
			adjusted_weight_sum += i["weight"]
	
	var chosen_weight = randf_range(1, adjusted_weight_sum)
	var itr = 0
	
	for item in adjusted_items:
		itr += item["weight"]
		if chosen_weight <= itr:
			return item["item"]
