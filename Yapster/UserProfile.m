//
//  UserProfile.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/23/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "UserProfile.h"
#import "UserSettings.h"
#import "Stream.h"
#import "UserProfile.h"
#import "ReportAProblem.h"
#import "SWTableViewCell.h"
#import "UserNotifications.h"
#import "SearchResults.h"
#import "AppPhotoRecord.h"
#import "IconDownloader.h"

@interface UserProfile ()

@end

@implementation UserProfile

@synthesize cameFromMenu;
@synthesize cameFromPushNotifications;
@synthesize playlistIsNotEmpty;
@synthesize menuOpen;
@synthesize searchBoxVisible;
@synthesize navHidden;
@synthesize userListensArePrivate;
@synthesize numReyaps;
@synthesize userToView;
@synthesize isLoadingMorePosts;
@synthesize isLoadingMoreSearchPosts;
@synthesize posts_are_private;
@synthesize user_following_profile_user;
@synthesize profile_user_following_user;
@synthesize user_requested_profile_user;
@synthesize after_yap;
@synthesize after_reyap;
@synthesize last_after_yap;
@synthesize last_after_reyap;
@synthesize listener_count;
@synthesize listening_count;
@synthesize current_cell;
@synthesize current_yap_to_delete;
@synthesize current_yap_to_report;
@synthesize alertViewConfirmDelete;
@synthesize alertViewConfirmReport;
@synthesize acceptRequestJson;
@synthesize denyRequestJson;
@synthesize unRequestJson;
@synthesize responseBodyAcceptRequest;
@synthesize responseBodyDenyRequest;
@synthesize responseBodyUnRequest;
@synthesize bigYapPhotoScrollView;
@synthesize myZoomableView;
@synthesize userInfoObject;
@synthesize userFeedObject;
@synthesize streamVC;
@synthesize streamCell;
@synthesize theTable;
@synthesize menuTable;
@synthesize menuKeys;
@synthesize menuItems;
@synthesize UserSettingsVC;
@synthesize userProfileInfo;
@synthesize userFeed;
@synthesize ReportAProblemVC;
@synthesize ExploreVC;
@synthesize editProfileVC;
@synthesize playerScreenVC;
@synthesize listeningVC;
@synthesize listenersVC;
@synthesize UserProfileVC;
@synthesize createYapVC;
@synthesize playlistVC;
@synthesize searchResultsVC;
@synthesize menuSearchCancelButton;
@synthesize menuSearchBox;
@synthesize sharedManager;
@synthesize timer;
@synthesize noMorePostsMessage;
@synthesize topLayer;
@synthesize layerPosition;
@synthesize notification_name;
@synthesize cameFromNotifications;
@synthesize followJson;
@synthesize unfollowJson;
@synthesize profileJson;
@synthesize deleteYapJson;
@synthesize reportYapJson;
@synthesize reportUserJson;
@synthesize userProfileDesc;
@synthesize json;
@synthesize responseBodyProfile;
@synthesize responseBody;
@synthesize responseBodyLikes;
@synthesize responseBodyListens;
@synthesize responseBodyFollow;
@synthesize responseBodyUnfollow;
@synthesize responseBodyDeleteYap;
@synthesize responseBodyReportYap;
@synthesize responseBodyReportUser;
@synthesize searchButton;
@synthesize cancelButton;
@synthesize playAllButton;
@synthesize moreOptionsButton;
@synthesize searchBox;
@synthesize connection1;
@synthesize connection2;
@synthesize connection3;
@synthesize connection4;
@synthesize connection5;
@synthesize connection6;
@synthesize connection7;
@synthesize connection8;
@synthesize connection9;
@synthesize connection10;
@synthesize connection11;
@synthesize separatorLineView;
@synthesize pendingOperations;
@synthesize photos;
@synthesize records;
@synthesize user_photo_entries;
@synthesize workingArray;
@synthesize workingEntry;
@synthesize imageDownloadsInProgress;

- (PendingOperations *)pendingOperations {
    if (!pendingOperations) {
        pendingOperations = [[PendingOperations alloc] init];
    }
    return pendingOperations;
}

//iphone screen dimensions
#define SCREEN_WIDTH  320
#define SCREEN_HEIGTH [[UIScreen mainScreen] bounds].size.height

#define VIEW_HIDDEN 260

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    loadingData.hidden = NO;
    
    [loadingData startAnimating];
    
    sharedManager = [MyManager sharedManager];
    
    records = [NSMutableArray array];
    
    photos = [[NSMutableArray alloc] init];
    
    self.workingArray = [NSMutableArray array];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    if (!cameFromMenu) {
        menu_btn.hidden = YES;
        back_btn.hidden = NO;
    }
    
    bigYapPhotoScrollView.delegate = self;
    
    playAllButton.enabled = NO;
    
    [[self bigYapPhotoScrollView] setMinimumZoomScale:1.0];
    [[self bigYapPhotoScrollView] setMaximumZoomScale:6.0];
    
    userInfoView.hidden = YES;
    segmentControllerAndTableView.hidden = YES;
	
    theTable.hidden = YES;
    theTable.bounces = NO;
    theTable.scrollEnabled = NO;
    theTable.scrollsToTop = NO;
    
    user_photo_btn.enabled = NO;
    
    //theTable.backgroundColor = [UIColor redColor];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    scrollView1.scrollEnabled = YES;
    scrollView1.frame = CGRectMake(scrollView1.frame.origin.x, 0, scrollView1.frame.size.width, scrollView1.frame.size.height);
    
    [scrollView1 setShowsHorizontalScrollIndicator:NO];
    [scrollView1 setShowsVerticalScrollIndicator:NO];
    
    mainScrollView.delegate = self;
    mainScrollView.bounces = NO;
    mainScrollView.showsHorizontalScrollIndicator = YES;
    mainScrollView.showsVerticalScrollIndicator = YES;
    mainScrollView.scrollEnabled = YES;
    //mainScrollView.backgroundColor = [UIColor blueColor];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    self.layerPosition = self.topLayer.frame.origin.x;
    
    self.topLayer.layer.shadowOpacity = 0.6f;
    self.topLayer.layer.shadowRadius = 4.0f;
    self.topLayer.layer.shadowColor = [UIColor grayColor].CGColor;
    
    segmentController.frame = CGRectMake(0, segmentController.frame.origin.y, 320, 60);
    
    //Add clear color to mask any bits of a selection state that the object might show around the images
    segmentController.tintColor = [UIColor clearColor];
    
    UIImage *stream;
    UIImage *likes;
    UIImage *play;
    UIImage *separator;
    
    searchBoxVisible = NO;
    searchBox.delegate = self;
    menuSearchBox.delegate = self;
    
    UIView *leftFieldSearchBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    UIView *rightFieldSearchBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 0)];
    
    searchBox.leftViewMode = UITextFieldViewModeAlways;
    searchBox.leftView     = leftFieldSearchBox;
    searchBox.rightViewMode = UITextFieldViewModeAlways;
    searchBox.rightView    = rightFieldSearchBox;
    
    UIColor *color = [UIColor whiteColor];
    if ([searchBox respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        searchBox.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search Posts Stream" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    menuSearchBox.backgroundColor = [UIColor clearColor];
    menuSearchBox.layer.masksToBounds=YES;
    menuSearchBox.layer.borderColor=[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.7f].CGColor;
    menuSearchBox.layer.borderWidth= 1.0f;
    
    menuSearchBox.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search Yapster" attributes:@{NSForegroundColorAttributeName: color}];
    
    UIView *leftFieldMenuSearchBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    UIView *rightFieldMenuSearchBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 0)];
    
    menuSearchBox.leftViewMode = UITextFieldViewModeAlways;
    menuSearchBox.leftView     = leftFieldMenuSearchBox;
    menuSearchBox.rightViewMode = UITextFieldViewModeAlways;
    menuSearchBox.rightView    = rightFieldMenuSearchBox;
    
    menuSearchBox.layer.cornerRadius = 15;
    
    menuTable.delegate = self;
    menuTable.autoresizingMask &= ~UIViewAutoresizingFlexibleBottomMargin;
    menuTable.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+70, self.view.bounds.size.width, self.view.bounds.size.height-60);
    menuTable.showsVerticalScrollIndicator = YES;
    menuTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, menuTable.bounds.size.width, 0.01f)];
    
    /*searchBox.autocorrectionType = UITextAutocorrectionTypeNo;
     searchBox.textColor = [UIColor whiteColor];
     searchBox.backgroundColor = [UIColor grayColor];
     searchBox.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
     searchBox.frame = CGRectMake(20, 76, 200, 40);
     [searchBox setClearsContextBeforeDrawing:YES];
     searchBox.clipsToBounds = YES;
     
     cancelButton.frame = CGRectMake(193, 86, 20, 20);
     [cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_cancel.png"] forState:UIControlStateNormal];
     
     [cancelButton addTarget:self action:@selector(toggleSearchBox:) forControlEvents:UIControlEventTouchUpInside];
     */
    
    postAmount = 10; //default, inital
    nextAmount = 15; //next amount
    numLoadedPosts = 0;
    
    userFeed = [[NSMutableArray alloc] init];
    
    theTable.delegate = self;
    theTable.autoresizingMask &= ~UIViewAutoresizingFlexibleBottomMargin;
    theTable.frame = CGRectMake(self.view.bounds.origin.x, theTable.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    theTable.showsVerticalScrollIndicator = NO;
    theTable.separatorColor = [UIColor lightGrayColor];
    theTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, theTable.bounds.size.width, 0.01f)];
    
    //theTable.backgroundColor = [UIColor blueColor];
    
    loadingMoreData.hidden = YES;
    
    message.frame = CGRectMake(20, 390, message.frame.size.width, message.frame.size.height);
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not load profile." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
            stream = [[UIImage imageNamed:@"profile-active-stream.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            likes = [[UIImage imageNamed:@"profile-inactive-like.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            play = [[UIImage imageNamed:@"profile-inactive-play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            separator = [[UIImage imageNamed:@"separator.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else {
            stream = [UIImage imageNamed:@"profile-active-stream.png"];
            likes = [UIImage imageNamed:@"profile-inactive-like.png"];
            play = [UIImage imageNamed:@"profile-inactive-play.png"];
            separator = [UIImage imageNamed:@"separator.png"];
        }
        
        [segmentController setImage:stream forSegmentAtIndex:0];
        [segmentController setImage:likes forSegmentAtIndex:1];
        [segmentController setImage:play forSegmentAtIndex:2];
        [segmentController setDividerImage:separator forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        //build an info object and convert to json
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        
        __block NSError *error;
        
        //call user profile info
        NSDictionary *profileDataInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        tempUserToView, @"profile_user_id",
                                        nil];
        
        NSData* jsonData2 = [NSJSONSerialization dataWithJSONObject:profileDataInfo options:kNilOptions  error:&error];
        
        NSURL *the_url2 = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/info/"];
        
        NSMutableURLRequest *request_info = [[NSMutableURLRequest alloc] init];
        [request_info setURL:the_url2];
        [request_info setHTTPMethod:@"POST"];
        [request_info setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request_info setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request_info setHTTPBody:jsonData2];
        
        __block NSHTTPURLResponse* urlResponse2 = nil;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            NSData *returnData2 = [NSURLConnection sendSynchronousRequest: request_info returningResponse: &urlResponse2 error: &error];
            
            responseBodyProfile = [[NSString alloc] initWithData:returnData2 encoding:NSUTF8StringEncoding];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

                if (!jsonData2) {
                    DLog(@"JSON error: %@", error);
                }
                
                connection2 = [[NSURLConnection alloc] initWithRequest:request_info delegate:self];
                
                [connection2 start];
                
                if (connection2) {
                    
                }
                else {
                    //Error
                }
            });
         });
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    NSString *path;
    
    path = [[NSBundle mainBundle] pathForResource:@"menulist" ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    self.menuItems = dict;
    
    NSArray *array = [[menuItems allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.menuKeys = array;
    
    if (sharedManager.sessionCurrentPlayingYap != nil && sharedManager.sessionCurrentPlayingYap.count > 0) {
        playerActive = true;
    }
    else {
        playerActive = false;
    }
    
    if (cameFromPlayerScreen) {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if (segmentController.selectedSegmentIndex == 0) {
            if (networkStatus == NotReachable) {
                
            }
            else {
                if ([searchBox.text isEqualToString:@""]) {
                    //build an info object and convert to json
                    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                    NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
                    NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
                    
                    __block NSError *error;
                    
                    //call stream
                    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                    tempSessionUserID, @"user_id",
                                                    tempSessionID, @"session_id",
                                                    tempUserToView, @"profile_user_id",
                                                    tempPostAmount, @"amount",
                                                    @"posts", @"stream_type",
                                                    nil];
                    
                    
                    
                    //convert object to data
                    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                    
                    NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
                    
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                    [request setURL:the_url];
                    [request setHTTPMethod:@"POST"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    [request setHTTPBody:jsonData];
                    
                    __block NSHTTPURLResponse* urlResponse = nil;
                    
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        
                        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                        
                        responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                            
                            //int responseCode = [urlResponse statusCode];
                            
                            if (!jsonData) {
                                DLog(@"JSON error: %@", error);
                            }
                            else {
                                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                                DLog(@"JSON: %@", JSONString);
                            }
                            
                            connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            
                            [connection1 start];
                            
                            if (connection1) {
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                                
                                message.hidden = YES;
                                theTable.hidden = NO;
                                // terminate all pending download connections
                                NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                                [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                                
                                [self.imageDownloadsInProgress removeAllObjects];
                                
                                userFeed = [[NSMutableArray alloc] init];
                                self.workingArray = [NSMutableArray array];
                                [self.workingArray removeAllObjects];
                                user_photo_entries = [NSMutableArray array];
                                [user_photo_entries removeAllObjects];
                                
                                numLoadedPosts = 0;
                                
                                mainScrollView.scrollEnabled = NO;
                            }
                            else {
                                //Error
                            }
                        });
                    });
                }
                else {
                    // terminate all pending download connections
                    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                    
                    [self.imageDownloadsInProgress removeAllObjects];
                    
                    [self searchYaps:searchBox];
                }
            }
        }
        else if (segmentController.selectedSegmentIndex == 1) {
            if (networkStatus == NotReachable) {
                
            }
            else {
                
                if ([searchBox.text isEqualToString:@""]) {
                    //build an info object and convert to json
                    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                    NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
                    NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
                    
                    __block NSError *error;
                    
                    //call stream
                    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                    tempSessionUserID, @"user_id",
                                                    tempSessionID, @"session_id",
                                                    tempUserToView, @"profile_user_id",
                                                    tempPostAmount, @"amount",
                                                    @"likes", @"stream_type",
                                                    nil];
                    
                    
                    
                    //convert object to data
                    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                    
                    NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
                    
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                    [request setURL:the_url];
                    [request setHTTPMethod:@"POST"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    [request setHTTPBody:jsonData];
                    
                    __block NSHTTPURLResponse* urlResponse = nil;
                    
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        
                        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                        
                        responseBodyLikes = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                    
                            //int responseCode = [urlResponse statusCode];
                            
                            if (!jsonData) {
                                DLog(@"JSON error: %@", error);
                            }
                            
                            connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            
                            [connection1 start];
                            
                            if (connection1) {
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                                
                                message.hidden = YES;
                                theTable.hidden = NO;
                                // terminate all pending download connections
                                NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                                [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                                
                                [self.imageDownloadsInProgress removeAllObjects];
                                
                                userFeed = [[NSMutableArray alloc] init];
                                self.workingArray = [NSMutableArray array];
                                [self.workingArray removeAllObjects];
                                user_photo_entries = [NSMutableArray array];
                                [user_photo_entries removeAllObjects];
                                
                                numLoadedPosts = 0;
            
                                mainScrollView.scrollEnabled = NO;
                            }
                            else {
                                //Error
                            }
                        });
                    });
                }
                else {
                    // terminate all pending download connections
                    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                    
                    [self.imageDownloadsInProgress removeAllObjects];
                    
                    [self searchYaps:searchBox];
                }
            }
        }
        else if (segmentController.selectedSegmentIndex == 2) {
            if (!userListensArePrivate || (userToView == sessionUserID)) {
                if (networkStatus == NotReachable) {
                    
                }
                else {
                    if ([searchBox.text isEqualToString:@""]) {
                        //build an info object and convert to json
                        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                        NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
                        NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
                        
                        __block NSError *error;
                        
                        //call stream
                        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                        tempSessionUserID, @"user_id",
                                                        tempSessionID, @"session_id",
                                                        tempUserToView, @"profile_user_id",
                                                        tempPostAmount, @"amount",
                                                        @"listens", @"stream_type",
                                                        nil];
                        
                        
                        
                        //convert object to data
                        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                        
                        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
                        
                        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                        [request setURL:the_url];
                        [request setHTTPMethod:@"POST"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [request setHTTPBody:jsonData];
                        
                        __block NSHTTPURLResponse* urlResponse = nil;
                        
                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        dispatch_async(queue, ^{
                            
                            NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                            
                            responseBodyListens = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                        
                                //int responseCode = [urlResponse statusCode];
                                
                                if (!jsonData) {
                                    DLog(@"JSON error: %@", error);
                                }
                                
                                connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                                
                                [connection1 start];
                                
                                if (connection1) {
                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                                    
                                    message.hidden = YES;
                                    theTable.hidden = NO;
                                    // terminate all pending download connections
                                    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                                    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                                    
                                    [self.imageDownloadsInProgress removeAllObjects];
                                    
                                    userFeed = [[NSMutableArray alloc] init];
                                    self.workingArray = [NSMutableArray array];
                                    [self.workingArray removeAllObjects];
                                    user_photo_entries = [NSMutableArray array];
                                    [user_photo_entries removeAllObjects];
                                    
                                    numLoadedPosts = 0;
                                    
                                    mainScrollView.scrollEnabled = NO;
                                }
                                else {
                                    //Error
                                }
                            });
                        });
                    }
                    else {
                        // terminate all pending download connections
                        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                        
                        [self.imageDownloadsInProgress removeAllObjects];
                        
                        [self searchYaps:searchBox];
                    }
                }
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //cancel connections
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    [connection7 cancel];
    [connection8 cancel];
    [connection9 cancel];
    [connection10 cancel];
    [connection11 cancel];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.myZoomableView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == searchBox) {
        if (![searchBox.text isEqualToString:@""]) {
            // terminate all pending download connections
            NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
            [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
            
            [self.imageDownloadsInProgress removeAllObjects];
        
            [self searchYaps:searchBox];
        }
    }
    else if (textField == menuSearchBox) {
        // terminate all pending download connections
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
        
        [self.imageDownloadsInProgress removeAllObjects];
        
        [self doMenuSearch:menuSearchBox];
    }
    
    [textField resignFirstResponder];
}

-(IBAction)showCancelButton:(id)sender {
    [self animateLayerToPoint:320];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         menuSearchBox.frame = CGRectMake(menuSearchBox.frame.origin.x, menuSearchBox.frame.origin.y, 280, menuSearchBox.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         menuSearchCancelButton.hidden = NO;
                     }];
    
}

