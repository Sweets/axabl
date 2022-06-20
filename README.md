<p align="center">
    <b>axabl</b><br/>
    accessibility abstraction layer
</p>

---

axabl is an abstraction layer over the accessibility API (and more) provided by Apple to make window management on macOS easier.

axabl provides calls to make general management easier, but it does not make reservations about how the windows themselves should be managed, stored in memory, or otherwise. Everything is left to the developer.

---

<p align="center"><b>Initialization of axabl</b></p>

axabl needs calls made to initialize specific dictionaries for stored observers and to do some integrity checks on the system to run. Likewise, for memory safety, calls should be made to deconstruct the abstraction layer. These are referred to as finalizing methods.

The order is not important, just that any particular part is initialized before being used (e.g. calls made in relation to AXUIElementRefs should initialize the AXUI API).

##### void initialize_nsworkspace(void);

Initializes `notification_center` and NS observers dictionary.

##### void finalize_nsworkspace(void);

Uninstalls any remaining observers and releases memory allocated for observer dictionary.

##### Boolean initialize_axui(void);

Performs a trust check to ensure that accessibility permissions have been permitted by the system for the application.
If the trust check passes, the observers dictionary is allocated and initialized, enabled the usage of the AXUI API.

Returns `true` if AXUI trust check is passed. Returns `false` otherwise.

##### void finalize_axui(void);

Uninstalls any remaining observers and releases dictionary used to store observers.

---

<p align="center"><b>NSWorkspace.h</b></p>

##### NSArray *nsworkspace_running_applications(void);

Convenience function used to collect an array of applications running in the shared workspace.

##### void nsworkspace_install_observer(NSNotificationName, void(^)(NSNotification *));

Installs a given block for a given notification.

##### void nsworkspace_uninstall_observer(NSNotificationName);

Uninstalls observers from a given notification name.

---

<p align="center"><b>AXUIElement.h</b></p>

##### AXUIElementRef axui_create_application_element(id);

Creates an accessibility object for a given process identifier (stored as an NSNumber).
Returns AXUIElementRef.

##### void axui_destroy_application_element(id);

Releases a given Accessibility UI object.

##### id axui_encode_element(AXUIElementRef);

Encodes a given accessibility object into an NSObject. This call is a convenience method provided to assist in storing references to AXUI objects easily. Any encoded references must be decoded before being able to be accessed (axui_decode_element).

##### AXUIElementRef axui_decode_element(id);

Decodes a given NSObject to an accessibility object.

##### bool axui_install_observer(AXUIElementRef, CFStringRef, AXObserverCallback);

Installs a given callback into a given accessibility object that responds to a given notification (CFStringRef).

##### axui_uninstall_observer(AXUIElementRef, CFStringRef);

Uninstalls observers attached to the given notification name from a given accessibility object.

##### CFTypeRef axui_get_attribute(AXUIElementRef, CFStringRef);

Gets a stored structure from an accessibility object. Structures that need specific values decoded should use axui_decode_struct_value().

##### void axui_set_attribute(AXUIElementRef, CFStringRef, CFTypeRef);

Sets and stores a structure with a given name for a given accessibility object. Values that need to be stored in a structure should be encoded using axui_encode_struct_value().

##### AXValueRef axui_encode_struct_value(AXValueType, void*);

Encodes a value into a structure and returns the reference.

##### void axui_decode_struct_value(AXValueRef, AXValueType, void*);

Decodes a value from a given structure to a given pointer.

---

<p align="center"><b>Quartz.h</b></p>

(tbd)