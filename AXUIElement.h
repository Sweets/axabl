#import <Foundation/Foundation.h>

void initialize_axui(void);
void finalize_axui(void);

AXUIElementRef axui_create_application_element(id);
void axui_destroy_application_element(id);

/*
 * axui_encode_element/axui_decode_element
 * are not intended for use by the end-user, but can be if
 * it is necessary to store the AXUIElementRef in an id (NSObject).
 *
 * encoded AXUIElementRefs cannot be type-casted downward and must be decoded.
 */
id axui_encode_element(AXUIElementRef);
AXUIElementRef axui_decode_element(id);

bool axui_install_observer(AXUIElementRef, CFStringRef, AXObserverCallback);
void axui_uninstall_observer(AXUIElementRef, CFStringRef);

void axui_get_attribute(AXUIElementRef, CFStringRef, CFTypeRef*);
void axui_set_attribute(AXUIElementRef, CFStringRef, CFTypeRef);

AXValueRef axui_encode_struct_value(AXValueType, void*);
void *axui_decode_struct_value(AXValueRef, AXValueType);

CGWindowID axui_get_window_id(AXUIElementRef);