-(IBAction)cancelMenuSearch:(id)sender {
    if ([menuSearchBox.text isEqualToString:@""]) {
        [self animateLayerToPoint:VIEW_HIDDEN];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             menuSearchBox.frame = CGRectMake(menuSearchBox.frame.origin.x, menuSearchBox.frame.origin.y, 220, menuSearchBox.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        menuSearchCancelButton.hidden = YES;
        [menuSearchBox resignFirstResponder];
    }
    else {
        menuSearchBox.text = @"";
    }
}

-(IBAction)cancelMenuSearch2:(id)sender {
    [self animateLayerToPoint:VIEW_HIDDEN];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         menuSearchBox.frame = CGRectMake(menuSearchBox.frame.origin.x, menuSearchBox.frame.origin.y, 220, menuSearchBox.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    menuSearchCancelButton.hidden = YES;
    [menuSearchBox resignFirstResponder];
}

-(IBAction)doMenuSearch:(id)sender {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *trimmedSearchTerms = [menuSearchBox.text stringByTrimmingCharactersInSet:whitespace];
    
    NSUInteger trimmedSearchTermsLength = [trimmedSearchTerms length];
    
    if (trimmedSearchTermsLength > 0) {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if (networkStatus == NotReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        else {
            searchResultsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultsVC"];
            
            NSMutableArray *hashtags_array = [[NSMutableArray alloc] init];
            NSMutableArray *new_hashtags_array = [[NSMutableArray alloc] init];
            NSMutableArray *userhandles_array = [[NSMutableArray alloc] init];
            NSMutableArray *new_userhandles_array = [[NSMutableArray alloc] init];
            
            NSString *search_text = [menuSearchBox.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            //if (![search_text isEqualToString:@""]) {
            if ([search_text rangeOfString:@"#"].location != NSNotFound) {
                hashtags_array = [[search_text componentsSeparatedByString: @"#"] mutableCopy];
                [hashtags_array removeObject:@""];
                
                int i = 0;
                
                for (NSString __strong *item in hashtags_array) {
                    NSRange range = [item rangeOfString:@"@"];
                    
                    if (range.location != NSNotFound) {
                        NSArray *chunks = [item componentsSeparatedByString: @"@"];
                        
                        item = [chunks objectAtIndex:0];
                        
                        i++;
                        
                        //DLog(@"%@", item);
                    }
                    
                    [new_hashtags_array addObject:item];
                }
                
                [new_hashtags_array removeObject:@""];
                
                if (new_hashtags_array.count > 2) {
                    new_hashtags_array = [[new_hashtags_array subarrayWithRange:NSMakeRange(0, 2)] mutableCopy];
                }
                
                searchResultsVC.hashtags_array = new_hashtags_array;
                searchResultsVC.hashtagSearch = true;
                searchResultsVC.textSearch = false;
            }
            
            if ([search_text rangeOfString:@"@"].location != NSNotFound) {
                userhandles_array = [[search_text componentsSeparatedByString: @"@"] mutableCopy];
                [userhandles_array removeObject:@""];
                
                int i = 0;
                
                for (NSString __strong *item in userhandles_array) {
                    NSRange range = [item rangeOfString:@"#"];
                    
                    if (range.location != NSNotFound) {
                        NSArray *chunks = [item componentsSeparatedByString: @"#"];
                        
                        item = [chunks objectAtIndex:0];
                        
                        i++;
                        
                        //DLog(@"%@", item);
                    }
                    
                    [new_userhandles_array addObject:item];
                }
                
                [new_userhandles_array removeObject:@""];
                
                if (new_userhandles_array.count > 2) {
                    new_userhandles_array = [[new_userhandles_array subarrayWithRange:NSMakeRange(0, 2)] mutableCopy];
                }
                
                searchResultsVC.users = new_userhandles_array;
                searchResultsVC.userSearch = true;
                searchResultsVC.textSearch = false;
            }
            else {
                if ([search_text rangeOfString:@"#"].location == NSNotFound) {
                    search_text = menuSearchBox.text;
                    
                    searchResultsVC.textSearch = true;
                    searchResultsVC.search_text = search_text;
                }
            }
            
            if (trimmedSearchTermsLength == 0) {
                searchResultsVC.textSearch = false;
            }
            
            searchResultsVC.search_text_for_label = menuSearchBox.text;
            
            //}
            
            [self.navigationController pushViewController:searchResultsVC animated:YES];
        }
    }
    else {
        [self animateLayerToPoint:VIEW_HIDDEN];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             menuSearchBox.frame = CGRectMake(menuSearchBox.frame.origin.x, menuSearchBox.frame.origin.y, 220, menuSearchBox.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        menuSearchCancelButton.hidden = YES;
    }
}

-(IBAction)searchYaps:(id)sender {
    isSearch = YES;
    isSearch2 = YES;
    
    BOOL hashtags_search = false;
    BOOL userhandles_search = false;
    BOOL text_search = false;
    NSMutableArray *hashtags_array = [[NSMutableArray alloc] init];
    NSMutableArray *new_hashtags_array = [[NSMutableArray alloc] init];
    NSMutableArray *userhandles_array = [[NSMutableArray alloc] init];
    NSMutableArray *new_userhandles_array = [[NSMutableArray alloc] init];
    
    NSString *search_text = [searchBox.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([search_text rangeOfString:@"#"].location != NSNotFound) {
        //DLog(@"%@", search_text);
        
        hashtags_array = [[search_text componentsSeparatedByString: @"#"] mutableCopy];
        [hashtags_array removeObject:@""];
        
        int i = 0;
        
        for (NSString __strong *item in hashtags_array) {
            NSRange range = [item rangeOfString:@"@"];
            
            if (range.location != NSNotFound) {
                NSArray *chunks = [item componentsSeparatedByString: @"@"];
                
                item = [chunks objectAtIndex:0];
                
                i++;
                
                //DLog(@"%@", item);
            }
            
            [new_hashtags_array addObject:item];
        }
        
        [new_hashtags_array removeObject:@""];
        
        if (new_hashtags_array.count > 2) {
            new_hashtags_array = [[new_hashtags_array subarrayWithRange:NSMakeRange(0, 2)] mutableCopy];
        }
        
        hashtags_search = true;
        text_search = false;
    }
    else {
        search_text = searchBox.text;
        
        text_search = true;
    }
    
    if ([search_text rangeOfString:@"@"].location != NSNotFound) {
        userhandles_array = [[search_text componentsSeparatedByString: @"@"] mutableCopy];
        [userhandles_array removeObject:@""];
        
        int i = 0;
        
        for (NSString __strong *item in userhandles_array) {
            NSRange range = [item rangeOfString:@"#"];
            
            if (range.location != NSNotFound) {
                NSArray *chunks = [item componentsSeparatedByString: @"#"];
                
                item = [chunks objectAtIndex:0];
                
                i++;
                
                //DLog(@"%@", item);
            }
            
            [new_userhandles_array addObject:item];
        }
        
        [new_userhandles_array removeObject:@""];
        
        if (new_userhandles_array.count > 2) {
            new_userhandles_array = [[new_userhandles_array subarrayWithRange:NSMakeRange(0, 2)] mutableCopy];
        }
        
        userhandles_search = true;
        text_search = false;
    }
    else {
        search_text = searchBox.text;
        
        text_search = true;
    }
    
    //build an info object and convert to json
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
    NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
    
    NSDictionary *newDatasetInfo;
    
    NSError *error;
    
    //convert object to data
    
    NSURL *the_url;
    
    if (segmentController.selectedSegmentIndex == 0) {
        //search posts
        
        if (hashtags_search) {
            if (userhandles_search) {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/profile/posts/hashtags_and_user_handles/search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  tempUserToView, @"profile_searched_id",
                                  new_hashtags_array, @"hashtags_searched",
                                  new_userhandles_array, @"user_handles_searched",
                                  nil];
                
                DLog(@"HASHTAGS AND USER HANDLES");
            }
            else {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/profile/posts/hashtags/search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  tempUserToView, @"profile_searched_id",
                                  new_hashtags_array, @"hashtags_searched",
                                  nil];
                
                DLog(@"ONLY HASHTAGS");
            }
        }
        else {
            if (userhandles_search) {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/profile/posts/user_handles/search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  tempUserToView, @"profile_searched_id",
                                  new_userhandles_array, @"user_handles_searched",
                                  nil];
                
                DLog(@"ONLY USER HANDLES");
            }
            else {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/profile/posts/text/search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  tempUserToView, @"profile_searched_id",
                                  searchBox.text, @"text_searched",
                                  nil];
                
                DLog(@"ONLY TEXT");
            }
        }
    }
    else if (segmentController.selectedSegmentIndex == 1) {
        //search likes
        
        if (hashtags_search) {
            if (userhandles_search) {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/profile/likes/hashtags_and_user_handles/search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  tempUserToView, @"profile_searched_id",
                                  new_hashtags_array, @"hashtags_searched",
                                  new_userhandles_array, @"user_handles_searched",
                                  nil];
                
                DLog(@"HASHTAGS AND USER HANDLES");
            }
            else {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/profile/likes/hashtags/search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  tempUserToView, @"profile_searched_id",
                                  new_hashtags_array, @"hashtags_searched",
                                  nil];
                
                DLog(@"ONLY HASHTAGS");
            }
        }
        else {
            if (userhandles_search) {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/profile/likes/user_handles/search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  tempUserToView, @"profile_searched_id",
                                  new_userhandles_array, @"user_handles_searched",
                                  nil];
                
                DLog(@"ONLY USER HANDLES");
            }
            else {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/profile/likes/text/search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  tempUserToView, @"profile_searched_id",
                                  searchBox.text, @"text_searched",
                                  nil];
                
                DLog(@"ONLY TEXT");
            }
        }
    }
    else if (segmentController.selectedSegmentIndex == 2) {
        //search listens
        if (!userListensArePrivate || (userToView == sessionUserID)) {
            if (hashtags_search) {
                if (userhandles_search) {
                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/profile/listens/hashtags_and_user_handles/search/"];
                    
                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      tempSessionUserID, @"user_id",
                                      tempSessionID, @"session_id",
                                      tempPostAmount, @"amount",
                                      tempUserToView, @"profile_searched_id",
                                      new_hashtags_array, @"hashtags_searched",
                                      new_userhandles_array, @"user_handles_searched",
                                      nil];
                    
                    DLog(@"HASHTAGS AND USER HANDLES");
                }
                else {
                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/profile/listens/hashtags/search/"];
                    
                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      tempSessionUserID, @"user_id",
                                      tempSessionID, @"session_id",
                                      tempPostAmount, @"amount",
                                      tempUserToView, @"profile_searched_id",
                                      new_hashtags_array, @"hashtags_searched",
                                      nil];
                    
                    DLog(@"ONLY HASHTAGS");
                }
            }
            else {
                if (userhandles_search) {
                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/profile/listens/user_handles/search/"];
                    
                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      tempSessionUserID, @"user_id",
                                      tempSessionID, @"session_id",
                                      tempPostAmount, @"amount",
                                      tempUserToView, @"profile_searched_id",
                                      new_userhandles_array, @"user_handles_searched",
                                      nil];
                    
                    DLog(@"ONLY USER HANDLES");
                }
                else {
                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/profile/listens/text/search/"];
                    
                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      tempSessionUserID, @"user_id",
                                      tempSessionID, @"session_id",
                                      tempPostAmount, @"amount",
                                      tempUserToView, @"profile_searched_id",
                                      searchBox.text, @"text_searched",
                                      nil];
                    
                    DLog(@"ONLY TEXT");
                }
            }
        }
        else {
            theTable.hidden = YES;
            message.text = @"This user's listens are private.";
            message.hidden = NO;
        }
    }
    
    if ([search_text isEqualToString:@""]) {
        the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
        
        if (segmentController.selectedSegmentIndex == 0) {
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempUserToView, @"profile_user_id",
                              tempPostAmount, @"amount",
                              @"posts", @"stream_type",
                              nil];
        }
        else if (segmentController.selectedSegmentIndex == 1) {
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempUserToView, @"profile_user_id",
                              tempPostAmount, @"amount",
                              @"likes", @"stream_type",
                              nil];
        }
        else if (segmentController.selectedSegmentIndex == 2) {
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempUserToView, @"profile_user_id",
                              tempPostAmount, @"amount",
                              @"listens", @"stream_type",
                              nil];
        }
    }
    
    if (segmentController.selectedSegmentIndex == 0 || segmentController.selectedSegmentIndex == 1) {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:the_url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        if (segmentController.selectedSegmentIndex == 0) {
            responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        }
        else if (segmentController.selectedSegmentIndex == 1) {
            responseBodyLikes = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        }
        
        //DLog(@"%@", responseBody);
        
        //DLog(@"THE URL: %@", the_url);
        
        //int responseCode = [urlResponse statusCode];
        
        if (!jsonData) {
            DLog(@"JSON error: %@", error);
        }
        else {
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            DLog(@"JSON: %@", JSONString);
        }
        
        connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection1 start];
        
        if (connection1) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            userFeed = [[NSMutableArray alloc] init];
            // terminate all pending download connections
            NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
            [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
            
            [self.imageDownloadsInProgress removeAllObjects];
            
            self.workingArray = [NSMutableArray array];
            [self.workingArray removeAllObjects];
            user_photo_entries = [NSMutableArray array];
            [user_photo_entries removeAllObjects];
            
            numLoadedPosts = 0;
            [self.theTable reloadData];
            [self.theTable setContentOffset:CGPointZero animated:NO];
            theTable.hidden = YES;
            message.hidden = YES;
            mainScrollView.scrollEnabled = NO;
            
            loadingData.hidden = NO;
            
            [loadingData startAnimating];
        }
        else {
            //Error
        }
    }
    else {
        if (!userListensArePrivate || (userToView == sessionUserID)) {
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:the_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonData];
            
            NSHTTPURLResponse* urlResponse = nil;
            
            NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
            
            responseBodyListens = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            //int responseCode = [urlResponse statusCode];
            
            if (!jsonData) {
                DLog(@"JSON error: %@", error);
            }
            else {
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                DLog(@"JSON: %@", JSONString);
            }
            
            connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection1 start];
            
            if (connection1) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                
                userFeed = [[NSMutableArray alloc] init];
                // terminate all pending download connections
                NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                
                [self.imageDownloadsInProgress removeAllObjects];
                
                self.workingArray = [NSMutableArray array];
                [self.workingArray removeAllObjects];
                user_photo_entries = [NSMutableArray array];
                [user_photo_entries removeAllObjects];
                
                numLoadedPosts = 0;
                [self.theTable reloadData];
                [self.theTable setContentOffset:CGPointZero animated:NO];
                theTable.hidden = YES;
                message.hidden = YES;
                mainScrollView.scrollEnabled = NO;
                
                loadingData.hidden = NO;
                
                [loadingData startAnimating];
            }
            else {
                //Error
            }
        }
        else {
            theTable.hidden = YES;
            message.text = @"This user's listens are private.";
            message.hidden = NO;
        }
    }
}

-(IBAction)showBigUserPhoto:(id)sender {
    bigYapPhotoViewWrapper.hidden = NO;
}

-(IBAction)hideBigUserPhoto:(id)sender {
    self.bigYapPhotoScrollView.zoomScale = 1.0;
    
    bigYapPhotoViewWrapper.hidden = YES;
}

-(IBAction)acceptRequest:(id)sender {
    //accept user follow request
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempUserRequestedId = [[NSNumber alloc] initWithDouble:userToView];
    
    NSDictionary *newDatasetInfo;
    NSData* jsonData;
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/follow/accept/"];
    
    NSError *error;
    
    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                      tempSessionUserID, @"user_id",
                      tempSessionID, @"session_id",
                      tempUserRequestedId, @"user_requesting_id",
                      nil];
    
    //convert object to data
    jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    if (!jsonData) {
        DLog(@"JSON error: %@", error);
    }
    else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        DLog(@"JSON: %@", JSONString);
    }
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
    
    responseBodyAcceptRequest = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    connection9 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection9 start];
    
    if (connection9) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    DLog(@"accepted user request");
}

-(IBAction)denyRequest:(id)sender {
    //accept user follow request
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempUserRequestedId = [[NSNumber alloc] initWithDouble:userToView];
    
    NSDictionary *newDatasetInfo;
    NSData* jsonData;
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/follow/deny/"];
    
    NSError *error;
    
    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                      tempSessionUserID, @"user_id",
                      tempSessionID, @"session_id",
                      tempUserRequestedId, @"user_requesting_id",
                      nil];
    
    //convert object to data
    jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    if (!jsonData) {
        DLog(@"JSON error: %@", error);
    }
    else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        DLog(@"JSON: %@", JSONString);
    }
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
    
    responseBodyDenyRequest = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    connection10 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection10 start];
    
    if (connection10) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        DLog(@"JSON: %@", JSONString);
    }
    
    DLog(@"denied user request");
}

-(IBAction)unRequest:(id)sender {
    //unrequest user
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempUserRequestedId = [[NSNumber alloc] initWithDouble:userToView];
    
    NSDictionary *newDatasetInfo;
    NSData* jsonData;
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/follow/unrequest/"];
    
    NSError *error;
    
    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                      tempSessionUserID, @"user_id",
                      tempSessionID, @"session_id",
                      tempUserRequestedId, @"user_requested_id",
                      nil];
    
    //convert object to data
    jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    if (!jsonData) {
        DLog(@"JSON error: %@", error);
    }
    else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        DLog(@"JSON: %@", JSONString);
    }
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
    
    responseBodyUnRequest = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    connection11 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection11 start];
    
    if (connection11) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    DLog(@"unrequested user");
}

