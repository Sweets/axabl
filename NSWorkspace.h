#pragma once
#import <Foundation/Foundation.h>

NSNotificationCenter *notification_center;

void initialize_nsworkspace(void);
void finalize_nsworkspace(void);

void nsworkspace_install_observer(NSNotificationName, void(^)(NSNotification*));
void nsworkspace_uninstall_observer(NSNotificationName);