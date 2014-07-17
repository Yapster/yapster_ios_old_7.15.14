//
//  SearchResults.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/30/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"
#import "Feed.h"
#import "StreamCell.h"
#import "Reachability.h"
#import "ReportAProblem.h"
#import "PlayerScreen.h"
#import "MyManager.h"
#import "UsersTableCell.h"
#import "SWTableViewCell.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"
#import "AFNetworking/AFNetworking.h"
#import <CoreImage/CoreImage.h>

@class Playlist;
@class UserProfile;
@class UserSettings;
@class UserNotifications;
@class Explore;
@class AppPhotoRecord;

@interface SearchResults : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, SWTableViewCellDelegate>

{
    IBOutlet UIButton *trendingBtn;
    IBOutlet UIButton *peopleBtn;
    IBOutlet UIButton *recentBtn;
    IBOutlet UIButton *playAllBtn;
    IBOutlet UIImageView *leftBorder;
    IBOutlet UIImageView *rightBorder;
    IBOutlet UIImageView *channelsViewBorder;
    IBOutlet UIScrollView *channelsView;
    IBOutlet UIActivityIndicatorView *loadingData;
    IBOutlet UILabel *label_search_text;
    IBOutlet UIButton *back_btn;
    IBOutlet UIView *topNav;
    IBOutlet UIView *subNav;
    
    int postAmount;
    int nextAmount;
    int numLoadedPosts;
    
    BOOL isFullMenu;
    BOOL isRefresh;
    BOOL playerActive;
}

@property(retain, nonatomic) UIRefreshControl *refreshControl;
@property BOOL menuOpen;
@property(retain, nonatomic)PlayerScreen *playerScreenVC;
@property(retain, nonatomic)Playlist *playlistVC;
@property(retain, nonatomic)UserProfile *UserProfileVC;
@property(retain, nonatomic)MyManager *sharedManager;
@property BOOL isLoadingMorePosts;
@property BOOL hashtagSearch;
@property BOOL channelSearch;
@property BOOL userSearch;
@property BOOL textSearch;
@property double after_yap;
@property double after_reyap;
@property double last_after_yap;
@property double last_after_reyap;
@property SWTableViewCell *current_cell;
@property double current_yap_to_delete;
@property double current_yap_to_report;
@property(retain, nonatomic)UIAlertView *alertViewConfirmDelete;
@property(retain, nonatomic)UIAlertView *alertViewConfirmReport;
@property(retain, nonatomic)IBOutlet UITableView *theTable;
@property(retain, nonatomic)IBOutlet UITableView *usersTable;
@property(retain, nonatomic)IBOutlet UILabel *message;
@property(retain, nonatomic)NSString *search_text;
@property(retain, nonatomic)NSString *search_text_for_label;
@property(retain, nonatomic)NSMutableArray *selectedChannels;
@property(retain, nonatomic)NSMutableArray *hashtags_array;
@property(retain, nonatomic)NSMutableArray *users;
@property (nonatomic, strong)NSMutableDictionary *channelImagesUnclicked;
@property (nonatomic, strong)NSMutableDictionary *channelImagesClicked;
@property(retain, nonatomic)NSArray *json;
@property(retain, nonatomic)NSMutableDictionary *followJson;
@property(retain, nonatomic)NSMutableDictionary *unfollowJson;
@property(retain, nonatomic)NSMutableDictionary *deleteYapJson;
@property(retain, nonatomic)NSMutableDictionary *reportYapJson;
@property(retain, nonatomic)NSString *responseBody;
@property(retain, nonatomic)NSMutableArray *userFeed;
@property(retain, nonatomic)NSString *responseBodyUsers;
@property(retain, nonatomic)NSString *responseBodyFollow;
@property(retain, nonatomic)NSString *responseBodyUnfollow;
@property(retain, nonatomic)NSString *responseBodyDeleteYap;
@property(retain, nonatomic)NSString *responseBodyReportYap;
@property(retain, nonatomic)NSMutableArray *usersResults;
@property(retain, nonatomic)NSURLConnection *connection1;
@property(retain, nonatomic)NSURLConnection *connection2;
@property(retain, nonatomic)NSURLConnection *connection3;
@property(retain, nonatomic)NSURLConnection *connection4;
@property(retain, nonatomic)NSURLConnection *connection5;
@property(retain, nonatomic)NSURLConnection *connection6;
@property(retain, nonatomic)NSURLConnection *connection7;
@property (nonatomic, strong)NSMutableArray *photos;
@property (nonatomic, strong)PendingOperations *pendingOperations;
@property(retain, nonatomic)NSMutableArray *records;
@property(retain, nonatomic)Stream *streamVC;
@property(retain, nonatomic)SearchResults *searchResultsVC;
@property(retain, nonatomic)UserSettings *UserSettingsVC;
@property(retain, nonatomic)ReportAProblem *ReportAProblemVC;
@property(retain, nonatomic)Explore *ExploreVC;
@property(retain, nonatomic)IBOutlet UIButton *menuSearchCancelButton;
@property(retain, nonatomic)IBOutlet UITextField *menuSearchBox;
@property (strong, nonatomic) IBOutlet UITableView *menuTable;
@property (strong, nonatomic) NSArray *menuKeys;
@property (strong, nonatomic) NSDictionary *menuItems;
@property (nonatomic) IBOutlet UIView *topLayer;
@property (nonatomic) CGFloat layerPosition;
@property(nonatomic, strong)NSMutableArray *user_photo_entries;
@property(nonatomic, strong)NSMutableArray *workingArray;
@property(nonatomic, strong)AppPhotoRecord *workingEntry;
@property(nonatomic, strong)NSMutableDictionary *imageDownloadsInProgress;

-(IBAction)goBack:(id)sender;
-(IBAction)playAll:(id)sender;
-(IBAction)showTrending:(id)sender;
-(IBAction)showPeople:(id)sender;
-(IBAction)showRecent:(id)sender;
-(void)viewTrendingBackgroundJob;
-(void)viewPeopleBackgroundJob;
-(void)viewRecentBackgroundJob;
-(IBAction)goToUserProfile:(id)sender;
-(void)goToUserProfileFromCell:(double)user_id;
-(IBAction)followOrUnfollowUser:(id)sender;
-(IBAction)showCancelButton:(id)sender;
-(IBAction)doMenuSearch:(id)sender;
-(IBAction)cancelMenuSearch:(id)sender;

@end
