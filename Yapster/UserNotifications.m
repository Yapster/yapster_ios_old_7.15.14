//
//  UserNotifications.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/9/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "UserNotifications.h"
#import "UserSettings.h"
#import "Stream.h"
#import "SearchResults.h"
#import "AppPhotoRecord.h"
#import "IconDownloader.h"

@interface UserNotifications ()

@end

@implementation UserNotifications

@synthesize refreshControl;
@synthesize menuOpen;
@synthesize searchBoxVisible;
@synthesize isLoadingMorePosts;
@synthesize last_object_id;
@synthesize userFeedObject;
@synthesize streamCell;
@synthesize theTable;
@synthesize menuTable;
@synthesize menuKeys;
@synthesize menuItems;
@synthesize UserSettingsVC;
@synthesize userFeed;
@synthesize yapsInfo;
@synthesize ReportAProblemVC;
@synthesize playerScreenVC;
@synthesize playlistVC;
@synthesize sharedManager;
@synthesize createYapVC;
@synthesize ExploreVC;
@synthesize UserProfileVC;
@synthesize searchResultsVC;
@synthesize menuSearchCancelButton;
@synthesize menuSearchBox;
@synthesize timer;
@synthesize noMorePostsMessage;
@synthesize topLayer;
@synthesize layerPosition;
@synthesize json;
@synthesize responseBody;
@synthesize searchButton;
@synthesize cancelButton;
@synthesize searchBox;
@synthesize connection1;
@synthesize connection2;
@synthesize connection3;
@synthesize connection4;
@synthesize connection5;
@synthesize connection6;
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
    
    sharedManager = [MyManager sharedManager];
    
    records = [NSMutableArray array];
    
    photos = [[NSMutableArray alloc] init];
    
    yapsInfo = [[NSMutableArray alloc] init];
    
    self.workingArray = [NSMutableArray array];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.theTable;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshNotifications) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.bounds = CGRectMake(0, 30, 20, 20);
    tableViewController.refreshControl = self.refreshControl;
	
    theTable.scrollEnabled = YES;
    
    theTable.contentInset = UIEdgeInsetsMake(-35, 0, 5, 0);
    
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        theTable.frame = CGRectMake(theTable.frame.origin.x, theTable.frame.origin.y, theTable.frame.size.width, 390);
    }
    else {
        theTable.frame = CGRectMake(theTable.frame.origin.x, theTable.frame.origin.y, theTable.frame.size.width, 478);
    }
    
    userFeed = [[NSMutableArray alloc] init];
    
    postAmount = 15; //default, inital
    nextAmount = 5; //next amount
    numLoadedPosts = 0;
    
    menuSearchBox.delegate = self;
    
    menuSearchBox.backgroundColor = [UIColor clearColor];
    menuSearchBox.layer.masksToBounds=YES;
    menuSearchBox.layer.borderColor=[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.7f].CGColor;
    menuSearchBox.layer.borderWidth= 1.0f;
    
    UIColor *color = [UIColor whiteColor];
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
        
        if (networkStatus == NotReachable) {
            
        }
        else {
            [self refreshNotifications];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (userFeed.count == 0) {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if (networkStatus == NotReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not load notifications." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        else {
            //build an info object and convert to json
            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
            NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
            
            NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            tempSessionUserID, @"user_id",
                                            tempSessionID, @"session_id",
                                            tempPostAmount, @"amount",
                                            nil];
            
            NSError *error;
            
            //convert object to data
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/notification/all/load/"];
            
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
                
            }
            else {
                //Error
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

-(void)refreshNotifications {
    theTable.userInteractionEnabled = NO;
    
    isRefresh = true;
    
    if (!btn_ViewToday.userInteractionEnabled) {
        [self viewToday:self];
    }
    else if (!btn_ViewMissed.userInteractionEnabled) {
        [self viewMissed:self];
    }
}

-(IBAction)goToUserProfile:(id)sender {
    UIButton *button = sender;
    int user_id = button.tag;
    
    UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
    
    UserProfileVC.userToView = user_id;
    
    //Push to controller
    [self.navigationController pushViewController:UserProfileVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == menuSearchBox) {
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

-(IBAction)viewToday:(id)sender {
    [self performSelectorOnMainThread:@selector(viewTodayBackgroundJob) withObject:nil waitUntilDone:NO];
}

-(IBAction)viewMissed:(id)sender {
    [self performSelectorOnMainThread:@selector(viewMissedBackgroundJob) withObject:nil waitUntilDone:NO];
}

-(void)viewTodayBackgroundJob {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not load notifications." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        [connection1 cancel];
        [connection2 cancel];
        [connection3 cancel];
        [connection4 cancel];
        [connection5 cancel];
        [connection6 cancel];
        
        // terminate all pending download connections
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
        
        [self.imageDownloadsInProgress removeAllObjects];
        
        message.hidden = YES;
        
        [loadingData stopAnimating];
        loadingData.hidden = YES;
        
        [btn_ViewMissed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_ViewMissed setFont:[UIFont fontWithName:@"Helvetica-Neue" size:17]];
        btn_ViewMissed.userInteractionEnabled = YES;
        [btn_ViewToday setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [btn_ViewToday setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        btn_ViewToday.userInteractionEnabled = NO;
        
        //build an info object and convert to json
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        tempPostAmount, @"amount",
                                        nil];
        
        __block NSError *error;
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/notification/all/load/"];
        
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
                
                connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                [connection1 start];
                
                if (connection1) {
                    if (refreshControl.isRefreshing) {
                        [refreshControl endRefreshing];
                    }
                    
                    isLoadingMorePosts = false;
                    
                    if (!isRefresh) {
                        userFeed = [[NSMutableArray alloc] init];
                        self.workingArray = [NSMutableArray array];
                        [self.workingArray removeAllObjects];
                        numLoadedPosts = 0;
                        
                        [self.theTable reloadData];
                        [self.theTable setContentOffset:CGPointZero animated:NO];
                        
                        loadingData.hidden = NO;
                        [loadingData startAnimating];
                        
                        theTable.hidden = YES;
                    }
                }
                else {
                    //Error
                }
            });
        });
    }
}

