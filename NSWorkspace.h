#import <Foundation/Foundation.h>

NSNotificationCenter *notification_center;

void initialize_nsworkspace(void);
void finalize_nsworkspace(void);

NSArray *nsworkspace_running_applications(void);

void nsworkspace_install_observer(NSNotificationName, void(^)(NSNotification*));
void nsworkspace_uninstall_observer(NSNotificationName);