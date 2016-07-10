#warn TODO: unfuck this file.

// Global variables.
/var/list/clockobelisks         = list()
/var/list/tinkcaches            = list()
/var/list/clockcult_powers      = list() // List of all clockcult powers.

#warn TODO: move to antag datums.
/var/list/clockcult_cv = 0

// Component types, use these.
#define CLOCK_VANGUARD    "vanguard"
#define CLOCK_BELLIGERENT "belligerent"
#define CLOCK_REPLICANT   "replicant"
#define CLOCK_HIEROPHANT  "hierophant"
#define CLOCK_GEIS        "geis"

/var/list/CLOCK_COMP_IDS = list(
	CLOCK_VANGUARD,
	CLOCK_BELLIGERENT,
	CLOCK_REPLICANT,
	CLOCK_HIEROPHANT,
	CLOCK_GEIS
)

// The above but has an assoc value of 0 for everything.
/var/list/CLOCK_COMP_STORAGE_PRESET = list()

/hook_handler/clockcult_storage_preset/proc/OnStartup(var/list/args)
	for (var/ID in global.CLOCK_COMP_IDS)
		global.CLOCK_COMP_STORAGE_PRESET[ID] = 0

/var/list/CLOCK_COMP_IDS_NAMES = list(
	CLOCK_VANGUARD      = "vanguard cogwheel",
	CLOCK_BELLIGERENT   = "belligerent eye",
	CLOCK_REPLICANT     = "replicant alloy",
	CLOCK_HIEROPHANT    = "hierophant ansible",
	CLOCK_GEIS          = "geis capacitor"
)

/var/list/CLOCK_COMP_NAMES_IDS = list(
	"vanguard cogwheel"     = CLOCK_VANGUARD,
	"belligerent eye"       = CLOCK_BELLIGERENT,
	"replicant alloy"       = CLOCK_REPLICANT,
	"hierophant ansible"    = CLOCK_HIEROPHANT,
	"geis capacitor"        = CLOCK_GEIS
)

/var/list/CLOCK_COMP_IDS_PATHS = list(
	CLOCK_VANGUARD      = /obj/item/clock_component/vanguard,
	CLOCK_BELLIGERENT   = /obj/item/clock_component/belligerent,
	CLOCK_REPLICANT     = /obj/item/clock_component/replicant,
	CLOCK_HIEROPHANT    = /obj/item/clock_component/hierophant,
	CLOCK_GEIS          = /obj/item/clock_component/geis
)

/var/list/CLOCK_COMP_IDS_COLORS = list(
	CLOCK_VANGUARD      = "blue",
	CLOCK_BELLIGERENT   = "red",
	CLOCK_REPLICANT     = "grey",
	CLOCK_HIEROPHANT    = "yellow",
	CLOCK_GEIS          = "pink"
)

/var/list/CLOCK_COMP_IDS_LIGHT_COLORS = list(
	CLOCK_VANGUARD      = LIGHT_COLOR_BLUE,
	CLOCK_BELLIGERENT   = LIGHT_COLOR_RED,
	CLOCK_REPLICANT     = "#AAAAAA",
	CLOCK_HIEROPHANT    = LIGHT_COLOR_YELLOW,
	CLOCK_GEIS          = LIGHT_COLOR_PINK
)

// Loudness
#define CLOCK_WHISPERED     1
#define CLOCK_SPOKEN        2
#define CLOCK_CHANTED       3

// Categories
#define CLOCK_DRIVER        1
#define CLOCK_SCRIPTS       2
#define CLOCK_APPLICATIONS  3
#define CLOCK_REVENANT      4
#define CLOCK_JUDGEMENT     5

// Slab production timings (in ticks from the obj process).
#define CLOCKSLAB_TICKS_UNTARGETED      90
#define CLOCKSLAB_TICKS_TARGETED        120

// Daemon production timings (in ticks from the obj process).
#define CLOCKDAEMON_UNTARGETED    30 SECONDS
#define CLOCKDAEMON_TARGETED      45 SECONDS // Yes the design docs say 45 seconds, this is 46, but it's the only way to keep the code relatively simple.

// Slab defines
#define CLOCKSLAB_CAPACITY              10

#define CLOCKCACHE_CAPACITY             50


// POWER SPECIFIC DEFINES.
#define CLOCK_HIEROPHANT_DURATION       30 SECONDS // Time the hierophant power lasts, note that this is in object process ticks (2 seconds per tick).
#define CLOCK_BELLIGERENT_RANGE         7
#define CLOCK_JUDICIAL_VISOR_DELAY      2 MINUTES

// Define for the language.
#define LANGUAGE_CLOCKCULT              "Clockwork Cult"

#define ROLE_CLOCKCULT  "machinegod"
