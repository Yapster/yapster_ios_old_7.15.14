//
//  UserProfile.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/23/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"
#import "UserInfo.h"
#import "StreamCell.h"
#import "Reachability.h"
#import "ReportAProblem.h"
#import "Explore.h"
#import "PlayerScreen.h"
#import "EditProfile.h"
#import "Listening.h"
#import "Listeners.h"
#import <AWSRuntime/AWSRuntime.h>
#import "AmazonClientManager.h"
#import "SWTableViewCell.h"
#import "MyManager.h"
#import "CreateYap.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"
#import "AFNetworking/AFNetworking.h"
#import <CoreImage/CoreImage.h>
#import "ZoomableView.h"

@class UserSettings;
@class Stream;
@class UserNotifications;
@class SearchResults;
@class AppPhotoRecord;

@interface UserProfile : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, SWTableViewCellDelegate>
{
    IBOutlet UILabel *nav_title_label;
    IBOutlet UIActivityIndicatorView *loadingData;
    IBOutlet UIActivityIndicatorView *loadingData2;
    IBOutlet UIActivityIndicatorView *loadingMoreData;
    IBOutlet UISegmentedControl *segmentController;
    IBOutlet UIScrollView *scrollView1;
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UIView *segmentControllerAndTableView;
    IBOutlet UIView *rightOptions;
    IBOutlet UIView *userInfoView;
    IBOutlet UIImageView *user_verified;
    IBOutlet UILabel *top_message;
    IBOutlet UILabel *message;
    IBOutlet UILabel *full_name_label;
    IBOutlet UILabel *username_label;
    IBOutlet UILabel *yap_count_label;
    IBOutlet UILabel *listening_label;
    IBOutlet UILabel *listeners_label;
    IBOutlet UILabel *location_label;
    IBOutlet UILabel *listens_to_you_label;
    IBOutlet UILabel *description_label;
    IBOutlet UIButton *edit_profile_btn;
    IBOutlet UIButton *listen_btn;
    IBOutlet UIButton *listening_btn;
    IBOutlet UIButton *requested_btn;
    IBOutlet UIButton *menu_btn;
    IBOutlet UIButton *back_btn;
    IBOutlet UIButton *yap_btn;
    IBOutlet UIButton *user_photo_btn;
    IBOutlet UIView *topNav;
    IBOutlet UIView *userMainInfoView;
    IBOutlet UIView *acceptOrDenyView;
    IBOutlet UIView *bottomView;
    IBOutlet UIView *bigYapPhotoViewWrapper;
    UIImageView *bigYapPhotoView;
    IBOutlet UIButton *doneBtn;
    
    BOOL isSearch;
    BOOL isSearch2;
    
    int postAmount;
    int nextAmount;
    int numLoadedPosts;
    
    BOOL playerActive;
    
    int tableOffset;
    
    CGRect desc_frame;
    
    CGRect rightOptions_original_position;
}