-(void)viewMissedBackgroundJob {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not load notifications." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        [connection1 cancel];
        [connection2 cancel];
        [connection3 cancel];
        [connection4 cancel];
        [connection5 cancel];
        [connection6 cancel];
        
        // terminate all pending download connections
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
        
        [self.imageDownloadsInProgress removeAllObjects];
        
        message.hidden = YES;
        
        [loadingData stopAnimating];
        loadingData.hidden = YES;
        
        [btn_ViewToday setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_ViewToday setFont:[UIFont fontWithName:@"Helvetica-Neue" size:17]];
        [btn_ViewMissed setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [btn_ViewMissed setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        btn_ViewMissed.userInteractionEnabled = NO;
        btn_ViewToday.userInteractionEnabled = YES;
        
        //build an info object and convert to json
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        tempPostAmount, @"amount",
                                        nil];
        
        __block NSError *error;
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/notification/unread/load/"];
        
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
                
                connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                [connection1 start];
                
                if (connection1) {
                    if (refreshControl.isRefreshing) {
                        [refreshControl endRefreshing];
                    }
                    
                    isLoadingMorePosts = false;
                    
                    if (!isRefresh) {
                        userFeed = [[NSMutableArray alloc] init];
                        self.workingArray = [NSMutableArray array];
                        [self.workingArray removeAllObjects];
                        numLoadedPosts = 0;
                        
                        [self.theTable reloadData];
                        [self.theTable setContentOffset:CGPointZero animated:NO];
                        
                        loadingData.hidden = NO;
                        [loadingData startAnimating];
                        
                        theTable.hidden = YES;
                    }
                }
                else {
                    //Error
                }
            });
        });
    }
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection1) {
        if (refreshControl.isRefreshing || cameFromPlayerScreen || isRefresh) {
            self.workingArray = [NSMutableArray array];
            [self.workingArray removeAllObjects];
            
            numLoadedPosts = 0;
            userFeed = [[NSMutableArray alloc] init];
            
            isRefresh = false;
            cameFromPlayerScreen = false;
        }
        
        NSData *data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
        
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //DLog(@"%@", json);
        
        NSDictionary *notification_type;
        NSDictionary *notification_info;
        NSDictionary *created_yap_info;
        NSDictionary *created_like_info;
        NSDictionary *created_listen_info;
        NSDictionary *acting_user_dictionary;
        
        if (json.count > 0) {
            message.hidden = YES;
            
            NSMutableArray *read_notifications = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < json.count; i++) {
                notification_type = [[json objectAtIndex:i] objectForKey:@"notification_type"];
                notification_info = [[json objectAtIndex:i] objectForKey:@"notification_info"];
                
                NSString *notification_name = [notification_type objectForKey:@"notification_name"];
                
                NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                NSString *trimmedNotificationName = [notification_name stringByTrimmingCharactersInSet:whitespace];
                
                NSUInteger trimmedNotificationNameLength = [trimmedNotificationName length];
                
                if (trimmedNotificationNameLength > 0) {
                    int reyap_count = 0;
                    int like_count = 0;
                    int listen_count = 0;
                    BOOL created_reyap_flag = false;
                    BOOL created_like_flag = false;
                    BOOL created_listen_flag = false;
                    BOOL user_read_flag = [[notification_info objectForKey:@"user_read_flag"] boolValue];
                    BOOL is_users_yap = true;
                    BOOL reyap_flag;
                    
                    NSDictionary *yap_info;
                    NSDictionary *notification_created_info = [[json objectAtIndex:i] objectForKey:@"notification_created_info"];
                    NSDictionary *channel;
                    
                    if ([notification_name isEqualToString:@"reyap_created"]) {
                        created_yap_info = [notification_info objectForKey:@"created_reyap"];
                        
                        created_reyap_flag = [[notification_info objectForKey:@"created_reyap_flag"] boolValue];
                        
                        reyap_flag = [[created_yap_info objectForKey:@"reyap_flag"] boolValue];
                        
                        if (reyap_flag) {
                            is_users_yap = false;
                            
                            yap_info = [created_yap_info objectForKey:@"reyap_reyap"];
                            yap_info = [yap_info objectForKey:@"yap"];
                        }
                        else {
                            yap_info = [created_yap_info objectForKey:@"yap"];
                        }
                        
                        if (created_reyap_flag) {
                            reyap_count = [[yap_info objectForKey:@"reyap_count"] intValue];
                        }
                    }
                    
                    if ([notification_name isEqualToString:@"like_created"]) {
                        //DLog(@"like");
                        
                        created_like_info = [notification_info objectForKey:@"created_like"];
                        
                        created_like_flag = [[notification_info objectForKey:@"created_like_flag"] boolValue];
                        
                        reyap_flag = [[created_like_info objectForKey:@"reyap_flag"] boolValue];
                        
                        if (reyap_flag) {
                            is_users_yap = false;
                            
                            yap_info = [created_like_info objectForKey:@"reyap"];
                            yap_info = [yap_info objectForKey:@"yap"];
                        }
                        else {
                            yap_info = [created_like_info objectForKey:@"yap"];
                        }
                        
                        if (created_like_flag) {
                            like_count = [[yap_info objectForKey:@"like_count"] intValue];
                            
                            //DLog(@"like %i", like_count);
                        }
                    }
                    
                    if ([notification_name isEqualToString:@"listen_created"]) {
                        //DLog(@"listen");
                        
                        created_listen_info = [notification_info objectForKey:@"created_listen"];
                        
                        if ([[created_listen_info objectForKey:@"reyap_flag"] boolValue] == true) {
                            is_users_yap = false;
                            
                            yap_info = [created_listen_info objectForKey:@"reyap"];
                            yap_info = [yap_info objectForKey:@"yap"];
                        }
                        else {
                            yap_info = [created_listen_info objectForKey:@"yap"];
                        }
                        
                        created_listen_flag = [[notification_info objectForKey:@"created_listen_flag"] boolValue];
                        
                        if (created_listen_flag) {
                            listen_count = [[yap_info objectForKey:@"listen_count"] intValue];
                            
                            //DLog(@"listen %i", listen_count);
                        }
                    }
                    
                    if ([notification_name isEqualToString:@"user_tag"]) {
                        yap_info = [notification_info objectForKey:@"origin_yap"];
                    }
                    
                    BOOL notification_type_id = [[notification_type objectForKey:@"notification_type_id"] boolValue];
                    BOOL is_yapster_notification = [[notification_type objectForKey:@"is_yapster_notification"] boolValue];
                    BOOL origin_reyap_flag = [[notification_info objectForKey:@"origin_reyap_flag"] boolValue];
                    BOOL user_seen_flag = [[notification_info objectForKey:@"user_seen_flag"] boolValue];
                    
                    NSString *notification_picture_path = [notification_info objectForKey:@"notification_picture_path"];
                    NSString *notification_message = [notification_info objectForKey:@"notification_message"];
                    NSString *origin_reyap = [notification_info objectForKey:@"origin_reyap"];
                    NSString *user = [notification_info objectForKey:@"user"];
                    acting_user_dictionary = [notification_info objectForKey:@"acting_user"];
                    NSString *acting_user = [NSString stringWithFormat:@"%@", [acting_user_dictionary objectForKey:@"username"]];
                    double acting_user_id = [[acting_user_dictionary objectForKey:@"id"] doubleValue];
                    NSString *created_listen = [notification_info objectForKey:@"created_listen"];
                    NSDate *date_created = [notification_info objectForKey:@"date_created"];
                    
                    NSDictionary *user_dic = [yap_info objectForKey:@"user"];

                    //post_info = [[json objectAtIndex:i] objectForKey:@"post_info"];
                    //yap_info = [[json objectAtIndex:i] objectForKey:@"yap_info"];
                    
                    if ([notification_name isEqualToString:@"like_created"] || [notification_name isEqualToString:@"reyap_created"] || [notification_name isEqualToString:@"user_tag"]) {
                        //create feed object
                        BOOL liked_by_viewer = [[notification_created_info objectForKey:@"liked_by_viewer"] boolValue];
                        double user_post_id = 0;
                        //DLog(@"after: %d", user_post_id);
                        int actual_like_count = [[yap_info objectForKey:@"like_count"] intValue];
                        int actual_reyap_count = [[yap_info objectForKey:@"reyap_count"] intValue];
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
                        
                        BOOL reyapped_by_viewer = [[notification_created_info objectForKey:@"reyapped_by_viewer"] boolValue];
                        BOOL group_flag = [[yap_info objectForKey:@"channel_flag"] boolValue];
                        BOOL listened_by_viewer = [[notification_created_info objectForKey:@"listened_by_viewer"] boolValue];
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
                        int actual_listen_count = [[yap_info objectForKey:@"listen_count"] boolValue];
                        NSString *reyap_user;
                        
                        if (created_reyap_flag || reyap_flag) {
                            reyap_user = acting_user;
                        }
                        else {
                            reyap_user = @"";
                        }
                        
                        NSString *latitude = [yap_info objectForKey:@"latitude"];
                        NSString *longitude = [yap_info objectForKey:@"longitude"];
                        NSString *yap_longitude = [yap_info objectForKey:@"longitude"];
                        NSString *username = [user_dic objectForKey:@"username"];
                        NSString *first_name = [user_dic objectForKey:@"first_name"];
                        NSString *last_name = [user_dic objectForKey:@"last_name"];
                        NSString *picture_path = [yap_info objectForKey:@"picture_path"];
                        NSString *picture_cropped_path = [yap_info objectForKey:@"picture_cropped_path"];
                        NSString *profile_picture_path = [user_dic objectForKey:@"profile_picture_path"];
                        NSString *profile_cropped_picture_path = [user_dic objectForKey:@"profile_cropped_picture_path"];
                        NSString *web_link = [yap_info objectForKey:@"web_link"];
                        NSString *yap_length = [yap_info objectForKey:@"length"];
                        double user_id = [[user_dic objectForKey:@"id"] doubleValue];
                        double reyap_user_id = 0;
                        double yap_id = [[yap_info objectForKey:@"yap_id"] doubleValue];
                        double reyap_id = 0;
                        
                        if (created_reyap_flag || reyap_flag) {
                            reyap_id = [[created_yap_info objectForKey:@"reyap_id"] doubleValue];
                            reyap_user_id = [[acting_user_dictionary objectForKey:@"id"] doubleValue];
                        }
                        
                        DLog(@"yap info %@", yap_info);
                        
                        NSString *yap_title = [yap_info objectForKey:@"title"];
                        NSString *audio_path = [yap_info objectForKey:@"audio_path"];
                        NSArray *user_tags = [yap_info objectForKey:@"user_tags"];
                        NSArray *hashtags = [yap_info objectForKey:@"hashtags"];
                        NSDate *post_date_created = [yap_info objectForKey:@"date_created"];
                        NSDate *yap_date_created = [yap_info objectForKey:@"date_created"];
                        
                        Feed *UserActualFeedObject = [[Feed alloc] initWithYapId: (int) yap_id andReyapId: (double) reyap_id andUserPostId: (double) user_post_id andLikedByViewer: (BOOL) liked_by_viewer andReyapUser: (NSString *) reyap_user andLikeCount: (int) actual_like_count andReyapCount: (int) actual_reyap_count andGroup: (NSArray *) group andGooglePlusAccountId: (double) google_plus_account_id andFacebookAccountId: (double) facebook_account_id andTwitterAccountId: (double) twitter_account_id andLinkedinAccountId: (double) linkedin_account_id andReyappedByViewer: (BOOL) reyapped_by_viewer andListenedByViewer: (BOOL) listened_by_viewer andHashtagsFlag: (BOOL) hashtags_flag andLinkedinSharedFlag: (BOOL) linkedin_shared_flag andFacebookSharedFlag: (BOOL) facebook_shared_flag andTwitterSharedFlag: (BOOL) twitter_shared_flag andGooglePlusSharedFlag: (BOOL) google_plus_shared_flag andUserTagsFlag: (BOOL) user_tags_flag andWebLinkFlag: (BOOL) web_link_flag andPictureFlag: (BOOL) picture_flag andPictureCroppedFlag: (BOOL) picture_cropped_flag andIsActive: (BOOL) is_active andGroupFlag: (BOOL) group_flag andIsDeleted: (BOOL) is_deleted andListenCount: (int) actual_listen_count andLatitude: (NSString *) latitude andLongitude: (NSString *) longitude andYapLongitude: (NSString *) yap_longitude andUsername: (NSString *) username andFirstName: (NSString *) first_name andLastName: (NSString *) last_name andPicturePath: (NSString *) picture_path andPictureCroppedPath: (NSString *) picture_cropped_path andProfilePicturePath: (NSString *) profile_picture_path andProfileCroppedPicturePath: (NSString *) profile_cropped_picture_path andWebLink: (NSString *) web_link andYapLength: (NSString *) yap_length andUserId: (double) user_id andReyapUserId: (double) reyap_user_id andYapTitle: (NSString *) yap_title andAudioPath: (NSString *) audio_path andUserTags: (NSArray *) user_tags andHashtags: (NSArray *) hashtags andPostDateCreated: (NSDate *) post_date_created andYapDateCreated: (NSDate *) yap_date_created];
                        
                        //add user object to user info array
                        [yapsInfo addObject:UserActualFeedObject];
                    }
                    else {
                        [yapsInfo addObject:@""];
                    }
                    
                    
                    double notification_id = [[[json objectAtIndex:i] objectForKey:@"notification_id"] doubleValue];
                    
                    NSNumber *notification_id2 = [[NSNumber alloc] initWithDouble:notification_id];
                    
                    [read_notifications addObject:notification_id2];
                    
                    last_object_id = 0;
                    
                    if (i == (json.count - 1)) {
                        last_object_id = [[[json objectAtIndex:i] objectForKey:@"notification_id"] doubleValue];
                    }
                    
                    //NSString *profile_picture_path2 = [user_dic objectForKey:@"profile_picture_path"];

                    NSString *profile_cropped_picture_path2 = [acting_user_dictionary objectForKey:@"profile_cropped_picture_path"];
                    
                    Notifications *UserActualNotificationsObject = [[Notifications alloc] initWithNotificationId:notification_id andNotificationTypeId:notification_type_id andReyapCount:reyap_count andListenCount:listen_count andLikeCount:like_count andIsYapsterNotification:is_yapster_notification andOriginReyapFlag:origin_reyap_flag andUserSeenFlag:user_seen_flag andCreatedReyapFlag:created_reyap_flag andCreatedLikeFlag:created_like_flag andCreatedListenFlag:created_listen_flag andUserReadFlag:user_read_flag andIsUsersYap:is_users_yap  andNotificationName:notification_name andNotificationPicturePath:notification_picture_path andNotificationMessage:notification_message andOriginReyap:origin_reyap andUser:user andActingUser:acting_user andActingUserId:acting_user_id andCreatedListen:created_listen andDateCreated:date_created];
                    
                    //add user object to user info array
                    [userFeed addObject:UserActualNotificationsObject];
                    
                    self.workingEntry = [[AppPhotoRecord alloc] init];
                    
                    if (![profile_cropped_picture_path2 isEqualToString:@""]) {
                        if (self.workingEntry)
                        {
                            NSString *bucket = @"yapsterapp";
                            S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
                            
                            //get profile photo
                            S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
                            gpsur_cropped_photo.key     = profile_cropped_picture_path2;
                            gpsur_cropped_photo.bucket  = bucket;
                            gpsur_cropped_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
                            gpsur_cropped_photo.responseHeaderOverrides = override;
                            
                            NSURL *url_cropped_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_cropped_photo];
                            
                            NSString *url_string = [url_cropped_photo absoluteString];
                            
                            self.workingEntry.imageURLString = url_string;
                            
                            [self.workingArray addObject:self.workingEntry];
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
                }
            }
            
            if (!btn_ViewMissed.userInteractionEnabled) {
                double user_id = sessionUserID;
                double session_id = sessionID;
                //NSString *device_token = sharedManager.userDeviceToken;
                
                NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:user_id];
                NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:session_id];
                
                NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                tempSessionUserID, @"user_id",
                                                tempSessionID, @"session_id",
                                                read_notifications, @"notifications_read",
                                                nil];
                
                NSError *error;
                
                //convert object to data
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                
                NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/notification/read/"];
                
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
                    DLog(@"JSON OUTPUT - READ: %@", JSONString);
                }
                
                connection5 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                
                [connection5 start];
                
                if (connection5) {
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                }
                else {
                    //Error
                }
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            numLoadedPosts = numLoadedPosts+postAmount;
            
            isLoadingMorePosts = false;
            
            if (refreshControl.isRefreshing) {
                [refreshControl endRefreshing];
            }
            
            //[theTable setContentOffset:CGPointZero animated:NO];
            theTable.hidden = NO;
            [theTable reloadData];
        }
        else {
            if (numLoadedPosts < postAmount) {
                theTable.hidden = YES;
                
                message.text = @"You don't have any notifications yet.";
                message.hidden = NO;
            }
        }
        
        [loadingData stopAnimating];
        loadingData.hidden = YES;
        
        [loadingMoreData stopAnimating];
        loadingMoreData.hidden = YES;
    }
    else if (connection == connection3) {
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
        
        ViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        
        [self.navigationController pushViewController:homeVC animated:NO];
    }
}

