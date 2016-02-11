// Hey look let's unity all the MILLIONS of health tracking things in the codebase!


// Defines of damage types.
#define BRUTE       "brute"
#define BURN        "fire"
#define TOX         "tox"
#define OXY         "oxy"
#define CLONE       "clone"
#define BRAIN       "brain"
#define HALLOS      "halloss"
#define RADIATION   "radiation"

/datum/health
	var/list/damage_types // List of types of damage, in the form of TYPE = AMOUNT

	var/event/change

/datum/health/simple
	damage_types = list(
		BRUTE = 0
	)

/datum/health/burn
	damage_types = list(
		BRUTE = 0,
		BURN  = 0
	)

// These are the procs you SHOULD be using to mess around.
/datum/health/proc/get_damage(var/damage_type)
	if(damage_types.Find(damage_type))
		return damage_types[damage_type]

	return 0

/datum/health/proc/adj_damage(var/damage_type, var/amount = 0)
	if(!amount || !damage_types.Find(damage_type))
		return 0

	return set_damage(damage_type, get_damage(damage_type) + amount)

/datum/health/proc/set_damage(var/damage_type, var/new_amount = 0)
	if(!damage_types.Find(damage_type))
		return 0

	INVOKE_EVENT(change, list("type" = damage_type, "new_amount" = new_amount, "old_amount" = get_damage(damage_type)))

	damage_types[damage_type] = new_amount

	return 1
