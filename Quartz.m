#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "AXUIElement.h"
#import "Quartz.h"

CGWindowID quartz_get_window_id(AXUIElementRef ax_element) {
    CGWindowID window_identifier = 0;
    _AXUIElementGetWindow(ax_element, &window_identifier);

    return window_identifier;
}

CGPoint quartz_get_window_origin(AXUIElementRef ax_element) {
    CGPoint origin;

    CFTypeRef origin_struct = axui_get_attribute(ax_element, kAXPositionAttribute);
    axui_decode_struct_value(origin_struct, (AXValueType)kAXValueCGPointType, &origin);
    
    return origin;
}

void quartz_set_window_origin(AXUIElementRef ax_element, CGPoint origin) {
    CFTypeRef origin_struct = axui_encode_struct_value((AXValueType)kAXValueCGPointType, &origin);
    axui_set_attribute(ax_element, kAXPositionAttribute, origin_struct);
}

CGSize quartz_get_window_size(AXUIElementRef ax_element) {
    CGSize size;

    CFTypeRef size_struct = axui_get_attribute(ax_element, kAXSizeAttribute);
    axui_decode_struct_value(size_struct, (AXValueType)kAXValueCGSizeType, &size);

    return size;
}

void quartz_set_window_size(AXUIElementRef ax_element, CGSize size) {
    CFTypeRef size_struct = axui_encode_struct_value((AXValueType)kAXValueCGSizeType, &size);
    axui_set_attribute(ax_element, kAXSizeAttribute, size_struct);
}

CGRect quartz_get_window_frame(AXUIElementRef ax_element) {
    CGRect frame = {
        .origin = quartz_get_window_origin(ax_element),
        .size = quartz_get_window_size(ax_element)
    };

    return frame;
}

void quartz_set_window_frame(AXUIElementRef ax_element, CGRect frame) {
    quartz_set_window_origin(ax_element, frame.origin);
    quartz_set_window_size(ax_element, frame.size);
}