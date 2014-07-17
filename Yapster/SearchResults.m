//
//  SearchResults.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/30/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "SearchResults.h"
#import "UserProfile.h"
#import "SWTableViewCell.h"
#import "UserSettings.h"
#import "UserNotifications.h"
#import "Explore.h"
#import "AppPhotoRecord.h"
#import "IconDownloader.h"

@interface SearchResults ()

@end

@implementation SearchResults

@synthesize alertViewConfirmDelete;
@synthesize alertViewConfirmReport;

@synthesize refreshControl;
@synthesize menuOpen;
@synthesize playerScreenVC;
@synthesize playlistVC;
@synthesize UserProfileVC;
@synthesize sharedManager;
@synthesize isLoadingMorePosts;
@synthesize hashtagSearch;
@synthesize channelSearch;
@synthesize userSearch;
@synthesize textSearch;
@synthesize after_yap;
@synthesize after_reyap;
@synthesize last_after_yap;
@synthesize last_after_reyap;
@synthesize current_cell;
@synthesize current_yap_to_delete;
@synthesize current_yap_to_report;
@synthesize theTable;
@synthesize usersTable;
@synthesize message;
@synthesize search_text;
@synthesize search_text_for_label;
@synthesize channelImagesUnclicked;
@synthesize channelImagesClicked;
@synthesize json;
@synthesize followJson;
@synthesize unfollowJson;
@synthesize deleteYapJson;
@synthesize reportYapJson;
@synthesize selectedChannels;
@synthesize hashtags_array;
@synthesize users;
@synthesize responseBody;
@synthesize userFeed;
@synthesize responseBodyUsers;
@synthesize responseBodyFollow;
@synthesize responseBodyUnfollow;
@synthesize responseBodyDeleteYap;
@synthesize responseBodyReportYap;
@synthesize usersResults;
@synthesize connection1;
@synthesize connection2;
@synthesize connection3;
@synthesize connection4;
@synthesize connection5;
@synthesize connection6;
@synthesize connection7;
@synthesize pendingOperations;
@synthesize photos;
@synthesize records;
@synthesize streamVC;
@synthesize searchResultsVC;
@synthesize UserSettingsVC;
@synthesize ReportAProblemVC;
@synthesize ExploreVC;
@synthesize menuSearchCancelButton;
@synthesize menuSearchBox;
@synthesize menuTable;
@synthesize menuKeys;
@synthesize menuItems;
@synthesize topLayer;
@synthesize layerPosition;
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
    
    self.workingArray = [NSMutableArray array];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.theTable;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshStream) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.bounds = CGRectMake(0, 0, 20, 20);
    tableViewController.refreshControl = self.refreshControl;
    
    theTable.scrollEnabled = YES;
    theTable.scrollsToTop = YES;
    usersTable.scrollEnabled = YES;
    usersTable.scrollsToTop = NO;
    menuTable.scrollsToTop = NO;
    
    postAmount = 25; //default, inital
    nextAmount = 15; //next amount
    numLoadedPosts = 0;
    
    playAllBtn.enabled = NO;
    
    label_search_text.text = search_text_for_label;
    
    [hashtags_array removeObject:@""];
    [users removeObject:@""];
    
    userFeed = [[NSMutableArray alloc] init];
    
    trendingBtn.userInteractionEnabled = NO;
    
    if (!userSearch && !textSearch && (!channelSearch || !userSearch) && (!channelSearch || !textSearch)) {
        peopleBtn.hidden = YES;
        rightBorder.hidden = YES;
        
        trendingBtn.frame = CGRectMake(57, trendingBtn.frame.origin.y, trendingBtn.frame.size.width, trendingBtn.frame.size.height);
        
        leftBorder.frame = CGRectMake(165, leftBorder.frame.origin.y, leftBorder.frame.size.width, leftBorder.frame.size.height);
        
        recentBtn.frame = CGRectMake(192, recentBtn.frame.origin.y, recentBtn.frame.size.width, recentBtn.frame.size.height);
    }
    
    channelsView.hidden = YES;
    
    theTable.delegate = self;
    theTable.autoresizingMask &= ~UIViewAutoresizingFlexibleBottomMargin;
    
    if (!channelSearch) {
        theTable.frame = CGRectMake(self.view.bounds.origin.x, theTable.frame.origin.y-30, self.view.bounds.size.width, self.view.bounds.size.height-100);
    }
    else {
        theTable.frame = CGRectMake(self.view.bounds.origin.x, theTable.frame.origin.y+20, self.view.bounds.size.width, self.view.bounds.size.height-140);
    }

    theTable.showsVerticalScrollIndicator = NO;
    theTable.separatorColor = [UIColor lightGrayColor];
    theTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, theTable.bounds.size.width, 0.01f)];
    
    usersTable.delegate = self;
    usersTable.autoresizingMask &= ~UIViewAutoresizingFlexibleBottomMargin;
    
    if (!channelSearch) {
        usersTable.frame = CGRectMake(self.view.bounds.origin.x, usersTable.frame.origin.y-10, self.view.bounds.size.width, self.view.bounds.size.height-100);
    }
    else {
        usersTable.frame = CGRectMake(self.view.bounds.origin.x, usersTable.frame.origin.y+40, self.view.bounds.size.width, self.view.bounds.size.height-100);
    }
    
    usersTable.showsVerticalScrollIndicator = NO;
    usersTable.separatorColor = [UIColor lightGrayColor];
    usersTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, theTable.bounds.size.width, 0.01f)];
    
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
    
    usersTable.delegate = self;
    usersTable.autoresizingMask &= ~UIViewAutoresizingFlexibleBottomMargin;
    usersTable.frame = CGRectMake(self.view.bounds.origin.x, usersTable.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-120);
    usersTable.showsVerticalScrollIndicator = NO;
    usersTable.separatorColor = [UIColor lightGrayColor];
    
    menuTable.delegate = self;
    menuTable.autoresizingMask &= ~UIViewAutoresizingFlexibleBottomMargin;
    menuTable.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+70, self.view.bounds.size.width, self.view.bounds.size.height-60);
    menuTable.showsVerticalScrollIndicator = YES;
    menuTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, menuTable.bounds.size.width, 0.01f)];
    
    //message.frame = CGRectMake(20, 275, message.frame.size.width, message.frame.size.height);
    
    if (channelSearch) {
        float max_width = 20;
        
        for (int i = 0; i < selectedChannels.count; i++) {
            DLog(@"%@", [channelImagesClicked objectForKey:[NSString stringWithFormat:@"%@", [selectedChannels objectAtIndex:i]]]);
            
            UIImageView *channel_image_view = [[UIImageView alloc] initWithImage:[channelImagesClicked objectForKey:[NSString stringWithFormat:@"%@", [selectedChannels objectAtIndex:i]]]];
            
            channel_image_view.frame = CGRectMake(max_width, 8, 35, 35);
            
            [channelsView addSubview:channel_image_view];
            
            max_width = max_width + channel_image_view.frame.size.width + 20;
        }
        
        float channel_count = selectedChannels.count;
        
        CGFloat scrollViewWidth = 0.0f;
        
        scrollViewWidth = (channel_count*(35+20));
        
        channelsView.contentSize = CGSizeMake(scrollViewWidth, channelsView.frame.size.height);
        
        if (scrollViewWidth < 320) {
            channelsViewBorder.frame = CGRectMake(channelsViewBorder.frame.origin.x, channelsViewBorder.frame.origin.y, 320, channelsViewBorder.frame.size.height);
        }
        else {
            channelsViewBorder.frame = CGRectMake(channelsViewBorder.frame.origin.x, channelsViewBorder.frame.origin.y, scrollViewWidth, channelsViewBorder.frame.size.height);
        }
        
        channelsView.hidden = NO;
    }
    
    //build an info object and convert to json
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
    
    NSDictionary *newDatasetInfo;
    
    __block NSError *error;
    
    //convert object to data
    
    NSURL *the_url;
    
    //DEFAULT: Trending
    if (hashtagSearch) {
        if (channelSearch) {
            if (userSearch) {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_hashtags_and_user_handles/trending_search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  hashtags_array, @"hashtags_searched",
                                  selectedChannels, @"channels_searched",
                                  users, @"user_handles_searched",
                                  nil];
            }
            else {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_hashtags/trending_search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  hashtags_array, @"hashtags_searched",
                                  selectedChannels, @"channels_searched",
                                  nil];
            }
        }
        else if (userSearch) {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/hashtags_and_user_handles/trending_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              hashtags_array, @"hashtags_searched",
                              users, @"user_handles_searched",
                              nil];
        }
        else {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/hashtags/trending_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              hashtags_array, @"hashtags_searched",
                              nil];
        }
    }
    else if (channelSearch) {
        if (userSearch) {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_user_handles/trending_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              selectedChannels, @"channels_searched",
                              users, @"user_handles_searched",
                              nil];
        }
        else if (textSearch) {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_text/trending_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              selectedChannels, @"channels_searched",
                              search_text, @"text_searched",
                              nil];
        }
        else {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels/trending_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              selectedChannels, @"channels_searched",
                              nil];
        }
        
    }
    else if (userSearch) {
        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/user_handles/trending_search/"];
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          tempPostAmount, @"amount",
                          users, @"user_handles_searched",
                          nil];
    }
    else if (textSearch) {
        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/text/trending_search/"];
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          tempPostAmount, @"amount",
                          search_text, @"text_searched",
                          nil];
    }
    
    DLog(@"the_url: %@", the_url);
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    __block NSHTTPURLResponse* urlResponse = nil;
    
    loadingData.hidden = NO;
    
    [loadingData startAnimating];
    
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
                
            }
            else {
                //Error
            }
        });
    });
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
            isRefresh = true;
            
            if (!trendingBtn.userInteractionEnabled) {
                [self showTrending:self];
            }
            else if (!recentBtn.userInteractionEnabled) {
                [self showRecent:self];
            }
        }
    }
    else if (cameFromProfileScreen) {
        isRefresh = true;
        
        if (!peopleBtn.userInteractionEnabled) {
            [self showPeople:self];
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

-(void)refreshStream {
    theTable.userInteractionEnabled = NO;
    usersTable.userInteractionEnabled = NO;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not load stream." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        isRefresh = true;
        
        if (!trendingBtn.userInteractionEnabled) {
            [self showTrending:self];
        }
        else if (!peopleBtn.userInteractionEnabled) {
            [self showPeople:self];
        }
        else if (!recentBtn.userInteractionEnabled) {
            [self showRecent:self];
        }
    }
}

-(IBAction)playAll:(id)sender {
    DLog(@"USER FEED COUNT: %lu", (unsigned long)userFeed.count);
    
    if (userFeed.count > 0) {
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
            
            [playlistDic setObject:@"search_results" forKey:@"came_from"];
            
            [playlistDic setObject:yap_to_play2 forKey:@"yap_to_play"];
            [playlistDic setObject:user_id2 forKey:@"user_id"];
            [playlistDic setObject:[NSString stringWithFormat:@"%@ %@", userFeedData.first_name, userFeedData.last_name] forKey:@"name_value"];
            [playlistDic setObject:[NSString stringWithFormat:@"%@", userFeedData.username] forKey:@"username_value"];
            
            NSString *dateString;
            
            if (![userFeedData.reyap_user isEqualToString:@""]) {
                [playlistDic setObject:userFeedData.reyap_user forKey:@"reyap_username_value"];
                [playlistDic setObject:reyap_user_id2 forKey:@"reyap_user_id"];
                [playlistDic setObject:@"reyap" forKey:@"object_type"];
                [playlistDic setObject:reyap_id2 forKey:@"reyap_id"];
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
            
            playerScreenVC.after_yap = after_yap;
            
            sharedManager.currentYapPlaying = 0;
            
            //Push to controller
            [self.navigationController pushViewController:playerScreenVC animated:YES];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There are no Yaps to play." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(IBAction)followOrUnfollowUser:(id)sender {
    UIButton *button = sender;
    int button_id = button.tag;
    
    UIImage *btn_bg = button.currentBackgroundImage;
    
    NSNumber *user_id = [[usersResults objectAtIndex:button_id] objectForKey:@"id"];
    
    if (btn_bg == [UIImage imageNamed:@"icon_plus.png"]) {
        [button setBackgroundImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateNormal];
        
        //follow user
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        
        NSDictionary *newDatasetInfo;
        NSData* jsonData;
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/follow/request/"];
        
        NSError *error;
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          user_id, @"user_requested_id",
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
    }
    else {
        [button setBackgroundImage:[UIImage imageNamed:@"icon_plus.png"] forState:UIControlStateNormal];
        
        //unfollow user
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        
        NSDictionary *newDatasetInfo;
        NSData* jsonData;
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/follow/unfollow/"];
        
        NSError *error;
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          user_id, @"user_unfollowed_id",
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

-(IBAction)showTrending:(id)sender {
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.theTable;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshStream) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.bounds = CGRectMake(0, 0, 20, 20);
    tableViewController.refreshControl = self.refreshControl;
    
    [self performSelectorOnMainThread:@selector(viewTrendingBackgroundJob) withObject:nil waitUntilDone:NO];
}

-(IBAction)showPeople:(id)sender {
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.usersTable;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshStream) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.bounds = CGRectMake(0, 0, 20, 20);
    tableViewController.refreshControl = self.refreshControl;
    
   [self performSelectorOnMainThread:@selector(viewPeopleBackgroundJob) withObject:nil waitUntilDone:NO];
    
}

-(IBAction)showRecent:(id)sender {
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.theTable;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshStream) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.bounds = CGRectMake(0, 0, 20, 20);
    tableViewController.refreshControl = self.refreshControl;
    
    [self performSelectorOnMainThread:@selector(viewRecentBackgroundJob) withObject:nil waitUntilDone:NO];
}

-(void)viewTrendingBackgroundJob {
    message.hidden = YES;
    playAllBtn.enabled = NO;
    
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    [peopleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [peopleBtn setFont:[UIFont fontWithName:@"Helvetica-Neue" size:17]];
    peopleBtn.userInteractionEnabled = YES;
    [recentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recentBtn setFont:[UIFont fontWithName:@"Helvetica-Neue" size:17]];
    recentBtn.userInteractionEnabled = YES;
    [trendingBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [trendingBtn setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    trendingBtn.userInteractionEnabled = NO;
    
    //build an info object and convert to json
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
    
    NSDictionary *newDatasetInfo;
    
    __block NSError *error;
    
    //convert object to data
    
    NSURL *the_url;
    
    //Get Trending
    if (hashtagSearch) {
        if (channelSearch) {
            if (userSearch) {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_hashtags_and_user_handles/trending_search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  hashtags_array, @"hashtags_searched",
                                  selectedChannels, @"channels_searched",
                                  users, @"user_handles_searched",
                                  nil];
            }
            else {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_hashtags/trending_search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  hashtags_array, @"hashtags_searched",
                                  selectedChannels, @"channels_searched",
                                  nil];
            }
        }
        else if (userSearch) {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/hashtags_and_user_handles/trending_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              hashtags_array, @"hashtags_searched",
                              users, @"user_handles_searched",
                              nil];
        }
        else {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/hashtags/trending_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              hashtags_array, @"hashtags_searched",
                              nil];
        }
    }
    else if (channelSearch) {
        if (userSearch) {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_user_handles/trending_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              selectedChannels, @"channels_searched",
                              users, @"user_handles_searched",
                              nil];
        }
        else if (textSearch) {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_text/trending_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              selectedChannels, @"channels_searched",
                              search_text, @"text_searched",
                              nil];
        }
        else {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels/trending_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              selectedChannels, @"channels_searched",
                              nil];
        }
        
    }
    else if (userSearch) {
        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/user_handles/trending_search/"];
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          tempPostAmount, @"amount",
                          users, @"user_handles_searched",
                          nil];
    }
    else if (textSearch) {
        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/text/trending_search/"];
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          tempPostAmount, @"amount",
                          search_text, @"text_searched",
                          nil];
    }
    
    DLog(@"the_url: %@", the_url);
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    __block NSHTTPURLResponse* urlResponse = nil;
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
    
    self.workingArray = [NSMutableArray array];
    [self.workingArray removeAllObjects];
    
    numLoadedPosts = 0;
    
    if (!isRefresh) {
        userFeed = [[NSMutableArray alloc] init];
        
        theTable.hidden = YES;
        usersTable.hidden = YES;
        
        loadingData.hidden = NO;
        
        [loadingData startAnimating];
    }
    else {
        usersTable.hidden = YES;
        
        if (refreshControl.isRefreshing) {
            [refreshControl endRefreshing];
        }
    }
    
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
                
            }
            else {
                //Error
            }
        });
    });
}

