//STRIKE TEAMS

/client/proc/strike_team()
	if (!check_rights(R_FUN))
		return

	if (!ticker)
		to_chat(usr, "<spawn class='warning'>The game hasn't started yet!</span>")
		return

	var/datum/antagonist/deathsquad/team
	var/team_type = alert("Do you want to send a Nanotrasen death squad or Syndicate strike team?", "Send strike team", "Death Squad", "Syndicate Strike Team.", "Cancel")
	switch (team_type)
		if ("Death Squad")
			team = deathsquad

		if ("Syndicate Strike Team")
			team = commandos

		else
			return


	if (team.deployed)
		to_chat(usr, "<spawn class='warning'>A team is already being sent.</span>")
		return

	if (alert("Are you 100% sure?", "Send strike team", "Yes", "No") != "Yes")
		return

	alert("This 'mode' will go on until everyone is dead or the station is destroyed. You may also admin-call the evac shuttle when appropriate. Spawned commandos have internals cameras which are viewable through a monitor inside the Spec. Ops. Office. Assigning the team's detailed task is recommended from there. While you will be able to manually pick the candidates from active ghosts, their assignment in the squad will be random.")

	var/input = null
	while (!input)
		input = copytext(sanitize(input(src, "Please specify which mission the strike team squad shall undertake.", "Specify Mission", "")), 1, MAX_MESSAGE_LEN)
		if (input)
			break

		if (alert("Error, no mission set. Do you want to exit the setup process?", "Send strike team", "Yes", "No") == "Yes")
			return

	if (team.deployed)
		to_chat(usr, "Looks like someone beat you to it.")
		return

	team.deployed = TRUE
	team.set_mission(input)

	if (emergency_shuttle.direction == 1 && emergency_shuttle.online == 1)
		emergency_shuttle.recall()

	team.build_candidate_list(TRUE)
	var/list/candidates_key = list()
	for (var/datum/mind/M in team.candidates)
		candidates_key[M.key] = M

	for (var/i = hard_cap, i > 0 && team.candidates.len, i--) // Decrease with every commando selected.
		var/candidate = input("Pick characters to spawn as the commandos. This will go on until there either no more ghosts to pick from or the slots are full.", "Active Players") as null|anything in candidates_key //It will auto-pick a person when there is only one candidate.
		var/datum/mind/M = candidates_key[candidate]
		candidates_key -= candidate
		if (!team.draft_antagonist(M))
			to_chat(usr, "<span class='warning'>Unable to draft [candidate].</span>")
			i++

		team.candidates -= M

	team.finalize_spawn()

	message_admins("<span class='notice'>[key_name_admin(usr)] has spawned a [team_type].</span>", 1)
	log_admin("[key_name(usr)] used [team_type].")
	return 1