-(IBAction)goBack:(id)sender {
    if (!cameFromPushNotifications) {
        cameFromProfileScreen = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UserNotifications *notificationsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserNotificationsVC"];
        
        //Push to controller
        [self.navigationController pushViewController:notificationsVC animated:YES];
    }
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    profileJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection1) {
        //DLog(@"RESPONSE: %@", responseBody);
        
        //set up feed info array
        
        NSData *data;
        
        if (segmentController.selectedSegmentIndex == 0) {
            data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
        }
        else if (segmentController.selectedSegmentIndex == 1) {
            data = [responseBodyLikes dataUsingEncoding:NSUTF8StringEncoding];
        }
        else if (segmentController.selectedSegmentIndex == 2) {
            data = [responseBodyListens dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSDictionary *post_info;
        NSDictionary *yap_info;
        NSDictionary *user;
        NSDictionary *channel;
        NSDictionary *reyap_user_dic;
        //NSDictionary *actual_value;
        
        after_reyap = 0;
        after_yap = 0;
        
        if (json.count > 0) {
            if (true) {
                for (int i = 0; i < json.count; i++) {
                    post_info = [[json objectAtIndex:i] objectForKey:@"post_info"];
                    yap_info = [[json objectAtIndex:i] objectForKey:@"yap_info"];
                    user = [yap_info objectForKey:@"user"];
                    reyap_user_dic = [post_info objectForKey:@"reyap_user"];
                    
                    //create feed object
                    BOOL liked_by_viewer = [[post_info objectForKey:@"liked_by_viewer"] boolValue];
                    double user_post_id = [[[json objectAtIndex:i] objectForKey:@"user_post_id"] doubleValue];
                    //DLog(@"after: %d", user_post_id);
                    int like_count = [[yap_info objectForKey:@"like_count"] intValue];
                    int reyap_count = [[yap_info objectForKey:@"reyap_count"] intValue];
                    NSArray *group;
                    if (![[yap_info objectForKey:@"channel"] isKindOfClass:[NSNull class]]) {
                        channel = [yap_info objectForKey:@"channel"];
                        group = [[NSArray alloc] initWithObjects:channel, nil];
                    }
                    double google_plus_account_id = 0;
                    if (![[yap_info objectForKey:@"google_plus_account_id"] isKindOfClass:[NSNull class]]) {
                        google_plus_account_id = [[yap_info objectForKey:@"google_plus_account_id"]
                                                  doubleValue];
                    }
                    double facebook_account_id = 0;
                    if (![[yap_info objectForKey:@"facebook_account_id"] isKindOfClass:[NSNull class]]) {
                        facebook_account_id = [[yap_info objectForKey:@"facebook_account_id"] doubleValue];
                    }
                    double twitter_account_id = 0;
                    if (![[yap_info objectForKey:@"twitter_account_id"] isKindOfClass:[NSNull class]]) {
                        twitter_account_id = [[yap_info objectForKey:@"twitter_account_id"] doubleValue];
                    }
                    double linkedin_account_id = 0;
                    if (![[yap_info objectForKey:@"linkedin_account_id"] isKindOfClass:[NSNull class]]) {
                        linkedin_account_id = [[yap_info objectForKey:@"linkedin_account_id"] doubleValue];
                    }
                    
                    BOOL reyapped_by_viewer = [[post_info objectForKey:@"reyapped_by_viewer"] boolValue];
                    BOOL group_flag = [[yap_info objectForKey:@"channel_flag"] boolValue];
                    BOOL listened_by_viewer = [[post_info objectForKey:@"listened_by_viewer"] boolValue];
                    BOOL hashtags_flag = [[yap_info objectForKey:@"hashtags_flag"] boolValue];
                    BOOL is_deleted = [[yap_info objectForKey:@"is_deleted"] boolValue];
                    BOOL linkedin_shared_flag = [[yap_info objectForKey:@"linkedin_shared_flag"] boolValue];
                    BOOL facebook_shared_flag = [[yap_info objectForKey:@"facebook_shared_flag"] boolValue];
                    BOOL twitter_shared_flag = [[yap_info objectForKey:@"twitter_shared_flag"] boolValue];
                    BOOL google_plus_shared_flag = [[yap_info objectForKey:@"google_plus_shared_flag"] boolValue];
                    BOOL user_tags_flag = [[yap_info objectForKey:@"user_tags_flag"] boolValue];
                    BOOL web_link_flag = [[yap_info objectForKey:@"web_link_flag"] boolValue];
                    BOOL picture_flag = [[yap_info objectForKey:@"picture_flag"] boolValue];
                    BOOL picture_cropped_flag = [[yap_info objectForKey:@"picture_cropped_flag"] boolValue];
                    BOOL is_active = [[yap_info objectForKey:@"is_active"] boolValue];
                    int listen_count = [[yap_info objectForKey:@"listen_count"] intValue];
                    NSString *reyap_user;
                    
                    if (![reyap_user_dic isKindOfClass:[NSNull class]]) {
                        reyap_user = [reyap_user_dic objectForKey:@"username"];
                    }
                    else {
                        reyap_user = @"";
                    }
                    
                    DLog(@"reyap_user %@", post_info);
                    
                    NSString *latitude = [yap_info objectForKey:@"latitude"];
                    NSString *longitude = [yap_info objectForKey:@"longitude"];
                    NSString *yap_longitude = [yap_info objectForKey:@"longitude"];
                    NSString *username = [user objectForKey:@"username"];
                    NSString *first_name = [user objectForKey:@"first_name"];
                    NSString *last_name = [user objectForKey:@"last_name"];
                    NSString *picture_path = [yap_info objectForKey:@"picture_path"];
                    NSString *picture_cropped_path = [yap_info objectForKey:@"picture_cropped_path"];
                    NSString *profile_picture_path = [user objectForKey:@"profile_picture_path"];
                    NSString *profile_cropped_picture_path = [user objectForKey:@"profile_cropped_picture_path"];
                    NSString *web_link = [yap_info objectForKey:@"web_link"];
                    NSString *yap_length = [yap_info objectForKey:@"length"];
                    double user_id = [[user objectForKey:@"id"] doubleValue];
                    double reyap_user_id = 0;
                    double yap_id = [[yap_info objectForKey:@"yap_id"] doubleValue];
                    double reyap_id = 0;
                    
                    if (![reyap_user isEqualToString:@""]) {
                        reyap_id = [[post_info objectForKey:@"reyap_id"] doubleValue];
                        reyap_user_id = [[reyap_user_dic objectForKey:@"id"] doubleValue];
                    }
                    
                    if (segmentController.selectedSegmentIndex == 0) {
                        if (![reyap_user isEqualToString:@""]) {
                            after_reyap = reyap_id;
                            last_after_reyap = after_reyap;
                        }
                        else {
                            if (last_after_reyap != 0) {
                                after_reyap = last_after_reyap;
                            }
                            
                            after_yap = yap_id;
                        }
                    }
                    else if (segmentController.selectedSegmentIndex == 1) {
                        double like_id = [[[json objectAtIndex:i] objectForKey:@"like_id"] doubleValue];
                        
                        after_yap = like_id;
                    }
                    else if (segmentController.selectedSegmentIndex == 2) {
                        double listen_id = [[[json objectAtIndex:i] objectForKey:@"listen_id"] doubleValue];
                        
                        after_yap = listen_id;
                    }
                    
                    if (![reyap_user isEqualToString:@""]) {
                        numReyaps = numReyaps + 1;
                    }
                    
                    NSString *yap_title = [yap_info objectForKey:@"title"];
                    NSString *audio_path = [yap_info objectForKey:@"audio_path"];
                    NSArray *user_tags = [yap_info objectForKey:@"user_tags"];
                    NSArray *hashtags = [yap_info objectForKey:@"hashtags"];
                    NSDate *post_date_created = [post_info objectForKey:@"date_created"];
                    NSDate *yap_date_created = [yap_info objectForKey:@"date_created"];
                    
                    Feed *UserActualFeedObject = [[Feed alloc] initWithYapId: (int) yap_id andReyapId: (double) reyap_id andUserPostId: (double) user_post_id andLikedByViewer: (BOOL) liked_by_viewer andReyapUser: (NSString *) reyap_user andLikeCount: (int) like_count andReyapCount: (int) reyap_count andGroup: (NSArray *) group andGooglePlusAccountId: (double) google_plus_account_id andFacebookAccountId: (double) facebook_account_id andTwitterAccountId: (double) twitter_account_id andLinkedinAccountId: (double) linkedin_account_id andReyappedByViewer: (BOOL) reyapped_by_viewer andListenedByViewer: (BOOL) listened_by_viewer andHashtagsFlag: (BOOL) hashtags_flag andLinkedinSharedFlag: (BOOL) linkedin_shared_flag andFacebookSharedFlag: (BOOL) facebook_shared_flag andTwitterSharedFlag: (BOOL) twitter_shared_flag andGooglePlusSharedFlag: (BOOL) google_plus_shared_flag andUserTagsFlag: (BOOL) user_tags_flag andWebLinkFlag: (BOOL) web_link_flag andPictureFlag: (BOOL) picture_flag andPictureCroppedFlag: (BOOL) picture_cropped_flag andIsActive: (BOOL) is_active andGroupFlag: (BOOL) group_flag andIsDeleted: (BOOL) is_deleted andListenCount: (int) listen_count andLatitude: (NSString *) latitude andLongitude: (NSString *) longitude andYapLongitude: (NSString *) yap_longitude andUsername: (NSString *) username andFirstName: (NSString *) first_name andLastName: (NSString *) last_name andPicturePath: (NSString *) picture_path andPictureCroppedPath: (NSString *) picture_cropped_path andProfilePicturePath: (NSString *) profile_picture_path andProfileCroppedPicturePath: (NSString *) profile_cropped_picture_path andWebLink: (NSString *) web_link andYapLength: (NSString *) yap_length andUserId: (double) user_id andReyapUserId: (double) reyap_user_id andYapTitle: (NSString *) yap_title andAudioPath: (NSString *) audio_path andUserTags: (NSArray *) user_tags andHashtags: (NSArray *) hashtags andPostDateCreated: (NSDate *) post_date_created andYapDateCreated: (NSDate *) yap_date_created];
                    
                    //add user object to user info array
                    [userFeed addObject:UserActualFeedObject];
                    
                    int difference = [userFeed count] - numReyaps;
                    
                    if ([userProfileDesc isEqualToString:@""]) {
                        theTable.frame = CGRectMake(theTable.frame.origin.x, 310, theTable.frame.size.width, (difference*125)+(numReyaps*155)+35);
                    }
                    else {
                        theTable.frame = CGRectMake(theTable.frame.origin.x, desc_frame.origin.y+description_label.frame.size.height+10+segmentControllerAndTableView.frame.size.height, theTable.frame.size.width, (difference*125)+(numReyaps*155)+35);
                        
                    }
                    
                    //[mainScrollView setContentSize:CGSizeMake(320, theTable.frame.origin.y+theTable.contentSize.height+100)];
                    
                    mainScrollView.scrollEnabled = YES;
                    
                    if ((isLoadingMorePosts && !isSearch2) || isLoadingMoreSearchPosts) {
                        [loadingMoreData stopAnimating];
                        loadingMoreData.hidden = YES;
                        
                        theTable.frame = CGRectMake(theTable.frame.origin.x, theTable.frame.origin.y+70, theTable.frame.size.width, theTable.frame.size.height);
                        theTable.scrollEnabled = YES;
                    }
                    
                    isLoadingMorePosts = false;
                    isLoadingMoreSearchPosts = false;
                    
                    playAllButton.enabled = YES;
                    
                    self.workingEntry = [[AppPhotoRecord alloc] init];
                    
                    if (![profile_cropped_picture_path isEqualToString:@""]) {
   
                        if (self.workingEntry)
                        {
                            NSString *bucket = @"yapsterapp";
                            S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
                            
                            //get profile photo
                            S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
                            gpsur_cropped_photo.key     = profile_cropped_picture_path;
                            gpsur_cropped_photo.bucket  = bucket;
                            gpsur_cropped_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
                            gpsur_cropped_photo.responseHeaderOverrides = override;
                            
                            NSURL *url_cropped_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_cropped_photo];
                            
                            NSString *url_string = [url_cropped_photo absoluteString];
                            
                            self.workingEntry.imageURLString = url_string;
                            
                            [self.workingArray addObject:self.workingEntry];
                            
                            DLog(@"added %i", i);
                        }
                    }
                    else {
                        NSString *url_string = @"http://i.imgur.com/HHL5lOB.jpg";
                        
                        self.workingEntry.imageURLString = url_string;
                        
                        [self.workingArray addObject:self.workingEntry];
                    }
                }
                
                if (self.workingArray.count > 0) {
                    user_photo_entries = self.workingArray;
                    
                    DLog(@"user_photo_entries.count %lu", (unsigned long)self.user_photo_entries.count);
                }
                
                [self.theTable reloadData];
                
                [mainScrollView setContentSize:CGSizeMake(320, theTable.frame.origin.y+theTable.contentSize.height+100)];
                
                loadingMoreData.frame = CGRectMake(loadingMoreData.frame.origin.x, theTable.frame.origin.y+theTable.contentSize.height+80, loadingMoreData.frame.size.width, loadingMoreData.frame.size.height);
                
                mainScrollView.scrollEnabled = YES;
                
                if ([userProfileDesc isEqualToString:@""]) {
                    theTable.frame = CGRectMake(theTable.frame.origin.x, 310, theTable.frame.size.width, theTable.contentSize.height);
                }
                else {
                    theTable.frame = CGRectMake(theTable.frame.origin.x, desc_frame.origin.y+description_label.frame.size.height+10+segmentControllerAndTableView.frame.size.height, theTable.frame.size.width, theTable.contentSize.height);
                }
                
                theTable.hidden = NO;
                
                numLoadedPosts = numLoadedPosts+postAmount;
            }
            else {
                if (numLoadedPosts < postAmount) {
                    message.text = @"No more posts to load.";
                    message.hidden = NO;
                    
                    menuTable.hidden = YES;
                    
                    [loadingData stopAnimating];
                    loadingData.hidden = YES;
                    [loadingData2 stopAnimating];
                    loadingData2.hidden = YES;
                }
            }
        }
        else {
            if (numLoadedPosts < postAmount) {
                //[mainScrollView setContentSize:CGSizeMake(320, [[UIScreen mainScreen] bounds].size.height)];
                
                mainScrollView.scrollEnabled = NO;
                
                if (segmentController.selectedSegmentIndex == 0) {
                    if (userToView == sessionUserID) {
                        message.text = @"No Yaps to show.";
                    }
                    else {
                        message.text = @"No Yaps from this user.";
                    }
                }
                else if (segmentController.selectedSegmentIndex == 1) {
                    if (userToView == sessionUserID) {
                        message.text = @"You don't have any likes.";
                    }
                    else {
                        message.text = @"No Likes from this user.";
                    }
                }
                else if (segmentController.selectedSegmentIndex == 2) {
                    if (userToView == sessionUserID) {
                        message.text = @"You don't have any listens.";
                    }
                    else {
                        message.text = @"This user currently has no listens.";
                    }
                }
                
                mainScrollView.scrollEnabled = NO;
                
                message.hidden = NO;
                theTable.hidden = YES;
            }
        }
        
        [loadingData stopAnimating];
        loadingData.hidden = YES;
        [loadingData2 stopAnimating];
        loadingData2.hidden = YES;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection2) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            __block NSData *data = [responseBodyProfile dataUsingEncoding:NSUTF8StringEncoding];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                profileJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSDictionary *general_info = profileJson;
                NSDictionary *user_city;
                NSDictionary *user_country;
                NSDictionary *user_state;
                NSDictionary *user;
                NSDictionary *following_info;
                
                if (profileJson.count > 0) {
                    user = [profileJson objectForKey:@"user"];
                    user_city = [general_info objectForKey:@"user_city"];
                    user_country = [general_info objectForKey:@"user_country"];
                    user_state = [general_info objectForKey:@"user_us_state"];
                    following_info = [general_info objectForKey:@"following_info"];
                    
                    NSString *location_city;
                    
                    if (![user_city isKindOfClass:[NSNull class]]) {
                        location_city = [user_city objectForKey:@"city_name"];
                    }
                    else {
                        location_city = @"";
                    }
                    
                    NSString *location_state;
                    
                    if (![user_state isKindOfClass:[NSNull class]]) {
                          location_state = [user_state objectForKey:@"us_state_name"];
                    }
                    else {
                        location_state = @"";
                    }
                    
                    listener_count = [[general_info objectForKey:@"follower_count"] doubleValue];
                    NSString *description = [general_info objectForKey:@"description"];
                    
                    userProfileDesc = description;
                    
                    NSString *location_country;
                    
                    if (![user_country isKindOfClass:[NSNull class]]) {
                        location_country = [user_country objectForKey:@"country_name"];
                    }
                    else {
                        location_country = @"";
                    }
                    
                    NSString *phone;
                    
                    if (![user_country isKindOfClass:[NSNull class]]) {
                        phone = [general_info objectForKey:@"phone"];
                    }
                    else {
                        phone = @"";
                    }
                    
                    listening_count = [[general_info objectForKey:@"following_count"] doubleValue];
                    BOOL is_active = [[general_info objectForKey:@"is_active"] boolValue];
                    
                    double listen_count = [[general_info objectForKey:@"listen_count"] doubleValue];
                    
                    NSString *location_zip_code;
                    
                    if (![user_country isKindOfClass:[NSNull class]]) {
                        location_zip_code = [general_info objectForKey:@"user_zip_code"];
                    }
                    else {
                        location_zip_code = @"";
                    }
                    
                    BOOL profile_picture_flag = [[general_info objectForKey:@"profile_picture_flag"] boolValue];
                    BOOL profile_picture_cropped_flag = [[general_info objectForKey:@"profile_picture_cropped_flag"] boolValue];
                    NSDate *date_of_birth = [general_info objectForKey:@"date_of_birth"];
                    BOOL verified_account_flag = [[general_info objectForKey:@"verified_account_flag"] boolValue];
                    double like_count = [[general_info objectForKey:@"listen_count"] doubleValue];
                    BOOL high_security_account_flag = [[general_info objectForKey:@"high_security_account_flag"] boolValue];
                    posts_are_private = [[general_info objectForKey:@"posts_are_private"] boolValue];
                    
                    DLog(@"posts_are_private one %hhd", posts_are_private);
                    
                    BOOL listen_stream_public = [[general_info objectForKey:@"listen_stream_public"] boolValue];
                    NSString *username = [user objectForKey:@"username"];
                    NSString *first_name = [user objectForKey:@"first_name"];
                    NSString *last_name = [user objectForKey:@"last_name"];
                    double user_id = [[user objectForKey:@"id"] doubleValue];
                    
                    user_following_profile_user = false;
                    profile_user_following_user = false;
                    user_requested_profile_user = false;
                    
                    if (user_id != sessionUserID) {
                        user_following_profile_user = [[following_info objectForKey:@"user_following_profile_user"] boolValue];
                        profile_user_following_user = [[following_info objectForKey:@"profile_user_following_user"] boolValue];
                        user_requested_profile_user = [[following_info objectForKey:@"user_requested_profile_user"] boolValue];
                    }
                    
                    double reyap_count = [[general_info objectForKey:@"reyap_count"] doubleValue];
                    NSString *profile_picture_path = [general_info objectForKey:@"profile_picture_path"];
                    NSString *profile_picture_cropped_path = [general_info objectForKey:@"profile_picture_cropped_path"];
                    double yap_count = [[general_info objectForKey:@"yap_count"] doubleValue];
                    
                    UserInfo *UserActualInfoObject = [[UserInfo alloc] initWithUserId:user_id andLocationCity:location_city andLocationState:location_state andListenerCount:listener_count andDescription:description andLocationCountry:location_country andPhone:phone andListeningCount:listening_count andIsActive:is_active andViewerListeningToUser:user_following_profile_user andUserListeningToViewer:profile_user_following_user andListenCount:listen_count andLocationZipCode:location_zip_code andProfilePictureFlag:profile_picture_flag andProfileCroppedPictureFlag: (BOOL) profile_picture_cropped_flag andDateOfBirth:date_of_birth andVerifiedAccountFlag:verified_account_flag andLikeCount:like_count andHighSecurityAccountFlag:high_security_account_flag andPostsArePrivate: (BOOL) posts_are_private andListenStreamPublic: (BOOL) listen_stream_public andUsername:username andFirstName:first_name andLastName:last_name andReyapCount:reyap_count andProfilePicturePath:profile_picture_path andProfileCroppedPicturePath: (NSString *)profile_picture_cropped_path andYapCount:yap_count];
                    
                    //add user info object to user info array
                    [userProfileInfo addObject:UserActualInfoObject];
                    
                    CGFloat constrainedWidth = 280.0f;
                    CGSize sizeOfText;
                    float max_width;
                    
                    sizeOfText = [[NSString stringWithFormat:@"%@ %@", UserActualInfoObject.first_name, UserActualInfoObject.last_name] sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:16] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)];
                    
                    //sizeOfText = [@"@dffdfdfdfdfdffdfdfddfddfdfdf" sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:16] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)];
                    
                    full_name_label.frame = CGRectMake(full_name_label.frame.origin.x,full_name_label.frame.origin.y,constrainedWidth,sizeOfText.height);
                    full_name_label.numberOfLines=0;
                    
                    max_width = sizeOfText.width;
                    
                    sizeOfText = [[NSString stringWithFormat:@"@%@", username] sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:16] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)];
                    
                    //sizeOfText = [@"@dffdfdfdfdfdffdfdfddfddfdfdf" sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:16] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)];
                    
                    if (sizeOfText.width > max_width) {
                        max_width = sizeOfText.width;
                    }
                    
                    username_label.frame = CGRectMake(username_label.frame.origin.x,username_label.frame.origin.y,constrainedWidth,sizeOfText.height);
                    username_label.numberOfLines=0;
                    
                    full_name_label.text = [NSString stringWithFormat:@"%@ %@", UserActualInfoObject.first_name, UserActualInfoObject.last_name];
                    username_label.text = [NSString stringWithFormat:@"@%@", username];
                    yap_count_label.text = [NSString stringWithFormat:@"%g", UserActualInfoObject.yap_count];
                    listening_label.text = [NSString stringWithFormat:@"%g", UserActualInfoObject.listening_count];
                    listeners_label.text = [NSString stringWithFormat:@"%g", UserActualInfoObject.listener_count];
                    
                    //DLog(@"sessionCountry %@", sessionCountry);
                    
                    if (![location_country isEqualToString:@""]) {
                        if (![location_city isEqualToString:@""]) {
                            if (![sessionCountry isEqualToString:location_country]) {
                                location_label.text = [NSString stringWithFormat:@"%@, %@", location_city, location_country];
                            }
                            else {
                                if (![location_state isEqualToString:@""]) {
                                    location_label.text = [NSString stringWithFormat:@"%@, %@", location_city, location_state];
                                }
                                else {
                                    location_label.text = [NSString stringWithFormat:@"%@", location_city];
                                }
                            }
                        }
                        else {
                            location_label.text = [NSString stringWithFormat:@"%@", location_country];
                        }
                    }
                    else {
                        location_label.hidden = YES;
                    }
                    
                    if (profile_user_following_user) {
                        listens_to_you_label.hidden = NO;
                    }
                    
                    if (![UserActualInfoObject.description isEqualToString:@""]) {
                        description_label.text = UserActualInfoObject.description;
                        
                        [description_label sizeToFit];
                    }
                    else {
                        description_label.hidden = YES;
                    }
                    
                    if (UserActualInfoObject.listen_stream_public) {
                        userListensArePrivate = false;
                    }
                    else {
                        userListensArePrivate = true;
                    }
                    
                    if (UserActualInfoObject.profile_cropped_picture_flag) {
                        //get cropped user profile photo
                        NSString *bucket = @"yapsterapp";
                        S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
                        
                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        dispatch_async(queue, ^{
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                            });
                            
                            S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
                            gpsur_cropped_photo.key     = UserActualInfoObject.profile_cropped_picture_path;
                            gpsur_cropped_photo.bucket  = bucket;
                            gpsur_cropped_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
                            gpsur_cropped_photo.responseHeaderOverrides = override;
                            
                            NSURL *url_cropped_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_cropped_photo];
                            
                            NSData *data_cropped_photo = [NSData dataWithContentsOfURL:url_cropped_photo];
                            
                            UIImage *cropped_photo = [UIImage imageWithData:data_cropped_photo];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                CALayer *imageLayer = user_photo_btn.layer;
                                [imageLayer setCornerRadius:user_photo_btn.frame.size.width/2];
                                [imageLayer setBorderWidth:0.0];
                                [imageLayer setMasksToBounds:YES];
                                
                                [user_photo_btn setBackgroundImage:cropped_photo forState:UIControlStateNormal];
                                
                                user_photo_btn.enabled = YES;
                            });
                        });
                    }
                    else {
                        user_photo_btn.enabled = NO;
                    }
                    
                    if (UserActualInfoObject.profile_picture_flag) {
                        //get big user profile photo
                        NSString *bucket = @"yapsterapp";
                        S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
                        
                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        dispatch_async(queue, ^{
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                            });
                            
                            S3GetPreSignedURLRequest *gpsur_big_photo = [[S3GetPreSignedURLRequest alloc] init];
                            gpsur_big_photo.key     = UserActualInfoObject.profile_picture_path;
                            gpsur_big_photo.bucket  = bucket;
                            gpsur_big_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
                            gpsur_big_photo.responseHeaderOverrides = override;
                            
                            NSURL *url_big_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_big_photo];
                            
                            NSData *data_big_photo = [NSData dataWithContentsOfURL:url_big_photo];
                            
                            UIImage *big_photo = [UIImage imageWithData:data_big_photo];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                bigYapPhotoViewWrapper.backgroundColor = [UIColor blackColor];
                                
                                bigYapPhotoView = [[UIImageView alloc] init];
                                bigYapPhotoView.image = big_photo;
                                
                                bigYapPhotoView.contentMode = UIViewContentModeScaleAspectFit;
                                
                                bigYapPhotoViewWrapper.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
                                bigYapPhotoScrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
                                
                                bigYapPhotoView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
                                
                                [[self myZoomableView] addSubview:bigYapPhotoView];
                                
                                CALayer *layer = doneBtn.layer;
                                layer.backgroundColor = [[UIColor blackColor] CGColor];
                                layer.borderColor = [[UIColor whiteColor] CGColor];
                                layer.cornerRadius = 8.0f;
                                layer.borderWidth = 1.0f;
                                
                                user_photo_btn.enabled = YES;
                            });
                        });
                    }
                    else {
                        user_photo_btn.enabled = NO;
                    }
                    
                    //verified_account_flag = true;
                    
                    if (UserActualInfoObject.user_id == sessionUserID) {
                        edit_profile_btn.hidden = NO;
                    }
                    else {
                        edit_profile_btn.hidden = YES;
                        
                        //profile_user_following_user = YES;
                        
                        if (user_following_profile_user == YES) {
                            listening_btn.hidden = NO;
                            listening_btn.frame = CGRectMake(listening_btn.frame.origin.x, edit_profile_btn.frame.origin.y, listening_btn.frame.size.width, listening_btn.frame.size.height);
                        }
                        else if (user_requested_profile_user == YES) {
                            requested_btn.hidden = NO;
                            requested_btn.frame = CGRectMake(requested_btn.frame.origin.x, edit_profile_btn.frame.origin.y, requested_btn.frame.size.width, requested_btn.frame.size.height);
                        }
                        else {
                            listen_btn.hidden = NO;
                            listen_btn.frame = CGRectMake(listen_btn.frame.origin.x, edit_profile_btn.frame.origin.y, listen_btn.frame.size.width, listen_btn.frame.size.height);
                        }
                    }
                    
                    userInfoView.hidden = NO;
                    segmentControllerAndTableView.hidden = NO;
                    
                    rightOptions.frame = CGRectMake(max_width+50, rightOptions.frame.origin.y, rightOptions.frame.size.width, rightOptions.frame.size.height);
                    
                    rightOptions_original_position = rightOptions.frame;
                    
                    if (verified_account_flag) {
                        user_verified.frame = CGRectMake(max_width+25, user_verified.frame.origin.y, user_verified.frame.size.width, user_verified.frame.size.height);
                        user_verified.hidden = NO;
                    }
                    
                    [scrollView1 setContentSize:CGSizeMake(rightOptions.frame.size.width+max_width+100, 63)];
                    
                    //segmentControllerAndTableView.backgroundColor = [UIColor redColor];
                    
                    if ([UserActualInfoObject.location_country isEqualToString:@""]) {
                        if (description_label.hidden == NO) {
                            description_label.frame = CGRectMake(description_label.frame.origin.x, location_label.frame.origin.y+22, description_label.frame.size.width, description_label.frame.size.height);
                        }
                    }
                    
                    DLog(@"description_label height %f", description_label.frame.size.height);
                    
                    desc_frame = [description_label.superview convertRect:description_label.frame toView:self.view];
                    
                    if ([UserActualInfoObject.description isEqualToString:@""]) {
                        segmentControllerAndTableView.frame = CGRectMake(segmentControllerAndTableView.frame.origin.x, 250, segmentControllerAndTableView.frame.size.width, segmentControllerAndTableView.frame.size.height);
                        userInfoView.frame = CGRectMake(userInfoView.frame.origin.x, userInfoView.frame.origin.y, userInfoView.frame.size.width, 220);
                        userMainInfoView.frame = CGRectMake(userMainInfoView.frame.origin.x, userMainInfoView.frame.origin.y, userMainInfoView.frame.size.width, 150);
                        //theTable.frame = CGRectMake(theTable.frame.origin.x, theTable.frame.origin.y-65, theTable.frame.size.width, self.view.bounds.size.height);
                    }
                    else {
                        segmentControllerAndTableView.frame = CGRectMake(segmentControllerAndTableView.frame.origin.x, desc_frame.origin.y+description_label.frame.size.height+10, segmentControllerAndTableView.frame.size.width, segmentControllerAndTableView.frame.size.height);
                        userInfoView.frame = CGRectMake(userInfoView.frame.origin.x, userInfoView.frame.origin.y, userInfoView.frame.size.width, 273);
                        userMainInfoView.frame = CGRectMake(userMainInfoView.frame.origin.x, userMainInfoView.frame.origin.y, userMainInfoView.frame.size.width, 203);
                        //theTable.frame = CGRectMake(theTable.frame.origin.x, theTable.frame.origin.y-20, theTable.frame.size.width, self.view.bounds.size.height);
                    }
                    
                    //DLog(@"theTable.frame: ", );
                    
                    if (cameFromNotifications && [notification_name isEqualToString:@"follower_requested"] && !profile_user_following_user) {
                        segmentControllerAndTableView.hidden = YES;
                        
                        if ([UserActualInfoObject.description isEqualToString:@""]) {
                            acceptOrDenyView.frame = CGRectMake(acceptOrDenyView.frame.origin.x, 252, acceptOrDenyView.frame.size.width, acceptOrDenyView.frame.size.height);
                        }
                        else {
                            acceptOrDenyView.frame = CGRectMake(acceptOrDenyView.frame.origin.x, desc_frame.origin.y+description_label.frame.size.height+12, acceptOrDenyView.frame.size.width, acceptOrDenyView.frame.size.height);
                        }
                        
                        acceptOrDenyView.hidden = NO;
                    }
                    
                    DLog(@"posts_are_private two %hhd", posts_are_private);
                    
                    if (UserActualInfoObject.user_id != sessionUserID) {
                        if (!posts_are_private || user_following_profile_user) {
                            NSError *error;
                            
                            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                            NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
                            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                            NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
                            
                            //call stream
                            NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                            tempSessionUserID, @"user_id",
                                                            tempUserToView, @"profile_user_id",
                                                            tempSessionID, @"session_id",
                                                            tempPostAmount, @"amount",
                                                            @"posts", @"stream_type",
                                                            nil];
                            
                            //convert object to data
                            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                            
                            NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
                            
                            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                            [request setURL:the_url];
                            [request setHTTPMethod:@"POST"];
                            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                            [request setHTTPBody:jsonData];
                            
                            NSHTTPURLResponse* urlResponse = nil;
                            
                            NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                            
                            responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                            
                            //int responseCode = [urlResponse statusCode];
                            
                            if (!jsonData) {
                                DLog(@"JSON error: %@", error);
                            }
                            else {
                                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                                DLog(@"JSON: %@", JSONString);
                            }
                            
                            connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            
                            [connection1 start];
                            
                            if (connection1) {
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                                
                                loadingData2.hidden = NO;
                                
                                [loadingData2 startAnimating];
                            }
                            else {
                                //Error
                            }
                        }
                        else {
                            segmentControllerAndTableView.hidden = YES;
                            message.text = @"This user's posts are private.";
                            message.frame = CGRectMake(message.frame.origin.x, message.frame.origin.y-70, message.frame.size.width, message.frame.size.height);
                            theTable.hidden = YES;
                            message.hidden = NO;
                            mainScrollView.scrollEnabled = NO;
                        }
                    }
                    else {
                        NSError *error;
                        
                        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                        NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
                        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                        NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
                        
                        //call stream
                        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                        tempSessionUserID, @"user_id",
                                                        tempUserToView, @"profile_user_id",
                                                        tempSessionID, @"session_id",
                                                        tempPostAmount, @"amount",
                                                        @"posts", @"stream_type",
                                                        nil];
                        
                        //convert object to data
                        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                        
                        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
                        
                        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                        [request setURL:the_url];
                        [request setHTTPMethod:@"POST"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [request setHTTPBody:jsonData];
                        
                        NSHTTPURLResponse* urlResponse = nil;
                        
                        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                        
                        responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                        
                        //int responseCode = [urlResponse statusCode];
                        
                        if (!jsonData) {
                            DLog(@"JSON error: %@", error);
                        }
                        else {
                            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                            DLog(@"JSON: %@", JSONString);
                        }
                        
                        connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                        
                        [connection1 start];
                        
                        if (connection1) {
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                            
                            loadingData2.hidden = NO;
                            
                            [loadingData2 startAnimating];
                        }
                        else {
                            //Error
                        }
                    }
                }
                else {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    
                    [loadingData stopAnimating];
                    loadingData.hidden = YES;
                    
                    top_message.hidden = NO;
                }
            });
        });
    }
    else if (connection == connection3) {
        NSData *data = [responseBodyFollow dataUsingEncoding:NSUTF8StringEncoding];
        
        followJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", followJson);
        
        if (json.count > 0) {
            BOOL valid = [[followJson objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not follow this user at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                listen_btn.hidden = YES;
                
                if (!posts_are_private) {
                    listening_btn.hidden = NO;
                    listening_btn.frame = CGRectMake(listening_btn.frame.origin.x, edit_profile_btn.frame.origin.y, listening_btn.frame.size.width, listening_btn.frame.size.height);
                }
                else {
                    requested_btn.hidden = NO;
                    requested_btn.frame = CGRectMake(requested_btn.frame.origin.x, edit_profile_btn.frame.origin.y, requested_btn.frame.size.width, requested_btn.frame.size.height);
                }
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not follow this user at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection4) {
        NSData *data = [responseBodyUnfollow dataUsingEncoding:NSUTF8StringEncoding];
        
        unfollowJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", unfollowJson);
        
        if (json.count > 0) {
            BOOL valid = [[unfollowJson objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not unfollow this user at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                listening_btn.hidden = YES;
                listen_btn.hidden = NO;
                listen_btn.frame = CGRectMake(listen_btn.frame.origin.x, edit_profile_btn.frame.origin.y, listen_btn.frame.size.width, listen_btn.frame.size.height);
                
                if (posts_are_private) {
                    segmentControllerAndTableView.hidden = YES;
                    
                    message.text = @"This user's posts are private.";
                    message.frame = CGRectMake(message.frame.origin.x, message.frame.origin.y-70, message.frame.size.width, message.frame.size.height);
                    theTable.hidden = YES;
                    message.hidden = NO;
                    
                    mainScrollView.scrollEnabled = NO;
                    
                    // terminate all pending download connections
                    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                    
                    [self.imageDownloadsInProgress removeAllObjects];
                }
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not unfollow this user at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection5) {
        NSData *data = [responseBodyDeleteYap dataUsingEncoding:NSUTF8StringEncoding];
        
        deleteYapJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", deleteYapJson);
        
        if (json.count > 0) {
            BOOL valid = [[deleteYapJson objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not delete this Yap. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                [userFeed removeObjectAtIndex:current_yap_to_delete];
                numLoadedPosts = numLoadedPosts-1;
                
                [theTable reloadData];
                
                current_yap_to_delete = 99999999;
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not delete this Yap. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection6) {
        NSData *data = [responseBodyReportYap dataUsingEncoding:NSUTF8StringEncoding];
        
        reportYapJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", reportYapJson);
        
        if (json.count > 0) {
            BOOL valid = [[reportYapJson objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not report this Yap. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yap Reported" message:@"This Yap has successfully been reported to the Yapster Team." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not report this Yap. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection7) {
        NSData *data = [responseBodyReportUser dataUsingEncoding:NSUTF8StringEncoding];
        
        reportUserJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", reportUserJson);
        
        if (json.count > 0) {
            BOOL valid = [[reportUserJson objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not report this user. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User Reported" message:@"This user has successfully been reported to the Yapster Team." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not report this user. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection8) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *userDataPath = [documentsDirectory stringByAppendingPathComponent:@"userinfo.plist"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:userDataPath]) {
            NSMutableArray *plistData = [[NSMutableArray alloc] init];
            
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            
            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
            
            [userInfo setObject:tempSessionUserID forKey:@"user_id"];
            [userInfo setObject:tempSessionID forKey:@"session_id"];
            [userInfo setObject:@"" forKey:@"device_token"];
            
            [plistData addObject:userInfo];
            
            DLog(@"%@", plistData);
            
            [plistData writeToFile:userDataPath atomically:YES];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        ViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        
        [self.navigationController pushViewController:homeVC animated:NO];
    }
    else if (connection == connection9) {
        NSData *data = [responseBodyAcceptRequest dataUsingEncoding:NSUTF8StringEncoding];
        
        acceptRequestJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", acceptRequestJson);
        
        if (json.count > 0) {
            BOOL valid = [[acceptRequestJson objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not accept follow request at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                listens_to_you_label.hidden = NO;
                
                acceptOrDenyView.hidden = YES;
                segmentControllerAndTableView.hidden = NO;
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not accept follow request at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection10) {
        NSData *data = [responseBodyDenyRequest dataUsingEncoding:NSUTF8StringEncoding];
        
        denyRequestJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", denyRequestJson);
        
        if (json.count > 0) {
            BOOL valid = [[denyRequestJson objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not deny follow request at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                acceptOrDenyView.hidden = YES;
                segmentControllerAndTableView.hidden = NO;
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not deny follow request at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    else if (connection == connection11) {
        NSData *data = [responseBodyUnRequest dataUsingEncoding:NSUTF8StringEncoding];
        
        unRequestJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", unRequestJson);
        
        if (json.count > 0) {
            BOOL valid = [[unRequestJson objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not unrequest user at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                requested_btn.hidden = YES;
                listen_btn.hidden = NO;
                listen_btn.frame = CGRectMake(listen_btn.frame.origin.x, edit_profile_btn.frame.origin.y, listen_btn.frame.size.width, listen_btn.frame.size.height);
            }
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

-(void)confirmDelete {
	alertViewConfirmDelete = [[UIAlertView alloc]
                              initWithTitle:@"Delete Yap"
                              message:@"Are you sure you want to delete this Yap?"
                              delegate:self
                              cancelButtonTitle:@"Don't delete"
                              otherButtonTitles:nil];
	
	[alertViewConfirmDelete addButtonWithTitle:@"Delete"];
	[alertViewConfirmDelete show];
}

-(void)confirmReport {
	alertViewConfirmReport= [[UIAlertView alloc]
                              initWithTitle:@"Report Yap"
                              message:@"Are you sure you want to report this Yap?"
                              delegate:self
                              cancelButtonTitle:@"Don't report"
                              otherButtonTitles:nil];
	
	[alertViewConfirmReport addButtonWithTitle:@"Report"];
	[alertViewConfirmReport show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == alertViewConfirmDelete) {
        if (buttonIndex == 1) {
            //delete yap
            NSIndexPath *pathOfTheCell = [theTable indexPathForCell:current_cell];
            NSInteger rowOfTheCell = [pathOfTheCell row];
            
            Feed *userFeedData = [userFeed objectAtIndex:rowOfTheCell];
            
            double the_id = 0;
            NSString *reyap_user = userFeedData.reyap_user;
            
            NSDictionary *newDatasetInfo;
            
            NSError *error;
            
            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
            
            NSURL *the_url;
            
            if ([reyap_user isEqualToString:@""]) {
                the_id = userFeedData.yap_id;
                
                NSNumber *tempYapID = [[NSNumber alloc] initWithDouble:the_id];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempYapID, @"yap_id",
                                  nil];
                
                the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/delete/"];
                
                DLog(@"%@", the_url);
            }
            else {
                the_id = userFeedData.reyap_id;
                
                NSNumber *tempReyapID = [[NSNumber alloc] initWithDouble:the_id];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempReyapID, @"reyap_id",
                                  nil];
                
                the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/reyap/delete/"];
            }
            
            //convert object to data
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:the_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonData];
            
            NSHTTPURLResponse* urlResponse = nil;
            
            NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
            
            responseBodyDeleteYap = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            //int responseCode = [urlResponse statusCode];
            
            if (!jsonData) {
                DLog(@"JSON error: %@", error);
            }
            else {
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                DLog(@"JSON: %@", JSONString);
            }
            
            connection5 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection5 start];
            
            if (connection5) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                
                current_yap_to_delete = rowOfTheCell;
            }
            
            DLog(@"YAP ID: %f", the_id);
            
            [current_cell hideUtilityButtonsAnimated:YES];
            
            DLog(@"Delete button clicked");
        }
        else {
            [current_cell hideUtilityButtonsAnimated:YES];
        }
    }
    else if (alertView == alertViewConfirmReport) {
        if (buttonIndex == 1) {
            //report yap
            
            NSIndexPath *pathOfTheCell = [theTable indexPathForCell:current_cell];
            NSInteger rowOfTheCell = [pathOfTheCell row];
            
            Feed *userFeedData = [userFeed objectAtIndex:rowOfTheCell];
            
            double the_id = 0;
            NSString *reyap_user = userFeedData.reyap_user;
            
            NSDictionary *newDatasetInfo;
            
            NSError *error;
            
            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
            
            NSURL *the_url;
            
            if ([reyap_user isEqualToString:@""]) {
                the_id = userFeedData.yap_id;
                
                NSNumber *tempYapID = [[NSNumber alloc] initWithDouble:the_id];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempYapID, @"reported_yap_id",
                                  nil];
                
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/report/yap/"];
                
                DLog(@"%@", the_url);
            }
            else {
                the_id = userFeedData.reyap_id;
                
                NSNumber *tempReyapID = [[NSNumber alloc] initWithDouble:the_id];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempReyapID, @"reported_reyap_id",
                                  nil];
                
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/report/reyap/"];
            }
            
            //convert object to data
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:the_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonData];
            
            NSHTTPURLResponse* urlResponse = nil;
            
            NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
            
            responseBodyReportYap = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            //int responseCode = [urlResponse statusCode];
            
            if (!jsonData) {
                DLog(@"JSON error: %@", error);
            }
            else {
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                DLog(@"JSON: %@", JSONString);
            }
            
            connection6 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection6 start];
            
            if (connection6) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                
                current_yap_to_report = rowOfTheCell;
            }
            
            DLog(@"YAP ID: %f", the_id);
            
            [current_cell hideUtilityButtonsAnimated:YES];
        }
        else {
            [current_cell hideUtilityButtonsAnimated:YES];
        }
    }
}

-(IBAction)showMoreOptions:(id)sender {
    if (userToView != sessionUserID) {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Report user",
                                nil];
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self reportUser:(popup)];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(IBAction)reportUser:(id)sender {
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempReportedUserId = [[NSNumber alloc] initWithDouble:userToView];
    
    NSDictionary *newDatasetInfo;
    NSData* jsonData;
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/report/user/"];
    
    NSError *error;
    
    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                      tempSessionUserID, @"user_id",
                      tempSessionID, @"session_id",
                      tempReportedUserId, @"reported_user_id",
                      nil];
    
    //convert object to data
    jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
    
    responseBodyReportUser = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    if (!jsonData) {
        DLog(@"JSON error: %@", error);
    }
    
    connection7 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection7 start];
}

-(IBAction)editProfile:(id)sender {
    editProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        //Push to controller
        [self.navigationController pushViewController:editProfileVC animated:YES];
    }
}

-(IBAction)followUser:(id)sender {
    //follow user
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempUserRequestedId = [[NSNumber alloc] initWithDouble:userToView];
    
    NSDictionary *newDatasetInfo;
    NSData* jsonData;
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/follow/request/"];
    
    NSError *error;
    
    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                      tempSessionUserID, @"user_id",
                      tempSessionID, @"session_id",
                      tempUserRequestedId, @"user_requested_id",
                      nil];
    
    //convert object to data
    jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
    
    responseBodyFollow = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    if (!jsonData) {
        DLog(@"JSON error: %@", error);
    }
    else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        DLog(@"JSON: %@", JSONString);
    }
    
    connection3 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection3 start];
    
    if (connection3) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    DLog(@"following");
}

-(IBAction)unfollowUser:(id)sender {
    //unfollow user
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempUserUnfollowedId = [[NSNumber alloc] initWithDouble:userToView];
    
    NSDictionary *newDatasetInfo;
    NSData* jsonData;
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/follow/unfollow/"];
    
    NSError *error;
    
    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                      tempSessionUserID, @"user_id",
                      tempSessionID, @"session_id",
                      tempUserUnfollowedId, @"user_unfollowed_id",
                      nil];
    
    //convert object to data
    jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
    
    responseBodyUnfollow = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    if (!jsonData) {
        DLog(@"JSON error: %@", error);
    }
    else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        DLog(@"JSON: %@", JSONString);
    }
    
    connection4 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection4 start];
    
    if (connection4) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    DLog(@"not following");
}

-(IBAction)showFollowing:(id)sender {
    listeningVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ListeningVC"];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        listeningVC.the_user = userToView;
        listeningVC.following_count = listening_count;
        
        //Push to controller
        [self.navigationController pushViewController:listeningVC animated:YES];
    }
}

-(IBAction)showFollowers:(id)sender {
    listenersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ListenersVC"];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        listenersVC.the_user = userToView;
        listenersVC.follower_count = listener_count;
        
        //Push to controller
        [self.navigationController pushViewController:listenersVC animated:YES];
    }
}

-(IBAction)playAll:(id)sender {
    //if (segmentController.selectedSegmentIndex == 0) { //play all "main stream"
        //DLog(@"USER FEED COUNT: %i", userFeed.count);
    
        if (userFeed.count > 0) {
            sharedManager.currentYapPlaying = [sharedManager.sessionCurrentPlaylist count];
            
            for (int i = 0; i < userFeed.count; i++) {
                Feed *userFeedData = [userFeed objectAtIndex:i];
                
                NSNumber *yap_to_play2 = [[NSNumber alloc] initWithDouble:userFeedData.yap_id];
                NSNumber *reyap_id2 = [[NSNumber alloc] initWithDouble:userFeedData.reyap_id];
                NSNumber *user_id2 = [[NSNumber alloc] initWithDouble:userFeedData.user_id];
                NSNumber *reyap_user_id2 = [[NSNumber alloc] initWithDouble:userFeedData.reyap_user_id];
                
                NSNumber *hashtags_flag2 = [[NSNumber alloc] initWithBool:userFeedData.hashtags_flag];
                NSNumber *user_tags_flag2 = [[NSNumber alloc] initWithBool:userFeedData.user_tags_flag];
                NSNumber *web_link_flag2 = [[NSNumber alloc] initWithBool:userFeedData.web_link_flag];
                NSNumber *yap_picture_flag2 = [[NSNumber alloc] initWithBool:userFeedData.picture_flag];
                NSNumber *yap_picture_cropped_flag2 = [[NSNumber alloc] initWithBool:userFeedData.picture_cropped_flag];
                
                NSNumber *reyapped_by_viewer2 = [[NSNumber alloc] initWithBool:userFeedData.reyapped_by_viewer];
                NSNumber *liked_by_viewer2 = [[NSNumber alloc] initWithBool:userFeedData.liked_by_viewer];
                
                NSNumber *yap_length_value2 = [[NSNumber alloc] initWithInt:[userFeedData.yap_length intValue]];
                NSNumber *yap_length_int2 = [[NSNumber alloc] initWithInt:[userFeedData.yap_length intValue]];
                NSNumber *yap_likes_value2 = [[NSNumber alloc] initWithInt:userFeedData.like_count];
                NSNumber *yap_reyaps_value2 = [[NSNumber alloc] initWithInt:userFeedData.reyap_count];
                NSNumber *yap_listens_value2 = [[NSNumber alloc] initWithInt:userFeedData.listen_count+1];
                
                NSMutableDictionary *playlistDic = [[NSMutableDictionary alloc] init];
                
                [playlistDic setObject:@"user_profile" forKey:@"came_from"];
                
                [playlistDic setObject:yap_to_play2 forKey:@"yap_to_play"];
                [playlistDic setObject:user_id2 forKey:@"user_id"];
                [playlistDic setObject:[NSString stringWithFormat:@"%@ %@", userFeedData.first_name, userFeedData.last_name] forKey:@"name_value"];
                [playlistDic setObject:[NSString stringWithFormat:@"%@", userFeedData.username] forKey:@"username_value"];
                
                NSString *dateString;
                
                if (![userFeedData.reyap_user isEqualToString:@""]) {
                    [playlistDic setObject:userFeedData.reyap_user forKey:@"reyap_username_value"];
                    [playlistDic setObject:reyap_user_id2 forKey:@"reyap_user_id"];
                    [playlistDic setObject:reyap_id2 forKey:@"reyap_id"];
                    [playlistDic setObject:@"reyap" forKey:@"object_type"];
                    dateString = [NSString stringWithFormat:@"%@", userFeedData.post_date_created];
                }
                else {
                    [playlistDic setObject:@"yap" forKey:@"object_type"];
                    dateString = [NSString stringWithFormat:@"%@", userFeedData.yap_date_created];
                }
                
                if ([dateString rangeOfString:@"T"].location != NSNotFound) {
                    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                }
                
                if ([dateString rangeOfString:@"."].location != NSNotFound) {
                    NSRange range = [dateString rangeOfString:@"."];
                    
                    dateString = [dateString substringToIndex:range.location];
                }
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //// here set format of date which is in your output date (means above str with format)
                
                NSDate *date = [dateFormatter dateFromString: dateString]; // here you can fetch date from string with define format
                
                NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                //NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [formatter setTimeZone:sourceTimeZone];
                
                NSDate* sourceDate = [NSDate date];
                
                NSString *timeStamp = [formatter stringFromDate:sourceDate];
                
                NSDate *destinationDateToday = [formatter dateFromString:timeStamp];
                
                NSDate *destinationDatePost = [formatter dateFromString:dateString];
                
                NSString *dateStringToday = [formatter stringFromDate:destinationDateToday];
                NSString *dateStringThen =  [formatter stringFromDate:destinationDatePost];
                
                NSDate *startDate = [formatter dateFromString:dateStringThen];
                NSDate *endDate = [formatter dateFromString:dateStringToday];
                
                NSDateComponents *minutesComponent = [[NSCalendar currentCalendar]
                                                      components:NSMinuteCalendarUnit
                                                      fromDate:startDate
                                                      toDate:endDate
                                                      options:0];
                NSDateComponents *hoursComponent = [[NSCalendar currentCalendar]
                                                    components:NSHourCalendarUnit
                                                    fromDate:startDate
                                                    toDate:endDate
                                                    options:0];
                NSDateComponents *daysComponent = [[NSCalendar currentCalendar]
                                                   components:NSDayCalendarUnit
                                                   fromDate:startDate
                                                   toDate:endDate
                                                   options:0];
                
                
                long timeDiffMins = [minutesComponent minute];
                long timeDiffHours = [hoursComponent hour];
                long timeDiffDays = [daysComponent day];
                
                NSString *convertedString;
                
                if (timeDiffDays >= 1) {
                    dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"M/d/yyyy"];// here set format which you want...
                    
                    convertedString = [dateFormatter stringFromDate:date];
                }
                else if (timeDiffHours >= 1 && timeDiffDays < 1) {
                    if (timeDiffHours > 1) {
                        convertedString = [NSString stringWithFormat:@"%li hrs ago", timeDiffHours];
                    }
                    else if (timeDiffHours == 1) {
                        convertedString = [NSString stringWithFormat:@"%li hr ago", timeDiffHours];
                    }
                }
                else if (timeDiffMins >= 1 && timeDiffHours < 1) {
                    if (timeDiffMins > 1) {
                        convertedString = [NSString stringWithFormat:@"%li mins ago", timeDiffMins];
                    }
                    else if (timeDiffMins == 1) {
                        convertedString = [NSString stringWithFormat:@"%li min ago", timeDiffMins];
                    }
                }
                else if (timeDiffMins < 1) {
                    convertedString = @"Just now";
                }
                
                [playlistDic setObject:convertedString forKey:@"yap_date_value"];
                
                [playlistDic setObject:userFeedData.title forKey:@"yap_title_value"];
                
                [playlistDic setObject:yap_length_value2 forKey:@"yap_length_value"];
                
                [playlistDic setObject:yap_likes_value2 forKey:@"yap_likes_value"];
                
                [playlistDic setObject:yap_listens_value2 forKey:@"yap_plays_value"];
                
                [playlistDic setObject:yap_reyaps_value2 forKey:@"yap_reyaps_value"];
                
                [playlistDic setObject:reyapped_by_viewer2 forKey:@"reyapped_by_viewer"];
                
                [playlistDic setObject:liked_by_viewer2 forKey:@"liked_by_viewer"];

                [playlistDic setObject:yap_length_int2 forKey:@"yap_length_int"];
                if (![userFeedData.audio_path isEqualToString:@""]) {
                    [playlistDic setObject:userFeedData.audio_path forKey:@"yap_audio_path"];
                }
                
                if (userFeedData.web_link_flag) {
                    [playlistDic setValue:web_link_flag2 forKey:@"web_link_flag"];
                    [playlistDic setValue:userFeedData.web_link forKey:@"web_link"];
                }
                
                if (userFeedData.picture_flag) {
                    [playlistDic setValue:yap_picture_flag2 forKey:@"picture_flag"];
                    [playlistDic setValue:userFeedData.picture_path forKey:@"picture_path"];
                }
                
                if (userFeedData.picture_cropped_flag) {
                    [playlistDic setValue:yap_picture_cropped_flag2 forKey:@"picture_cropped_flag"];
                    [playlistDic setValue:userFeedData.picture_cropped_path forKey:@"picture_cropped_path"];
                }
                
                if (userFeedData.hashtags_flag) {
                    [playlistDic setValue:hashtags_flag2 forKey:@"hashtags_flag"];
                    [playlistDic setValue:userFeedData.hashtags forKey:@"hashtags"];
                }
                
                if (userFeedData.user_tags_flag) {
                    [playlistDic setValue:user_tags_flag2 forKey:@"user_tags_flag"];
                    [playlistDic setValue:userFeedData.user_tags forKey:@"user_tags"];
                }
                
                if (![userFeedData.profile_cropped_picture_path isEqualToString:@""]) {
                    [playlistDic setValue:userFeedData.profile_cropped_picture_path forKey:@"user_profile_picture_cropped_path"];
                }
                else {
                    [playlistDic setValue:@"" forKey:@"user_profile_picture_cropped_path"];
                }
  
                [sharedManager.sessionCurrentPlaylist addObject:playlistDic];

                if (i == 0) {
                    sharedManager.sessionCurrentPlayingYap = [[NSMutableArray alloc] init];
                    
                    [sharedManager.sessionCurrentPlayingYap addObject:playlistDic];
                }
                
                BOOL found = false;
                
                for (int i = 0; i < sharedManager.sessionCurrentPlaylist.count; i++) {
                    double this_yap = userFeedData.yap_id;
                    double current_yap_in_playlist = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:i] valueForKey:@"yap_to_play"] doubleValue];
                    
                    if (this_yap == current_yap_in_playlist) {
                        if (found) {
                            [sharedManager.sessionCurrentPlaylist removeObjectAtIndex:i];
                            
                            found = false;
                        }
                        else {
                            found = true;
                        }
                    }
                }
            }
            
            //playlistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistVC"];
            
            playerScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerScreenVC"];
            
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            
            if (networkStatus == NotReachable) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            } else {
                playerScreenVC.isPlaylist = true;
                
                if (segmentController.selectedSegmentIndex == 0) {
                    playerScreenVC.profile_stream_type = @"posts";
                }
                else if (segmentController.selectedSegmentIndex == 1) {
                    playerScreenVC.profile_stream_type = @"likes";
                }
                else if (segmentController.selectedSegmentIndex == 2) {
                    playerScreenVC.profile_stream_type = @"listens";
                }
                
                if (segmentController.selectedSegmentIndex == 0) {
                    playerScreenVC.after_yap = after_yap;
                    
                    playerScreenVC.after_reyap = after_reyap;
                }
                else {
                    playerScreenVC.after_yap = after_yap;
                }
                
                playerScreenVC.user_to_view = userToView;
                
                sharedManager.currentYapPlaying = 0;
                
                //Push to controller
                [self.navigationController pushViewController:playerScreenVC animated:YES];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There are no Yaps to play." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    //}
    //else if (segmentController.selectedSegmentIndex == 1) { //play all "like stream"
        
    //}
    //else if (segmentController.selectedSegmentIndex == 2) { //play all "user plays stream"
        
    //}
}

-(IBAction)goToYapScreen:(id)sender {
    createYapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateYapVC"];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        //Push to controller
        [self.navigationController pushViewController:createYapVC animated:YES];
    }
}

