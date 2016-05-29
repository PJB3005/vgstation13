/**
 * /vg/ Events System
 *
 * Intended to replace the hook system.
 * Eventually. :V
 */

// Buggy bullshit requires shitty workarounds
/proc/INVOKE_EVENT(event/event,args)
	if (istype(event))
		. = event.Invoke(args)

#define EVENT_HANDLE(obj, proc_name) "\ref[obj]:[proc_name]"

/**
 * Event dispatcher
 */
/event
	var/list/handlers // List of [\ref, Procname]
	var/atom/holder

/event/New(owner)
	..()
	holder = owner

	handlers = list()

/event/proc/Add(var/objectRef, var/procName)
	var/key = EVENT_HANDLE(objectRef, procName)
	handlers[key] = list(EVENT_OBJECT_INDEX = objectRef, EVENT_PROC_INDEX = procName)
	return key

/event/proc/Remove(var/key)
	return handlers.Remove(key)

/event/proc/RemoveWithoutKey(var/datum/objectRef, var/procName)
	var/key = EVENT_HANDLE(objectRef, procName)
	handlers.Remove(key)

/event/proc/Invoke(var/list/args)
	if (handlers.len == 0)
		return

	for (var/key in handlers)
		var/list/handler = handlers[key]
		if (!handler)
			continue

		var/objRef = handler[EVENT_OBJECT_INDEX]
		var/procName = handler[EVENT_PROC_INDEX]

		if (objRef == null)
			handlers.Remove(handler)
			continue

		args["event"] = src
		if (call(objRef, procName)(args, holder)) //An intercept value so whatever code section knows we mean business
			. = 1
