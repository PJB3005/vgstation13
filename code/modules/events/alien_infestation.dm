/var/global/sent_aliens_to_station = 0

/datum/event/alien_infestation
	announceWhen	= 450

	var/spawncount = 1
	var/successSpawn = 0	//So we don't make a command report if nothing gets spawned.
	var/player_factor = 1


/datum/event/alien_infestation/setup()
	announceWhen = rand(300, 600)
	player_factor = round(player_list.len/10) //One bonus starting alium for 10 players
	spawncount = rand(1, 2)+player_factor
	sent_aliens_to_station = 1

/datum/event/alien_infestation/announce()
	if(successSpawn)
		command_alert("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert",alert='sound/AI/aliens.ogg')


/datum/event/alien_infestation/start()
	global.xenomorphs.announced = TRUE
	global.xenomorphs.attempt_random_spawn(spawncount)