-(IBAction)goToYapScreen:(id)sender {
    createYapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateYapVC"];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        //Push to controller
        [self.navigationController pushViewController:createYapVC animated:YES];
    }
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
        rowHeight = 90;
        
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
    
    UserNotificationsTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tableView == theTable) {
        UserNotificationsTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell = [[UserNotificationsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == theTable) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([theTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [theTable setSeparatorInset:UIEdgeInsetsZero];
        }
        
        cell.notification_type_follow.hidden = YES;
        cell.notification_type_listen.hidden = YES;
        cell.notification_type_like.hidden = YES;
        cell.notification_type_reyap.hidden = YES;
        //cell.notification_type.frame = CGRectMake(275, 47, 33, 33);
        
        CALayer *imageLayer = cell.btnUserProfilePhoto.layer;
        [imageLayer setCornerRadius:cell.btnUserProfilePhoto.frame.size.width/2];
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
                [cell.btnUserProfilePhoto setBackgroundImage:[UIImage imageNamed:@"placer holder_profile photo Large.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.btnUserProfilePhoto setBackgroundImage:photoRecord.actualPhoto forState:UIControlStateNormal];
            }
        }
        
        NSString *dateString;
        
        if (userFeed.count > 0) {
            Notifications *userNotificationsData = [userFeed objectAtIndex:indexPath.row];
            
            dateString = [NSString stringWithFormat:@"%@", userNotificationsData.date_created];
            
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
            
            [cell.acting_user_btn setTitle:[NSString stringWithFormat:@"@%@", userNotificationsData.acting_user] forState:UIControlStateNormal];
            
            CGFloat constrainedWidth = 108.0f;
            CGSize sizeOfText;
            float max_width;
            
            sizeOfText = [[NSString stringWithFormat:@"@%@", userNotificationsData.acting_user] sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:16] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)];
            
            //sizeOfText = [@"@dffdfdfdfdfdffdfdfddfddfdfdf" sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:16] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)];
            
            max_width = sizeOfText.width;
            
            cell.acting_user_btn.frame = CGRectMake(cell.acting_user_btn.frame.origin.x, cell.acting_user_btn.frame.origin.y, cell.acting_user_btn.frame.size.width, cell.acting_user_btn.frame.size.height);
             
            cell.acting_user_btn.userInteractionEnabled = YES;
            
            cell.btnUserProfilePhoto.tag = userNotificationsData.acting_user_id;
            
            [cell.btnUserProfilePhoto addTarget:self action:@selector(goToUserProfile:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.date_label.text = convertedString;
            
            //[cell.date_label sizeToFit];
            
            int notification_type_count = 0;
            
            if ([userNotificationsData.notification_name isEqualToString:@"new_follower"]) {
                notification_type_count = 0;
                //[cell.notification_type setImage:[UIImage imageNamed:@"place holder_profile photo.png"]];
                cell.notification_type_follow.hidden = NO;
            }
            else if ([userNotificationsData.notification_name isEqualToString:@"listen_created"]) {
                notification_type_count = userNotificationsData.listen_count;
                //[cell.notification_type setImage:[UIImage imageNamed:@"place holder_profile photo.png"]];
                cell.notification_type_listen.hidden = NO;
            }
            else if ([userNotificationsData.notification_name isEqualToString:@"like_created"]) {
                notification_type_count = userNotificationsData.like_count;
                //cell.notification_type.frame = CGRectMake(cell.notification_type.frame.origin.x+5, cell.notification_type.frame.origin.y, cell.notification_type.frame.size.width-5, 25);
                //[cell.notification_type setImage:[UIImage imageNamed:@"bttn_like gry.png"]];
                cell.notification_type_like.hidden = NO;
            }
            else if ([userNotificationsData.notification_name isEqualToString:@"reyap_created"]) {
                notification_type_count = userNotificationsData.reyap_count;
                //cell.notification_type.frame = CGRectMake(cell.notification_type.frame.origin.x+5, cell.notification_type.frame.origin.y+10, cell.notification_type.frame.size.width-5, 20);
                //[cell.notification_type setImage:[UIImage imageNamed:@"bttn_reyap gry.png"]];
                cell.notification_type_reyap.hidden = NO;
                
            }
            else if ([userNotificationsData.notification_name isEqualToString:@"user_recommended"] || [userNotificationsData.notification_name isEqualToString:@"user_unrecommended"] || [userNotificationsData.notification_name isEqualToString:@"user_tag"] || [userNotificationsData.notification_name isEqualToString:@"follower_requested"] || [userNotificationsData.notification_name isEqualToString:@"follower_accepted"] || [userNotificationsData.notification_name isEqualToString:@"user_verified"] || [userNotificationsData.notification_name isEqualToString:@"user_unverified"] || [userNotificationsData.notification_name isEqualToString:@"user_deactivated"] || [userNotificationsData.notification_name isEqualToString:@"user_activated"]) {
                notification_type_count = 0;
                /*cell.notification_type_follow.hidden = YES;
                cell.notification_type_like.hidden = YES;
                cell.notification_type_reyap.hidden = YES;*/
            }
            
            if (notification_type_count > 0) {
                cell.and_label.hidden = NO;
                cell.and_label.frame = CGRectMake(cell.btnUserProfilePhoto.frame.origin.x+cell.btnUserProfilePhoto.frame.size.width+max_width+25, cell.and_label.frame.origin.y, cell.and_label.frame.size.width, cell.and_label.frame.size.height);
                
                if ([userNotificationsData.notification_name isEqualToString:@"new_follower"]) {
                    [cell.other_users setText:[NSString stringWithFormat:@"%d others started following you", notification_type_count]];
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"listen_created"]) {
                    [cell.other_users setText:[NSString stringWithFormat:@"%d others listened to your yap", notification_type_count]];
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"like_created"]) {
                    if (userNotificationsData.is_users_yap) {
                        [cell.other_users setText:[NSString stringWithFormat:@"%d others liked your yap", notification_type_count]];
                    }
                    else {
                        [cell.other_users setText:[NSString stringWithFormat:@"%d others liked your reyap", notification_type_count]];
                    }
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"reyap_created"]) {
                    if (userNotificationsData.is_users_yap) {
                        [cell.other_users setText:[NSString stringWithFormat:@"%d others reyapped your yap", notification_type_count]];
                    }
                    else {
                        [cell.other_users setText:[NSString stringWithFormat:@"%d others reyapped your reyap", notification_type_count]];
                    }
                }
                
                //cell.other_users.frame = CGRectMake(cell.btnUserProfilePhoto.frame.origin.x+cell.btnUserProfilePhoto.frame.size.width+max_width+20, 12, 100, 40);
            }
            else {
                cell.and_label.hidden = YES;
                
                if ([userNotificationsData.notification_name isEqualToString:@"new_follower"]) {
                    [cell.other_users setText:@"started following you"];
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"listen_created"]) {
                    [cell.other_users setText:@"listened to your yap"];
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"like_created"]) {
                    if (userNotificationsData.is_users_yap) {
                        [cell.other_users setText:@"liked your yap"];
                    }
                    else {
                        [cell.other_users setText:@"liked your reyap"];
                    }
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"reyap_created"]) {
                    if (userNotificationsData.is_users_yap) {
                        [cell.other_users setText:@"reyapped your yap"];
                    }
                    else {
                        [cell.other_users setText:@"reyapped your reyap"];
                    }
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"user_recommended"]) {
                    [cell.other_users setText:@"you've become a recommended user"];
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"user_unrecommended"]) {
                    [cell.other_users setText:@"you've been unrecommended"];
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"user_tag"]) {
                    [cell.other_users setText:@"tagged you in their yap"];
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"follower_requested"]) {
                    [cell.other_users setText:@"requested to follow you"];
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"follower_accepted"]) {
                    [cell.other_users setText:@"accepted your follower request"];
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"user_verified"]) {
                    [cell.other_users setText:@"you've been verified"];
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"user_unverified"]) {
                    [cell.other_users setText:@"you've been unverified"];
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"user_deactivated"]) {
                    [cell.other_users setText:@"your account is now deactivated"];
                }
                else if ([userNotificationsData.notification_name isEqualToString:@"user_activated"]) {
                    [cell.other_users setText:@"your account is now active"];
                }
                
                //cell.other_users.frame = CGRectMake(cell.btnUserProfilePhoto.frame.origin.x+cell.btnUserProfilePhoto.frame.size.width+max_width+20, 12, 100, 40);
            }
            
            if (cell.other_users == nil) {
                cell.other_users.numberOfLines = 0;
                [cell.other_users sizeToFit];
            }
        }
        
        [loadingData stopAnimating];
        loadingData.hidden = YES;
    }
    else {
        NSString *key = [menuKeys objectAtIndex:indexPath.section];
        
        NSArray *list = [menuItems objectForKey:key];
        
        //UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
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
                        theIconImage = [UIImage imageNamed:@"bttn_notification grn.png"];
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
        
        if (indexPath.row == 4) {
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
                            Stream *streamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Stream"];
                            
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
                            [self toggleMenu];
                            
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
                            
                            connection3 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            
                            [connection3 start];
                            
                            if (connection3) {
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
        Notifications *userNotificationsData = [userFeed objectAtIndex:indexPath.row];
        
        if ([userNotificationsData.notification_name isEqualToString:@"like_created"] || [userNotificationsData.notification_name isEqualToString:@"reyap_created"] || [userNotificationsData.notification_name isEqualToString:@"user_tag"]) {
            
            int row = indexPath.row;
            
            playerScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerScreenVC"];
            
            Feed *userFeedData = [yapsInfo objectAtIndex:row];
            
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
            
            DLog(@"notif reyap_id %f", userFeedData.reyap_id);
            
            playerScreenVC.cameFrom = @"user_notifications";
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
        else {
            UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
            UserProfileVC.userToView = userNotificationsData.acting_user_id;
            
            if ([userNotificationsData.notification_name isEqualToString:@"follower_requested"]) {
                UserProfileVC.cameFromNotifications = true;
                UserProfileVC.notification_name = @"follower_requested";
            }
            
            //Push to controller
            [self.navigationController pushViewController:UserProfileVC animated:YES];
        }
        
        /*
        double user_id = sessionUserID;
        double session_id = sessionID;
        //NSString *device_token = sharedManager.userDeviceToken;
        
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:user_id];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:session_id];
        NSNumber *tempNotificationId = [[NSNumber alloc] initWithDouble:userNotificationsData.notification_id];
        
        NSMutableArray *clicked_notifications = [[NSMutableArray alloc] init];
        
        [clicked_notifications addObject:tempNotificationId];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        clicked_notifications, @"notifications_clicked",
                                        nil];
        
        NSError *error;
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/notification/clicked/"];
        
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
            DLog(@"JSON OUTPUT: %@", JSONString);
        }
        
        connection4 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection4 start];
        
        if (connection4) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
        else {
            //Error
        }
         */
    }
}

 //load more rows as user scrolls to bottom of table
 - (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
     if (aScrollView == theTable) {
         CGPoint offset = aScrollView.contentOffset;
         CGRect bounds = aScrollView.bounds;
         CGSize size = aScrollView.contentSize;
         UIEdgeInsets inset = aScrollView.contentInset;
         float y = offset.y + ((bounds.size.height - inset.bottom));
         float h = size.height-150;
         
         //DLog(@"offset: %f", offset.y);
         // DLog(@"content.height: %f", size.height);
         // DLog(@"bounds.height: %f", bounds.size.height);
         // DLog(@"inset.top: %f", inset.top);
         // DLog(@"inset.bottom: %f", inset.bottom);
         // DLog(@"pos: %f of %f", y, h);
         
         float reload_distance = 0;
         
         if(y > h + reload_distance) {
             //postAmount += nextAmount;
             
             //build an info object and convert to json
             NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
             NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
             
             if (isLoadingMorePosts == false) {
                 isLoadingMorePosts = true;
                 
                 NSNumber *tempPostAmount = [[NSNumber alloc] initWithInt:postAmount];
                 
                 DLog(@"num posts: %i", [userFeed count]);
                 
                 if ([userFeed count] >= (numLoadedPosts-1)) {
                     DLog(@"loading...");
                     
                     //Notifications *userNotificationsData = [userFeed objectAtIndex:numLoadedPosts-1];
                     
                     DLog(@"COUNT: %lu", (unsigned long)[userFeed count]);
                     
                     NSNumber *tempAfter = [[NSNumber alloc] initWithInt:last_object_id];
                     
                     //DLog(@"after: %@", json);
                     
                     NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     tempSessionUserID, @"user_id",
                                                     tempSessionID, @"session_id",
                                                     tempPostAmount, @"amount",
                                                     tempAfter, @"after",
                                                     nil];
                     
                     NSError *error;
                     
                     //convert object to data
                     NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                     
                     NSURL *the_url;
                     
                     if (btn_ViewToday.userInteractionEnabled == NO) {
                         the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/notification/all/load/"];
                     }
                     else {
                         the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/notification/unread/load/"];
                     }
                     
                     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                     [request setURL:the_url];
                     [request setHTTPMethod:@"POST"];
                     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                     [request setHTTPBody:jsonData];
                     
                     NSHTTPURLResponse* urlResponse = nil;
                     
                     NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                     
                     responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                     
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
                         
                         //DLog(@"ddfdffd %f", [theTable contentSize].height);
                         
                         //loadingMoreData.frame = CGRectMake(loadingMoreData.frame.origin.x, [[UIScreen mainScreen] bounds].size.height, loadingMoreData.frame.size.width, loadingMoreData.frame.size.height);
                         
                         //loadingMoreData.hidden = NO;
                         //[loadingMoreData startAnimating];
                     }
                     else {
                         //Error
                     }
                 }
             }
         
             //DLog(@"num posts: %i", numLoadedPosts);
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
            theTable.userInteractionEnabled = YES;
            searchButton.enabled = YES;
            searchButton.alpha = 1.0;
        }
        else {
            [self animateLayerToPoint: VIEW_HIDDEN];
            menuOpen = YES;
            theTable.userInteractionEnabled = NO;
            [searchBox resignFirstResponder];
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
        cancelButton.hidden = YES;
        searchButton.hidden = NO;
        searchButton.enabled = NO;
        searchButton.alpha = 1.0;
        searchBoxVisible = NO;
    }
    else {
        [self animateLayerToPoint:0];
        menuOpen = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             menuSearchBox.frame = CGRectMake(menuSearchBox.frame.origin.x, menuSearchBox.frame.origin.y, 220, menuSearchBox.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        menuSearchCancelButton.hidden = YES;
        [menuSearchBox resignFirstResponder];
        theTable.userInteractionEnabled = YES;
        searchButton.enabled = YES;
        searchButton.alpha = 1.0;
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
            
            UserNotificationsTableCell *cell = (UserNotificationsTableCell *)[self.theTable cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            [cell.btnUserProfilePhoto setBackgroundImage:photoRecord.actualPhoto forState:UIControlStateNormal];
            
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
