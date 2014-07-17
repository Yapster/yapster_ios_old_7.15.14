//
//  Feed.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/31/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "Feed.h"

@implementation Feed

@synthesize liked_by_viewer;
@synthesize reyap_user;
@synthesize like_count;
@synthesize reyap_count;
@synthesize group;
@synthesize google_plus_account_id;
@synthesize facebook_account_id;
@synthesize twitter_account_id;
@synthesize linkedin_account_id;
@synthesize reyapped_by_viewer;
@synthesize listened_by_viewer;
@synthesize hashtags_flag;
@synthesize linkedin_shared_flag;
@synthesize facebook_shared_flag;
@synthesize twitter_shared_flag;
@synthesize google_plus_shared_flag;
@synthesize user_tags_flag;
@synthesize web_link_flag;
@synthesize picture_flag;
@synthesize picture_cropped_flag;
@synthesize is_active;
@synthesize group_flag;
@synthesize is_deleted;
@synthesize listen_count;
@synthesize latitude;
@synthesize longitude;
@synthesize yap_longitude;
@synthesize username;
@synthesize first_name;
@synthesize last_name;
@synthesize picture_path;
@synthesize picture_cropped_path;
@synthesize profile_picture_path;
@synthesize profile_cropped_picture_path;
@synthesize web_link;
@synthesize yap_length;
@synthesize user_id;
@synthesize yap_id;
@synthesize reyap_id;
@synthesize reyap_user_id;
@synthesize user_post_id;
@synthesize title;
@synthesize audio_path;
@synthesize user_tags;
@synthesize hashtags;
@synthesize post_date_created;
@synthesize yap_date_created;

-(id) initWithYapId: (int) yapId andReyapId: (double) reyapId andUserPostId: (double) userPostId andLikedByViewer: (BOOL) likedByViewer andReyapUser: (NSString *) reyapUser andLikeCount: (int) likeCount andReyapCount: (int) reyapCount andGroup: (NSArray *) theGroup andGooglePlusAccountId: (double) googlePlusAccountId andFacebookAccountId: (double) facebookAccountId andTwitterAccountId: (double) twitterAccountId andLinkedinAccountId: (double) linkedinAccountId andReyappedByViewer: (BOOL) reyappedByViewer andListenedByViewer: (BOOL) listenedByViewer andHashtagsFlag: (BOOL) hashtagsFlag andLinkedinSharedFlag: (BOOL) linkedinSharedFlag andFacebookSharedFlag: (BOOL) facebookSharedFlag andTwitterSharedFlag: (BOOL) twitterSharedFlag andGooglePlusSharedFlag: (BOOL) googlePlusSharedFlag andUserTagsFlag: (BOOL) userTagsFlag andWebLinkFlag: (BOOL) webLinkFlag andPictureFlag: (BOOL) pictureFlag andPictureCroppedFlag: (BOOL) pictureCroppedFlag andIsActive: (BOOL) isActive andGroupFlag: (BOOL) groupFlag andIsDeleted: (BOOL) isDeleted andListenCount: (int) listenCount andLatitude: (NSString *) theLatitude andLongitude: (NSString *) theLongitude andYapLongitude: (NSString *) yapLongitude andUsername: (NSString *) theUsername andFirstName: (NSString *) firstName andLastName: (NSString *) lastName andPicturePath: (NSString *) picturePath andPictureCroppedPath: (NSString *) pictureCroppedPath andProfilePicturePath: (NSString *) profilePicturePath andProfileCroppedPicturePath: (NSString *) profileCroppedPicturePath andWebLink: (NSString *) webLink andYapLength: (NSString *) yapLength andUserId: (double) userId andReyapUserId: (double) reyapUserId andYapTitle: (NSString *) yapTitle andAudioPath: (NSString *) audioPath andUserTags: (NSArray *) userTags andHashtags: (NSArray *) theHashtags andPostDateCreated: (NSDate *) postDateCreated andYapDateCreated: (NSDate *) yapDateCreated {
    
    self = [super init];
    
    if (self) {
        yap_id = yapId;
        reyap_id = reyapId;
        user_post_id = userPostId;
        liked_by_viewer = likedByViewer;
        reyap_user = reyapUser;
        like_count = likeCount;
        reyap_count = reyapCount;
        group = theGroup;
        google_plus_account_id = googlePlusAccountId;
        facebook_account_id = facebookAccountId;
        twitter_account_id = twitterAccountId;
        linkedin_account_id = linkedinAccountId;
        reyapped_by_viewer = reyappedByViewer;
        listened_by_viewer = listenedByViewer;
        hashtags_flag = hashtagsFlag;
        linkedin_shared_flag = linkedinSharedFlag;
        facebook_shared_flag = facebookSharedFlag;
        twitter_shared_flag = twitterSharedFlag;
        google_plus_shared_flag = googlePlusSharedFlag;
        user_tags_flag = userTagsFlag;
        web_link_flag = webLinkFlag;
        picture_flag = pictureFlag;
        picture_cropped_flag = pictureCroppedFlag;
        profile_picture_path = profilePicturePath;
        profile_cropped_picture_path = profileCroppedPicturePath;
        is_active = isActive;
        group_flag = groupFlag;
        listen_count = listenCount;
        latitude = theLatitude;
        longitude = theLongitude;
        yap_longitude = yapLongitude;
        username = theUsername;
        first_name = firstName;
        last_name = lastName;
        picture_path = picturePath;
        picture_cropped_path = pictureCroppedPath;
        web_link = webLink;
        yap_length = yapLength;
        user_id = userId;
        reyap_user_id = reyapUserId;
        title = yapTitle;
        audio_path = audioPath;
        user_tags = userTags;
        hashtags = theHashtags;
        post_date_created = postDateCreated;
        yap_date_created = yapDateCreated;
    }
    
    return self;
    
}

@end
