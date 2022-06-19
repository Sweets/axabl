#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "NSWorkspace.h"

NSNotificationCenter *notification_center;
NSMutableArray *installed_ns_observers;

void initialize_nsworkspace() {
    notification_center = [[NSWorkspace sharedWorkspace] notificationCenter];
    installed_ns_observers = [[NSMutableArray alloc] init];
}

void finalize_nsworkspace() {
    /* NOTE: collection mutation and enumeration cannot be done at simultaneously */
    NSArray *observers = [installed_ns_observers copy];
    for (NSNotificationName notification in observers)
        nsworkspace_uninstall_observer(notification);
    
    [installed_ns_observers release];
}

void nsworkspace_install_observer(NSNotificationName name, void (^block)(NSNotification*)) {
    [notification_center
        addObserverForName:name object:nil queue:nil usingBlock:block];
    [installed_ns_observers addObject:name];
}

void nsworkspace_uninstall_observer(NSNotificationName name) {
    [notification_center removeObserver:name];
    [installed_ns_observers removeObject:name];
}