-(void)viewPeopleBackgroundJob {
    message.hidden = YES;
    playAllBtn.enabled = NO;
    
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    [peopleBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [peopleBtn setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    peopleBtn.userInteractionEnabled = NO;
    [recentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recentBtn setFont:[UIFont fontWithName:@"Helvetica-Neue" size:17]];
    recentBtn.userInteractionEnabled = YES;
    [trendingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [trendingBtn setFont:[UIFont fontWithName:@"Helvetica-Neue" size:17]];
    trendingBtn.userInteractionEnabled = YES;
    
    //build an info object and convert to json
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
    
    NSDictionary *newDatasetInfo;
    
    __block NSError *error;
    
    //convert object to data
    
    NSURL *the_url;
    
    //Get People
    if (userSearch) {
        if (!channelSearch) {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/user_handles/people_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              users, @"user_handles_searched",
                              nil];
        }
        else {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_user_handles/people_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              selectedChannels, @"channels_searched",
                              users, @"user_handles_searched",
                              nil];
        }
    }
    else if (channelSearch && textSearch) {
        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_text/people_search/"];
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          tempPostAmount, @"amount",
                          selectedChannels, @"channels_searched",
                          search_text, @"text_searched",
                          nil];
    }
    else if (textSearch) {
        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/text/people_search/"];
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          tempPostAmount, @"amount",
                          search_text, @"text_searched",
                          nil];
    }
    
    DLog(@"the_url: %@", the_url);
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    __block NSHTTPURLResponse* urlResponse = nil;
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
    
    self.workingArray = [NSMutableArray array];
    [self.workingArray removeAllObjects];
    
    numLoadedPosts = 0;
    
    if (!isRefresh) {
        usersResults = [[NSMutableArray alloc] init];
        
        theTable.hidden = YES;
        usersTable.hidden = YES;
        
        loadingData.hidden = NO;
        
        [loadingData startAnimating];
    }
    else {
        theTable.hidden = YES;
        
        if (refreshControl.isRefreshing) {
            [refreshControl endRefreshing];
        }
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBodyUsers = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
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
            
            connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection2 start];
            
            if (connection2) {
 
            }
            else {
                //Error
            }
        });
    });
}

