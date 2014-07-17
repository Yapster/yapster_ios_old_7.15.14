//
//  GlobalVars.h
//  PixChat
//
//  Created by Abu-Bakar Bah on 1/10/14.
//  Copyright (c) 2014 Code Mob. All rights reserved.
//

#ifndef Globals_h
#define Globals_h
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

extern double sessionUserID;
extern double sessionID;
extern BOOL cameFromWebScreen;
extern BOOL cameFromPlaylist;
extern BOOL cameFromSearchResults;
extern BOOL cameFromCropImageScreen;
extern BOOL yapWasNotPlayed;
extern BOOL yapFinishedLoading;
extern BOOL exploreScreenFirstLoaded;
extern BOOL playlistScreenFirstLoaded;
extern BOOL yapScreenFirstLoaded;
extern BOOL cameFromPlayerScreen;
extern BOOL cameFromProfileScreen;

extern NSString *sessionEmail;
extern NSString *sessionUsername;
extern NSString *sessionFirstName;
extern NSString *sessionLastName;
extern NSString *sessionPassword;
extern NSString *sessionPhone;
extern NSString *sessionCountry;
extern UIImage *sessionUnCroppedPhoto;
extern UIImage *sessionCroppedPhoto;
extern UIImage *sessionUserCroppedPhoto;
extern UIImage *sessionUserUncroppedPhoto;
extern NSMutableArray *replyTo;
extern UIImageOrientation currentImageOrientation;

#endif

#import <Foundation/Foundation.h>

@interface GlobalVars : NSObject
{
    NSMutableArray *_truckBoxes;
    NSMutableArray *_farmerlist;
    NSString *_farmerCardNumber;
    NSString *_fName;
}

+ (GlobalVars *)sharedInstance;

@property(strong, nonatomic, readwrite) NSMutableArray *truckBoxes;
@property(strong, nonatomic, readwrite) NSMutableArray *farmerList;
@property(strong, nonatomic, readwrite) NSString *farmerCardNumber;
@property(strong, nonatomic, readwrite) NSString *fName;

@end