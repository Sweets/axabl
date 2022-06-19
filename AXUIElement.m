#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "AXUIElement.h"

extern AXError _AXUIElementGetWindow(AXUIElementRef, CGWindowID*);

NSMutableDictionary *installed_ax_observers;

Boolean initialize_axui() {
    CFDictionaryRef options = (CFDictionaryRef)@{
        (id)kAXTrustedCheckOptionPrompt: @true
    };
    Boolean process_is_trusted = AXIsProcessTrustedWithOptions(options);

    if (!process_is_trusted)
        return false;

    installed_ax_observers = [[NSMutableDictionary alloc] init];

    return true;
}

void finalize_axui() {
    // enumerate over observers, kill all.
    [installed_ax_observers release];
}

AXUIElementRef axui_create_application_element(id process_identifier) {
    AXUIElementRef ax_element = AXUIElementCreateApplication([process_identifier intValue]);

    id element = axui_encode_element(ax_element);
    [installed_ax_observers setObject:[[NSMutableDictionary alloc] init] forKey:element];

    return ax_element;
}

void axui_destroy_application_element(id element) {
    [element release];
}

id axui_encode_element(AXUIElementRef element) {
    id encoded_element = [NSValue valueWithBytes:&element objCType:@encode(AXUIElementRef)];
    [encoded_element retain];

    return encoded_element;
}

AXUIElementRef axui_decode_element(id encoded_element) {
    AXUIElementRef element;
    [encoded_element getValue:&element];
    [encoded_element release];

    return element;
}

bool axui_install_observer(AXUIElementRef element, CFStringRef notification, AXObserverCallback callback) {
    // TODO: check to make sure that the notification isn't already mapped to an observer

    AXError result_code;
    AXObserverRef observer;
    pid_t process_identifier;

    id ax_element = axui_encode_element(element);

    result_code = AXUIElementGetPid(element, &process_identifier);
    if (result_code != kAXErrorSuccess)
        return false;
    
    AXObserverCreate(process_identifier, callback, &observer);

    result_code = AXObserverAddNotification(observer, element, notification, NULL);
    if (result_code != kAXErrorSuccess) {
        CFRelease(observer);
        return false;
    }

    id observer_object = [NSValue valueWithPointer: &observer];

    [[installed_ax_observers objectForKey:ax_element] setObject:observer_object forKey:(__bridge id)notification];

    CFRunLoopSourceRef observer_run_loop = AXObserverGetRunLoopSource(observer);
    CFRunLoopRef main_run_loop = CFRunLoopGetMain();

    CFRunLoopAddSource(main_run_loop, observer_run_loop, kCFRunLoopDefaultMode);

    return true;
}

void axui_uninstall_observer(AXUIElementRef element, CFStringRef notification) {
    AXObserverRef observer;

    id ax_element = axui_encode_element(element);
    NSMutableDictionary *observers = [installed_ax_observers objectForKey:ax_element];
    observer = [[observers valueForKey:(NSString *)notification] pointerValue];

    AXObserverRemoveNotification(observer, element, notification);

    CFRunLoopSourceRef observer_run_loop = AXObserverGetRunLoopSource(observer);
    CFRunLoopSourceInvalidate(observer_run_loop);
    CFRelease(observer);
}

CFTypeRef axui_get_attribute(AXUIElementRef ax_element, CFStringRef attribute) {
    CFTypeRef value;

    AXUIElementCopyAttributeValue(ax_element, attribute, &value);

    return value;
}

void axui_set_attribute(AXUIElementRef ax_element, CFStringRef attribute, CFTypeRef value) {
    Boolean muttable = false;

    AXUIElementIsAttributeSettable(ax_element, attribute, &muttable);

    if (!muttable)
        return;
    
    AXUIElementSetAttributeValue(ax_element, attribute, value);
}

AXValueRef axui_encode_struct_value(AXValueType type, void *pointer) {
    return AXValueCreate(type, (const void*)pointer);
}

void axui_decode_struct_value(AXValueRef structure, AXValueType type, void *to_pointer) {
    AXValueGetValue(structure, type, to_pointer);
}

CGWindowID axui_get_window_id(AXUIElementRef ax_element) {
    CGWindowID window_identifier = 0;
    _AXUIElementGetWindow(ax_element, &window_identifier);

    return window_identifier;
}