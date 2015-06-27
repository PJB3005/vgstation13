//Types defining where a part attaches to another part.
#define ATTACH_SIDE			1	//Something on the side of a part, like mech arms.
#define ATTACH_UNDER		2	//Something under the vehicle, like a cleaner under a janicart.
#define ATTACH_INTERNAL		3	//Something like an atmos tank that's inside the vehicle.
#define ATTACH_EQUIP_MINOR	4	//Small attachements like a flashlight.
#define ATTACH_EQUIP_MAJOR	5	//Shit like drills, guns etc...
#define ATTACH_TOP			6	//Attaches above something like a mech body to a mech chassis

//On flags because muh magic numbers.
#define PART_POWER_OFF		0	//What your PC looks like if you run shutdown.exe.
#define PART_POWER_PASSIVE	1	//On but not using mqximum power.
#define PART_POWER_ACTIVE	2	//On and going full out with power usage.

//Weight thresholds.
#define WEIGHT_HUMAN_PICKUP	15	//10 kg is the max a spessman can lift.
#define WEIGHT_HUMAN_PULL	25	//25 kg is the max a spessman can pull.

//Types used by vehicle entry.
#define ENTER_ENCLOSED		1	//Like mechs.
#define ENTER_BUCKLE		2	//Like the janicart.
