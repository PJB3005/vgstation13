//Vaults are structures that are randomly spawned as a part of the main map
//They're stored in maps/randomVaults/ as .dmm files

//HOW TO ADD YOUR OWN VAULTS:
//1. make a map in the maps/randomVaults/ folder (1 zlevel only please)
//2. add the map's name to the vault_map_names list
//3. the game will handle the rest

var/const/vault_map_directory = "maps/randomVaults/"
var/list/vault_map_names = list(
	"doomed_satelite",
	"asteroid_temple",
	"restaurant",
)

/area/random_vault
	name = "random vault area"
	desc = "Spawn a vault in there somewhere"
	icon_state = "random_vault"

//Because areas are shit and it's easier that way!

/area/random_vault/v1
/area/random_vault/v2
/area/random_vault/v3
/area/random_vault/v4
/area/random_vault/v5
/area/random_vault/v6
/area/random_vault/v7
/area/random_vault/v8
/area/random_vault/v9
/area/random_vault/v10

/proc/generate_vaults()
	var/area/space = get_area(locate(1,1,2)) //xd

	var/list/list_of_vaults = shuffle(typesof(/area/random_vault))
	var/failures = 0
	var/successes = 0
	var/vault_number = rand(1,min(vault_map_names.len, list_of_vaults.len-1))

	vault_number = vault_map_names.len

	message_admins("<span class='info'>Spawning [vault_number] vaults...</span>")

	for(var/T in list_of_vaults) //Go through all subtypes of /area/random_vault
		var/area/A = locate(T) //Find the area

		if(!A || !A.contents.len) //Area is empty and doesn't exist - skip
			continue

		if(vault_map_names.len > 0 && vault_number>0)
			vault_number--

			var/vault_x
			var/vault_y
			var/vault_z

			var/turf/TURF = get_turf(pick(A.contents))

			vault_x = TURF.x
			vault_y = TURF.y
			vault_z = TURF.z

			var/map_name = pick(vault_map_names)
			vault_map_names.Remove(map_name)

			var/path_file = "[vault_map_directory][pick(map_name)].dmm"

			if(fexists(path_file))
				maploader.load_map(file(path_file), vault_z, vault_x, vault_y)

				message_admins("<span class='info'>Loaded [path_file]: [formatJumpTo(locate(vault_x, vault_y, vault_z))]!!!")
				successes++
			else
				message_admins("<span class='danger'>Can't find [path_file]!</span>")
				failures++

		for(var/turf/TURF in A) //Replace all of the temporary areas with space
			space.contents.Add(TURF)
			TURF.change_area(A, space)

	message_admins("<span class='info'>Loaded [successes] vaults successfully, [failures] failures.</span>")
