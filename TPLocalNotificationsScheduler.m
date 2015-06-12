//
//  TPLocalNotificationsScheduler.m
//  greenline_POC
//
//  Created by Tony Person on 4/16/14.
//  Copyright 2014 Tony Person. All rights reserved.
//

#import "TPLocalNotificationsScheduler.h"

@implementation TPLocalNotificationsScheduler

#pragma mark -
#pragma mark Singleton Methods

+ (TPLocalNotificationsScheduler*)sharedInstance {

	static TPLocalNotificationsScheduler *_sharedInstance;
	if(!_sharedInstance) {
		static dispatch_once_t oncePredicate;
		dispatch_once(&oncePredicate, ^{
			_sharedInstance = [[super allocWithZone:nil] init];
            
            Class notificationClass = NSClassFromString(@"UILocalNotification");
            
            if(notificationClass == nil)
            {
                _sharedInstance = nil;
            }
            else
            {
                _sharedInstance = [[super allocWithZone:NULL] init];
                _sharedInstance.badgeCount = 0;
            }
			});
		}

		return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {	

	return [self sharedInstance];
}


- (id)copyWithZone:(NSZone *)zone {
	return self;	
}

#if (!__has_feature(objc_arc))

- (id)retain {	

	return self;	
}

- (unsigned)retainCount {
	return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
	//do nothing
}

- (id)autorelease {

	return self;	
}
#endif

#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here
- (void) scheduleNotificationOn:(NSDate*) fireDate
                           text:(NSString*) alertText
                         action:(NSString*) alertAction
                          sound:(NSString*) soundfileName
                    launchImage:(NSString*) launchImage
                        andInfo:(NSDictionary*) userInfo

{
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;
    
	if(soundfileName == nil)
	{
		localNotification.soundName = UILocalNotificationDefaultSoundName;
	}
	else
	{
		localNotification.soundName = soundfileName;
	}
    
	localNotification.alertLaunchImage = launchImage;
    
	self.badgeCount ++;
    localNotification.applicationIconBadgeNumber = self.badgeCount;
    localNotification.userInfo = userInfo;
    
	// Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void) handleReceivedNotification:(UILocalNotification*) thisNotification
{
	//NSLog(@"Received: %@",[thisNotification description]);
	[self decreaseBadgeCountBy:1];
}

- (void) clearBadgeCount
{
	self.badgeCount = 0;
	[UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void) decreaseBadgeCountBy:(int) count
{
	self.badgeCount -= count;
	if(self.badgeCount < 0) self.badgeCount = 0;
    
	[UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}
@end
