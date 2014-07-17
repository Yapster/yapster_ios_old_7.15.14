//
//  GetRecommendedUsers.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/31/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"
#import "UsersTableCell.h"
#import "Reachability.h"
#import "Stream.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"
#import "AFNetworking/AFNetworking.h"

@class AppPhotoRecord;

@interface GetRecommendedUsers : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel *labelCurrentFollowingCount;
    IBOutlet UIButton *startBtn;
    IBOutlet UIActivityIndicatorView *loadingData;
    
    int currentFollowingCount;
}

@property(retain, nonatomic)IBOutlet UITableView *usersTable;
@property(retain, nonatomic)Stream *stream;
@property(retain, nonatomic)NSString *username;
@property(retain, nonatomic)NSString *password;
@property(retain, nonatomic)NSString *retypePassword;
@property(retain, nonatomic)NSString *firstName;
@property(retain, nonatomic)NSString *lastName;
@property(retain, nonatomic)NSString *email;
@property(retain, nonatomic)NSString *DOB;
@property(retain, nonatomic)NSString *city;
@property(retain, nonatomic)NSString *state;
@property(retain, nonatomic)NSString*zipcode;
@property(retain, nonatomic)NSString *country;
@property(retain, nonatomic)NSString *phone;
@property(retain, nonatomic)NSString *description;
@property(retain, nonatomic)NSArray *json;
@property(retain, nonatomic)NSMutableDictionary *followJson;
@property(retain, nonatomic)NSMutableDictionary *unfollowJson;
@property(retain, nonatomic)NSString *responseBodyUsers;
@property(retain, nonatomic)NSString *responseBodyFollow;
@property(retain, nonatomic)NSString *responseBodyUnfollow;
@property (nonatomic, strong)NSMutableArray *followedUsers;
@property(retain, nonatomic)NSMutableArray *recommendedUsersData;
@property(retain, nonatomic)NSURLConnection *connection1;
@property(retain, nonatomic)NSURLConnection *connection2;
@property(retain, nonatomic)NSURLConnection *connection3;
@property(retain, nonatomic)NSURLConnection *connection4;
@property(retain, nonatomic)NSURLConnection *connection5;
@property(retain, nonatomic)NSURLConnection *connection6;
@property (nonatomic, strong)NSMutableArray *photos;
@property (nonatomic, strong)PendingOperations *pendingOperations;
@property(retain, nonatomic)NSMutableArray *records;
@property(nonatomic, strong)NSMutableArray *user_photo_entries;
@property(nonatomic, strong)NSMutableArray *workingArray;
@property(nonatomic, strong)AppPhotoRecord *workingEntry;
@property(nonatomic, strong)NSMutableDictionary *imageDownloadsInProgress;

-(IBAction)goBack:(id)sender;
-(IBAction)followOrUnfollowUser:(id)sender;
-(IBAction)start:(id)sender;

@end
