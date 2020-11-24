/obj/item/organ/external/robotic
	name = "robotic"
	force_icon = 'icons/mob/human_races/cyberlimbs/unbranded/unbranded_alt1.dmi'
	icon = 'icons/mob/human_races/cyberlimbs/unbranded/unbranded_alt1.dmi'
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	dislocated = -1
	cannot_break = 1
	nature = MODIFICATION_SILICON
	armor = list(melee = 20, bullet = 20, energy = 20, bomb = 20, bio = 100, rad = 100)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2) // Multiplied by w_class
	var/min_malfunction_damage = 20 // Any more damage than that and you start getting nasty random malfunctions

/obj/item/organ/external/robotic/get_cache_key()
	return "Robotic[model]"

/obj/item/organ/external/robotic/update_icon()
    var/gender = "m"
    if(owner)
        gender = owner.gender == FEMALE ? "f" : "m"
    if(gendered || force_icon == 'icons/mob/human_races/cyberlimbs/generic.dmi')

        icon_state = "[organ_tag]_[gender]"
    else
        icon_state = "[organ_tag]"
    mob_icon = icon(force_icon, icon_state)
    icon = mob_icon
    return mob_icon

/obj/item/organ/external/robotic/is_malfunctioning()
	return prob(brute_dam + burn_dam - min_malfunction_damage)

/obj/item/organ/external/robotic/set_description(datum/organ_description/desc)
	..()
	src.name = "[initial(name)] [desc.name]"
	for(var/mat_name in matter)
		matter[mat_name] *= w_class

/obj/item/organ/external/robotic/Destroy()
	deactivate(emergency=TRUE)
	. = ..()

/obj/item/organ/external/robotic/removed()
	deactivate(emergency=TRUE)
	..()

/obj/item/organ/external/robotic/update_germs()
	germ_level = 0
	return

/obj/item/organ/external/robotic/setBleeding()
	return FALSE

/obj/item/organ/external/robotic/proc/can_activate()
	return TRUE

/obj/item/organ/external/robotic/proc/activate()
	return TRUE

/obj/item/organ/external/robotic/proc/deactivate(emergency = TRUE)
	return TRUE

/obj/item/organ/external/robotic/limb
	max_damage = 50
	min_broken_damage = 30
	w_class = ITEM_SIZE_NORMAL
	bad_type = /obj/item/organ/external/robotic/limb

/obj/item/organ/external/robotic/tiny
	min_broken_damage = 15
	w_class = ITEM_SIZE_SMALL
	bad_type = /obj/item/organ/external/robotic/tiny

/obj/item/organ/external/robotic/New()
	. = ..()


/obj/item/organ/external/robotic/l_arm
	default_description = /datum/organ_description/arm/left

/obj/item/organ/external/robotic/r_arm
	default_description = /datum/organ_description/arm/right

/obj/item/organ/external/robotic/l_leg
	default_description = /datum/organ_description/leg/left

/obj/item/organ/external/robotic/r_leg
	default_description = /datum/organ_description/leg/right

/obj/item/organ/external/robotic/groin
	default_description = /datum/organ_description/groin

/obj/item/organ/external/robotic/head
	default_description = /datum/organ_description/head

/obj/item/organ/external/robotic/chest
	default_description = /datum/organ_description/chest

/obj/item/organ/external/robotic/l_hand
	default_description = /datum/organ_description/hand/left

/obj/item/organ/external/robotic/r_hand
	default_description = /datum/organ_description/hand/right

/obj/item/organ/external/robotic/l_foot
	default_description = /datum/organ_description/foot/left

/obj/item/organ/external/robotic/r_foot
	default_description = /datum/organ_description/foot/right
