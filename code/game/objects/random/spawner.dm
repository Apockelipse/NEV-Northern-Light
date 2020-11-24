/obj/spawner
	name = "random object"
	icon = 'icons/misc/landmarks.dmi'
	alpha = 64 //Or else they cover half of the map
	invisibility = INVISIBILITY_MAXIMUM	// Hides these spawners from the dmm-tools minimap renderer of SpacemanDMM
	rarity_value = 10
	spawn_frequency = 10
	spawn_tags = SPAWN_SPAWNER
	bad_types = /obj/spawner
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/min_amount = 1
	var/max_amount = 1
	var/top_price = 0
	var/low_price = 0
	var/list/tags_to_spawn = list(SPAWN_ITEM, SPAWN_MOB, SPAWN_MACHINERY, SPAWN_STRUCTURE)
<<<<<<< HEAD
=======
	var/list/should_be_include_tags = list()//TODO
>>>>>>> 7d47de9... loot rework optimization. (#5709)
	var/allow_blacklist = FALSE
	var/list/aditional_object = list()
	var/list/exclusion_paths = list()
	var/list/restricted_tags = list()
	var/list/include_paths = list()
	var/spread_range = 0
	var/has_postspawn = TRUE
	var/datum/loot_spawner_data/lsd


// creates a new object and deletes itself
/obj/spawner/Initialize()
	..()
	lsd = GLOB.all_spawn_data["loot_s_data"]
	if(!prob(spawn_nothing_percentage))
		var/list/spawns = spawn_item()
		if (has_postspawn && spawns.len)
			post_spawn(spawns)

	return INITIALIZE_HINT_QDEL

/obj/spawner/proc/valid_candidates()
	var/list/candidates = lsd.spawn_by_tag(tags_to_spawn)
	candidates -= lsd.spawn_by_tag(restricted_tags)
	candidates -= exclusion_paths
	if(!allow_blacklist)
		candidates -= lsd.all_spawn_blacklist
	if(low_price)
		candidates -= lsd.spawns_lower_price(candidates, low_price)
	if(top_price)
		candidates -= lsd.spawns_upper_price(candidates, top_price)
	candidates += include_paths
	return candidates

/obj/spawner/proc/pick_spawn(list/candidates)
	candidates = lsd.pick_frequencies_spawn(candidates)
	candidates = lsd.pick_rarities_spawn(candidates)
	var/selected = lsd.pick_spawn(candidates)
	aditional_object = lsd.all_spawn_accompanying_obj_by_path[selected]
	return selected

// this function should return a specific item to spawn
/obj/spawner/proc/item_to_spawn()
	var/list/candidates = valid_candidates()
	//if(!candidates.len)
	//	return
	return pick_spawn(candidates)

/obj/spawner/proc/post_spawn(list/spawns)
	return


// creates the random item
/obj/spawner/proc/spawn_item()
	var/list/points_for_spawn = list()
	var/list/spawns = list()
	if (spread_range && istype(loc, /turf))
		for(var/turf/T in trange(spread_range, src.loc))
			if (!T.is_wall && !T.is_hole)
				points_for_spawn += T
	else
		points_for_spawn += loc //We do not use get turf here, so that things can spawn inside containers
	for(var/i in 1 to rand(min_amount, max_amount))
		var/build_path = item_to_spawn()
		if (!build_path)
			return list()
		if(!points_for_spawn.len)
			log_debug("Spawner \"[type]\" ([x],[y],[z]) try spawn without free space around!")
			break
		var/atom/T = pick(points_for_spawn)
		var/atom/A = new build_path(T)
		if(istype(A,/obj/machinery) || istype(A, /obj/structure))
			A.set_dir(src.dir)
		spawns.Add(A)
		if(ismovable(A))
			var/atom/movable/AM = A
			price_tag += AM.price_tag
		if(islist(aditional_object) && aditional_object.len)
			for(var/thing in aditional_object)
				var/atom/AO = new thing (T)
				spawns.Add(AO)
				if(ismovable(AO))
					var/atom/movable/AMAO = AO
					price_tag += AMAO.price_tag
	return spawns

<<<<<<< HEAD
=======
/obj/spawner/proc/find_biome()
	var/turf/T = get_turf(src)
	if(T && T.biome)
		biome = T.biome
	if(check_biome_spawner())
		update_biome_vars()

/obj/spawner/proc/update_tags()
	biome.update_tags()
	tags_to_spawn = biome.tags_to_spawn

/obj/spawner/proc/update_biome_vars()
	update_tags()
	tags_to_spawn = biome.tags_to_spawn
	allow_blacklist = biome.allow_blacklist
	exclusion_paths = biome.exclusion_paths
	restricted_tags = biome.restricted_tags
	top_price = min(biome.top_price, max(biome.cap_price - biome.price_tag, 0))
	low_price = biome.low_price
	min_amount = biome.min_loot_amount
	max_amount = biome.max_loot_amount
	if(use_biome_range)
		spread_range = biome.range
		loc = biome.loc

// this function should return a specific item to spawn
/obj/spawner/proc/item_to_spawn()
	if(check_biome_spawner())
		update_tags()
		if(biome.price_tag + price_tag >= biome.cap_price && !istype(src, /obj/spawner/mob) && !istype(src, /obj/spawner/traps))
			return
	var/list/candidates = valid_candidates()
	if(check_biome_spawner() && (istype(src, /obj/spawner/traps) || istype(src, /obj/spawner/mob)))
		var/count = 1
		if(istype(src, /obj/spawner/traps))
			count = biome.spawner_trap_count
		else if(istype(src, /obj/spawner/mob))
			count = biome.spawner_mob_count
		if(count < 2)
			var/top = round(candidates.len*spawn_count*biome.only_top)
			if(top <= candidates.len)
				var/top_spawn = CLAMP(top, 1, min(candidates.len,7))
				candidates = SSspawn_data.only_top_candidates(candidates, top_spawn)
	//if(!candidates.len)
	//	return
	return pick_spawn(candidates)

/obj/spawner/proc/valid_candidates()
	var/list/candidates = SSspawn_data.valid_candidates(tags_to_spawn, restricted_tags, allow_blacklist, low_price, top_price, FALSE, include_paths, exclusion_paths, should_be_include_tags)
	return candidates

/obj/spawner/proc/pick_spawn(list/candidates)
	var/selected = SSspawn_data.pick_spawn(candidates)
	aditional_object = SSspawn_data.all_accompanying_obj_by_path[selected]
	return selected

/obj/spawner/proc/post_spawn(list/spawns)
	return

/proc/check_spawn_point(turf/T, check_density=FALSE)
	. = TRUE
	if(T.density  || T.is_wall || (T.is_hole && !T.is_solid_structure()))
		. = FALSE
	if(check_density && !turf_clear(T))
		. = FALSE

/obj/spawner/proc/find_smart_point()
	var/list/points_for_spawn = list()
	for(var/turf/T in trange(spread_range, loc))
		if(check_biome_spawner() && !(T in biome.spawn_turfs))
			continue
		if(!check_spawn_point(T, check_density))
			continue
		points_for_spawn += T
	return points_for_spawn

/proc/check_room(atom/movable/source, atom/movable/target)
	. = TRUE
	var/ndist = get_dist(source, target)
	var/turf/current = source
	for(var/i in 1 to ndist)
		current = get_step(current, get_dir(current, target))
		if(!check_spawn_point(current))
			return FALSE

>>>>>>> 7d47de9... loot rework optimization. (#5709)
/obj/randomcatcher
	name = "Random Catcher Object"
	desc = "You should not see this."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/randomcatcher/proc/get_item(type)
	new type(src)
	if (contents.len)
		. = pick(contents)
	else
		return null

/obj/randomcatcher/proc/get_items(type)
	new type(src)
	if (contents.len)
		return contents
	else
		return null
