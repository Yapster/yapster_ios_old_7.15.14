//
//  Notifications.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/14/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notifications : NSObject

@property double notification_id;
@property double notification_type_id;
@property double reyap_count;
@property double like_count;
@property double listen_count;
@property double acting_user_id;
@property BOOL is_yapster_notification;
@property BOOL origin_reyap_flag;
@property BOOL user_seen_flag;
@property BOOL created_reyap_flag;
@property BOOL created_like_flag;
@property BOOL created_listen_flag;
@property BOOL user_read_flag;
@property BOOL is_users_yap;
@property NSString *notification_name;
@property NSString *notification_picture_path;
@property NSString *notification_message;
@property NSString *origin_reyap;
@property NSString *user;
@property NSString *acting_user;
@property NSString *created_listen;
@property NSDate *date_created;


-(id) initWithNotificationId: (double) notificationId andNotificationTypeId: (double) notificationTypeId andReyapCount: (double) reyapCount andListenCount: (double) listenCount andLikeCount: (double) likeCount andIsYapsterNotification: (BOOL) isYapsterNotification andOriginReyapFlag: (BOOL) originReyapFlag andUserSeenFlag: (BOOL) userSeenFlag andCreatedReyapFlag: (BOOL) createdReyapFlag andCreatedLikeFlag: (BOOL) createdLikeFlag andCreatedListenFlag: (BOOL) createdListenFlag andUserReadFlag: (BOOL) userReadFlag andIsUsersYap: (BOOL)isUsersYap andNotificationName: (NSString *) notificationName andNotificationPicturePath: (NSString *) notificationPicturePath andNotificationMessage: (NSString *) notificationMessage andOriginReyap: (NSString *) originReyap andUser: (NSString *) theUser andActingUser: (NSString *) actingUser andActingUserId: (double) actingUserId andCreatedListen: (NSString *) createdListen andDateCreated: (NSDate *) dateCreated;

@end
