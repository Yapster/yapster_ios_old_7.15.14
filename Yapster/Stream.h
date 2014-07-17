//
//  Stream.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/28/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"
#import "Feed.h"
#import "StreamCell.h"
#import "MenuTableCell.h"
#import "Reachability.h"
#import "ReportAProblem.h"
#import "UserProfile.h"
#import "Explore.h"
#import "CreateYap.h"
#import "PlayerScreen.h"
#import <AWSRuntime/AWSRuntime.h>
#import "AmazonClientManager.h"
#import "SWTableViewCell.h"
#import "MyManager.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"
#import "AFNetworking/AFNetworking.h"
#import <CoreImage/CoreImage.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <SDWebImage/UIImageView+WebCache.h>


@class UserSettings;
@class UserNotifications;
@class SearchResults;
@class AppPhotoRecord;

@interface Stream : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SWTableViewCellDelegate>
{
    IBOutlet UIActivityIndicatorView *loadingData;
    IBOutlet UIActivityIndicatorView *loadingMoreData;
    IBOutlet UIButton *playAllBtn;
    IBOutlet UILabel *message;
    IBOutlet UIButton *menu_btn;
    IBOutlet UIButton *yap_btn;
    IBOutlet UIView *topNav;
    IBOutlet UIView *subNav;
    
    int postAmount;
    int nextAmount;
    int numLoadedPosts;
    
    BOOL isSearch;
    BOOL isSearch2;
    BOOL isFullMenu;
    BOOL isRefresh;
    
    BOOL playerActive;
    
    SLComposeViewController *mySLComposerSheet;
}

@property(retain, nonatomic) UIRefreshControl *refreshControl;
@property BOOL menuOpen;
@property BOOL searchBoxVisible;
@property BOOL isLoadingMorePosts;
@property BOOL isLoadingMoreSearchPosts;
@property double after_yap;
@property double after_reyap;
@property double last_after_yap;
@property double last_after_reyap;
@property SWTableViewCell *current_cell;
@property double current_yap_to_delete;
@property double current_yap_to_report;
@property(retain, nonatomic)UIAlertView *alertViewConfirmDelete;
@property(retain, nonatomic)UIAlertView *alertViewConfirmReport;
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
@property(retain, nonatomic)NSTimer *timer;
@property(retain, nonatomic)IBOutlet UITableView *theTable;
@property (strong, nonatomic) IBOutlet UITableView *menuTable;
@property (strong, nonatomic) NSArray *menuKeys;
@property (strong, nonatomic) NSDictionary *menuItems;
@property (nonatomic) IBOutlet UIView *topLayer;
@property (nonatomic) CGFloat layerPosition;
@property(retain, nonatomic)IBOutlet UILabel *noMorePostsMessage;
@property(retain, nonatomic)NSArray *json;
@property(retain, nonatomic)NSMutableDictionary *deleteYapJson;
@property(retain, nonatomic)NSMutableDictionary *reportYapJson;
@property(retain, nonatomic)NSString *responseBody;
@property(retain, nonatomic)NSString *responseBodyDeleteYap;
@property(retain, nonatomic)NSString *responseBodyReportYap;
@property(retain, nonatomic)NSString *responseBodySearchYaps;
@property(retain, nonatomic)NSMutableArray *userFeed;
@property(retain, nonatomic)IBOutlet UIButton *searchButton;
@property(retain, nonatomic)IBOutlet UIButton *cancelButton;
@property(retain, nonatomic)IBOutlet UITextField *searchBox;
@property(retain, nonatomic)IBOutlet UIButton *menuSearchCancelButton;
@property(retain, nonatomic)IBOutlet UITextField *menuSearchBox;
@property(retain, nonatomic)NSURLConnection *connection1;
@property(retain, nonatomic)NSURLConnection *connection2;
@property(retain, nonatomic)NSURLConnection *connection3;
@property(retain, nonatomic)NSURLConnection *connection4;
@property(retain, nonatomic)NSURLConnection *connection5;
@property(retain, nonatomic)NSURLConnection *connection6;
@property(retain, nonatomic)NSURLConnection *connection7;
@property(nonatomic, strong)NSMutableArray *photos;
@property(nonatomic, strong)PendingOperations *pendingOperations;
@property(retain, nonatomic)NSMutableArray *records;
@property(retain, nonatomic)SDWebImageManager *image_download_manager;
@property(nonatomic, strong)NSMutableArray *user_photo_entries;
@property(nonatomic, strong)NSMutableArray *workingArray;
@property(nonatomic, strong)AppPhotoRecord *workingEntry;
@property(nonatomic, strong)NSMutableDictionary *imageDownloadsInProgress;

-(IBAction)toggleMenu;
-(IBAction)toggleSearchBox:(id)sender;
-(IBAction)showCancelButton:(id)sender;
-(IBAction)goToYapScreen:(id)sender;
-(IBAction)goToUserProfile:(id)sender;
-(IBAction)playAll:(id)sender;
-(IBAction)doSearch:(id)sender;
-(IBAction)doMenuSearch:(id)sender;
-(IBAction)cancelSearch:(id)sender;
-(IBAction)cancelMenuSearch:(id)sender;
-(void)refreshStream;

@end
