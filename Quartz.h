#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

extern AXError _AXUIElementGetWindow(AXUIElementRef, CGWindowID*);

CGWindowID quartz_get_window_id(AXUIElementRef);

CGPoint quartz_get_window_origin(AXUIElementRef);
void quartz_set_window_origin(AXUIElementRef, CGPoint);

CGSize quartz_get_window_size(AXUIElementRef);
void quartz_set_window_size(AXUIElementRef, CGSize);

CGRect quartz_get_window_frame(AXUIElementRef);
void quartz_set_window_frame(AXUIElementRef, CGRect);