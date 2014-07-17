//
//  UserInfo.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/23/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property NSString *location_city;
@property NSString *location_state;
@property double listener_count;
@property NSString *description;
@property NSString *location_country;
@property NSString *phone;
@property double listening_count;
@property BOOL is_active;
@property BOOL viewer_listening_to_user;
@property BOOL user_listening_to_viewer;
@property double listen_count;
@property NSString *location_zip_code;
@property BOOL profile_picture_flag;
@property BOOL profile_cropped_picture_flag;
@property NSDate *date_of_birth;
@property BOOL verified_account_flag;
@property double like_count;
@property BOOL high_security_account_flag;
@property BOOL posts_are_private;
@property BOOL listen_stream_public;
@property NSString *username;
@property NSString *first_name;
@property NSString *last_name;
@property double user_id;
@property double reyap_count;
@property NSString *profile_picture_path;
@property NSString *profile_cropped_picture_path;
@property double yap_count;

-(id) initWithUserId: (double) userId andLocationCity: (NSString *) locationCity andLocationState: (NSString *) locationState andListenerCount: (double) listenerCount andDescription: (NSString *) theDescription andLocationCountry: (NSString *) locationCountry andPhone: (NSString *) thePhone andListeningCount: (double) listeningCount andIsActive: (BOOL) isActive andViewerListeningToUser: (BOOL) viewerListeningToUser andUserListeningToViewer: (BOOL) userListeningToViewer andListenCount: (double) listenCount andLocationZipCode: (NSString *) locationZipCode andProfilePictureFlag: (BOOL) profilePictureFlag andProfileCroppedPictureFlag: (BOOL) profileCroppedPictureFlag andDateOfBirth: (NSDate *) dateOfBirth andVerifiedAccountFlag: (BOOL) verifiedAccountFlag andLikeCount: (double) likeCount andHighSecurityAccountFlag: (BOOL) highSecurityAccountFlag andPostsArePrivate: (BOOL) postsArePrivate andListenStreamPublic: (BOOL) listenStreamPublic andUsername: (NSString *) theUsername andFirstName: (NSString *) firstName andLastName: (NSString *) lastName andReyapCount: (double) reyapCount andProfilePicturePath: (NSString *) profilePicturePath andProfileCroppedPicturePath: (NSString *) profileCroppedPicturePath andYapCount: (double) yapCount;

@end
