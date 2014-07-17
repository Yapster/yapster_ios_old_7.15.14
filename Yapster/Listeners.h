//
//  Listeners.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/25/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"
#import "UsersTableCell.h"
#import "Reachability.h"
#import "ReportAProblem.h"
#import "PlayerScreen.h"
#import "Explore.h"
#import <AWSRuntime/AWSRuntime.h>
#import "AmazonClientManager.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"
#import "AFNetworking/AFNetworking.h"
#import <CoreImage/CoreImage.h>
#import "MyManager.h"

@class UserProfile;
@class UserSettings;
@class UserNotifications;
@class SearchResults;
@class AppPhotoRecord;

@interface Listeners : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, AmazonServiceRequestDelegate> {
    
    IBOutlet UILabel *label_follower_count;
    IBOutlet UILabel *label_followers;
    
    IBOutlet UIActivityIndicatorView *loadingData;
    IBOutlet UILabel *message;
    
    int postAmount;
    int nextAmount;
    int numLoadedPosts;
    
    BOOL isFullMenu;
    BOOL playerActive;
}

@property(retain, nonatomic)IBOutlet UITableView *usersTable;
@property BOOL menuOpen;
@property double the_user;
@property double follower_count;
@property double last_user_id;
@property(retain, nonatomic)UserProfile *UserProfileVC;
@property(retain, nonatomic)NSArray *json;
@property(retain, nonatomic)NSString *responseBodyFollowers;
@property(retain, nonatomic)NSMutableArray *userFollowers;
@property(retain, nonatomic)NSURLConnection *connection1;
@property(retain, nonatomic)NSURLConnection *connection3;
@property (nonatomic, strong)NSMutableArray *photos;
@property (nonatomic, strong)PendingOperations *pendingOperations;
@property(retain, nonatomic)NSMutableArray *records;
@property(retain, nonatomic)MyManager *sharedManager;
@property(retain, nonatomic)Stream *streamVC;
@property(retain, nonatomic)SearchResults *searchResultsVC;
@property(retain, nonatomic)UserSettings *UserSettingsVC;
@property(retain, nonatomic)ReportAProblem *ReportAProblemVC;
@property(retain, nonatomic)PlayerScreen *playerScreenVC;
@property(retain, nonatomic)Explore *ExploreVC;
@property(retain, nonatomic)IBOutlet UIButton *menuSearchCancelButton;
@property(retain, nonatomic)IBOutlet UITextField *menuSearchBox;
@property (strong, nonatomic) IBOutlet UITableView *menuTable;
@property (strong, nonatomic) NSArray *menuKeys;
@property (strong, nonatomic) NSDictionary *menuItems;
@property (nonatomic) IBOutlet UIView *topLayer;
@property (nonatomic) CGFloat layerPosition;
@property BOOL isLoadingMorePosts;
@property(nonatomic, strong)NSMutableArray *user_photo_entries;
@property(nonatomic, strong)NSMutableArray *workingArray;
@property(nonatomic, strong)AppPhotoRecord *workingEntry;
@property(nonatomic, strong)NSMutableDictionary *imageDownloadsInProgress;

-(IBAction)goBack:(id)sender;
-(IBAction)toggleMenu;
-(IBAction)goToUserProfile:(id)sender;
-(void)goToUserProfileFromCell:(double)user_id;
-(IBAction)showCancelButton:(id)sender;
-(IBAction)doMenuSearch:(id)sender;
-(IBAction)cancelMenuSearch:(id)sender;

@end
