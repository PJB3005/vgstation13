
// Pressure checks as used by unary and binary vent pumps.
#define CHECKS_OFF          0 // Don't give a shit.
#define CHECKS_EXTERNAL     1 // Do not pass the external bound.
#define CHECKS_INTERNAL_IN  2 // Do not pass the internal bound (internal in for binary).
#define CHECKS_INTERNAL_OUT 4 // Do not pass internal out bound (binary only).

// Bitflags used by gas sensors.
#define MEASURE_PRESSURE    1
#define MEASURE_TEMPERATURE 2
#define MEASURE_OXYGEN      4
#define MEASURE_PLASMA      8
#define MEASURE_NITROGEN    16
#define MEASURE_CO2         32
#define MEASURE_ALL         63