-(IBAction)segmentControl:(id)sender {
    UIImage *stream;
    UIImage *likes;
    UIImage *play;
    UIImage *separator;
    
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    [connection7 cancel];
    [connection8 cancel];
    [connection9 cancel];
    [connection10 cancel];
    [connection11 cancel];
    
    numReyaps = 0;
    
    mainScrollView.scrollEnabled = NO;
    
    /*
    CGRect desc_frame = [description_label.superview convertRect:description_label.frame toView:self.view];
    
    if ([userProfileDesc isEqualToString:@""]) {
        segmentControllerAndTableView.frame = CGRectMake(segmentControllerAndTableView.frame.origin.x, 250, segmentControllerAndTableView.frame.size.width, segmentControllerAndTableView.frame.size.height);
    }
    else {
        segmentControllerAndTableView.frame = CGRectMake(segmentControllerAndTableView.frame.origin.x, (description_label.frame.origin.y+description_label.frame.size.height+scrollView1.frame.size.height)-11, segmentControllerAndTableView.frame.size.width, segmentControllerAndTableView.frame.size.height);
    }*/
    
    [mainScrollView setContentOffset:CGPointZero animated:YES];
    
    [loadingData2 stopAnimating];
    loadingData2.hidden = YES;
    
    isLoadingMorePosts = false;
    
    theTable.hidden = YES;
    userMainInfoView.hidden = NO;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (segmentController.selectedSegmentIndex == 0) {
        if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
            stream = [[UIImage imageNamed:@"profile-active-stream.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            likes = [[UIImage imageNamed:@"profile-inactive-like.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            play = [[UIImage imageNamed:@"profile-inactive-play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            separator = [[UIImage imageNamed:@"separator.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else {
            stream = [UIImage imageNamed:@"profile-active-stream.png"];
            likes = [UIImage imageNamed:@"profile-inactive-like.png"];
            play = [UIImage imageNamed:@"profile-inactive-play.png"];
            separator = [UIImage imageNamed:@"separator.png"];
        }
        
        [segmentController setImage:stream forSegmentAtIndex:0];
        [segmentController setImage:likes forSegmentAtIndex:1];
        [segmentController setImage:play forSegmentAtIndex:2];
        [segmentController setDividerImage:separator forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        if ([searchBox respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor whiteColor];
            searchBox.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search Posts Stream" attributes:@{NSForegroundColorAttributeName: color}];
        }
        
        if (networkStatus == NotReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not load stream." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        else {
            if ([searchBox.text isEqualToString:@""]) {
                //build an info object and convert to json
                NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
                NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
                
                __block NSError *error;
                
                //call stream
                NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                tempSessionUserID, @"user_id",
                                                tempSessionID, @"session_id",
                                                tempUserToView, @"profile_user_id",
                                                tempPostAmount, @"amount",
                                                @"posts", @"stream_type",
                                                nil];
                
                
                
                //convert object to data
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                
                NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:the_url];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setHTTPBody:jsonData];
                
                __block NSHTTPURLResponse* urlResponse = nil;
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    
                    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                    
                    responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                        
                        message.hidden = YES;
                        // terminate all pending download connections
                        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                        
                        [self.imageDownloadsInProgress removeAllObjects];
                        
                        userFeed = [[NSMutableArray alloc] init];
                        self.workingArray = [NSMutableArray array];
                        [self.workingArray removeAllObjects];
                        user_photo_entries = [NSMutableArray array];
                        [user_photo_entries removeAllObjects];
                        
                        numLoadedPosts = 0;
                        [self.theTable reloadData];
                        [self.theTable setContentOffset:CGPointZero animated:NO];
                        mainScrollView.scrollEnabled = NO;
                        
                        loadingData2.hidden = NO;
                        
                        [loadingData2 startAnimating];
                
                        //int responseCode = [urlResponse statusCode];
                        
                        if (!jsonData) {
                            DLog(@"JSON error: %@", error);
                        }
                        else {
                            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                            DLog(@"JSON: %@", JSONString);
                        }
                        
                        connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                        
                        [connection1 start];
                        
                        if (connection1) {
                            
                        }
                        else {
                            //Error
                        }
                    });
                });
            }
            else {
                // terminate all pending download connections
                NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                
                [self.imageDownloadsInProgress removeAllObjects];
                
                [self searchYaps:searchBox];
            }
        }
    }
    else if (segmentController.selectedSegmentIndex == 1) {
        if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
            stream = [[UIImage imageNamed:@"profile-inactive-stream.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            likes = [[UIImage imageNamed:@"profile-active-like.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            play = [[UIImage imageNamed:@"profile-inactive-play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            separator = [[UIImage imageNamed:@"separator.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else {
            stream = [UIImage imageNamed:@"profile-inactive-stream.png"];
            likes = [UIImage imageNamed:@"profile-active-like.png"];
            play = [UIImage imageNamed:@"profile-inactive-play.png"];
            separator = [UIImage imageNamed:@"separator.png"];
        }
        
        [segmentController setImage:stream forSegmentAtIndex:0];
        [segmentController setImage:likes forSegmentAtIndex:1];
        [segmentController setImage:play forSegmentAtIndex:2];
        [segmentController setDividerImage:separator forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        if ([searchBox respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor whiteColor];
            searchBox.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search Likes Stream" attributes:@{NSForegroundColorAttributeName: color}];
        }
        
        if (networkStatus == NotReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not load likes." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        else {
            
            if ([searchBox.text isEqualToString:@""]) {
                //build an info object and convert to json
                NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
                NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
                
                __block NSError *error;
                
                //call stream
                NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                tempSessionUserID, @"user_id",
                                                tempSessionID, @"session_id",
                                                tempUserToView, @"profile_user_id",
                                                tempPostAmount, @"amount",
                                                @"likes", @"stream_type",
                                                nil];
                
                
                
                //convert object to data
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                
                NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                [request setURL:the_url];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setHTTPBody:jsonData];
                
                __block NSHTTPURLResponse* urlResponse = nil;
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    
                    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                    
                    responseBodyLikes = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                        
                        message.hidden = YES;
                        // terminate all pending download connections
                        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                        
                        [self.imageDownloadsInProgress removeAllObjects];
                        
                        userFeed = [[NSMutableArray alloc] init];
                        self.workingArray = [NSMutableArray array];
                        [self.workingArray removeAllObjects];
                        user_photo_entries = [NSMutableArray array];
                        [user_photo_entries removeAllObjects];
                        
                        numLoadedPosts = 0;
                        [self.theTable reloadData];
                        [self.theTable setContentOffset:CGPointZero animated:NO];
                        mainScrollView.scrollEnabled = NO;
                        
                        loadingData2.hidden = NO;
                        
                        [loadingData2 startAnimating];
    
                        //int responseCode = [urlResponse statusCode];
                        
                        if (!jsonData) {
                            DLog(@"JSON error: %@", error);
                        }
                        
                        connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                        
                        [connection1 start];
                        
                        if (connection1) {
                            
                        }
                        else {
                            //Error
                        }
                    });
                });
            }
            else {
                // terminate all pending download connections
                NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                
                [self.imageDownloadsInProgress removeAllObjects];
                
                [self searchYaps:searchBox];
            }
        }
    }
    else if (segmentController.selectedSegmentIndex == 2) {
        if ([UIImage instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
            stream = [[UIImage imageNamed:@"profile-inactive-stream.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            likes = [[UIImage imageNamed:@"profile-inactive-like.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            play = [[UIImage imageNamed:@"profile-active-play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            separator = [[UIImage imageNamed:@"separator.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else {
            stream = [UIImage imageNamed:@"profile-inactive-stream.png"];
            likes = [UIImage imageNamed:@"profile-inactive-like.png"];
            play = [UIImage imageNamed:@"profile-active-play.png"];
            separator = [UIImage imageNamed:@"separator.png"];
        }
        
        [segmentController setImage:stream forSegmentAtIndex:0];
        [segmentController setImage:likes forSegmentAtIndex:1];
        [segmentController setImage:play forSegmentAtIndex:2];
        [segmentController setDividerImage:separator forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        if ([searchBox respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor whiteColor];
            searchBox.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search Listens Stream" attributes:@{NSForegroundColorAttributeName: color}];
        }
        
        if (!userListensArePrivate || (userToView == sessionUserID)) {
            if (networkStatus == NotReachable) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not load listens." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                
                if ([searchBox.text isEqualToString:@""]) {
                    //build an info object and convert to json
                    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                    NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
                    NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
                    
                    __block NSError *error;
                    
                    //call stream
                    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                    tempSessionUserID, @"user_id",
                                                    tempSessionID, @"session_id",
                                                    tempUserToView, @"profile_user_id",
                                                    tempPostAmount, @"amount",
                                                    @"listens", @"stream_type",
                                                    nil];
                    
                    
                    
                    //convert object to data
                    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                    
                    NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
                    
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                    [request setURL:the_url];
                    [request setHTTPMethod:@"POST"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    [request setHTTPBody:jsonData];
                    
                    __block NSHTTPURLResponse* urlResponse = nil;
                    
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        
                        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                        
                        responseBodyListens = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                            
                            message.hidden = YES;
                            // terminate all pending download connections
                            NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                            [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                            
                            [self.imageDownloadsInProgress removeAllObjects];
                            
                            userFeed = [[NSMutableArray alloc] init];
                            self.workingArray = [NSMutableArray array];
                            [self.workingArray removeAllObjects];
                            user_photo_entries = [NSMutableArray array];
                            [user_photo_entries removeAllObjects];
                            
                            numLoadedPosts = 0;
                            [self.theTable reloadData];
                            [self.theTable setContentOffset:CGPointZero animated:NO];
                            mainScrollView.scrollEnabled = NO;
                            
                            loadingData2.hidden = NO;
                            
                            [loadingData2 startAnimating];

                            //int responseCode = [urlResponse statusCode];
                            
                            if (!jsonData) {
                                DLog(@"JSON error: %@", error);
                            }
                            
                            connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            
                            [connection1 start];
                            
                            if (connection1) {
                                
                            }
                            else {
                                //Error
                            }
                        });
                    });
                }
                else {
                    // terminate all pending download connections
                    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                    
                    [self.imageDownloadsInProgress removeAllObjects];
                    
                    [self searchYaps:searchBox];
                }
            }
        }
        else {
            theTable.hidden = YES;
            message.text = @"This user's listens are private.";
            message.hidden = NO;
        }
    }
}

/*-(IBAction)goToPlayerScreen:(id)sender {
    UIButton *button = sender;
    int row = button.tag;
    
    playerScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerScreenVC"];
    
    Feed *userFeedData = [userFeed objectAtIndex:row];
    
    NSString *dateString;
    
    dateString = [NSString stringWithFormat:@"%@", userFeedData.yap_date_created];
    
    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSRange range = [dateString rangeOfString:@"."];
    
    dateString = [dateString substringToIndex:range.location];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //// here set format of date which is in your output date (means above str with format)
    
    NSDate *date = [dateFormatter dateFromString: dateString]; // here you can fetch date from string with define format
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDateToday = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDatePost = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    
    NSString *dateStringToday = [formatter stringFromDate:destinationDateToday];
    NSString *dateStringThen =  [formatter stringFromDate:destinationDatePost];
    
    NSDate *startDate = [formatter dateFromString:dateStringThen];
    NSDate *endDate = [formatter dateFromString:dateStringToday];
    
    NSDateComponents *minutesComponent = [[NSCalendar currentCalendar]
                                          components:NSMinuteCalendarUnit
                                          fromDate:startDate
                                          toDate:endDate
                                          options:0];
    NSDateComponents *hoursComponent = [[NSCalendar currentCalendar]
                                        components:NSHourCalendarUnit
                                        fromDate:startDate
                                        toDate:endDate
                                        options:0];
    NSDateComponents *daysComponent = [[NSCalendar currentCalendar]
                                       components:NSDayCalendarUnit
                                       fromDate:startDate
                                       toDate:endDate
                                       options:0];
    
    
    long timeDiffMins = [minutesComponent minute];
    long timeDiffHours = [hoursComponent hour];
    long timeDiffDays = [daysComponent day];
    
    NSString *convertedString;
    
    if (timeDiffDays >= 1) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M/d/yyyy"];// here set format which you want...
        
        convertedString = [dateFormatter stringFromDate:date];
    }
    else if (timeDiffHours >= 1 && timeDiffDays < 1) {
        if (timeDiffHours > 1) {
            convertedString = [NSString stringWithFormat:@"%li hours ago", timeDiffHours];
        }
        else if (timeDiffHours == 1) {
            convertedString = [NSString stringWithFormat:@"%li hour ago", timeDiffHours];
        }
    }
    else if (timeDiffMins >= 1 && timeDiffHours < 1) {
        if (timeDiffMins > 1) {
            convertedString = [NSString stringWithFormat:@"%li minutes ago", timeDiffMins];
        }
        else if (timeDiffMins == 1) {
            convertedString = [NSString stringWithFormat:@"%li minute ago", timeDiffMins];
        }
    }
    else if (timeDiffMins < 1) {
        convertedString = @"Just now";
    }
    
    playerScreenVC.yap_to_play = userFeedData.yap_id;
    
    if ([userFeedData.reyap_user isKindOfClass:[NSNull class]]) {
        playerScreenVC.object_type = @"yap";
    }
    else {
        playerScreenVC.object_type = @"reyap";
    }
    
    playerScreenVC.user_id = userFeedData.user_id;
    playerScreenVC.yap_audio_path = userFeedData.audio_path;
    playerScreenVC.yap_picture_flag = userFeedData.picture_flag;
    playerScreenVC.yap_picture_path = userFeedData.picture_path;
    playerScreenVC.yap_picture_cropped_flag = userFeedData.picture_cropped_flag;
    playerScreenVC.yap_picture_cropped_path = userFeedData.picture_cropped_path;
    playerScreenVC.name_value = [NSString stringWithFormat:@"%@ %@", userFeedData.first_name, userFeedData.last_name];
    playerScreenVC.username_value = [NSString stringWithFormat:@"@%@", userFeedData.username];
    playerScreenVC.yap_title_value = [NSString stringWithFormat:@"%@", userFeedData.title];
    playerScreenVC.hashtags_flag = userFeedData.hashtags_flag;
    playerScreenVC.hashtags_array = userFeedData.hashtags;
    playerScreenVC.user_tags_flag = userFeedData.user_tags_flag;
    playerScreenVC.userstag_array = userFeedData.user_tags;
    playerScreenVC.yap_date_value = convertedString;
    playerScreenVC.yap_plays_value = userFeedData.listen_count;
    playerScreenVC.yap_reyaps_value = userFeedData.reyap_count;
    playerScreenVC.yap_likes_value = userFeedData.like_count;
    playerScreenVC.yap_length_value = [userFeedData.yap_length intValue];
    
    //Push to controller
    [self.navigationController pushViewController:playerScreenVC animated:YES];
}*/

-(IBAction)goToUserProfile:(id)sender {
    UIButton *button = sender;
    int user_id = button.tag;
    
    UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
    
    UserProfileVC.userToView = user_id;
    
    //Push to controller
    [self.navigationController pushViewController:UserProfileVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if (tableView == theTable) {
        return 1;
    }
    else {
        return [menuKeys count];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == theTable) {
        return [userFeed count];
    }
    else {
        NSString *key = [menuKeys objectAtIndex:section];
        
        NSArray *list = [menuItems objectForKey:key];
        
        return [list count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    
    if (tableView == theTable) {
        rowHeight = 125;
        
        Feed *userFeedData = [userFeed objectAtIndex:indexPath.row];
        
        if (![userFeedData.reyap_user isEqualToString:@""]) {
            rowHeight = rowHeight+30;
        }
        
        if (userFeedData.hashtags_flag) {
            rowHeight = rowHeight+30;
        }
        
        if (userFeedData.user_tags_flag) {
            rowHeight = rowHeight+30;
        }
        
        if (userFeedData.web_link_flag) {
            rowHeight = rowHeight+30;
        }
    }
    else {
        rowHeight = 52;
    }
    
    return rowHeight;
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
 return 0.01f;
 }
 
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
 {
 UIView *footerView = [[UIView alloc] init];
 
 footerView.backgroundColor = [UIColor blackColor];
 
 return footerView;
 }*/

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    
    StreamCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tableView == theTable) {
        StreamCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == theTable) {
        if ([theTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [theTable setSeparatorInset:UIEdgeInsetsZero];
        }
        
        Feed *userFeedData = [userFeed objectAtIndex:indexPath.row];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        /*theTable.separatorColor = [UIColor clearColor];
        
        separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        separatorLineView.backgroundColor = [UIColor lightGrayColor];
        
        if (indexPath.row != 0) {
            [cell.contentView addSubview:separatorLineView];
        }
        else {
            [separatorLineView removeFromSuperview];
        }*/
        
        NSString *dateString;
        
        if ([userFeedData.reyap_user isEqualToString:@""]) {
            if (userFeedData.user_id == sessionUserID) {
                cell.rightUtilityButtons = [self rightButtonForDelete];
                cell.tag = 1;
            }
            else {
                cell.rightUtilityButtons = [self rightButtonForReport];
                cell.tag = 2;
            }
        }
        else {
            if (userFeedData.reyap_user_id == sessionUserID) {
                cell.rightUtilityButtons = [self rightButtonForDelete];
                cell.tag = 1;
            }
            else {
                cell.rightUtilityButtons = [self rightButtonForReport];
                cell.tag = 2;
            }
        }
        
        cell.delegate = self;
        
        if ([userFeedData.reyap_user isEqualToString:@""]) {
            cell.reyapUserImageView.hidden = YES;
            cell.btnReyapUser.hidden = YES;
            
            if (segmentController.selectedSegmentIndex == 0) {
                dateString = [NSString stringWithFormat:@"%@", userFeedData.yap_date_created];
            }
            else {
                dateString = [NSString stringWithFormat:@"%@", userFeedData.post_date_created];
            }
            
            cell.btnUserPhoto.frame = CGRectMake(15, 13, cell.btnUserPhoto.frame.size.width, cell.btnUserPhoto.frame.size.height);
            cell.name.frame = CGRectMake(87, 13, cell.name.frame.size.width, cell.name.frame.size.height);
            //cell.yapDate.frame = CGRectMake(cell.yapDate.frame.origin.x, 65, cell.yapDate.frame.size.width, cell.yapDate.frame.size.height);
            cell.username.frame = CGRectMake(87, 28, cell.username.frame.size.width, cell.username.frame.size.height);
            cell.yapTitle.frame = CGRectMake(87, 62, cell.yapTitle.frame.size.width, cell.yapTitle.frame.size.height);
            
            /*
             if (!userFeedData.hashtags_flag) {
             cell.btnPlay.frame = CGRectMake(15, 100, cell.btnPlay.frame.size.width, cell.btnPlay.frame.size.height);
             cell.btnReyap.frame = CGRectMake(95, 100, cell.btnReyap.frame.size.width, cell.btnReyap.frame.size.height);
             cell.btnLike.frame = CGRectMake(180, 100, cell.btnLike.frame.size.width, cell.btnLike.frame.size.height);
             cell.yapPlays.frame = CGRectMake(36, 97, cell.yapPlays.frame.size.width, cell.yapPlays.frame.size.height);
             cell.yapReyaps.frame = CGRectMake(119, 97, cell.yapReyaps.frame.size.width, cell.yapReyaps.frame.size.height);
             cell.yapLikes.frame = CGRectMake(207, 97, cell.yapLikes.frame.size.width, cell.yapLikes.frame.size.height);
             cell.yapLength.frame = CGRectMake(275, 97, cell.yapLength.frame.size.width, cell.yapLength.frame.size.height);
             }
             else {
             cell.btnPlay.frame = CGRectMake(15, 120, cell.btnPlay.frame.size.width, cell.btnPlay.frame.size.height);
             cell.btnReyap.frame = CGRectMake(95, 120, cell.btnReyap.frame.size.width, cell.btnReyap.frame.size.height);
             cell.btnLike.frame = CGRectMake(180, 120, cell.btnLike.frame.size.width, cell.btnLike.frame.size.height);
             cell.yapPlays.frame = CGRectMake(36, 117, cell.yapPlays.frame.size.width, cell.yapPlays.frame.size.height);
             cell.yapReyaps.frame = CGRectMake(119, 117, cell.yapReyaps.frame.size.width, cell.yapReyaps.frame.size.height);
             cell.yapLikes.frame = CGRectMake(207, 117, cell.yapLikes.frame.size.width, cell.yapLikes.frame.size.height);
             cell.yapLength.frame = CGRectMake(275, 117, cell.yapLength.frame.size.width, cell.yapLength.frame.size.height);
             }*/
        }
        else {
            cell.reyapUserImageView.hidden = NO;
            cell.btnReyapUser.hidden = NO;
            
            //cell.reyapUserImageView.frame = CGRectMake(65, 16, 21, 15);
            
            //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            dateString = [NSString stringWithFormat:@"%@", userFeedData.post_date_created];
            
            cell.btnUserPhoto.frame = CGRectMake(cell.btnUserPhoto.frame.origin.x, 45, cell.btnUserPhoto.frame.size.width, cell.btnUserPhoto.frame.size.height);
            cell.name.frame = CGRectMake(cell.name.frame.origin.x, 45, cell.name.frame.size.width, cell.name.frame.size.height);
            //cell.yapDate.frame = CGRectMake(cell.yapDate.frame.origin.x, 15, cell.yapDate.frame.size.width, cell.yapDate.frame.size.height);
            cell.username.frame = CGRectMake(cell.username.frame.origin.x, 60, cell.username.frame.size.width, cell.username.frame.size.height);
            cell.yapTitle.frame = CGRectMake(cell.yapTitle.frame.origin.x, 94, cell.yapTitle.frame.size.width, cell.yapTitle.frame.size.height);
            
            /*
             if (!userFeedData.hashtags_flag) {
             cell.btnPlay.frame = CGRectMake(cell.btnPlay.frame.origin.x, 132, cell.btnPlay.frame.size.width, cell.btnPlay.frame.size.height);
             cell.btnReyap.frame = CGRectMake(cell.btnReyap.frame.origin.x, 132, cell.btnReyap.frame.size.width, cell.btnReyap.frame.size.height);
             cell.btnLike.frame = CGRectMake(cell.btnLike.frame.origin.x, 132, cell.btnLike.frame.size.width, cell.btnLike.frame.size.height);
             cell.yapPlays.frame = CGRectMake(cell.yapPlays.frame.origin.x, 129, cell.yapPlays.frame.size.width, cell.yapPlays.frame.size.height);
             cell.yapReyaps.frame = CGRectMake(cell.yapReyaps.frame.origin.x, 129, cell.yapReyaps.frame.size.width, cell.yapReyaps.frame.size.height);
             cell.yapLikes.frame = CGRectMake(cell.yapLikes.frame.origin.x, 129, cell.yapLikes.frame.size.width, cell.yapLikes.frame.size.height);
             cell.yapLength.frame = CGRectMake(cell.yapLength.frame.origin.x, 129, cell.yapLength.frame.size.width, cell.yapLength.frame.size.height);
             }
             else {
             cell.btnPlay.frame = CGRectMake(cell.btnPlay.frame.origin.x, 147, cell.btnPlay.frame.size.width, cell.btnPlay.frame.size.height);
             cell.btnReyap.frame = CGRectMake(cell.btnReyap.frame.origin.x, 147, cell.btnReyap.frame.size.width, cell.btnReyap.frame.size.height);
             cell.btnLike.frame = CGRectMake(cell.btnLike.frame.origin.x, 147, cell.btnLike.frame.size.width, cell.btnLike.frame.size.height);
             cell.yapPlays.frame = CGRectMake(cell.yapPlays.frame.origin.x, 147, cell.yapPlays.frame.size.width, cell.yapPlays.frame.size.height);
             cell.yapReyaps.frame = CGRectMake(cell.yapReyaps.frame.origin.x, 147, cell.yapReyaps.frame.size.width, cell.yapReyaps.frame.size.height);
             cell.yapLikes.frame = CGRectMake(cell.yapLikes.frame.origin.x, 147, cell.yapLikes.frame.size.width, cell.yapLikes.frame.size.height);
             cell.yapLength.frame = CGRectMake(cell.yapLength.frame.origin.x, 147, cell.yapLength.frame.size.width, cell.yapLength.frame.size.height);
             }*/
            
            [cell.btnReyapUser setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.btnReyapUser setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
            cell.btnReyapUser.frame = CGRectMake(87, 12, cell.btnReyapUser.frame.size.width, 21);
            [cell.btnReyapUser setTitle:[NSString stringWithFormat:@"%@", userFeedData.reyap_user] forState:UIControlStateNormal];
        }
        
        if ([dateString rangeOfString:@"T"].location != NSNotFound) {
            dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        }
        
        if ([dateString rangeOfString:@"."].location != NSNotFound) {
            NSRange range = [dateString rangeOfString:@"."];
            
            dateString = [dateString substringToIndex:range.location];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //// here set format of date which is in your output date (means above str with format)
        
        NSDate *date = [dateFormatter dateFromString: dateString]; // here you can fetch date from string with define format
        
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        //NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setTimeZone:sourceTimeZone];
        
        NSDate* sourceDate = [NSDate date];
        
        NSString *timeStamp = [formatter stringFromDate:sourceDate];
        
        NSDate *destinationDateToday = [formatter dateFromString:timeStamp];
        
        NSDate *destinationDatePost = [formatter dateFromString:dateString];
        
        NSString *dateStringToday = [formatter stringFromDate:destinationDateToday];
        NSString *dateStringThen =  [formatter stringFromDate:destinationDatePost];
        
        NSDate *startDate = [formatter dateFromString:dateStringThen];
        NSDate *endDate = [formatter dateFromString:dateStringToday];
        
        NSDateComponents *minutesComponent = [[NSCalendar currentCalendar]
                                              components:NSMinuteCalendarUnit
                                              fromDate:startDate
                                              toDate:endDate
                                              options:0];
        NSDateComponents *hoursComponent = [[NSCalendar currentCalendar]
                                            components:NSHourCalendarUnit
                                            fromDate:startDate
                                            toDate:endDate
                                            options:0];
        NSDateComponents *daysComponent = [[NSCalendar currentCalendar]
                                           components:NSDayCalendarUnit
                                           fromDate:startDate
                                           toDate:endDate
                                           options:0];
        
        
        long timeDiffMins = [minutesComponent minute];
        long timeDiffHours = [hoursComponent hour];
        long timeDiffDays = [daysComponent day];
        
        NSString *convertedString;
        
        if (timeDiffDays >= 1) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"M/d/yyyy"];// here set format which you want...
            
            convertedString = [dateFormatter stringFromDate:date];
        }
        else if (timeDiffHours >= 1 && timeDiffDays < 1) {
            if (timeDiffHours > 1) {
                convertedString = [NSString stringWithFormat:@"%li hrs ago", timeDiffHours];
            }
            else if (timeDiffHours == 1) {
                convertedString = [NSString stringWithFormat:@"%li hr ago", timeDiffHours];
            }
        }
        else if (timeDiffMins >= 1 && timeDiffHours < 1) {
            if (timeDiffMins > 1) {
                convertedString = [NSString stringWithFormat:@"%li mins ago", timeDiffMins];
            }
            else if (timeDiffMins == 1) {
                convertedString = [NSString stringWithFormat:@"%li min ago", timeDiffMins];
            }
        }
        else if (timeDiffMins < 1) {
            convertedString = @"Just now";
        }
        
        cell.yapDate.text = convertedString;
        //[cell.yapDate sizeToFit];
        
        //cell.yapDate.text = [NSString stringWithFormat:@"%f", userFeedData.user_post_id];
        
        int yap_length_int = [userFeedData.yap_length intValue];
        
        if (yap_length_int < 10) {
            cell.yapLength.text = [NSString stringWithFormat:@"0:0%@", userFeedData.yap_length];
        }
        else {
            cell.yapLength.text = [NSString stringWithFormat:@"0:%@", userFeedData.yap_length];
        }
        
        float max_height = 0.0f;
        
        if ([userFeedData.reyap_user isEqualToString:@""]) {
            max_height = cell.yapTitle.frame.origin.y+cell.yapTitle.frame.size.height+10;
        }
        else {
            max_height = cell.yapTitle.frame.origin.y+cell.yapTitle.frame.size.height+10;
        }
        
        if (userFeedData.hashtags_flag) {
            cell.hashtags_scroll.hidden = NO;
            
            NSArray *hashtags_array = [[NSMutableArray alloc] init];
            
            hashtags_array = userFeedData.hashtags;
            
            for (UIView *subview in [cell.hashtags_scroll subviews]) {
                [subview removeFromSuperview];
            }
            
            /*if (![[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"user_tags_flag"]) {
             cell.hashtags_scroll.frame = CGRectMake(67, 123, 233, 20);
             }
             else {
             cell.hashtags_scroll.frame = CGRectMake(67, 75, 233, 20);
             }*/
            
            cell.hashtags_scroll.userInteractionEnabled = YES;
            cell.hashtags_scroll.scrollEnabled = YES;
            cell.hashtags_scroll.showsHorizontalScrollIndicator = NO;
            cell.hashtags_scroll.showsVerticalScrollIndicator = NO;
            
            float last_width = 0.0f;
            float max_width = 0.0f;
            float current_scrollview_width = 0.0f;
            float max_scrollview_width = 213.0f;
            
            //cell.yapTitle.backgroundColor = [UIColor redColor];
            
            for (int i = 0; i < hashtags_array.count; i++) {
                UIButton *hashtag_btn = [[UIButton alloc] init];
                [hashtag_btn setTitle:[NSString stringWithFormat:@"#%@", [[hashtags_array objectAtIndex:i] valueForKey:@"hashtag_name"]] forState:UIControlStateNormal];
                [hashtag_btn setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
                
                [hashtag_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                hashtag_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                
                hashtag_btn.userInteractionEnabled = YES;
                
                hashtag_btn.tag = [[[hashtags_array objectAtIndex:i] valueForKey:@"hashtag_id"] intValue];
                
                [hashtag_btn sizeToFit];
                
                [cell.hashtags_scroll addSubview:hashtag_btn];
                
                if (i == 0) {
                    hashtag_btn.frame = CGRectMake(0, 0, hashtag_btn.frame.size.width, cell.hashtags_scroll.frame.size.height);
                }
                else {
                    hashtag_btn.frame = CGRectMake(max_width, 0, hashtag_btn.frame.size.width, cell.hashtags_scroll.frame.size.height);
                }
                
                last_width = hashtag_btn.frame.size.width;
                max_width = max_width+last_width+5;
                current_scrollview_width = current_scrollview_width+max_width;
                
                if (current_scrollview_width > max_scrollview_width) {
                    current_scrollview_width = max_scrollview_width;
                }
                
                [cell.hashtags_scroll setContentSize:CGSizeMake(max_width, cell.hashtags_scroll.frame.size.height)];
                
                if ([userFeedData.reyap_user isEqualToString:@""]) {
                    cell.hashtags_scroll.frame = CGRectMake(cell.hashtags_scroll.frame.origin.x, 90, current_scrollview_width, cell.hashtags_scroll.frame.size.height);
                }
                else {
                    cell.hashtags_scroll.frame = CGRectMake(cell.hashtags_scroll.frame.origin.x, 115, current_scrollview_width, cell.hashtags_scroll.frame.size.height);
                }
                
                /*
                 cell.yapPlays.frame = CGRectMake(cell.yapPlays.frame.origin.x, 129, cell.yapPlays.frame.size.width, cell.yapPlays.frame.size.height);
                 cell.yapReyaps.frame = CGRectMake(cell.yapReyaps.frame.origin.x, 129, cell.yapReyaps.frame.size.width, cell.yapReyaps.frame.size.height);
                 cell.yapLikes.frame = CGRectMake(cell.yapLikes.frame.origin.x, 129, cell.yapLikes.frame.size.width, cell.yapLikes.frame.size.height);*/
            }
            
            max_height = max_height + 30.0;
            
            cell.hashtags_scroll.scrollEnabled = NO;
        }
        else {
            cell.hashtags_scroll.hidden = YES;
        }
        
        if (userFeedData.user_tags_flag) {
            cell.usertags_scroll.hidden = NO;
            
            NSArray *usertags_array = [[NSMutableArray alloc] init];
            
            usertags_array = userFeedData.user_tags;
            
            for (UIView *subview in [cell.usertags_scroll subviews]) {
                [subview removeFromSuperview];
            }
            
            if (!userFeedData.hashtags_flag) {
                if ([userFeedData.reyap_user isEqualToString:@""]) {
                    cell.usertags_scroll.frame = CGRectMake(cell.usertags_scroll.frame.origin.x, 90, cell.usertags_scroll.frame.size.width, cell.usertags_scroll.frame.size.height);
                }
                else {
                    cell.usertags_scroll.frame = CGRectMake(cell.usertags_scroll.frame.origin.x, 113, cell.usertags_scroll.frame.size.width, cell.usertags_scroll.frame.size.height);
                }
            }
            else {
                if ([userFeedData.reyap_user isEqualToString:@""]) {
                    cell.usertags_scroll.frame = CGRectMake(cell.usertags_scroll.frame.origin.x, 113, cell.usertags_scroll.frame.size.width, cell.usertags_scroll.frame.size.height);
                }
                else {
                    cell.usertags_scroll.frame = CGRectMake(cell.usertags_scroll.frame.origin.x, 139, cell.usertags_scroll.frame.size.width, cell.usertags_scroll.frame.size.height);
                }
            }
            
            cell.usertags_scroll.userInteractionEnabled = YES;
            cell.usertags_scroll.scrollEnabled = YES;
            cell.usertags_scroll.showsHorizontalScrollIndicator = NO;
            cell.usertags_scroll.showsVerticalScrollIndicator = NO;
            
            float last_width = 0.0f;
            float max_width = 0.0f;
            float current_scrollview_width = 0.0f;
            float max_scrollview_width = 213.0f;
            
            for (int i = 0; i < usertags_array.count; i++) {
                UIButton *usertag_btn = [[UIButton alloc] init];
                [usertag_btn setTitle:[NSString stringWithFormat:@"@%@", [[usertags_array objectAtIndex:i] valueForKey:@"username"]] forState:UIControlStateNormal];
                [usertag_btn setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
                
                [usertag_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                usertag_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                
                usertag_btn.userInteractionEnabled = YES;
                
                usertag_btn.tag = [[[usertags_array objectAtIndex:i] valueForKey:@"id"] intValue];
                
                [usertag_btn sizeToFit];
                
                [cell.usertags_scroll addSubview:usertag_btn];
                
                if (i == 0) {
                    usertag_btn.frame = CGRectMake(0, 0, usertag_btn.frame.size.width, cell.hashtags_scroll.frame.size.height);
                }
                else {
                    usertag_btn.frame = CGRectMake(max_width, 0, usertag_btn.frame.size.width, cell.usertags_scroll.frame.size.height);
                }
                
                last_width = usertag_btn.frame.size.width;
                max_width = max_width+last_width+5;
                current_scrollview_width = current_scrollview_width+max_width;
                
                if (current_scrollview_width > max_scrollview_width) {
                    current_scrollview_width = max_scrollview_width;
                }
                
                [cell.usertags_scroll setContentSize:CGSizeMake(max_width, cell.usertags_scroll.frame.size.height)];
                
                cell.usertags_scroll.frame = CGRectMake(cell.usertags_scroll.frame.origin.x, cell.usertags_scroll.frame.origin.y, current_scrollview_width, cell.usertags_scroll.frame.size.height);
            }
            
            max_height = max_height + 30.0;
            
            cell.usertags_scroll.scrollEnabled = NO;
        }
        else {
            cell.usertags_scroll.hidden = YES;
        }
        
        if (userFeedData.web_link_flag) {
            NSString *web_link = userFeedData.web_link;
            
            [cell.web_link_btn setTitle:[NSString stringWithFormat:@"%@", web_link] forState:UIControlStateNormal];
            [cell.web_link_btn setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
            
            [cell.web_link_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            cell.web_link_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            cell.web_link_btn.userInteractionEnabled = YES;
            
            cell.web_link_btn.tag = indexPath.row;
            
            cell.web_link_btn.hidden = NO;
            
            BOOL hashtags_flag = userFeedData.hashtags_flag;
            BOOL user_tags_flag = userFeedData.user_tags_flag;
            
            if (!hashtags_flag) { //no hashtags
                if (!user_tags_flag) { //and no usertags
                    if ([userFeedData.reyap_user isEqualToString:@""]) {
                        cell.web_link_btn.frame = CGRectMake(cell.web_link_btn.frame.origin.x, 90, cell.web_link_btn.frame.size.width, cell.web_link_btn.frame.size.height);
                    }
                    else {
                        cell.web_link_btn.frame = CGRectMake(cell.web_link_btn.frame.origin.x, 113, cell.web_link_btn.frame.size.width, cell.web_link_btn.frame.size.height);
                    }
                }
                else { //has usertags
                    if ([userFeedData.reyap_user isEqualToString:@""]) {
                        cell.web_link_btn.frame = CGRectMake(cell.web_link_btn.frame.origin.x, 142, cell.web_link_btn.frame.size.width, cell.web_link_btn.frame.size.height);
                    }
                    else {
                        cell.web_link_btn.frame = CGRectMake(cell.web_link_btn.frame.origin.x, 113, cell.web_link_btn.frame.size.width, cell.web_link_btn.frame.size.height);
                    }
                }
            }
            else { //has hashtags
                if (!user_tags_flag) { //no usertags
                    if ([userFeedData.reyap_user isEqualToString:@""]) {
                        cell.web_link_btn.frame = CGRectMake(cell.web_link_btn.frame.origin.x, 113, cell.web_link_btn.frame.size.width, cell.web_link_btn.frame.size.height);
                    }
                    else {
                        cell.web_link_btn.frame = CGRectMake(cell.web_link_btn.frame.origin.x, 142, cell.web_link_btn.frame.size.width, cell.web_link_btn.frame.size.height);
                    }
                }
                else { //has usertags
                    if ([userFeedData.reyap_user isEqualToString:@""]) {
                        cell.web_link_btn.frame = CGRectMake(cell.web_link_btn.frame.origin.x, 142, cell.web_link_btn.frame.size.width, cell.web_link_btn.frame.size.height);
                    }
                    else {
                        cell.web_link_btn.frame = CGRectMake(cell.web_link_btn.frame.origin.x, 162, cell.web_link_btn.frame.size.width, cell.web_link_btn.frame.size.height);
                    }
                }
            }
            
            max_height = max_height + 30.0;
        }
        else {
            cell.web_link_btn.hidden = YES;
        }
        
        cell.btnPlay.frame = CGRectMake(15, max_height, cell.btnPlay.frame.size.width, cell.btnPlay.frame.size.height);
        cell.btnReyap.frame = CGRectMake(95, max_height, cell.btnReyap.frame.size.width, cell.btnReyap.frame.size.height);
        cell.btnLike.frame = CGRectMake(180, max_height, cell.btnLike.frame.size.width, cell.btnLike.frame.size.height);
        cell.yapPlays.frame = CGRectMake(36, max_height-3, cell.yapPlays.frame.size.width, cell.yapPlays.frame.size.height);
        cell.yapReyaps.frame = CGRectMake(119, max_height-3, cell.yapReyaps.frame.size.width, cell.yapReyaps.frame.size.height);
        cell.yapLikes.frame = CGRectMake(207, max_height-3, cell.yapLikes.frame.size.width, cell.yapLikes.frame.size.height);
        cell.yapLength.frame = CGRectMake(275, max_height-3, cell.yapLength.frame.size.width, cell.yapLength.frame.size.height);
        
        CALayer *imageLayer = cell.btnUserPhoto.layer;
        [imageLayer setCornerRadius:cell.btnUserPhoto.frame.size.width/2];
        [imageLayer setBorderWidth:0.0];
        [imageLayer setMasksToBounds:YES];
        
        // add a placeholder cell while waiting on table data
        NSUInteger nodeCount = [self.user_photo_entries count];
        
        if (nodeCount > 0 && user_photo_entries.count == nodeCount)
        {
            AppPhotoRecord *photoRecord = [self.user_photo_entries objectAtIndex:indexPath.row];
            
            // Only load cached images; defer new downloads until scrolling ends
            if (!photoRecord.actualPhoto)
            {
                if (self.theTable.dragging == NO && self.theTable.decelerating == NO)
                {
                    [self startIconDownload:photoRecord forIndexPath:indexPath];
                }
                
                // if a download is deferred or in progress, return a placeholder image
                [cell.btnUserPhoto setBackgroundImage:[UIImage imageNamed:@"placer holder_profile photo Large.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.btnUserPhoto setBackgroundImage:photoRecord.actualPhoto forState:UIControlStateNormal];
            }
        }
        
        cell.name.text = [NSString stringWithFormat:@"%@ %@", userFeedData.first_name, userFeedData.last_name];
        //[cell.name sizeToFit];
        [cell.username setTitle:[NSString stringWithFormat:@"@%@", userFeedData.username] forState:UIControlStateNormal];
        //[cell.username sizeToFit];
        cell.yapTitle.text = [NSString stringWithFormat:@"%@", userFeedData.title];
        cell.yapPlays.text = [NSString stringWithFormat:@"%d", userFeedData.listen_count];
        cell.yapReyaps.text = [NSString stringWithFormat:@"%d", userFeedData.reyap_count];
        cell.yapLikes.text = [NSString stringWithFormat:@"%d", userFeedData.like_count];
        
        if (yap_length_int < 10) {
            cell.yapLength.text = [NSString stringWithFormat:@"0:0%@", userFeedData.yap_length];
        }
        else {
            cell.yapLength.text = [NSString stringWithFormat:@"0:%@", userFeedData.yap_length];
        }
        
        if (userFeedData.listened_by_viewer == YES) {
            [cell.btnPlay setBackgroundImage:[UIImage imageNamed:@"bttn_play grn.png"] forState:UIControlStateNormal];
        }
        else {
            [cell.btnPlay setBackgroundImage:[UIImage imageNamed:@"bttn_play gry.png"] forState:UIControlStateNormal];
        }
        
        if (userFeedData.reyapped_by_viewer == YES) {
            [cell.btnReyap setBackgroundImage:[UIImage imageNamed:@"bttn_reyap blue.png"] forState:UIControlStateNormal];
        }
        else {
            [cell.btnReyap setBackgroundImage:[UIImage imageNamed:@"bttn_reyap gry.png"] forState:UIControlStateNormal];
        }
        
        if (userFeedData.liked_by_viewer == YES) {
            [cell.btnLike setBackgroundImage:[UIImage imageNamed:@"bttn_like red.png"] forState:UIControlStateNormal];
        }
        else {
            [cell.btnLike setBackgroundImage:[UIImage imageNamed:@"bttn_like gry.png"] forState:UIControlStateNormal];
        }
        
        cell.btnUserPhoto.tag = userFeedData.user_id;
        cell.username.tag = userFeedData.user_id;
        
        [cell.btnUserPhoto addTarget:self action:@selector(goToUserProfile:) forControlEvents:UIControlEventTouchUpInside];
        [cell.username addTarget:self action:@selector(goToUserProfile:) forControlEvents:UIControlEventTouchUpInside];
        
        if (![userFeedData.reyap_user isKindOfClass:[NSNull class]]) {
            cell.btnReyapUser.tag = userFeedData.reyap_user_id;
            
            [cell.btnReyapUser addTarget:self action:@selector(goToUserProfile:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else {
        NSString *key = [menuKeys objectAtIndex:indexPath.section];
        
        NSArray *list = [menuItems objectForKey:key];
        
        //UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            cell = [[StreamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        
        UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
        self.menuTable.contentInset = inset;
        
        UIImageView *tablelBG = [[UIImageView alloc] initWithFrame:CGRectMake(menuTable.frame.origin.x, menuTable.frame.origin.y, menuTable.frame.size.width, menuTable.frame.size.height)];
        tablelBG.backgroundColor = [UIColor clearColor];
        tablelBG.opaque = NO;
        
        //tablelBG.image = [UIImage imageNamed:@"bg01-01.png"];
        //menuTable.backgroundView = tablelBG;
        
        menuTable.separatorColor = [UIColor clearColor];
        
        if ([menuTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [menuTable setSeparatorInset:UIEdgeInsetsZero];
        }
        
        cell.opaque = YES;
        
        UIImageView *icon = [[UIImageView alloc] init];
        UIImage *theIconImage = [[UIImage alloc] init];
        
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        if (sessionUserCroppedPhoto == nil) {
                            theIconImage = [UIImage imageNamed:@"placer holder_profile photo Large.png"];
                        }
                        else {
                            theIconImage = sessionUserCroppedPhoto;
                        }
                        break;
                    case 1:
                        theIconImage = [UIImage imageNamed:@"bttn_stream wt.png"];
                        break;
                    case 2:
                        theIconImage = [UIImage imageNamed:@"bttn_player wt.png"];
                        break;
                    case 3:
                        theIconImage = [UIImage imageNamed:@"bttn_explore wt.png"];
                        break;
                    case 4:
                        theIconImage = [UIImage imageNamed:@"bttn_notification.png"];
                        break;
                    case 5:
                        theIconImage = [UIImage imageNamed:@"bttn_setting wt.png"];
                        break;
                    case 6:
                        theIconImage = [UIImage imageNamed:@"bttn_rateAPP wt.png"];
                        break;
                    case 7:
                        theIconImage = [UIImage imageNamed:@"bttn_reportProblem wt.png"];
                        break;
                    case 8:
                        theIconImage = [UIImage imageNamed:@""];
                        break;
                    default:
                        break;
                }
                break;
        }
        
        icon.image = theIconImage;
        icon.frame = CGRectMake(40, 10, 35, 35);
        
        CALayer *imageLayer = icon.layer;
        [imageLayer setCornerRadius:icon.frame.size.width/2];
        [imageLayer setBorderWidth:0.0];
        [imageLayer setMasksToBounds:YES];
        
        UILabel *item = [[UILabel alloc]init];
        
        if (indexPath.row != 8) {
            item.textColor = [UIColor whiteColor];
            item.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        }
        else {
            item.textColor = [UIColor greenColor];
            item.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
        }
        
        if (indexPath.row == 0 && userToView == sessionUserID) {
            item.textColor = [UIColor greenColor];
            item.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        }
        
        item.frame = CGRectMake(90, (cell.frame.size.height/2)-9, 280, 26);
        
        if (indexPath.row == 0) {
            item.text = [NSString stringWithFormat:@"%@ %@", sessionFirstName, sessionLastName];
        }
        else {
            item.text = [list objectAtIndex:indexPath.row];
        }
        
        [cell.contentView addSubview:icon];
        [cell.contentView addSubview:item];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == menuTable) {
        // Determine the row/section on the tapped cell
            switch (indexPath.section) {
                case 0:
                    switch (indexPath.row) {
                        case 0: {
                            UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
                            
                            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                            
                            if (networkStatus == NotReachable) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                [alert show];
                            } else {
                                UserProfileVC.userToView = sessionUserID;
                                UserProfileVC.cameFromMenu = YES;
                                
                                //Push to controller
                                [self.navigationController pushViewController:UserProfileVC animated:YES];
                            }
                            
                            break;
                        }
                        case 1: {
                            streamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Stream"];
                            
                            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                            
                            if (networkStatus == NotReachable) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                [alert show];
                            } else {
                                //Push to controller
                                [self.navigationController pushViewController:streamVC animated:YES];
                            }
                            
                            break;
                        }
                        case 2: {
                            if (playerActive) {
                                playerScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerScreenVC"];
                                
                                playerScreenVC.isPlaylist = true;
                                playerScreenVC.cameFromMenu = true;
                                
                                //Push to controller
                                [self.navigationController pushViewController:playerScreenVC animated:YES];
                            }
                            
                            break;
                        }
                        case 3: {
                            ExploreVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreVC"];
                            
                            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                            
                            if (networkStatus == NotReachable) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                [alert show];
                            } else {
                                //Push to controller
                                [self.navigationController pushViewController:ExploreVC animated:YES];
                            }
                            
                            break;
                        }
                        case 4: {
                            UserNotifications *notificationsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserNotificationsVC"];
                            
                            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                            
                            if (networkStatus == NotReachable) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                [alert show];
                            } else {
                                //Push to controller
                                [self.navigationController pushViewController:notificationsVC animated:YES];
                            }
                            
                            break;
                        }
                        case 5: {
                            UserSettings *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSettings"];
                            
                            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                            
                            if (networkStatus == NotReachable) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                [alert show];
                            } else {
                                //Push to controller
                                [self.navigationController pushViewController:settingsVC animated:YES];
                            }
                            
                            break;
                        }
                        case 7: {
                            ReportAProblem *reportAProblemVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportAProblemVC"];
                            
                            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                            
                            if (networkStatus == NotReachable) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                                [alert show];
                            } else {
                                //Push to controller
                                [self.navigationController pushViewController:reportAProblemVC animated:YES];
                            }
                            
                            break;
                        }
                        case 8: {
                            
                            
                            double user_id = sessionUserID;
                            double session_id = sessionID;
                            //NSString *device_token = sharedManager.userDeviceToken;
                            
                            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:user_id];
                            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:session_id];
                            
                            NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                            tempSessionUserID, @"user_id",
                                                            tempSessionID, @"session_id",
                                                            nil];
                            
                            NSError *error;
                            
                            //convert object to data
                            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                            
                            NSMutableURLRequest *request = [ NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://api.yapster.co/api/0.0.1/users/sign_out/"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60.0];
                            
                            [request setHTTPMethod:@"POST"];
                            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                            [request setHTTPBody:jsonData];
                            
                            if (!jsonData) {
                                DLog(@"JSON error: %@", error);
                            } else {
                                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                                DLog(@"JSON OUTPUT: %@", JSONString);
                                
                            }
                            
                            connection8 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            
                            [connection8 start];
                            
                            if (connection8) {
                                self.view.userInteractionEnabled = NO;
                                
                                sessionUserID = 0;
                                sessionID = 0;
                                sessionEmail = nil;
                                sessionUsername = nil;
                                sessionFirstName = nil;
                                sessionLastName = nil;
                                sessionPassword = nil;
                                sessionPhone = nil;
                            }
                            else {
                                //Error
                            }
                        }
                    }
                    break;
            }
    }
    else if (tableView == theTable) {
        int row = indexPath.row;
        
        playerScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerScreenVC"];
        
        Feed *userFeedData = [userFeed objectAtIndex:row];
        
        NSString *dateString;
        
        dateString = [NSString stringWithFormat:@"%@", userFeedData.yap_date_created];
        
        if ([dateString rangeOfString:@"T"].location != NSNotFound) {
            dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        }
        
        if ([dateString rangeOfString:@"."].location != NSNotFound) {
            NSRange range = [dateString rangeOfString:@"."];
            
            dateString = [dateString substringToIndex:range.location];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //// here set format of date which is in your output date (means above str with format)
        
        NSDate *date = [dateFormatter dateFromString: dateString]; // here you can fetch date from string with define format
        
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        //NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setTimeZone:sourceTimeZone];
        
        NSDate* sourceDate = [NSDate date];
        
        NSString *timeStamp = [formatter stringFromDate:sourceDate];
        
        NSDate *destinationDateToday = [formatter dateFromString:timeStamp];
        
        NSDate *destinationDatePost = [formatter dateFromString:dateString];
        
        NSString *dateStringToday = [formatter stringFromDate:destinationDateToday];
        NSString *dateStringThen =  [formatter stringFromDate:destinationDatePost];
        
        NSDate *startDate = [formatter dateFromString:dateStringThen];
        NSDate *endDate = [formatter dateFromString:dateStringToday];
        
        NSDateComponents *minutesComponent = [[NSCalendar currentCalendar]
                                              components:NSMinuteCalendarUnit
                                              fromDate:startDate
                                              toDate:endDate
                                              options:0];
        NSDateComponents *hoursComponent = [[NSCalendar currentCalendar]
                                            components:NSHourCalendarUnit
                                            fromDate:startDate
                                            toDate:endDate
                                            options:0];
        NSDateComponents *daysComponent = [[NSCalendar currentCalendar]
                                           components:NSDayCalendarUnit
                                           fromDate:startDate
                                           toDate:endDate
                                           options:0];
        
        
        long timeDiffMins = [minutesComponent minute];
        long timeDiffHours = [hoursComponent hour];
        long timeDiffDays = [daysComponent day];
        
        NSString *convertedString;
        
        if (timeDiffDays >= 1) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"M/d/yyyy"];// here set format which you want...
            
            convertedString = [dateFormatter stringFromDate:date];
        }
        else if (timeDiffHours >= 1 && timeDiffDays < 1) {
            if (timeDiffHours > 1) {
                convertedString = [NSString stringWithFormat:@"%li hrs ago", timeDiffHours];
            }
            else if (timeDiffHours == 1) {
                convertedString = [NSString stringWithFormat:@"%li hr ago", timeDiffHours];
            }
        }
        else if (timeDiffMins >= 1 && timeDiffHours < 1) {
            if (timeDiffMins > 1) {
                convertedString = [NSString stringWithFormat:@"%li mins ago", timeDiffMins];
            }
            else if (timeDiffMins == 1) {
                convertedString = [NSString stringWithFormat:@"%li min ago", timeDiffMins];
            }
        }
        else if (timeDiffMins < 1) {
            convertedString = @"Just now";
        }
        
        playerScreenVC.yap_to_play = userFeedData.yap_id;
        
        if ([userFeedData.reyap_user isEqualToString:@""]) {
            playerScreenVC.object_type = @"yap";
            playerScreenVC.reyap_username_value = @"";
        }
        else {
            playerScreenVC.object_type = @"reyap";
            playerScreenVC.isReyap = YES;
            playerScreenVC.reyap_username_value = [NSString stringWithFormat:@"%@", userFeedData.reyap_user];
            playerScreenVC.reyap_user_id = userFeedData.reyap_user_id;
            playerScreenVC.reyap_id = userFeedData.reyap_id;
        }
        
        if (userFeedData.liked_by_viewer) {
            playerScreenVC.likedByViewer = YES;
        }
        
        playerScreenVC.cameFrom = @"user_profile";
        playerScreenVC.reyappedByViewer = userFeedData.reyapped_by_viewer;
        playerScreenVC.user_id = userFeedData.user_id;
        playerScreenVC.yap_audio_path = userFeedData.audio_path;
        playerScreenVC.yap_picture_flag = userFeedData.picture_flag;
        playerScreenVC.yap_picture_path = userFeedData.picture_path;
        playerScreenVC.yap_picture_cropped_flag = userFeedData.picture_cropped_flag;
        playerScreenVC.yap_picture_cropped_path = userFeedData.picture_cropped_path;
        
        if (![userFeedData.profile_cropped_picture_path isEqualToString:@""]) {
            playerScreenVC.user_profile_picture_cropped_path = userFeedData.profile_cropped_picture_path;
        }
        else {
            playerScreenVC.user_profile_picture_cropped_path = @"";
        }
        
        playerScreenVC.web_link_flag = userFeedData.web_link_flag;
        playerScreenVC.web_link = userFeedData.web_link;
        playerScreenVC.name_value = [NSString stringWithFormat:@"%@ %@", userFeedData.first_name, userFeedData.last_name];
        playerScreenVC.username_value = [NSString stringWithFormat:@"%@", userFeedData.username];
        playerScreenVC.yap_title_value = [NSString stringWithFormat:@"%@", userFeedData.title];
        playerScreenVC.hashtags_flag = userFeedData.hashtags_flag;
        playerScreenVC.hashtags_array = userFeedData.hashtags;
        playerScreenVC.user_tags_flag = userFeedData.user_tags_flag;
        playerScreenVC.userstag_array = userFeedData.user_tags;
        playerScreenVC.yap_date_value = convertedString;
        playerScreenVC.yap_plays_value = userFeedData.listen_count+1;
        playerScreenVC.yap_reyaps_value = userFeedData.reyap_count;
        playerScreenVC.yap_likes_value = userFeedData.like_count;
        playerScreenVC.yap_length_value = [userFeedData.yap_length intValue];
        
        playerScreenVC.isSingleYap = true;
        
        //Push to controller
        [self.navigationController pushViewController:playerScreenVC animated:YES];
    }
}

- (NSArray *)rightButtonForReport
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    /*[rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];*/
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0]
                                                title:@"Report"];
    
    return rightUtilityButtons;
}

- (NSArray *)rightButtonForDelete
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    /*[rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];*/
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    current_cell = cell;
    
    if (cell.tag == 1) {
        /*if (index == 0) {
         NSArray *itemsToShare;
         
         NSMutableString *textToShare;
         NSURL *URLToShare;
         
         NSIndexPath *pathOfTheCell = [theTable indexPathForCell:current_cell];
         NSInteger rowOfTheCell = [pathOfTheCell row];
         
         Feed *userFeedData = [userFeed objectAtIndex:rowOfTheCell];
         
         NSString *yap_title = userFeedData.title;
         NSArray *hashtags = userFeedData.hashtags;
         NSArray *usertags = userFeedData.user_tags;
         
         textToShare = [NSMutableString stringWithFormat:@"%@ ", yap_title];
         
         if (userFeedData.hashtags_flag) {
         for (int i = 0; i < hashtags.count; i ++) {
         NSString *hashtag_name = [[hashtags objectAtIndex:i] valueForKey:@"hashtag_name"];
         
         [textToShare appendString:[NSString stringWithFormat:@"#%@ ", hashtag_name]];
         }
         }
         
         if (userFeedData.user_tags_flag) {
         for (int i = 0; i < usertags.count; i ++) {
         NSString *user_name = [[usertags objectAtIndex:i] valueForKey:@"username"];
         
         [textToShare appendString:[NSString stringWithFormat:@"@%@ ", user_name]];
         }
         }
         
         NSString *bucket = @"yapsterapp";
         NSString *audio_path = userFeedData.audio_path;
         
         S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
         override.contentType = @"audio/mpeg";
         
         //get yap audio
         S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
         gpsur.key     = audio_path;
         gpsur.bucket  = bucket;
         gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
         gpsur.responseHeaderOverrides = override;
         
         NSString *url = [[[AmazonClientManager s3] getPreSignedURL:gpsur] absoluteString];
         
         URLToShare = [NSURL URLWithString:url];
         
         NSString *big_photo_path;
         UIImage *big_photo;
         
         if (userFeedData.picture_flag) {
         big_photo_path = userFeedData.picture_path;
         
         S3GetPreSignedURLRequest *gpsur_big_photo = [[S3GetPreSignedURLRequest alloc] init];
         gpsur_big_photo.key     = big_photo_path;
         gpsur_big_photo.bucket  = bucket;
         gpsur_big_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
         gpsur_big_photo.responseHeaderOverrides = override;
         
         NSURL *url_big_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_big_photo];
         
         NSData *data_big_photo = [NSData dataWithContentsOfURL:url_big_photo];
         
         big_photo = [UIImage imageWithData:data_big_photo];
         
         itemsToShare =  @[textToShare, big_photo, URLToShare];
         }
         else {
         itemsToShare =  @[textToShare, URLToShare];
         }
         
         UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
         activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypeAddToReadingList];
         [self presentViewController:activityVC animated:YES completion:nil];
         }*/
        
        if (index == 0) {
            [self confirmDelete];
        }
    }
    else if (cell.tag == 2) {
        /*if (index == 0) {
         NSArray *itemsToShare;
         
         NSMutableString *textToShare;
         NSURL *URLToShare;
         
         NSIndexPath *pathOfTheCell = [theTable indexPathForCell:current_cell];
         NSInteger rowOfTheCell = [pathOfTheCell row];
         
         Feed *userFeedData = [userFeed objectAtIndex:rowOfTheCell];
         
         NSString *yap_title = userFeedData.title;
         NSArray *hashtags = userFeedData.hashtags;
         NSArray *usertags = userFeedData.user_tags;
         
         textToShare = [NSMutableString stringWithFormat:@"%@ ", yap_title];
         
         if (userFeedData.hashtags_flag) {
         for (int i = 0; i < hashtags.count; i ++) {
         NSString *hashtag_name = [[hashtags objectAtIndex:i] valueForKey:@"hashtag_name"];
         
         [textToShare appendString:[NSString stringWithFormat:@"#%@ ", hashtag_name]];
         }
         }
         
         if (userFeedData.user_tags_flag) {
         for (int i = 0; i < usertags.count; i ++) {
         NSString *user_name = [[usertags objectAtIndex:i] valueForKey:@"username"];
         
         [textToShare appendString:[NSString stringWithFormat:@"@%@ ", user_name]];
         }
         }
         
         NSString *bucket = @"yapsterapp";
         NSString *audio_path = userFeedData.audio_path;
         
         S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
         override.contentType = @"audio/mpeg";
         
         //get yap audio
         S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
         gpsur.key     = audio_path;
         gpsur.bucket  = bucket;
         gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
         gpsur.responseHeaderOverrides = override;
         
         NSString *url = [[[AmazonClientManager s3] getPreSignedURL:gpsur] absoluteString];
         
         URLToShare = [NSURL URLWithString:url];
         
         NSString *big_photo_path;
         UIImage *big_photo;
         
         if (userFeedData.picture_flag) {
         big_photo_path = userFeedData.picture_path;
         
         S3GetPreSignedURLRequest *gpsur_big_photo = [[S3GetPreSignedURLRequest alloc] init];
         gpsur_big_photo.key     = big_photo_path;
         gpsur_big_photo.bucket  = bucket;
         gpsur_big_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
         gpsur_big_photo.responseHeaderOverrides = override;
         
         NSURL *url_big_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_big_photo];
         
         NSData *data_big_photo = [NSData dataWithContentsOfURL:url_big_photo];
         
         big_photo = [UIImage imageWithData:data_big_photo];
         
         itemsToShare =  @[textToShare, big_photo, URLToShare];
         }
         else {
         itemsToShare =  @[textToShare, URLToShare];
         }
         
         UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
         activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypeAddToReadingList];
         [self presentViewController:activityVC animated:YES completion:nil];
         }
         */
        
        if (index == 0) {
            [self confirmReport];
        }
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            return YES;
            break;
        case 2:
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


-(void)expand
{
    [UIView animateWithDuration:0.0
                     animations:^{
                         //theTable.frame = self.view.bounds;
                         
                         menu_btn.hidden = NO;
                         yap_btn.hidden = NO;
                         
                         topNav.frame = CGRectMake(topNav.frame.origin.x,
                                                   0,
                                                   topNav.frame.size.width,
                                                   topNav.frame.size.height);
                         
                         scrollView1.frame = CGRectMake(scrollView1.frame.origin.x,
                                                        0,
                                                        scrollView1.frame.size.width,
                                                        scrollView1.frame.size.height);
                         
                         userMainInfoView.hidden = NO;
                         
                         loadingData.frame = CGRectMake(loadingData.frame.origin.x, 390, loadingData.frame.size.width, loadingData.frame.size.height);
                         message.frame = CGRectMake(message.frame.origin.x, 390, message.frame.size.width, message.frame.size.height);
                         
                         if ([userProfileDesc isEqualToString:@""]) {
                             segmentController.frame = CGRectMake(segmentController.frame.origin.x,
                                                              190,
                                                              segmentController.frame.size.width,
                                                              segmentController.frame.size.height);
                             
                             userInfoView.frame = CGRectMake(userInfoView.frame.origin.x,
                                                             topNav.frame.size.height,
                                                             userInfoView.frame.size.width,
                                                             260);
                             
                             theTable.frame = CGRectMake(self.view.bounds.origin.x, 295, self.view.bounds.size.width, self.view.bounds.size.height-280);
                         }
                         else {
                             segmentController.frame = CGRectMake(segmentController.frame.origin.x,
                                                                  240,
                                                                  segmentController.frame.size.width,
                                                                  segmentController.frame.size.height);
                             
                             userInfoView.frame = CGRectMake(userInfoView.frame.origin.x,
                                                             topNav.frame.size.height,
                                                             userInfoView.frame.size.width,
                                                             280);
                             
                             theTable.frame = CGRectMake(self.view.bounds.origin.x, 335, self.view.bounds.size.width, self.view.bounds.size.height-180);
                         }
                         
                         
                         
                         
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    DLog(@"expand");
}

-(void)contract
{
    [UIView animateWithDuration:0.0
                     animations:^{
                         //theTable.frame = self.view.bounds;
                         
                         menu_btn.hidden = YES;
                         yap_btn.hidden = YES;
                         
                         topNav.frame = CGRectMake(topNav.frame.origin.x,
                                                        -40,
                                                        topNav.frame.size.width,
                                                        topNav.frame.size.height);
                         
                         
                         userInfoView.frame = CGRectMake(userInfoView.frame.origin.x,
                                                         topNav.frame.size.height-40,
                                                         userInfoView.frame.size.width,
                                                         scrollView1.frame.size.height+segmentController.frame.size.height);
                         
                         scrollView1.frame = CGRectMake(scrollView1.frame.origin.x,
                                                   0,
                                                   scrollView1.frame.size.width,
                                                   scrollView1.frame.size.height);
                         
                         userMainInfoView.hidden = YES;
                         
                         segmentController.frame = CGRectMake(segmentController.frame.origin.x,
                                                        scrollView1.frame.origin.y+scrollView1.frame.size.height,
                                                        segmentController.frame.size.width,
                                                        segmentController.frame.size.height);
                       
                         loadingData.frame = CGRectMake(loadingData.frame.origin.x, 180, loadingData.frame.size.width, loadingData.frame.size.height);
                         message.frame = CGRectMake(message.frame.origin.x, 220, message.frame.size.width, message.frame.size.height);
                         
                         theTable.frame = CGRectMake(self.view.bounds.origin.x, scrollView1.frame.size.height+segmentController.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-90);
                         
                     }
                     completion:^(BOOL finished) {
                         /*topNav.frame = CGRectMake(topNav.frame.origin.x,
                                                   topNav.frame.origin.y-40,
                                                   topNav.frame.size.width,
                                                   topNav.frame.size.height);*/
                     }];
    
    DLog(@"contract");
}

//load more rows as user scrolls to bottom of table
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if (aScrollView == mainScrollView) {
        CGPoint offset = aScrollView.contentOffset;
        CGRect bounds = aScrollView.bounds;
        CGSize size = aScrollView.contentSize;
        UIEdgeInsets inset = aScrollView.contentInset;
        //float y = offset.y + ((bounds.size.height - inset.bottom));
        //float h = size.height-150;
        
        float y_offset = offset.y;
        
        if (searchBoxVisible) {
            [searchBox resignFirstResponder];
        }
        
        //DLog(@"%f", y_offset);
        
        double max_value = 0;
        
        if ([userProfileDesc isEqualToString:@""]) {
            max_value = 163;
        }
        else {
            max_value = (description_label.frame.origin.y+description_label.frame.size.height+scrollView1.frame.size.height)-11;
        }
        
        //animate top navigation bars
        if (y_offset >= 41) {
            
            //userInfoView.backgroundColor = [UIColor redColor];
            
            if (cameFromMenu) {
                menu_btn.hidden = YES;
            }
            else {
                back_btn.hidden = YES;
            }
            
            nav_title_label.hidden = YES;
            
            yap_btn.hidden = YES;
            
            topNav.frame = CGRectMake(topNav.frame.origin.x,
                                      y_offset-40,
                                      topNav.frame.size.width,
                                      topNav.frame.size.height);
            
            userInfoView.frame = CGRectMake(userInfoView.frame.origin.x,
                                            y_offset+(topNav.frame.size.height-40),
                                            userInfoView.frame.size.width,
                                            userInfoView.frame.size.height);
            
            scrollView1.frame = CGRectMake(scrollView1.frame.origin.x,
                                           0,
                                           scrollView1.frame.size.width,
                                           scrollView1.frame.size.height);
            
            userMainInfoView.frame = CGRectMake(userMainInfoView.frame.origin.x,
                                                65,
                                                userMainInfoView.frame.size.width,
                                                userMainInfoView.frame.size.height);
            
            if (y_offset >= max_value) {
                if (cameFromNotifications && [notification_name isEqualToString:@"follower_requested"] && !profile_user_following_user) {
                    acceptOrDenyView.frame = CGRectMake(acceptOrDenyView.frame.origin.x, y_offset+(topNav.frame.size.height-40)+scrollView1.frame.size.height, acceptOrDenyView.frame.size.width, acceptOrDenyView.frame.size.height);
                }
                else {
                    segmentControllerAndTableView.frame = CGRectMake(segmentControllerAndTableView.frame.origin.x, y_offset+(topNav.frame.size.height-40)+scrollView1.frame.size.height, segmentControllerAndTableView.frame.size.width, segmentControllerAndTableView.frame.size.height);
                }
                
                userInfoView.frame = CGRectMake(userInfoView.frame.origin.x,
                                                y_offset+(topNav.frame.size.height-40),
                                                userInfoView.frame.size.width,
                                                125);
                userMainInfoView.hidden = YES;
                
                [mainScrollView sendSubviewToBack:theTable];
                [theTable setNeedsDisplay];
                
                float bottomEdge = aScrollView.contentOffset.y + aScrollView.frame.size.height;
                
                if (bottomEdge >= aScrollView.contentSize.height-30) {
                    //postAmount += nextAmount;
                    
                    //build an info object and convert to json
                    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                    NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
                    NSNumber *tempPostAmount = [[NSNumber alloc] initWithInt:postAmount];
                    
                    if (isLoadingMorePosts == false) {
                        isLoadingMorePosts = true;
                        
                        if ([userFeed count] >= (numLoadedPosts-1)) {
                            DLog(@"loading...");
                            
                            //Notifications *userNotificationsData = [userFeed objectAtIndex:numLoadedPosts-1];
                            
                            NSNumber *tempAfterYap = [[NSNumber alloc] initWithInt:after_yap];
                            NSNumber *tempAfterReyap = [[NSNumber alloc] initWithInt:after_reyap];
                            
                            //DLog(@"after: %@", json);
                            
                            NSDictionary *newDatasetInfo = [[NSDictionary alloc] init];
                            
                            if (segmentController.selectedSegmentIndex == 0) {
                                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  tempSessionUserID, @"user_id",
                                                  tempUserToView, @"profile_user_id",
                                                  tempSessionID, @"session_id",
                                                  tempPostAmount, @"amount",
                                                  @"posts", @"stream_type",
                                                  tempAfterYap, @"after_yap",
                                                  tempAfterReyap, @"after_reyap",
                                                  nil];
                                
                            }
                            else if (segmentController.selectedSegmentIndex == 1) {
                                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  tempSessionUserID, @"user_id",
                                                  tempUserToView, @"profile_user_id",
                                                  tempSessionID, @"session_id",
                                                  tempPostAmount, @"amount",
                                                  @"likes", @"stream_type",
                                                  tempAfterYap, @"after",
                                                  nil];
                            }
                            else if (segmentController.selectedSegmentIndex == 2) {
                                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  tempSessionUserID, @"user_id",
                                                  tempUserToView, @"profile_user_id",
                                                  tempSessionID, @"session_id",
                                                  tempPostAmount, @"amount",
                                                  @"listens", @"stream_type",
                                                  tempAfterYap, @"after",
                                                  nil];
                            }
                            
                            NSError *error;
                            
                            //convert object to data
                            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                            
                            NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
                            
                            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                            [request setURL:the_url];
                            [request setHTTPMethod:@"POST"];
                            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                            [request setHTTPBody:jsonData];
                            
                            NSHTTPURLResponse* urlResponse = nil;
                            
                            NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                            
                            if (segmentController.selectedSegmentIndex == 0) {
                                responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                            }
                            else if (segmentController.selectedSegmentIndex == 1) {
                                responseBodyLikes = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                            }
                            else if (segmentController.selectedSegmentIndex == 2) {
                                responseBodyListens = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                            }
                            
                            if (!jsonData) {
                                DLog(@"JSON error: %@", error);
                            }
                            else {
                                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                                DLog(@"JSON: %@", JSONString);
                            }
                            
                            connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            
                            [connection1 start];
                            
                            if (connection1) {
                                loadingData.hidden = YES;
                                
                                theTable.frame = CGRectMake(theTable.frame.origin.x, theTable.frame.origin.y-70, theTable.frame.size.width, theTable.frame.size.height);
                                mainScrollView.scrollEnabled = NO;
                                
                                [loadingMoreData startAnimating];
                                loadingMoreData.hidden = NO;
                            }
                            else {
                                //Error
                            }
                        }
                    }
                }
            }
            else {
                if ([userProfileDesc isEqualToString:@""]) {
                    if (cameFromNotifications && [notification_name isEqualToString:@"follower_requested"] && !profile_user_following_user) {
                        acceptOrDenyView.frame = CGRectMake(acceptOrDenyView.frame.origin.x, 252, acceptOrDenyView.frame.size.width, acceptOrDenyView.frame.size.height);
                    }
                    else {
                        segmentControllerAndTableView.frame = CGRectMake(segmentControllerAndTableView.frame.origin.x, 250, segmentControllerAndTableView.frame.size.width, segmentControllerAndTableView.frame.size.height);
                    }
                }
                else {
                    if (cameFromNotifications && [notification_name isEqualToString:@"follower_requested"] && !profile_user_following_user) {
                        acceptOrDenyView.frame = CGRectMake(acceptOrDenyView.frame.origin.x, (theTable.frame.origin.y-segmentControllerAndTableView.frame.size.height)+2, acceptOrDenyView.frame.size.width, acceptOrDenyView.frame.size.height);
                    }
                    else {
                        segmentControllerAndTableView.frame = CGRectMake(segmentControllerAndTableView.frame.origin.x, theTable.frame.origin.y-segmentControllerAndTableView.frame.size.height, segmentControllerAndTableView.frame.size.width, segmentControllerAndTableView.frame.size.height);
                    }
                }
                
                [mainScrollView bringSubviewToFront:theTable];
                [theTable setNeedsDisplay];
                
                if ([userProfileDesc isEqualToString:@""]) {
                    userInfoView.frame = CGRectMake(userInfoView.frame.origin.x, userInfoView.frame.origin.y, userInfoView.frame.size.width, 210);
                }
                else {
                    userInfoView.frame = CGRectMake(userInfoView.frame.origin.x, userInfoView.frame.origin.y, userInfoView.frame.size.width, 250);
                }
                
                userMainInfoView.hidden = NO;
            }
            
            navHidden = YES;
        }
        else {
            //theTable.scrollEnabled = NO;
            
            if (cameFromMenu) {
                menu_btn.hidden = NO;
            }
            else {
                back_btn.hidden = NO;
            }
            
            nav_title_label.hidden = NO;
            
            yap_btn.hidden = NO;
            
            topNav.frame = CGRectMake(topNav.frame.origin.x,
                                      0,
                                      topNav.frame.size.width,
                                      topNav.frame.size.height);
            
            userInfoView.frame = CGRectMake(userInfoView.frame.origin.x,
                                            64,
                                            userInfoView.frame.size.width,
                                            userInfoView.frame.size.height);
            
            scrollView1.frame = CGRectMake(scrollView1.frame.origin.x,
                                           0,
                                           scrollView1.frame.size.width,
                                           scrollView1.frame.size.height);
            
            userMainInfoView.frame = CGRectMake(userMainInfoView.frame.origin.x,
                                                65,
                                                userMainInfoView.frame.size.width,
                                                userMainInfoView.frame.size.height);
            
            if (y_offset == 0) {
                if ([userProfileDesc isEqualToString:@""]) {
                    if (cameFromNotifications && [notification_name isEqualToString:@"follower_requested"] && !profile_user_following_user) {
                        acceptOrDenyView.frame = CGRectMake(acceptOrDenyView.frame.origin.x, 252, acceptOrDenyView.frame.size.width, acceptOrDenyView.frame.size.height);
                    }
                    else {
                        segmentControllerAndTableView.frame = CGRectMake(segmentControllerAndTableView.frame.origin.x, 250, segmentControllerAndTableView.frame.size.width, segmentControllerAndTableView.frame.size.height);
                    }
                }
                else {
                    if (cameFromNotifications && [notification_name isEqualToString:@"follower_requested"] && !profile_user_following_user) {
                        acceptOrDenyView.frame = CGRectMake(acceptOrDenyView.frame.origin.x, desc_frame.origin.y+description_label.frame.size.height+12, acceptOrDenyView.frame.size.width, acceptOrDenyView.frame.size.height);
                    }
                    else {
                        DLog(@"desc_frame.origin.y %f", desc_frame.origin.y);
                        
                        segmentControllerAndTableView.frame = CGRectMake(segmentControllerAndTableView.frame.origin.x, desc_frame.origin.y+description_label.frame.size.height+10, segmentControllerAndTableView.frame.size.width, segmentControllerAndTableView.frame.size.height);
                    }
                }
            }
        }
    }
    else if (aScrollView == menuTable) {
        if (menuOpen) {
            [self animateLayerToPoint:VIEW_HIDDEN];
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 menuSearchBox.frame = CGRectMake(menuSearchBox.frame.origin.x, menuSearchBox.frame.origin.y, 220, menuSearchBox.frame.size.height);
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
            
            menuSearchCancelButton.hidden = YES;
            [menuSearchBox resignFirstResponder];
        }
    }
}

- (IBAction)panLayer:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self.topLayer];
        CGRect frame = self.topLayer.frame;
        frame.origin.x = self.layerPosition + point.x;
        
        if (frame.origin.x < 0) frame.origin.x = 0;
        
        self.topLayer.frame = frame;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.topLayer.frame.origin.x <= 160) {
            [self animateLayerToPoint:0];
            menuOpen = NO;
            mainScrollView.scrollEnabled = YES;
            theTable.userInteractionEnabled = YES;
            mainScrollView.scrollEnabled = YES;
            full_name_label.hidden = NO;
            username_label.hidden = NO;
            rightOptions.hidden = NO;
            scrollView1.scrollEnabled = YES;
            searchButton.enabled = YES;
            searchButton.alpha = 1.0;
        }
        else {
            [self animateLayerToPoint: VIEW_HIDDEN];
            menuOpen = YES;
            full_name_label.hidden = NO;
            username_label.hidden = NO;
            rightOptions.hidden = NO;
            mainScrollView.scrollEnabled = NO;
            [searchBox resignFirstResponder];
            theTable.userInteractionEnabled = NO;
            mainScrollView.scrollEnabled = NO;
            scrollView1.scrollEnabled = NO;
            searchBox.hidden = YES;
            cancelButton.hidden = YES;
            searchButton.hidden = NO;
            searchButton.enabled = NO;
            searchButton.alpha = 1.0;
            searchBoxVisible = NO;
        }
    }
}