@property BOOL cameFromMenu;
@property BOOL cameFromPushNotifications;
@property BOOL playlistIsNotEmpty;
@property BOOL menuOpen;
@property BOOL searchBoxVisible;
@property BOOL navHidden;
@property BOOL userListensArePrivate;
@property int userToView;
@property int numReyaps;
@property BOOL isLoadingMorePosts;
@property BOOL isLoadingMoreSearchPosts;
@property BOOL cameFromNotifications;
@property BOOL posts_are_private;
@property BOOL user_following_profile_user;
@property BOOL profile_user_following_user;
@property BOOL user_requested_profile_user;
@property double after_yap;
@property double after_reyap;
@property double last_after_yap;
@property double last_after_reyap;
@property double listener_count;
@property double listening_count;
@property SWTableViewCell *current_cell;
@property double current_yap_to_delete;
@property double current_yap_to_report;
@property(retain, nonatomic)UIAlertView *alertViewConfirmDelete;
@property(retain, nonatomic)UIAlertView *alertViewConfirmReport;
@property (nonatomic, strong)IBOutlet UIScrollView *bigYapPhotoScrollView;
@property (retain, nonatomic)IBOutlet ZoomableView *myZoomableView;
@property(retain, nonatomic)UserInfo *userInfoObject;
@property(retain, nonatomic)Feed *userFeedObject;
@property(retain, nonatomic)Stream *streamVC;
@property(retain, nonatomic)StreamCell *streamCell;
@property(retain, nonatomic)UserSettings *UserSettingsVC;
@property(retain, nonatomic)ReportAProblem *ReportAProblemVC;
@property(retain, nonatomic)Explore *ExploreVC;
@property(retain, nonatomic)EditProfile *editProfileVC;
@property(retain, nonatomic)PlayerScreen *playerScreenVC;
@property(retain, nonatomic)Listening *listeningVC;
@property(retain, nonatomic)Listeners *listenersVC;
@property(retain, nonatomic)UserProfile *UserProfileVC;
@property(retain, nonatomic)Playlist *playlistVC;
@property(retain, nonatomic)CreateYap *createYapVC;
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
@property(retain, nonatomic)NSMutableDictionary *followJson;
@property(retain, nonatomic)NSMutableDictionary *unfollowJson;
@property(retain, nonatomic)NSMutableDictionary *acceptRequestJson;
@property(retain, nonatomic)NSMutableDictionary *denyRequestJson;
@property(retain, nonatomic)NSMutableDictionary *unRequestJson;
@property(retain, nonatomic)NSMutableDictionary *profileJson;
@property(retain, nonatomic)NSMutableDictionary *deleteYapJson;
@property(retain, nonatomic)NSMutableDictionary *reportYapJson;
@property(retain, nonatomic)NSMutableDictionary *reportUserJson;
@property(retain, nonatomic)NSString *notification_name;
@property(retain, nonatomic)NSArray *json;
@property(retain, nonatomic)NSString *userProfileDesc;
@property(retain, nonatomic)NSString *responseBodyProfile;
@property(retain, nonatomic)NSString *responseBody;
@property(retain, nonatomic)NSString *responseBodyLikes;
@property(retain, nonatomic)NSString *responseBodyListens;
@property(retain, nonatomic)NSString *responseBodyFollow;
@property(retain, nonatomic)NSString *responseBodyUnfollow;
@property(retain, nonatomic)NSString *responseBodyAcceptRequest;
@property(retain, nonatomic)NSString *responseBodyDenyRequest;
@property(retain, nonatomic)NSString *responseBodyUnRequest;
@property(retain, nonatomic)NSString *responseBodyDeleteYap;
@property(retain, nonatomic)NSString *responseBodyReportYap;
@property(retain, nonatomic)NSString *responseBodyReportUser;
@property(retain, nonatomic)NSMutableArray *userProfileInfo;
@property(retain, nonatomic)NSMutableArray *userFeed;
@property(retain, nonatomic)IBOutlet UIButton *searchButton;
@property(retain, nonatomic)IBOutlet UIButton *cancelButton;
@property(retain, nonatomic)IBOutlet UITextField *searchBox;
@property(retain, nonatomic)IBOutlet UIButton *playAllButton;
@property(retain, nonatomic)IBOutlet UIButton *moreOptionsButton;
@property(retain, nonatomic)NSURLConnection *connection1;
@property(retain, nonatomic)NSURLConnection *connection2;
@property(retain, nonatomic)NSURLConnection *connection3;
@property(retain, nonatomic)NSURLConnection *connection4;
@property(retain, nonatomic)NSURLConnection *connection5;
@property(retain, nonatomic)NSURLConnection *connection6;
@property(retain, nonatomic)NSURLConnection *connection7;
@property(retain, nonatomic)NSURLConnection *connection8;
@property(retain, nonatomic)NSURLConnection *connection9;
@property(retain, nonatomic)NSURLConnection *connection10;
@property(retain, nonatomic)NSURLConnection *connection11;
@property(retain, nonatomic)UIView* separatorLineView;
@property (nonatomic, strong)NSMutableArray *photos;
@property (nonatomic, strong)PendingOperations *pendingOperations;
@property(retain, nonatomic)NSMutableArray *records;
@property(nonatomic, strong)NSMutableArray *user_photo_entries;
@property(nonatomic, strong)NSMutableArray *workingArray;
@property(nonatomic, strong)AppPhotoRecord *workingEntry;
@property(nonatomic, strong)NSMutableDictionary *imageDownloadsInProgress;

-(IBAction)toggleMenu;
-(IBAction)toggleSearchBox:(id)sender;
-(IBAction)segmentControl:(id)sender;
-(IBAction)editProfile:(id)sender;
-(IBAction)goToUserProfile:(id)sender;
-(IBAction)goToYapScreen:(id)sender;
-(IBAction)followUser:(id)sender;
-(IBAction)unfollowUser:(id)sender;
-(IBAction)showFollowing:(id)sender;
-(IBAction)showFollowers:(id)sender;
-(IBAction)playAll:(id)sender;
-(IBAction)showMoreOptions:(id)sender;
-(IBAction)reportUser:(id)sender;
-(IBAction)searchYaps:(id)sender;
-(IBAction)showBigUserPhoto:(id)sender;
-(IBAction)hideBigUserPhoto:(id)sender;
-(IBAction)acceptRequest:(id)sender;
-(IBAction)denyRequest:(id)sender;
-(IBAction)unRequest:(id)sender;
-(void)expand;
-(void)contract;
-(IBAction)showCancelButton:(id)sender;
-(IBAction)doMenuSearch:(id)sender;
-(IBAction)cancelMenuSearch:(id)sender;
-(IBAction)goBack:(id)sender;

@end

