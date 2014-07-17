//
//  UserNotifications.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/9/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserNotificationsTableCell.h"
#import "GlobalVars.h"
#import "Reachability.h"
#import "ReportAProblem.h"
#import "UserProfile.h"
#import "Explore.h"
#import "CreateYap.h"
#import "Notifications.h"
#import "MyManager.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"
#import "AFNetworking/AFNetworking.h"
#import <CoreImage/CoreImage.h>

@class UserSettings;
@class Stream;
@class SearchResults;
@class AppPhotoRecord;

@interface UserNotifications : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
    IBOutlet UIActivityIndicatorView *loadingData;
    IBOutlet UIActivityIndicatorView *loadingMoreData;
    
    IBOutlet UILabel *message;
    IBOutlet UIButton *btn_ViewToday;
    IBOutlet UIButton *btn_ViewMissed;
    
    int postAmount;
    int nextAmount;
    int numLoadedPosts;
    
    BOOL isFullMenu;
    BOOL isRefresh;
    BOOL playerActive;
}

@property(retain, nonatomic) UIRefreshControl *refreshControl;
@property BOOL menuOpen;
@property BOOL searchBoxVisible;
@property BOOL isLoadingMorePosts;
@property double last_object_id;
@property(retain, nonatomic)Feed *userFeedObject;
@property(retain, nonatomic)StreamCell *streamCell;
@property(retain, nonatomic)UserSettings *UserSettingsVC;
@property(retain, nonatomic)ReportAProblem *ReportAProblemVC;
@property(retain, nonatomic)UserProfile *UserProfileVC;
@property(retain, nonatomic)Explore *ExploreVC;
@property(retain, nonatomic)CreateYap *createYapVC;
@property(retain, nonatomic)PlayerScreen *playerScreenVC;
@property(retain, nonatomic)Playlist *playlistVC;
@property(retain, nonatomic)MyManager *sharedManager;
@property(retain, nonatomic)SearchResults *searchResultsVC;
@property(retain, nonatomic)IBOutlet UIButton *menuSearchCancelButton;
@property(retain, nonatomic)IBOutlet UITextField *menuSearchBox;
@property(retain, nonatomic)NSTimer *timer;
@property(retain, nonatomic)IBOutlet UITableView *theTable;
@property (strong, nonatomic) IBOutlet UITableView *menuTable;
@property (strong, nonatomic) NSArray *menuKeys;
@property (strong, nonatomic) NSDictionary *menuItems;
@property (nonatomic) IBOutlet UIView *topLayer;
@property (nonatomic) CGFloat layerPosition;
@property(retain, nonatomic)IBOutlet UILabel *noMorePostsMessage;
@property(retain, nonatomic)NSArray *json;
@property(retain, nonatomic)NSString *responseBody;
@property(retain, nonatomic)NSMutableArray *userFeed;
@property(retain, nonatomic)NSMutableArray *yapsInfo;
@property(retain, nonatomic)IBOutlet UIButton *searchButton;
@property(retain, nonatomic)IBOutlet UIButton *cancelButton;
@property(retain, nonatomic)IBOutlet UITextField *searchBox;
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

-(IBAction)toggleMenu;
-(IBAction)goToYapScreen:(id)sender;
-(IBAction)viewToday:(id)sender;
-(IBAction)viewMissed:(id)sender;
-(void)viewTodayBackgroundJob;
-(void)viewMissedBackgroundJob;
-(IBAction)goToUserProfile:(id)sender;
-(IBAction)showCancelButton:(id)sender;
-(IBAction)doMenuSearch:(id)sender;
-(IBAction)cancelMenuSearch:(id)sender;

@end
