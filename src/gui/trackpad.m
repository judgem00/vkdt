#import <Cocoa/Cocoa.h>
#include "trackpad.h"

static int    g_precise;   // current scroll event is from a trackpad
static double g_dx, g_dy;  // its deltas in points
static dt_trackpad_magnify_fun g_magnify;

void dt_trackpad_init(dt_trackpad_magnify_fun magnify)
{
  g_magnify = magnify;
  // local monitors run in -[NSApplication sendEvent:] before the event is
  // dispatched to the glfw content view, so we see it before the scroll callback.
  [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskScrollWheel
    handler:^NSEvent *(NSEvent *event) {
      g_precise = [event hasPreciseScrollingDeltas];
      g_dx = [event scrollingDeltaX];
      g_dy = [event scrollingDeltaY];
      return event;
    }];
  [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskMagnify
    handler:^NSEvent *(NSEvent *event) {
      if(g_magnify && [event magnification] != 0.0)
        g_magnify([event magnification]);
      return event;
    }];
}

int dt_trackpad_scroll_precise(double *dx, double *dy)
{
  if(!g_precise) return 0;
  *dx = g_dx;
  *dy = g_dy;
  return 1;
}
