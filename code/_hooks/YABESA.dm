/*
YABESA - Yet Another Better Event System Attempt.

I straight up copied this from SS12, but because the filename (events.dm) was already in use, I came up with a retarded name.

What do they do? Allow you to 'listen' to certain events on a certain thing.
When that thing happens, the proc you specified will be called.

Oh, and don't use sleep() in something that's called by YABESA.

*/

/datum/YABESA
	var/datum/parent //The datum (atoms are datums too, keep that in mind) this events datum belong to.

	var/list/listening[0] //List of event datums that are listening to events from this datum. Format is list("event1" = listeners)

	var/list/subscribed[0] //List of events datums that this datum will be triggered by. Format is list(sender = list("event1" = "procname", "event2" = "procname2"))

	var/list/events_list[0] //The list of valid events for this datum, can't listen to something that doesn't exist!

/*
	This proc should be used to start listening to another event.
	Params: - event: The events datum to listen to.
			- event_id: The ID of the actual event to listen to.
			- procname: The name of the proc to be called on the parent, if the event gets triggered.
*/
/datum/YABESA/proc/start_listening(var/datum/YABESA/event, var/event_id, var/procname)
	if(!event || !event_id || !procname)
		return

	if(subscribed[event] && subscribed[event][event_id]) //We're already listening to this event.
		return

	if(subscribed[event] != null) //We're already listening to this events datum in some way, add to the entry.
		var/list/eventlist = subscribed[event]
		eventlist[event_id] = procname
	else //We're not, add a new entry in subscribed.
		subscribed += list(event = list(event_id = procname))

	event.listening[event_id] += src //Actually sign us up to be called

/*
	This proc should be used to stop listening to another event.
	Params: - event: The events datum we should (partially) stop listening to.
			- event_id: The ID of the event to stop listening to, if not specified all listening to event will stop.
*/
/datum/YABESA/proc/stop_listening(var/datum/YABESA/event, var/event_id)
	if(!event || !subscribed[event])
		return

	var/list/eventlist = subscribed[event]

	if(!event_id) //Wipe all the things.
		for(var/id in eventlist) //Get rid of all references to us in event.
			event.listening[id] -= src

		subscribed -= event //Get rid of any references to event on our side.
		return 1 //Should be good.

	if(!eventlist[event_id]) //We're not even listening to this in the first place.
		return

	event.listening[event_id] -= src
	if(eventlist.len == 1) //We're removing the last event to listen to, remove all references whilst we're at it.
		subscribed -= event
	else
		eventlist -= event_id

	return 1

/*
	This proc adds stuff to the events list, automatically generates entries in listening.
	Param: - event_list: List of events to add.
*/
/datum/YABESA/proc/add_event(var/list/event_list)
	events |= event_list

	for(var/event_id in event_list)
		if(listening[event_id]) //Duplicate, yay.
			continue
		listening[event_id] = list()

	return 1

/*
	This proc removes stuff from the events list, automatically removes references (including listening references).
	Param: - event_list: List of events to remove.
*/
/datum/YABESA/proc/remove_event(var/list/event_list)
	events -= event_list

	for(var/event_id in event_list) //Cycle through every reference to stop them from listening
		for(var/datum/YABESA/event in listening[event_id])
			event.stop_listening(src, event_id)

		listening -= event_id

/*
	This proc invokes an event, triggering any listening events.
	Params: - event_id: ID of the event to invoke.
			- others: Optional arguments with which listening procs are called.
*/
/datum/YABESA/proc/invoke(var/event_id)
	if(!(event_id in events))
		return

	var/list/extraargs = args - event_id

	for(var/datum/YABESA/listener in listening[event_id])
		listener.trigger(event_id, extraargs)

	return 1

//Internal proc to handle being triggered.
/datum/YABESA/proc/trigger(var/datum/YABESA/sender, var/event_id, var/list/extraargs)
	if(!sender || !event_id || !subscribed[sender] || !subscribed[sender][event_id])
		return 0

	var/procname = subscribed[sender][event_id]

	if(!hascall(parent, procname))
		return

	call(parent, procname) (arglist(extraargs))

//Make sure to remove us from any other events to ensure we get soft deleted correctly
/datum/YABESA/Destroy()
	remove_event(events)

	for(var/datum/YABESA/E in subscribed)
		stop_listening(E)

	parent.events_datum = null

//Events datum subtype that uses a queue, events are added to a queue, and are invoked first-in first-out on calling next_event()
//Maintains all functionality of the parent type.

/datum/YABESA/queued
	var/datum/queue/event_queue //That qeue I mentioned 4 lines up. Format is list(procname = extraargs, procname2 = someotherextraargs, ...)

/datum/YABESA/queued/trigger(var/datum/YABESA/sender, var/event_id, var/list/extraargs)
	if(!sender || !event_id || !subscribed[sender] || !subscribed[sender][event_id])
		return 0

	var/procname = subscribed[sender][event_id]

	if(!hascall(parent, procname))
		return

	event_queue.add(procname, extraargs)

//Calls the next event in the qeue, first in first out.
/datum/YABESA/queued/proc/next_event()
	var/list/queue_out = event_queue.next()

	var/procname = queue_out[1]
	var/extraargs = queue_out[2]

	call(parent, procname) (arglist(extraargs))

/datum/YABESA/queued/Destroy()
	. = ..()

	qdel(event_queue)
	event_queue = null

/datum/var/datum/YABESA/events_datum

//This proc news an events datum and adds the supplied events, literally sets it up.
/datum/proc/init_events(var/list/event_list)
	events_datum = new
	events_datum.add_event(event_list)

//This proc should be used instead of directly calling it on the events datum if the datum calling it is not guaranteed to actually utilise events.
/datum/proc/invoke_event()
	if(events_datum)
		events_datum.invoke(arglist(args))
