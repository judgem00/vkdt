#pragma once
// macintosh trackpad support. glfw does not tell us whether a scroll event
// came from a mouse wheel or from a trackpad, and it does not forward pinch
// gestures at all. on macos we install a cocoa event monitor to find out.

// called with the accumulated magnification (relative, 0 means no change)
// of a pinch gesture over the main window.
typedef void (*dt_trackpad_magnify_fun)(double magnification);

#ifdef __APPLE__
void dt_trackpad_init(dt_trackpad_magnify_fun magnify);
// query properties of the scroll event that is currently being dispatched by glfw.
// returns non-zero if it came from a trackpad (precise, pixel-based deltas).
// in that case dx, dy are set to the scroll distance in screen points.
int  dt_trackpad_scroll_precise(double *dx, double *dy);
#else
static inline void dt_trackpad_init(dt_trackpad_magnify_fun magnify) {}
static inline int  dt_trackpad_scroll_precise(double *dx, double *dy) { return 0; }
#endif
