/**
 * /vg/ Events System
 *
 * Intended to replace the hook system.
 * Eventually. :V
 */

// Buggy bullshit requires shitty workarounds
#define INVOKE_EVENT(event,args) if(istype(event)) event.Invoke(args)

#define EVENT_HANDLE(obj, proc_name) "\ref[obj]:[proc_name]"

/**
 * Event dispatcher
 */
/event
	var/list/handlers // List of [\ref, Function]
	var/datum/holder

/event/New(owner)
	. = ..()
	holder = owner

	handlers = list()

/event/Destroy()
	// . = ..()
	holder = null
	handlers = null

/event/proc/Add(var/objectRef,var/procName)
	var/key = EVENT_HANDLE(objectRef, procName)
	handlers[key] = list("o" = objectRef, "p" = procName)
	return key

/event/proc/Remove(var/key)
	return handlers.Remove(key)

/event/proc/Invoke(var/list/args)
	if(handlers.len == 0)
		return

	for(var/key in handlers)
		var/list/handler = handlers[key]
		if(!handler)
			continue

		var/objRef = handler["o"]
		var/procName = handler["p"]

		if(objRef == null)
			handlers.Remove(handler)
			continue

		args["event"] = src
		call(objRef, procName)(args, holder)