-(void)animateLayerToPoint:(CGFloat) x {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         CGRect frame = self.topLayer.frame;
                         frame.origin.x = x;
                         self.topLayer.frame = frame;
                     } completion:^(BOOL finished) {
                         self.layerPosition = self.topLayer.frame.origin.x;
                     }];
}

-(IBAction)toggleMenu {
    if (!menuOpen) {
        [self animateLayerToPoint:VIEW_HIDDEN];
        menuOpen = YES;
        theTable.userInteractionEnabled = NO;
        mainScrollView.scrollEnabled = NO;
        [searchBox resignFirstResponder];
        [UIView animateWithDuration:0.3
                         animations:^{
                             menuSearchBox.frame = CGRectMake(menuSearchBox.frame.origin.x, menuSearchBox.frame.origin.y, 220, menuSearchBox.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        menuSearchCancelButton.hidden = YES;
        [menuSearchBox resignFirstResponder];
        searchBox.hidden = YES;
        scrollView1.scrollEnabled = NO;
        full_name_label.hidden = NO;
        username_label.hidden = NO;
        rightOptions.hidden = NO;
        cancelButton.hidden = YES;
        searchButton.hidden = NO;
        searchButton.enabled = NO;
        searchButton.alpha = 1.0;
        searchBoxVisible = NO;
    }
    else {
        [self animateLayerToPoint:0];
        menuOpen = NO;
        scrollView1.scrollEnabled = YES;
        full_name_label.hidden = NO;
        username_label.hidden = NO;
        rightOptions.hidden = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             menuSearchBox.frame = CGRectMake(menuSearchBox.frame.origin.x, menuSearchBox.frame.origin.y, 220, menuSearchBox.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        menuSearchCancelButton.hidden = YES;
        [menuSearchBox resignFirstResponder];
        theTable.userInteractionEnabled = YES;
        mainScrollView.scrollEnabled = YES;
        searchButton.enabled = YES;
        searchButton.alpha = 1.0;
    }
}


//search box toggling
-(IBAction)toggleSearchBox:(id)sender {
    if (!searchBoxVisible) {
        rightOptions.frame = CGRectMake(150, rightOptions.frame.origin.y, rightOptions.frame.size.width, rightOptions.frame.size.height);
        
        searchButton.hidden = YES;
        full_name_label.hidden = YES;
        username_label.hidden = YES;
        
        searchBox.text = @"";
        
        [searchBox becomeFirstResponder];
        
        searchBox.hidden = NO;
        cancelButton.hidden = NO;
        
        searchBoxVisible = YES;
    }
    else {
        if ([searchBox.text isEqualToString:@""]) {
            rightOptions.frame = rightOptions_original_position;
            
            cancelButton.hidden = YES;
            searchButton.hidden = NO;
            searchBox.hidden = YES;
            
            [searchBox resignFirstResponder];
            searchBoxVisible = NO;
            full_name_label.hidden = NO;
            username_label.hidden = NO;
            
            if (isSearch) {
                isSearch = NO;
                isSearch2 = NO;
                
                Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                
                if (segmentController.selectedSegmentIndex == 0) {
                    if (networkStatus == NotReachable) {
                        
                    }
                    else {
                    
                        //build an info object and convert to json
                        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                        NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
                        NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
                        
                        NSError *error;
                        
                        //call stream
                        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                        tempSessionUserID, @"user_id",
                                                        tempSessionID, @"session_id",
                                                        tempUserToView, @"profile_user_id",
                                                        tempPostAmount, @"amount",
                                                        @"posts", @"stream_type",
                                                        nil];
                        
                        
                        
                        //convert object to data
                        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                        
                        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
                        
                        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                        [request setURL:the_url];
                        [request setHTTPMethod:@"POST"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [request setHTTPBody:jsonData];
                        
                        NSHTTPURLResponse* urlResponse = nil;
                        
                        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                        
                        responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                        
                        //int responseCode = [urlResponse statusCode];
                        
                        if (!jsonData) {
                            DLog(@"JSON error: %@", error);
                        }
                        else {
                            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                            DLog(@"JSON: %@", JSONString);
                        }
                        
                        connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                        
                        [connection1 start];
                        
                        if (connection1) {
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                            
                            message.hidden = YES;
                            // terminate all pending download connections
                            NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                            [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                            
                            [self.imageDownloadsInProgress removeAllObjects];
                            
                            userFeed = [[NSMutableArray alloc] init];
                            self.workingArray = [NSMutableArray array];
                            [self.workingArray removeAllObjects];
                            user_photo_entries = [NSMutableArray array];
                            [user_photo_entries removeAllObjects];
                            
                            numLoadedPosts = 0;
                            [self.theTable reloadData];
                            [self.theTable setContentOffset:CGPointZero animated:NO];
                            mainScrollView.scrollEnabled = NO;
                            
                            loadingData2.hidden = NO;
                            
                            [loadingData2 startAnimating];
                        }
                        else {
                            //Error
                        }
                    }
                }
                else if (segmentController.selectedSegmentIndex == 1) {
                    if (networkStatus == NotReachable) {
                        
                    }
                    else {
                        
                        //build an info object and convert to json
                        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                        NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
                        NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
                        
                        NSError *error;
                        
                        //call stream
                        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                        tempSessionUserID, @"user_id",
                                                        tempSessionID, @"session_id",
                                                        tempUserToView, @"profile_user_id",
                                                        tempPostAmount, @"amount",
                                                        @"likes", @"stream_type",
                                                        nil];
                        
                        
                        
                        //convert object to data
                        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                        
                        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
                        
                        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                        [request setURL:the_url];
                        [request setHTTPMethod:@"POST"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [request setHTTPBody:jsonData];
                        
                        NSHTTPURLResponse* urlResponse = nil;
                        
                        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                        
                        responseBodyLikes = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                        
                        //int responseCode = [urlResponse statusCode];
                        
                        if (!jsonData) {
                            DLog(@"JSON error: %@", error);
                        }
                        
                        connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                        
                        [connection1 start];
                        
                        if (connection1) {
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                            
                            message.hidden = YES;
                            // terminate all pending download connections
                            NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                            [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                            
                            [self.imageDownloadsInProgress removeAllObjects];
                            
                            userFeed = [[NSMutableArray alloc] init];
                            self.workingArray = [NSMutableArray array];
                            [self.workingArray removeAllObjects];
                            user_photo_entries = [NSMutableArray array];
                            [user_photo_entries removeAllObjects];
                            
                            numLoadedPosts = 0;
                            [self.theTable reloadData];
                            [self.theTable setContentOffset:CGPointZero animated:NO];
                            mainScrollView.scrollEnabled = NO;
                            
                            loadingData2.hidden = NO;
                            
                            [loadingData2 startAnimating];
                        }
                        else {
                            //Error
                        }
                    }
                }
                else if (segmentController.selectedSegmentIndex == 2) {
                    if (!userListensArePrivate || (userToView == sessionUserID)) {
                        if (networkStatus == NotReachable) {
                            
                        }
                        else {

                            //build an info object and convert to json
                            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                            NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:userToView];
                            NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
                            
                            NSError *error;
                            
                            //call stream
                            NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                            tempSessionUserID, @"user_id",
                                                            tempSessionID, @"session_id",
                                                            tempUserToView, @"profile_user_id",
                                                            tempPostAmount, @"amount",
                                                            @"listens", @"stream_type",
                                                            nil];
                            
                            
                            
                            //convert object to data
                            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                            
                            NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/stream/"];
                            
                            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                            [request setURL:the_url];
                            [request setHTTPMethod:@"POST"];
                            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                            [request setHTTPBody:jsonData];
                            
                            NSHTTPURLResponse* urlResponse = nil;
                            
                            NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                            
                            responseBodyListens = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                            
                            //int responseCode = [urlResponse statusCode];
                            
                            if (!jsonData) {
                                DLog(@"JSON error: %@", error);
                            }
                            
                            connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            
                            [connection1 start];
                            
                            if (connection1) {
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                                
                                message.hidden = YES;
                                // terminate all pending download connections
                                NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
                                [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
                                
                                [self.imageDownloadsInProgress removeAllObjects];
                                
                                userFeed = [[NSMutableArray alloc] init];
                                self.workingArray = [NSMutableArray array];
                                [self.workingArray removeAllObjects];
                                user_photo_entries = [NSMutableArray array];
                                [user_photo_entries removeAllObjects];
                                
                                numLoadedPosts = 0;
                                [self.theTable reloadData];
                                [self.theTable setContentOffset:CGPointZero animated:NO];
                                mainScrollView.scrollEnabled = NO;
                                
                                loadingData2.hidden = NO;
                                
                                [loadingData2 startAnimating];
                            }
                            else {
                                //Error
                            }
                        }
                    }
                }
            }
        }
        else {
            searchBox.text = @"";
        }
    }
}

#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(AppPhotoRecord *)photoRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.photoRecord = photoRecord;
        [iconDownloader setCompletionHandler:^{
            
            StreamCell *cell = (StreamCell *)[self.theTable cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            [cell.btnUserPhoto setBackgroundImage:photoRecord.actualPhoto forState:UIControlStateNormal];
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if ([self.user_photo_entries count] > 0)
    {
        NSArray *visiblePaths = [self.theTable indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            AppPhotoRecord *photoRecord = [self.user_photo_entries objectAtIndex:indexPath.row];
            
            if (!photoRecord.actualPhoto)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:photoRecord forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

@end