-(void)viewRecentBackgroundJob {
    message.hidden = YES;
    playAllBtn.enabled = NO;
    
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    [peopleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [peopleBtn setFont:[UIFont fontWithName:@"Helvetica-Neue" size:17]];
    peopleBtn.userInteractionEnabled = YES;
    [recentBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [recentBtn setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    recentBtn.userInteractionEnabled = NO;
    [trendingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [trendingBtn setFont:[UIFont fontWithName:@"Helvetica-Neue" size:17]];
    trendingBtn.userInteractionEnabled = YES;
    
    //build an info object and convert to json
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
    
    NSDictionary *newDatasetInfo;
    
    __block NSError *error;
    
    //convert object to data
    NSURL *the_url;
    
    //Get Recent
    if (hashtagSearch) {
        if (channelSearch) {
            if (userSearch) {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_hashtags_and_user_handles/recent_search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  hashtags_array, @"hashtags_searched",
                                  selectedChannels, @"channels_searched",
                                  users, @"user_handles_searched",
                                  nil];
            }
            else {
                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_hashtags/recent_search/"];
                
                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  tempSessionUserID, @"user_id",
                                  tempSessionID, @"session_id",
                                  tempPostAmount, @"amount",
                                  hashtags_array, @"hashtags_searched",
                                  selectedChannels, @"channels_searched",
                                  nil];
            }
        }
        else if (userSearch) {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/hashtags_and_user_handles/recent_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              hashtags_array, @"hashtags_searched",
                              users, @"user_handles_searched",
                              nil];
        }
        else {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/hashtags/recent_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              hashtags_array, @"hashtags_searched",
                              nil];
        }
    }
    else if (channelSearch) {
        if (userSearch) {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_user_handles/recent_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              selectedChannels, @"channels_searched",
                              users, @"user_handles_searched",
                              nil];
        }
        else if (textSearch) {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_text/recent_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              selectedChannels, @"channels_searched",
                              search_text, @"text_searched",
                              nil];
        }
        else {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels/recent_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              selectedChannels, @"channels_searched",
                              nil];
        }
        
    }
    else if (userSearch) {
        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/user_handles/recent_search/"];
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          tempPostAmount, @"amount",
                          users, @"user_handles_searched",
                          nil];
    }
    else if (textSearch) {
        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/text/recent_search/"];
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          tempPostAmount, @"amount",
                          search_text, @"text_searched",
                          nil];
    }
    
    DLog(@"the_url: %@", the_url);
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    __block NSHTTPURLResponse* urlResponse = nil;
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
    
    self.workingArray = [NSMutableArray array];
    [self.workingArray removeAllObjects];
    
    numLoadedPosts = 0;
    
    if (!isRefresh) {
        userFeed = [[NSMutableArray alloc] init];
        
        theTable.hidden = YES;
        usersTable.hidden = YES;
        
        loadingData.hidden = NO;
        
        [loadingData startAnimating];
    }
    else {
        usersTable.hidden = YES;
        
        if (refreshControl.isRefreshing) {
            [refreshControl endRefreshing];
        }
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

-(IBAction)goBack:(id)sender {
    cameFromSearchResults = true;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection1) {
        //DLog(@"RESPONSE: %@", responseBody);
        
        if (refreshControl.isRefreshing || cameFromPlayerScreen || isRefresh) {
            userFeed = [[NSMutableArray alloc] init];
            
            isRefresh = false;
            cameFromPlayerScreen = false;
            cameFromPlayerScreen = false;
        }
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void) {
            
            NSData *data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
            
            json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            DLog(@"RESPONSE: %@", json);
            
            NSDictionary *post_info;
            NSDictionary *yap_info;
            NSDictionary *user;
            NSDictionary *channel;
            NSDictionary *reyap_user_dic;
            //NSDictionary *check_valid;
            //NSDictionary *actual_value;
            
            if (json.count > 0) {
                BOOL valid = true;
                
                /*NSData *data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
                
                check_valid = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if (![[check_valid objectForKey:@"Valid"] isKindOfClass:[NSNull class]]) {
                    valid = [[check_valid objectForKey:@"Valid"] boolValue];
                }
                else {
                    valid = true;
                }*/
                
                if (valid) {
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
                        
                        after_yap = yap_id;
                        
                        NSString *yap_title = [yap_info objectForKey:@"title"];
                        NSString *audio_path = [yap_info objectForKey:@"audio_path"];
                        NSArray *user_tags = [yap_info objectForKey:@"user_tags"];
                        NSArray *hashtags = [yap_info objectForKey:@"hashtags"];
                        NSDate *post_date_created = [post_info objectForKey:@"date_created"];
                        NSDate *yap_date_created = [yap_info objectForKey:@"date_created"];
                        
                        Feed *UserActualFeedObject = [[Feed alloc] initWithYapId: (int) yap_id andReyapId: (double) reyap_id andUserPostId: (double) user_post_id andLikedByViewer: (BOOL) liked_by_viewer andReyapUser: (NSString *) reyap_user andLikeCount: (int) like_count andReyapCount: (int) reyap_count andGroup: (NSArray *) group andGooglePlusAccountId: (double) google_plus_account_id andFacebookAccountId: (double) facebook_account_id andTwitterAccountId: (double) twitter_account_id andLinkedinAccountId: (double) linkedin_account_id andReyappedByViewer: (BOOL) reyapped_by_viewer andListenedByViewer: (BOOL) listened_by_viewer andHashtagsFlag: (BOOL) hashtags_flag andLinkedinSharedFlag: (BOOL) linkedin_shared_flag andFacebookSharedFlag: (BOOL) facebook_shared_flag andTwitterSharedFlag: (BOOL) twitter_shared_flag andGooglePlusSharedFlag: (BOOL) google_plus_shared_flag andUserTagsFlag: (BOOL) user_tags_flag andWebLinkFlag: (BOOL) web_link_flag andPictureFlag: (BOOL) picture_flag andPictureCroppedFlag: (BOOL) picture_cropped_flag andIsActive: (BOOL) is_active andGroupFlag: (BOOL) group_flag andIsDeleted: (BOOL) is_deleted andListenCount: (int) listen_count andLatitude: (NSString *) latitude andLongitude: (NSString *) longitude andYapLongitude: (NSString *) yap_longitude andUsername: (NSString *) username andFirstName: (NSString *) first_name andLastName: (NSString *) last_name andPicturePath: (NSString *) picture_path andPictureCroppedPath: (NSString *) picture_cropped_path andProfilePicturePath: (NSString *) profile_picture_path andProfileCroppedPicturePath: (NSString *) profile_cropped_picture_path andWebLink: (NSString *) web_link andYapLength: (NSString *) yap_length andUserId: (double) user_id andReyapUserId: (double) reyap_user_id andYapTitle: (NSString *) yap_title andAudioPath: (NSString *) audio_path andUserTags: (NSArray *) user_tags andHashtags: (NSArray *) hashtags andPostDateCreated: (NSDate *) post_date_created andYapDateCreated: (NSDate *) yap_date_created];
                        
                        //add user object to user info array
                        [userFeed addObject:UserActualFeedObject];
                    
                    //dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                        theTable.hidden = NO;
                        [self.theTable reloadData];
                        
                        playAllBtn.enabled = YES;
                        
                        isLoadingMorePosts = false;
                        
                        [loadingData stopAnimating];
                        loadingData.hidden = YES;
                    //});
                        
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
                    
                    numLoadedPosts = numLoadedPosts+postAmount;
                    
                    //timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(loadMorePosts:) userInfo:nil repeats:YES];
                    
                    //[NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
                    
                    //DLog(@"num posts %i", numLoadedPosts);
                }
                else {
                    
                }
            }
            else {
                if (numLoadedPosts < postAmount) {
                    message.text = @"No Yap results for your search.";
                    message.hidden = NO;
                    
                    playAllBtn.enabled = NO;
                    
                    theTable.hidden = YES;
                    
                    [loadingData stopAnimating];
                    loadingData.hidden = YES;
                }
            }
        //});
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        theTable.userInteractionEnabled = YES;
        usersTable.userInteractionEnabled = YES;
        
        if (refreshControl.isRefreshing) {
            [refreshControl endRefreshing];
        }
    }
    else if (connection == connection2) {
        if (refreshControl.isRefreshing) {
            isRefresh = false;
        }
        
        NSData *data = [responseBodyUsers dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableArray *json_people = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        usersResults = [[NSMutableArray alloc] init];
        
        DLog(@"%@", json_people);
        
        if (json_people.count > 0) {
            for (int i = 0; i < json_people.count; i++) {
                NSArray *an_array = [json_people objectAtIndex:i];
                
                [usersResults addObject:an_array];
                
                NSString *profile_picture_path = [[usersResults objectAtIndex:i] objectForKey:@"profile_picture_path"];
                NSString *profile_cropped_picture_path = [[usersResults objectAtIndex:i] objectForKey:@"profile_cropped_picture_path"];
                
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
            
            if (usersResults.count == 0) {
                message.text = @"No people results to show.";
                message.hidden = NO;
                
                usersTable.hidden = YES;
            }
            else {
                DLog(@"%@", usersResults);

                
                [usersTable reloadData];
                usersTable.hidden = NO;
            }
        }
        else {
            message.text = @"No people results to show.";
            message.hidden = NO;
            
            usersTable.hidden = YES;
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [loadingData stopAnimating];
        loadingData.hidden = YES;
        
        theTable.userInteractionEnabled = YES;
        usersTable.userInteractionEnabled = YES;
        
        if (refreshControl.isRefreshing) {
            [refreshControl endRefreshing];
        }
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
                DLog(@"USER FOLLOWED");
            }
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
                DLog(@"USER UNFOLLOWED");
            }
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
    }
    else if (connection == connection7) {
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
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(IBAction)goToUserProfile:(id)sender {
    UIButton *button = sender;
    NSInteger user_id = button.tag;
    
    UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
    
    UserProfileVC.userToView = user_id;
    
    //Push to controller
    [self.navigationController pushViewController:UserProfileVC animated:YES];
}

-(void)goToUserProfileFromCell:(double)user_id {
    UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
    
    UserProfileVC.userToView = user_id;
    
    //Push to controller
    [self.navigationController pushViewController:UserProfileVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if (tableView == theTable) {
        return 1;
    }
    else if (theTable == menuTable) {
        return [menuKeys count];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == theTable) {
        return [userFeed count];
    }
    else if (tableView == usersTable) {
        return [usersResults count];
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
        
        return rowHeight;
    }
    else if (tableView == menuTable) {
        rowHeight = 52;
    }
    else {
        rowHeight = 95;
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
    
    StreamCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tableView == theTable) {
        if ([theTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [theTable setSeparatorInset:UIEdgeInsetsZero];
        }
        
        Feed *userFeedData = [userFeed objectAtIndex:indexPath.row];
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
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
            
            dateString = [NSString stringWithFormat:@"%@", userFeedData.yap_date_created];
            
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
        cell.yapDate.textAlignment = NSTextAlignmentRight;
        
        //cell.yapDate.text = [NSString stringWithFormat:@"%f", userFeedData.user_post_id];
        
        /*if (![userFeedData.picture_path isKindOfClass:[NSNull class]]) {
         //get profile photo
         NSURL *userPhotoPath = [NSURL URLWithString:userFeedData.picture_path];
         
         NSData *image_data = [NSData dataWithContentsOfURL:userPhotoPath];
         UIImage *profile_image = [UIImage imageWithData:image_data];
         
         [cell.btnUserPhoto setBackgroundImage:profile_image forState:UIControlStateNormal];
         }*/
        
        /*
         if (![userFeedData.profile_cropped_picture_path isKindOfClass:[NSNull class]] && ![userFeedData.profile_cropped_picture_path isEqualToString:@""]) {
         //get cropped user profile photo
         NSString *bucket = @"yapsterapp";
         S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
         
         dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
         dispatch_async(queue, ^{
         
         dispatch_async(dispatch_get_main_queue(), ^{
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
         });
         
         //get profile photo
         S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
         gpsur_cropped_photo.key     = userFeedData.profile_cropped_picture_path;
         gpsur_cropped_photo.bucket  = bucket;
         gpsur_cropped_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
         gpsur_cropped_photo.responseHeaderOverrides = override;
         
         NSURL *url_cropped_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_cropped_photo];
         
         NSData *data_cropped_photo = [NSData dataWithContentsOfURL:url_cropped_photo];
         
         UIImage *cropped_photo = [UIImage imageWithData:data_cropped_photo];
         
         dispatch_async(dispatch_get_main_queue(), ^{
         CALayer *imageLayer = cell.btnUserPhoto.layer;
         [imageLayer setCornerRadius:cell.btnUserPhoto.frame.size.width/2];
         [imageLayer setBorderWidth:0.0];
         [imageLayer setMasksToBounds:YES];
         
         [cell.btnUserPhoto setBackgroundImage:cropped_photo forState:UIControlStateNormal];
         });
         });
         }*/
        
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
            
            NSArray *hashtags_array2 = [[NSMutableArray alloc] init];
            
            hashtags_array2 = userFeedData.hashtags;
            
            DLog(@"HAS HASHTAGS %@ %@", userFeedData.title, userFeedData.hashtags);
            
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
            
            for (int i = 0; i < hashtags_array2.count; i++) {
                UIButton *hashtag_btn = [[UIButton alloc] init];
                [hashtag_btn setTitle:[NSString stringWithFormat:@"#%@", [[hashtags_array2 objectAtIndex:i] valueForKey:@"hashtag_name"]] forState:UIControlStateNormal];
                [hashtag_btn setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
                
                [hashtag_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                hashtag_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                
                hashtag_btn.userInteractionEnabled = YES;
                
                hashtag_btn.tag = [[[hashtags_array2 objectAtIndex:i] valueForKey:@"hashtag_id"] intValue];
                
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
    else if (tableView == usersTable) {
        UsersTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if ([usersTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [usersTable setSeparatorInset:UIEdgeInsetsZero];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CALayer *imageLayer = cell.user_photo.layer;
        [imageLayer setCornerRadius:cell.user_photo.frame.size.width/2];
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
                if (self.usersTable.dragging == NO && self.usersTable.decelerating == NO)
                {
                    [self startIconDownload:photoRecord forIndexPath:indexPath];
                }
                
                // if a download is deferred or in progress, return a placeholder image
                [cell.user_photo setBackgroundImage:[UIImage imageNamed:@"placer holder_profile photo Large.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.user_photo setBackgroundImage:photoRecord.actualPhoto forState:UIControlStateNormal];
            }
        }
        
        usersTable.backgroundColor = [UIColor clearColor];
        
        DLog(@"%@", [NSString stringWithFormat:@"%@ %@", [[usersResults objectAtIndex:indexPath.row] objectForKey:@"first_name"], [[usersResults objectAtIndex:indexPath.row] objectForKey:@"last_name"]]);
        
        //DLog(@"%@", [NSString stringWithFormat:@"%@ %@", [[usersResults objectAtIndex:indexPath.row] objectForKey:@"first_name"], [[usersResults objectAtIndex:indexPath.row] objectForKey:@"last_name"]]);
        
        cell.label_name.text = [NSString stringWithFormat:@"%@ %@", [[usersResults objectAtIndex:indexPath.row] objectForKey:@"first_name"], [[usersResults objectAtIndex:indexPath.row] objectForKey:@"last_name"]];
        [cell.btn_username setTitle:[NSString stringWithFormat:@"@%@", [[usersResults objectAtIndex:indexPath.row] objectForKey:@"username"]] forState:UIControlStateNormal];
        
        cell.user_photo.tag = [[[usersResults objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.btn_username.tag = [[[usersResults objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.addOrRemoveBtn.tag = indexPath.row;
        
        [cell.user_photo addTarget:self action:@selector(goToUserProfile:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_username addTarget:self action:@selector(goToUserProfile:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.addOrRemoveBtn setTitleEdgeInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
        
        [cell.addOrRemoveBtn addTarget:self action:@selector(followOrUnfollowUser:) forControlEvents:UIControlEventTouchDown];
        
        BOOL is_following = false;
        
        if ([[[usersResults objectAtIndex:indexPath.row] objectForKey:@"id"] intValue] != sessionUserID) {
            is_following = [[[usersResults objectAtIndex:indexPath.row] objectForKey:@"user_following_listed_user"] boolValue];
            
            cell.addOrRemoveBtn.hidden = NO;
            
            if (is_following) {
                [cell.addOrRemoveBtn setBackgroundImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateNormal];
            }
            else {
                [cell.addOrRemoveBtn setBackgroundImage:[UIImage imageNamed:@"icon_plus.png"] forState:UIControlStateNormal];
            }
        }
        else {
            cell.addOrRemoveBtn.hidden = YES;
        }
        
        [loadingData stopAnimating];
        loadingData.hidden = YES;
        
        return cell;
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
        
        //DLog(@"placer holder_profile photo Large.png %f", sessionUserID);
        
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
    
    NSInteger row = indexPath.row;
    
    if (tableView == theTable) {
        Feed *userFeedData = [userFeed objectAtIndex:row];
        
        playerScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerScreenVC"];
     
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
        
        playerScreenVC.cameFrom = @"search_results";
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
    else if (tableView == usersTable) {
        double user_id = [[[usersResults objectAtIndex:row] objectForKey:@"id"] intValue];
        
        [self goToUserProfileFromCell:user_id];
    }
    else {
        
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
                            
                            connection7 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            
                            [connection7 start];
                            
                            if (connection7) {
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
            usersTable.userInteractionEnabled = YES;
        }
        else {
            [self animateLayerToPoint: VIEW_HIDDEN];
            menuOpen = YES;
            theTable.userInteractionEnabled = NO;
            usersTable.userInteractionEnabled = NO;
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
            
            NSMutableArray *hashtags_array2 = [[NSMutableArray alloc] init];
            NSMutableArray *new_hashtags_array = [[NSMutableArray alloc] init];
            NSMutableArray *userhandles_array = [[NSMutableArray alloc] init];
            NSMutableArray *new_userhandles_array = [[NSMutableArray alloc] init];
            
            NSString *menu_search_text = [menuSearchBox.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            //if (![search_text isEqualToString:@""]) {
            if ([menu_search_text rangeOfString:@"#"].location != NSNotFound) {
                hashtags_array2 = [[menu_search_text componentsSeparatedByString: @"#"] mutableCopy];
                [hashtags_array2 removeObject:@""];
                
                int i = 0;
                
                for (NSString __strong *item in hashtags_array2) {
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
            
            if ([menu_search_text rangeOfString:@"@"].location != NSNotFound) {
                userhandles_array = [[menu_search_text componentsSeparatedByString: @"@"] mutableCopy];
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
                if ([menu_search_text rangeOfString:@"#"].location == NSNotFound) {
                    search_text = menuSearchBox.text;
                    
                    searchResultsVC.textSearch = true;
                    searchResultsVC.search_text = menu_search_text;
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

-(IBAction)toggleMenu {
    if (!menuOpen) {
        [self animateLayerToPoint:VIEW_HIDDEN];
        menuOpen = YES;
        theTable.userInteractionEnabled = NO;
        usersTable.userInteractionEnabled = NO;
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
        usersTable.userInteractionEnabled = YES;
    }
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
        
        float y_offset = offset.y;
        
        if (y_offset >= 41) {
            if (userFeed.count > 1) {
                back_btn.hidden = YES;
                
                label_search_text.hidden = YES;
                
                playAllBtn.hidden = YES;
  
                topNav.frame = CGRectMake(topNav.frame.origin.x,
                                          topNav.frame.origin.y,
                                          topNav.frame.size.width,
                                          24);
                
                subNav.frame = CGRectMake(subNav.frame.origin.x,
                                          topNav.frame.size.height,
                                          subNav.frame.size.width,
                                          subNav.frame.size.height);
                
                trendingBtn.frame = CGRectMake(trendingBtn.frame.origin.x,
                                             subNav.frame.origin.y+15,
                                             trendingBtn.frame.size.width,
                                             trendingBtn.frame.size.height);
                
                peopleBtn.frame = CGRectMake(peopleBtn.frame.origin.x,
                                               subNav.frame.origin.y+15,
                                               peopleBtn.frame.size.width,
                                               peopleBtn.frame.size.height);
                
                recentBtn.frame = CGRectMake(recentBtn.frame.origin.x,
                                               subNav.frame.origin.y+15,
                                               recentBtn.frame.size.width,
                                               recentBtn.frame.size.height);
                
                leftBorder.frame = CGRectMake(leftBorder.frame.origin.x,
                                              subNav.frame.origin.y+15,
                                              leftBorder.frame.size.width,
                                              leftBorder.frame.size.height);
                
                rightBorder.frame = CGRectMake(rightBorder.frame.origin.x,
                                              subNav.frame.origin.y+15,
                                              rightBorder.frame.size.width,
                                              rightBorder.frame.size.height);
                
                if (channelSearch) {
                    channelsView.frame = CGRectMake(channelsView.frame.origin.x, subNav.frame.origin.y+subNav.frame.size.height, channelsView.frame.size.width, channelsView.frame.size.height);
                    
                    theTable.frame = CGRectMake(self.view.bounds.origin.x, channelsView.frame.origin.y+channelsView.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-135);
                }
                else {
                    theTable.frame = CGRectMake(self.view.bounds.origin.x, subNav.frame.origin.y+subNav.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-88);
                }
            }
        }
        else {
            back_btn.hidden = NO;
            
            label_search_text.hidden = NO;
            
            playAllBtn.hidden = NO;
            
            topNav.frame = CGRectMake(topNav.frame.origin.x,
                                      topNav.frame.origin.y,
                                      topNav.frame.size.width,
                                      64);
            
            subNav.frame = CGRectMake(subNav.frame.origin.x,
                                      62,
                                      subNav.frame.size.width,
                                      subNav.frame.size.height);
            
            trendingBtn.frame = CGRectMake(trendingBtn.frame.origin.x,
                                           79,
                                           trendingBtn.frame.size.width,
                                           trendingBtn.frame.size.height);
            
            peopleBtn.frame = CGRectMake(peopleBtn.frame.origin.x,
                                           79,
                                           peopleBtn.frame.size.width,
                                           peopleBtn.frame.size.height);
            
            recentBtn.frame = CGRectMake(recentBtn.frame.origin.x,
                                           79,
                                           recentBtn.frame.size.width,
                                           recentBtn.frame.size.height);
            
            leftBorder.frame = CGRectMake(leftBorder.frame.origin.x,
                                          79,
                                          leftBorder.frame.size.width,
                                          leftBorder.frame.size.height);
            
            rightBorder.frame = CGRectMake(rightBorder.frame.origin.x,
                                           79,
                                           rightBorder.frame.size.width,
                                           rightBorder.frame.size.height);
            
            if (channelSearch) {
                channelsView.frame = CGRectMake(channelsView.frame.origin.x, 126, channelsView.frame.size.width, channelsView.frame.size.height);
                
                theTable.frame = CGRectMake(self.view.bounds.origin.x, channelsView.frame.origin.y+channelsView.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-95);
            }
            else {
                theTable.frame = CGRectMake(self.view.bounds.origin.x, subNav.frame.origin.y+subNav.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-90);
            }
        }
        
        if (y_offset > 10) { //animate top navigation bars
            channelsViewBorder.hidden = NO;
        }
        else {
            channelsViewBorder.hidden = YES;
        }
        
        float reload_distance = 0;
        
        if(y > h + reload_distance) {
            //postAmount += nextAmount;
            
            //build an info object and convert to json
            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
            
            if (isLoadingMorePosts == false) {
                isLoadingMorePosts = true;
                
                NSNumber *tempPostAmount = [[NSNumber alloc] initWithInt:postAmount];
                
                if ([userFeed count] >= (numLoadedPosts-1)) {
                    if (usersTable.hidden == YES) {
                        DLog(@"loading...");
                        
                        NSNumber *tempAfter = [[NSNumber alloc] initWithInt:after_yap];
                        
                        //DLog(@"after: %@", json);
                        
                        NSDictionary *newDatasetInfo;
                        NSError *error;
                        
                        //convert object to data
                        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                        
                        NSURL *the_url;
                        
                        if (!trendingBtn.userInteractionEnabled) {
                            //DEFAULT: Trending
                            if (hashtagSearch) {
                                if (channelSearch) {
                                    if (userSearch) {
                                        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_hashtags_and_user_handles/trending_search/"];
                                        
                                        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                          tempSessionUserID, @"user_id",
                                                          tempSessionID, @"session_id",
                                                          tempPostAmount, @"amount",
                                                          hashtags_array, @"hashtags_searched",
                                                          selectedChannels, @"channels_searched",
                                                          users, @"user_handles_searched",
                                                          tempAfter, @"after",
                                                          nil];
                                    }
                                    else {
                                        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_hashtags/trending_search/"];
                                        
                                        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                          tempSessionUserID, @"user_id",
                                                          tempSessionID, @"session_id",
                                                          tempPostAmount, @"amount",
                                                          hashtags_array, @"hashtags_searched",
                                                          selectedChannels, @"channels_searched",
                                                          tempAfter, @"after",
                                                          nil];
                                    }
                                }
                                else if (userSearch) {
                                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/hashtags_and_user_handles/trending_search/"];
                                    
                                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      tempSessionUserID, @"user_id",
                                                      tempSessionID, @"session_id",
                                                      tempPostAmount, @"amount",
                                                      hashtags_array, @"hashtags_searched",
                                                      users, @"user_handles_searched",
                                                      tempAfter, @"after",
                                                      nil];
                                }
                                else {
                                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/hashtags/trending_search/"];
                                    
                                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      tempSessionUserID, @"user_id",
                                                      tempSessionID, @"session_id",
                                                      tempPostAmount, @"amount",
                                                      hashtags_array, @"hashtags_searched",
                                                      tempAfter, @"after",
                                                      nil];
                                }
                            }
                            else if (channelSearch) {
                                if (userSearch) {
                                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_user_handles/trending_search/"];
                                    
                                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      tempSessionUserID, @"user_id",
                                                      tempSessionID, @"session_id",
                                                      tempPostAmount, @"amount",
                                                      selectedChannels, @"channels_searched",
                                                      users, @"user_handles_searched",
                                                      tempAfter, @"after",
                                                      nil];
                                }
                                else if (textSearch) {
                                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_text/trending_search/"];
                                    
                                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      tempSessionUserID, @"user_id",
                                                      tempSessionID, @"session_id",
                                                      tempPostAmount, @"amount",
                                                      selectedChannels, @"channels_searched",
                                                      search_text, @"text_searched",
                                                      tempAfter, @"after",
                                                      nil];
                                }
                                else {
                                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels/trending_search/"];
                                    
                                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      tempSessionUserID, @"user_id",
                                                      tempSessionID, @"session_id",
                                                      tempPostAmount, @"amount",
                                                      selectedChannels, @"channels_searched",
                                                      tempAfter, @"after",
                                                      nil];
                                }
                                
                            }
                            else if (userSearch) {
                                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/user_handles/trending_search/"];
                                
                                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  tempSessionUserID, @"user_id",
                                                  tempSessionID, @"session_id",
                                                  tempPostAmount, @"amount",
                                                  users, @"user_handles_searched",
                                                  tempAfter, @"after",
                                                  nil];
                            }
                            else if (textSearch) {
                                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/text/trending_search/"];
                                
                                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  tempSessionUserID, @"user_id",
                                                  tempSessionID, @"session_id",
                                                  tempPostAmount, @"amount",
                                                  search_text, @"text_searched",
                                                  tempAfter, @"after",
                                                  nil];
                            }
                        }
                        else if (!recentBtn.userInteractionEnabled) {
                            //Get Recent
                            if (hashtagSearch) {
                                if (channelSearch) {
                                    if (userSearch) {
                                        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_hashtags_and_user_handles/recent_search/"];
                                        
                                        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                          tempSessionUserID, @"user_id",
                                                          tempSessionID, @"session_id",
                                                          tempPostAmount, @"amount",
                                                          hashtags_array, @"hashtags_searched",
                                                          selectedChannels, @"channels_searched",
                                                          users, @"user_handles_searched",
                                                          nil];
                                    }
                                    else {
                                        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_hashtags/recent_search/"];
                                        
                                        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                          tempSessionUserID, @"user_id",
                                                          tempSessionID, @"session_id",
                                                          tempPostAmount, @"amount",
                                                          hashtags_array, @"hashtags_searched",
                                                          selectedChannels, @"channels_searched",
                                                          nil];
                                    }
                                }
                                else if (userSearch) {
                                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/hashtags_and_user_handles/recent_search/"];
                                    
                                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      tempSessionUserID, @"user_id",
                                                      tempSessionID, @"session_id",
                                                      tempPostAmount, @"amount",
                                                      hashtags_array, @"hashtags_searched",
                                                      users, @"user_handles_searched",
                                                      nil];
                                }
                                else {
                                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/hashtags/recent_search/"];
                                    
                                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      tempSessionUserID, @"user_id",
                                                      tempSessionID, @"session_id",
                                                      tempPostAmount, @"amount",
                                                      hashtags_array, @"hashtags_searched",
                                                      nil];
                                }
                            }
                            else if (channelSearch) {
                                if (userSearch) {
                                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_user_handles/recent_search/"];
                                    
                                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      tempSessionUserID, @"user_id",
                                                      tempSessionID, @"session_id",
                                                      tempPostAmount, @"amount",
                                                      selectedChannels, @"channels_searched",
                                                      users, @"user_handles_searched",
                                                      nil];
                                }
                                else if (textSearch) {
                                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels_and_text/recent_search/"];
                                    
                                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      tempSessionUserID, @"user_id",
                                                      tempSessionID, @"session_id",
                                                      tempPostAmount, @"amount",
                                                      selectedChannels, @"channels_searched",
                                                      search_text, @"text_searched",
                                                      nil];
                                }
                                else {
                                    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/channels/recent_search/"];
                                    
                                    newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      tempSessionUserID, @"user_id",
                                                      tempSessionID, @"session_id",
                                                      tempPostAmount, @"amount",
                                                      selectedChannels, @"channels_searched",
                                                      nil];
                                }
                                
                            }
                            else if (userSearch) {
                                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/user_handles/recent_search/"];
                                
                                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  tempSessionUserID, @"user_id",
                                                  tempSessionID, @"session_id",
                                                  tempPostAmount, @"amount",
                                                  users, @"user_handles_searched",
                                                  nil];
                            }
                            else if (textSearch) {
                                the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/explore/text/recent_search/"];
                                
                                newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  tempSessionUserID, @"user_id",
                                                  tempSessionID, @"session_id",
                                                  tempPostAmount, @"amount",
                                                  search_text, @"text_searched",
                                                  nil];
                            }
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
            }
            
            //DLog(@"num posts: %i", numLoadedPosts);
        }
    }
    else if (aScrollView == usersTable) {
        CGPoint offset = aScrollView.contentOffset;
        
        float y_offset = offset.y;
        
        if (y_offset > 10) { //animate top navigation bars
            channelsViewBorder.hidden = NO;
        }
        else {
            channelsViewBorder.hidden = YES;
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
            
            if (!self.theTable.hidden) {
                StreamCell *cell = (StreamCell *)[self.theTable cellForRowAtIndexPath:indexPath];
                
                // Display the newly loaded image
                [cell.btnUserPhoto setBackgroundImage:photoRecord.actualPhoto forState:UIControlStateNormal];
            }
            else if (!self.usersTable.hidden) {
                UsersTableCell *cell = (UsersTableCell *)[self.usersTable cellForRowAtIndexPath:indexPath];
                
                // Display the newly loaded image
                [cell.user_photo setBackgroundImage:photoRecord.actualPhoto forState:UIControlStateNormal];
            }
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
        NSArray *visiblePaths;
        
        if (!self.theTable.hidden) {
            visiblePaths = [self.theTable indexPathsForVisibleRows];
        }
        else if (!self.usersTable.hidden) {
            visiblePaths = [self.usersTable indexPathsForVisibleRows];
        }
        
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
