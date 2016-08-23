// Pipe layer stuff.
#define PIPING_LAYER_DEFAULT   3 //starting value - this is the "central" pipe
#define PIPING_LAYER_INCREMENT 1 //how much the smallest step in piping_layer is

#define PIPING_LAYER_MIN       1
#define PIPING_LAYER_MAX       5

#define PIPING_LAYER_P_X       5 //each positive increment of piping_layer changes the pixel_x by this amount
#define PIPING_LAYER_P_Y      -5 //same, but negative because they form a diagonal
#define PIPING_LAYER_LCHANGE   0.05 //how much the layer var changes per increment

#define PIPING_LAYER_SCRUBBING 4
#define PIPING_LAYER_SUPPLY    2

#define PIPING_LAYER_PIXEL_X(LAYER) (LAYER - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_X
#define PIPING_LAYER_PIXEL_Y(LAYER) (LAYER - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_Y

#define PIPING_PIXELX_SUPPLY    PIPING_LAYER_PIXEL_X(PIPING_LAYER_SUPPLY)
#define PIPING_PIXELY_SUPPLY    PIPING_LAYER_PIXEL_Y(PIPING_LAYER_SUPPLY)

#define PIPING_PIXELX_SCRUBBERS PIPING_LAYER_PIXEL_X(PIPING_LAYER_SCRUBBING)
#define PIPING_PIXELY_SCRUBBERS PIPING_LAYER_PIXEL_Y(PIPING_LAYER_SCRUBBING)
