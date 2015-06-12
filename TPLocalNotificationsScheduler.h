//
//  TPLocalNotificationsScheduler.h
//  greenline_POC
//
//  Created by Tony Person on 4/16/14.
//  Copyright 2014 Tony Person. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPLocalNotificationsScheduler : NSObject
@property (nonatomic) NSInteger badgeCount;
+ (TPLocalNotificationsScheduler*) sharedInstance;
- (void) scheduleNotificationOn:(NSDate*) fireDate
                           text:(NSString*) alertText
                         action:(NSString*) alertAction
                          sound:(NSString*) soundfileName
                    launchImage:(NSString*) launchImage
                        andInfo:(NSDictionary*) userInfo;
- (void) handleReceivedNotification:(UILocalNotification*) thisNotification;
- (void) clearBadgeCount;
@end
