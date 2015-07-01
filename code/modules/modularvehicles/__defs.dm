//Types defining where a part attaches to another part.
#define ATTACH_SIDE			1	//Something on the side of a part, like mech arms.
#define ATTACH_UNDER		2	//Something under the vehicle, like a cleaner under a janicart.
#define ATTACH_BACK			3
#define ATTACH_FRONT		4
#define ATTACH_TOP			5	//Attaches above something like a mech body to a mech chassis
#define ATTACH_INTERNAL		6	//Something like an atmos tank that's inside the vehicle.

//Weight thresholds.
#define WEIGHT_HUMAN_PICKUP	15	//10 kg is the max a spessman can lift.
#define WEIGHT_HUMAN_PULL	25	//25 kg is the max a spessman can pull.

//Types used by vehicle entry.
#define ENTER_ENCLOSED		1	//Like mechs.
#define ENTER_BUCKLE		2	//Like the janicart.
