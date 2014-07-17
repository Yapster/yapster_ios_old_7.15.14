//
//  Feed.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/31/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject

@property BOOL liked_by_viewer;
@property int like_count;
@property int reyap_count;
@property NSArray *group;
@property double google_plus_account_id;
@property double facebook_account_id;
@property double twitter_account_id;
@property double linkedin_account_id;
@property BOOL reyapped_by_viewer;
@property BOOL listened_by_viewer;
@property BOOL hashtags_flag;
@property BOOL linkedin_shared_flag;
@property BOOL facebook_shared_flag;
@property BOOL twitter_shared_flag;
@property BOOL google_plus_shared_flag;
@property BOOL user_tags_flag;
@property BOOL web_link_flag;
@property BOOL picture_flag;
@property BOOL picture_cropped_flag;
@property BOOL is_active;
@property BOOL group_flag;
@property BOOL is_deleted;
@property int listen_count;
@property NSString *reyap_user;
@property NSString *latitude;
@property NSString *longitude;
@property NSString *yap_longitude;
@property NSString *username;
@property NSString *first_name;
@property NSString *last_name;
@property NSString *picture_path;
@property NSString *picture_cropped_path;
@property NSString *profile_picture_path;
@property NSString *profile_cropped_picture_path;
@property NSString *web_link;
@property NSString *yap_length;
@property double user_id;
@property double yap_id;
@property double reyap_id;
@property double reyap_user_id;
@property double user_post_id;
@property NSString *title;
@property NSString *audio_path;
@property NSArray *hashtags;
@property NSArray *user_tags;
@property(retain, nonatomic) NSDate *post_date_created;
@property(retain, nonatomic) NSDate *yap_date_created;

-(id) initWithYapId: (int) yapId andReyapId: (double) reyapId andUserPostId: (double) userPostId andLikedByViewer: (BOOL) likedByViewer andReyapUser: (NSString *) reyapUser andLikeCount: (int) likeCount andReyapCount: (int) reyapCount andGroup: (NSArray *) theGroup andGooglePlusAccountId: (double) googlePlusAccountId andFacebookAccountId: (double) facebookAccountId andTwitterAccountId: (double) twitterAccountId andLinkedinAccountId: (double) linkedinAccountId andReyappedByViewer: (BOOL) reyappedByViewer andListenedByViewer: (BOOL) listenedByViewer andHashtagsFlag: (BOOL) hashtagsFlag andLinkedinSharedFlag: (BOOL) linkedinSharedFlag andFacebookSharedFlag: (BOOL) facebookSharedFlag andTwitterSharedFlag: (BOOL) twitterSharedFlag andGooglePlusSharedFlag: (BOOL) googlePlusSharedFlag andUserTagsFlag: (BOOL) userTagsFlag andWebLinkFlag: (BOOL) webLinkFlag andPictureFlag: (BOOL) pictureFlag andPictureCroppedFlag: (BOOL) pictureCroppedFlag andIsActive: (BOOL) isActive andGroupFlag: (BOOL) groupFlag andIsDeleted: (BOOL) isDeleted andListenCount: (int) listenCount andLatitude: (NSString *) theLatitude andLongitude: (NSString *) theLongitude andYapLongitude: (NSString *) yapLongitude andUsername: (NSString *) theUsername andFirstName: (NSString *) firstName andLastName: (NSString *) lastName andPicturePath: (NSString *) picturePath andPictureCroppedPath: (NSString *) pictureCroppedPath andProfilePicturePath: (NSString *) profilePicturePath andProfileCroppedPicturePath: (NSString *) profileCroppedPicturePath andWebLink: (NSString *) webLink andYapLength: (NSString *) yapLength andUserId: (double) userId andReyapUserId: (double) reyapUserId andYapTitle: (NSString *) yapTitle andAudioPath: (NSString *) audioPath andUserTags: (NSArray *) userTags andHashtags: (NSArray *) theHashtags andPostDateCreated: (NSDate *) postDateCreated andYapDateCreated: (NSDate *) yapDateCreated;

@end
