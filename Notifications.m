//
//  Notifications.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/14/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "Notifications.h"

@implementation Notifications

@synthesize notification_id;
@synthesize notification_type_id;
@synthesize reyap_count;
@synthesize like_count;
@synthesize listen_count;
@synthesize acting_user_id;
@synthesize is_yapster_notification;
@synthesize origin_reyap_flag;
@synthesize user_seen_flag;
@synthesize created_reyap_flag;
@synthesize created_like_flag;
@synthesize created_listen_flag;
@synthesize user_read_flag;
@synthesize is_users_yap;
@synthesize notification_name;
@synthesize notification_picture_path;
@synthesize notification_message;
@synthesize origin_reyap;
@synthesize user;
@synthesize acting_user;
@synthesize created_listen;
@synthesize date_created;

-(id) initWithNotificationId: (double) notificationId andNotificationTypeId: (double) notificationTypeId andReyapCount: (double) reyapCount andListenCount: (double) listenCount andLikeCount: (double) likeCount andIsYapsterNotification: (BOOL) isYapsterNotification andOriginReyapFlag: (BOOL) originReyapFlag andUserSeenFlag: (BOOL) userSeenFlag andCreatedReyapFlag: (BOOL) createdReyapFlag andCreatedLikeFlag: (BOOL) createdLikeFlag andCreatedListenFlag: (BOOL) createdListenFlag andUserReadFlag: (BOOL) userReadFlag andIsUsersYap: (BOOL)isUsersYap andNotificationName: (NSString *) notificationName andNotificationPicturePath: (NSString *) notificationPicturePath andNotificationMessage: (NSString *) notificationMessage andOriginReyap: (NSString *) originReyap andUser: (NSString *) theUser andActingUser: (NSString *) actingUser andActingUserId: (double) actingUserId andCreatedListen: (NSString *) createdListen andDateCreated: (NSDate *) dateCreated {
    
    self = [super init];
    
    if (self) {
        notification_id = notificationId;
        notification_type_id = notificationTypeId;
        reyap_count = reyapCount;
        like_count = likeCount;
        listen_count = listenCount;
        acting_user_id = actingUserId;
        is_yapster_notification = isYapsterNotification;
        origin_reyap_flag = originReyapFlag;
        user_seen_flag = userSeenFlag;
        created_reyap_flag = createdReyapFlag;
        created_like_flag = createdLikeFlag;
        created_listen_flag = createdListenFlag;
        created_listen_flag = createdListenFlag;
        user_read_flag = userReadFlag;
        is_users_yap = isUsersYap;
        notification_name = notificationName;
        notification_picture_path = notificationPicturePath;
        notification_message = notificationMessage;
        origin_reyap = originReyap;
        user = theUser;
        acting_user = actingUser;
        created_listen = createdListen;
        date_created = dateCreated;
    }
    
    return self;
}

@end
