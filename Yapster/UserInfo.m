//
//  UserInfo.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/23/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize location_city;
@synthesize location_state;
@synthesize listener_count;
@synthesize description;
@synthesize location_country;
@synthesize phone;
@synthesize listening_count;
@synthesize is_active;
@synthesize viewer_listening_to_user;
@synthesize user_listening_to_viewer;
@synthesize listen_count;
@synthesize location_zip_code;
@synthesize profile_picture_flag;
@synthesize profile_cropped_picture_flag;
@synthesize date_of_birth;
@synthesize verified_account_flag;
@synthesize like_count;
@synthesize high_security_account_flag;
@synthesize posts_are_private;
@synthesize listen_stream_public;
@synthesize username;
@synthesize first_name;
@synthesize last_name;
@synthesize user_id;
@synthesize reyap_count;
@synthesize profile_picture_path;
@synthesize profile_cropped_picture_path;
@synthesize yap_count;

-(id) initWithUserId: (double) userId andLocationCity: (NSString *) locationCity andLocationState: (NSString *) locationState andListenerCount: (double) listenerCount andDescription: (NSString *) theDescription andLocationCountry: (NSString *) locationCountry andPhone: (NSString *) thePhone andListeningCount: (double) listeningCount andIsActive: (BOOL) isActive andViewerListeningToUser: (BOOL) viewerListeningToUser andUserListeningToViewer: (BOOL) userListeningToViewer andListenCount: (double) listenCount andLocationZipCode: (NSString *) locationZipCode andProfilePictureFlag: (BOOL) profilePictureFlag andProfileCroppedPictureFlag: (BOOL) profileCroppedPictureFlag andDateOfBirth: (NSDate *) dateOfBirth andVerifiedAccountFlag: (BOOL) verifiedAccountFlag andLikeCount: (double) likeCount andHighSecurityAccountFlag: (BOOL) highSecurityAccountFlag andPostsArePrivate: (BOOL) postsArePrivate andListenStreamPublic: (BOOL) listenStreamPublic andUsername: (NSString *) theUsername andFirstName: (NSString *) firstName andLastName: (NSString *) lastName andReyapCount: (double) reyapCount andProfilePicturePath: (NSString *) profilePicturePath andProfileCroppedPicturePath: (NSString *) profileCroppedPicturePath andYapCount: (double) yapCount {
    
    self = [super init];
    
    if (self) {
        user_id = userId;
        location_city = locationCity;
        location_state = locationState;
        listener_count = listenerCount;
        description = theDescription;
        location_country = locationCountry;
        phone = thePhone;
        listening_count = listeningCount;
        is_active = isActive;
        viewer_listening_to_user = viewerListeningToUser;
        user_listening_to_viewer = userListeningToViewer;
        listen_count = listenCount;
        location_zip_code = locationZipCode;
        profile_picture_flag = profilePictureFlag;
        profile_cropped_picture_flag = profilePictureFlag;
        date_of_birth = dateOfBirth;
        verified_account_flag = verifiedAccountFlag;
        like_count = likeCount;
        high_security_account_flag = highSecurityAccountFlag;
        posts_are_private = postsArePrivate;
        listen_stream_public = listenStreamPublic;
        username = theUsername;
        first_name = firstName;
        last_name = lastName;
        reyap_count = reyapCount;
        profile_picture_path = profilePicturePath;
        profile_cropped_picture_path = profileCroppedPicturePath;
        yap_count = yapCount;
        
    }
    
    return self;
    
}

@end
