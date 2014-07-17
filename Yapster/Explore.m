//
//  Explore.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/29/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "Explore.h"
#import "UserSettings.h"
#import "UserNotifications.h"
#import "Stream.h"
#import "DDPageControl.h"

@interface Explore ()

@end

@implementation Explore

@synthesize menuOpen;
@synthesize sharedManager;
@synthesize userFeedObject;
@synthesize streamCell;
@synthesize theTable;
@synthesize menuTable;
@synthesize menuKeys;
@synthesize menuItems;
@synthesize selectedChannels;
@synthesize UserSettingsVC;
@synthesize userFeed;
@synthesize ReportAProblemVC;
@synthesize streamVC;
@synthesize searchResultsVC;
@synthesize UserProfileVC;
@synthesize playerScreenVC;
@synthesize playlistVC;
@synthesize ExploreVC;
@synthesize createYapVC;
@synthesize menuSearchCancelButton;
@synthesize menuSearchBox;
@synthesize channelImagesUnclicked;
@synthesize channelImagesClicked;
@synthesize timer;
@synthesize noMorePostsMessage;
@synthesize topLayer;
@synthesize layerPosition;
@synthesize json;
@synthesize responseBody;
@synthesize responseBodyHashtags;
@synthesize searchButton;
@synthesize cancelButton;
@synthesize searchBox;
@synthesize connection1;
@synthesize connection2;
@synthesize connection3;
@synthesize connection4;
@synthesize connection5;
@synthesize connection6;

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
	
    loadingData.hidden = YES;
    pageControl.hidden = YES;
    theTable.scrollEnabled = YES;
    pageControlBeingUsed = NO;
    
    trendingHashtags.frame = CGRectMake(trendingHashtags.frame.origin.x, 415, trendingHashtags.frame.size.width, trendingHashtags.frame.size.height);
    
    theTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, theTable.bounds.size.width, 0.01f)];
    
    pageControl = [[DDPageControl alloc] init];
    
    channelImagesUnclicked = [[NSMutableDictionary alloc] init];
    channelImagesClicked = [[NSMutableDictionary alloc] init];
    selectedChannels = [[NSMutableArray alloc] init];
    
    separator.hidden = NO;
    
    searchBox.delegate = self;
    menuSearchBox.delegate = self;
    
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        channelsView.frame = CGRectMake(0, 128, 320, 220);
        separator.frame = CGRectMake(0, 370, 320, 1);
    }
    else {
        channelsView.frame = CGRectMake(0, 128, 320, 300);
        separator.frame = CGRectMake(0, 470, 320, 1);
    }
    
    channelsView.showsHorizontalScrollIndicator = NO;
    channelsView.showsVerticalScrollIndicator = NO;
    
    UIView *leftFieldSearchBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    UIView *rightFieldSearchBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 0)];
    
    searchBox.leftViewMode = UITextFieldViewModeAlways;
    searchBox.leftView     = leftFieldSearchBox;
    searchBox.rightViewMode = UITextFieldViewModeAlways;
    searchBox.rightView    = rightFieldSearchBox;
    
    //search box placeholder color
    if ([searchBox respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        searchBox.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search Yapster" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
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
    
    //load channels
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not load channels." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else {
        if (sharedManager.sessionChannels.count == 0) {
            //build an info object and convert to json
            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
            
            NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            tempSessionUserID, @"user_id",
                                            tempSessionID, @"session_id",
                                            nil];
            
            __block NSError *error;
            
            //convert object to data
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/explore/channels/load/"];
            
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
                        
                    }
                    else {
                        //Error
                    }
                });
            });
        }
        else {
            DLog(@"%@", sharedManager.sessionChannels);
            
            if (sharedManager.sessionChannels.count > 0) {
                UIView *channel;
                UIButton *channel_pic;
                UILabel *channel_name;
                
                NSString *icon_explore_path_unclicked;
                NSString *icon_explore_path_clicked;
                
                int channel_id = 0;
                int last_view_position_x = 0;
                int last_view_position_y = 20;
                int channel_width = 80;
                int channel_height = 80;
                
                for (int i = 0; i < sharedManager.sessionChannels.count; i++) {
                    icon_explore_path_unclicked = [[sharedManager.sessionChannels objectAtIndex:i] objectForKey:@"icon_explore_path_unclicked"];
                    icon_explore_path_clicked = [[sharedManager.sessionChannels objectAtIndex:i] objectForKey:@"icon_explore_path_clicked"];
                    channel_id = [[[sharedManager.sessionChannels objectAtIndex:i] objectForKey:@"channel_id"] intValue];
                    
                    if (i == 3 || i == 4 || i == 5) {
                        if (i == 3) {
                            last_view_position_x = 0;
                            
                            //DLog(@"%@ %i", [[json objectAtIndex:i] objectForKey:@"channel_name"], last_view_position_x);
                        }
                        
                        last_view_position_y = 120;
                    }
                    else if (i == 6 || i == 7 || i == 8) {
                        if ([[UIScreen mainScreen] bounds].size.height == 480) {
                            if (i == 6) {
                                last_view_position_x = ((channel_width+20)*3)+20;
                            }
                            
                            last_view_position_y = 20;
                        }
                        else {
                            if (i == 6) {
                                last_view_position_x = 0;
                            }
                            
                            last_view_position_y = 220;
                        }
                    }
                    else if (i == 9 || i == 10 || i == 11) {
                        if ([[UIScreen mainScreen] bounds].size.height == 480) {
                            if (i == 9) {
                                last_view_position_x = ((channel_width+20)*3)+20;
                            }
                            
                            last_view_position_y = 120;
                        }
                        else {
                            if (i == 9) {
                                last_view_position_x = ((channel_width+20)*3)+20;
                            }
                            
                            last_view_position_y = 20;
                        }
                    }
                    else if (i == 12 || i == 13 || i == 14) {
                        if ([[UIScreen mainScreen] bounds].size.height == 480) {
                            if (i == 12) {
                                last_view_position_x = ((channel_width+20)*6)+40;
                            }
                            
                            last_view_position_y = 20;
                        }
                        else {
                            if (i == 12) {
                                last_view_position_x = ((channel_width+20)*3)+20;
                            }
                            
                            last_view_position_y = 120;
                        }
                    }
                    else if (i == 15 || i == 16 || i == 17) {
                        if ([[UIScreen mainScreen] bounds].size.height == 480) {
                            if (i == 15) {
                                last_view_position_x = ((channel_width+20)*6)+40;
                            }
                            
                            last_view_position_y = 120;
                        }
                        else {
                            if (i == 15) {
                                last_view_position_x = ((channel_width+20)*3)+20;
                            }
                            
                            last_view_position_y = 220;
                        }
                    }
                    else if (i == 18 || i == 19 || i == 20) {
                        if ([[UIScreen mainScreen] bounds].size.height == 480) {
                            if (i == 18) {
                                last_view_position_x = ((channel_width+20)*9)+60;
                            }
                            
                            last_view_position_y = 20;
                        }
                        else {
                            if (i == 18) {
                                last_view_position_x = ((channel_width+20)*6)+40;
                            }
                            
                            last_view_position_y = 20;
                        }
                    }
                    else if (i == 21 || i == 22 || i == 23) {
                        if ([[UIScreen mainScreen] bounds].size.height == 480) {
                            if (i == 21) {
                                last_view_position_x = ((channel_width+20)*9)+60;
                            }
                            
                            last_view_position_y = 120;
                        }
                        else {
                            if (i == 21) {
                                last_view_position_x = ((channel_width+20)*6)+40;
                            }
                            
                            last_view_position_y = 120;
                        }
                    }
                    else {
                        last_view_position_y = 20;
                    }
                    
                    UIImage *channel_image = [[sharedManager.sessionChannels objectAtIndex:i] objectForKey:@"icon_unclicked"];
                    
                    if (channel_image != nil) {
                        [channelImagesUnclicked setObject:channel_image forKey:[NSString stringWithFormat:@"%i", channel_id]];
                        
                        DLog(@"IMAGE DATA: %@", channel_image);
                    }
                    
                    UIImage *channel_image2 = [[sharedManager.sessionChannels objectAtIndex:i] objectForKey:@"icon_clicked"];
                    
                    if (channel_image2 != nil) {
                        [channelImagesClicked setObject:channel_image2 forKey:[NSString stringWithFormat:@"%i", channel_id]];
                    }
                    
                    channel = [[UIView alloc] initWithFrame:CGRectMake(last_view_position_x+20, last_view_position_y, channel_width, channel_height)];
                    //channel.layer.borderColor = [UIColor grayColor].CGColor;
                    //channel.layer.borderWidth = 2.0f;
                    channel_pic = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, channel_width-30, channel_height-30)];
                    [channel_pic setBackgroundImage:channel_image forState:UIControlStateNormal];
                    channel_pic.tag = [[[sharedManager.sessionChannels objectAtIndex:i] objectForKey:@"channel_id"] intValue];
                    [channel_pic addTarget:self action:@selector(selectChannel:) forControlEvents:UIControlEventTouchUpInside];
                    channel_name = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, channel_width, 20)];
                    channel_name.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
                    channel_name.text = [[sharedManager.sessionChannels objectAtIndex:i] objectForKey:@"channel_name"];
                    channel_name.textAlignment = NSTextAlignmentCenter;
                    
                    [channel addSubview:channel_pic];
                    [channel addSubview:channel_name];
                    [channelsView addSubview:channel];
                    
                    last_view_position_x = last_view_position_x+(channel.frame.size.width+20);
                    
                }
                
                float channel_count = (float)sharedManager.sessionChannels.count;
                float rows = 0.0f;
                
                if ([[UIScreen mainScreen] bounds].size.height == 480) {
                    rows = channel_count / 6.0;
                }
                else {
                    rows = channel_count / 9.0;
                }
                
                DLog(@"%f", ceilf(rows));
                
                CGFloat scrollViewWidth = 0.0f;
                
                scrollViewWidth = (ceilf(rows) * 320);
                
                pageControl.numberOfPages = round(rows);
                
                channelsView.contentSize = CGSizeMake(scrollViewWidth, channelsView.frame.size.height);
                
                if ([[UIScreen mainScreen] bounds].size.height == 480) {
                    [pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-130.0f)] ;
                }
                else {
                    [pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-120.0f)] ;
                }
                
                [pageControl setCurrentPage: 0] ;
                
                [pageControl setDefersCurrentPageDisplay: YES] ;
                [pageControl setType: DDPageControlTypeOnFullOffEmpty];
                [pageControl setOnColor: [UIColor colorWithRed:21.0f/255.0f green:212.0f/255.0f blue:0.0f alpha:1.0f]];
                [pageControl setOffColor: [UIColor colorWithRed:21.0f/255.0f green:212.0f/255.0f blue:0.0f alpha:1.0f]];
                [pageControl setIndicatorDiameter: 10.0f];
                [pageControl setIndicatorSpace: 15.0f];
                [topLayer addSubview: pageControl];
                [topLayer sendSubviewToBack:pageControl];
                
                pageControl.hidden = NO;
                
                separator.hidden = NO;
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
        }
        
        //load trending hashtags
        
        //build an info object and convert to json
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        nil];
        
        __block NSError *error;
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/search/explore/top_12_popular_hashtags/"];
        
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
            
            responseBodyHashtags = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                
                if (!jsonData) {
                    DLog(@"JSON error: %@", error);
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if (sharedManager.sessionChannels.count == 0) {
        loadingData.hidden = NO;
        
        [loadingData startAnimating];
    }
    
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (exploreScreenFirstLoaded) {
        tutorialViewWrapper = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, [[UIScreen mainScreen] bounds].size.height)];
        
        UILabel *title = [[UILabel alloc] init];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            title.frame = CGRectMake(0, 20, tutorialViewWrapper.frame.size.width, 30);
        }
        else {
            title.frame = CGRectMake(0, 30, tutorialViewWrapper.frame.size.width, 30);
        }
        
        title.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
        title.text = @"How To Explore";
        title.textAlignment = NSTextAlignmentCenter;
        
        [tutorialViewWrapper addSubview:title];
        
        tutorialScrollView = [[UIScrollView alloc] init];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            tutorialScrollView.frame = CGRectMake(30, title.frame.origin.y+title.frame.size.height, 240, [[UIScreen mainScreen] bounds].size.height-90);
        }
        else {
            tutorialScrollView.frame = CGRectMake(30, title.frame.origin.y+title.frame.size.height+10, 240, [[UIScreen mainScreen] bounds].size.height-140);
        }
        
        //tutorialScrollView.center =  CGPointMake(tutorialViewWrapper.frame.size.width / 2, tutorialScrollView.frame.size.height);
        tutorialScrollView.delegate = self;
        tutorialScrollView.pagingEnabled = YES;
        tutorialScrollView.scrollEnabled = YES;
        tutorialScrollView.contentSize = CGSizeMake(tutorialScrollView.frame.size.width*2, tutorialScrollView.frame.size.height);
        
        UIImageView *first_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tutorialScrollView.frame.size.width, tutorialScrollView.frame.size.height)];
        first_image.image = [UIImage imageNamed:@"explore01.png"];
        
        UIImageView *second_image = [[UIImageView alloc] initWithFrame:CGRectMake(tutorialScrollView.frame.size.width, 0, tutorialScrollView.frame.size.width, tutorialScrollView.frame.size.height-30)];
        second_image.image = [UIImage imageNamed:@"explore02.png"];
        
        tutorialPageControl = [[DDPageControl alloc] init];
        tutorialPageControl.numberOfPages = 2;
        [tutorialPageControl setCurrentPage:0];
        [tutorialPageControl setDefersCurrentPageDisplay: YES] ;
        [tutorialPageControl setType: DDPageControlTypeOnFullOffEmpty];
        [tutorialPageControl setOnColor: [UIColor colorWithRed:21.0f/255.0f green:212.0f/255.0f blue:0.0f alpha:1.0f]];
        [tutorialPageControl setOffColor: [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
        [tutorialPageControl setIndicatorDiameter: 10.0f];
        [tutorialPageControl setIndicatorSpace: 15.0f];

        skipAll = [[UIButton alloc] init];
        [skipAll setTitle:@"Skip All" forState:UIControlStateNormal];
        [skipAll setFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];
        [skipAll setTitleColor:[UIColor colorWithRed:21.0f/255.0f green:212.0f/255.0f blue:0.0f alpha:1.0f  ] forState:UIControlStateNormal];
        skipAll.titleLabel.textAlignment = NSTextAlignmentRight;
        skipAll.userInteractionEnabled = YES;
        
        [skipAll addTarget:self action:@selector(closeTutorial) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            [tutorialPageControl setCenter: CGPointMake(tutorialViewWrapper.center.x-10, tutorialViewWrapper.bounds.size.height-20)];
            skipAll.frame = CGRectMake(tutorialScrollView.frame.size.width-35, tutorialViewWrapper.bounds.size.height-36, 60, 30);
        }
        else {
            [tutorialPageControl setCenter: CGPointMake(tutorialViewWrapper.center.x-10, tutorialViewWrapper.bounds.size.height-40)];
            skipAll.frame = CGRectMake(tutorialScrollView.frame.size.width-35, tutorialViewWrapper.bounds.size.height-56, 60, 30);
        }
        
        tutorialScrollView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
        tutorialViewWrapper.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
        
        [tutorialScrollView addSubview:first_image];
        [tutorialScrollView addSubview:second_image];
        [tutorialViewWrapper addSubview:tutorialPageControl];
        [tutorialViewWrapper addSubview:skipAll];
        [tutorialViewWrapper addSubview:tutorialScrollView];
        
        [self.view addSubview: tutorialViewWrapper];
        
        exploreScreenFirstLoaded = false;
    }
}

-(void)closeTutorial {
    [tutorialViewWrapper removeFromSuperview];
    [tutorialPageControl removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showCancelButton:(id)sender {
    cancelButton.hidden = NO;
}

-(IBAction)cancelSearch:(id)sender {
    if ([searchBox.text isEqualToString:@""]) {
        cancelButton.hidden = YES;
        [searchBox resignFirstResponder];
    }
    else {
        searchBox.text = @"";
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == searchBox) {
        cancelButton.hidden = YES;
    }
    
    [textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == menuSearchBox) {
        [self doMenuSearch:menuSearchBox];
    }
    
    [textField resignFirstResponder];
}

-(IBAction)showMenuCancelButton:(id)sender {
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

-(IBAction)doSearch:(id)sender {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *trimmedSearchTerms = [searchBox.text stringByTrimmingCharactersInSet:whitespace];
    
    NSUInteger trimmedSearchTermsLength = [trimmedSearchTerms length];
    
    if (trimmedSearchTermsLength > 0 || selectedChannels.count > 0) {
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
            
            NSString *search_text = [searchBox.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            
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
                        search_text = searchBox.text;
                        
                        searchResultsVC.textSearch = true;
                        searchResultsVC.search_text = search_text;
                    }
                }
                
                if (selectedChannels.count > 0) {
                    searchResultsVC.channelSearch = true;
                    searchResultsVC.selectedChannels = selectedChannels;
                    searchResultsVC.channelImagesClicked = channelImagesClicked;
                    searchResultsVC.channelImagesUnclicked = channelImagesUnclicked;
                }
            
            if (trimmedSearchTermsLength == 0) {
                searchResultsVC.textSearch = false;
            }
            
            searchResultsVC.search_text_for_label = searchBox.text;
            
            //}
            
            [self.navigationController pushViewController:searchResultsVC animated:YES];
        }
    }
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection1) {
        //DLog(@"RESPONSE: %@", responseBody);
        
        NSData *data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
        
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (json.count > 0) {
            UIView *channel;
            UIButton *channel_pic;
            UILabel *channel_name;
            
            NSString *icon_explore_path_unclicked;
            NSString *icon_explore_path_clicked;
            
            int channel_id = 0;
            int last_view_position_x = 0;
            int last_view_position_y = 20;
            int channel_width = 80;
            int channel_height = 80;
            
            for (int i = 0; i < json.count; i++) {
                icon_explore_path_unclicked = [[json objectAtIndex:i] objectForKey:@"icon_explore_path_unclicked"];
                icon_explore_path_clicked = [[json objectAtIndex:i] objectForKey:@"icon_explore_path_clicked"];
                channel_id = [[[json objectAtIndex:i] objectForKey:@"channel_id"] intValue];
                
                if (i == 3 || i == 4 || i == 5) {
                    if (i == 3) {
                        last_view_position_x = 0;
                        
                        //DLog(@"%@ %i", [[json objectAtIndex:i] objectForKey:@"channel_name"], last_view_position_x);
                    }
                    
                    last_view_position_y = 120;
                }
                else if (i == 6 || i == 7 || i == 8) {
                    if ([[UIScreen mainScreen] bounds].size.height == 480) {
                        if (i == 6) {
                            last_view_position_x = ((channel_width+20)*3)+20;
                        }
                        
                        last_view_position_y = 20;
                    }
                    else {
                        if (i == 6) {
                            last_view_position_x = 0;
                        }
                        
                        last_view_position_y = 220;
                    }
                }
                else if (i == 9 || i == 10 || i == 11) {
                    if ([[UIScreen mainScreen] bounds].size.height == 480) {
                        if (i == 9) {
                            last_view_position_x = ((channel_width+20)*3)+20;
                        }
                        
                        last_view_position_y = 120;
                    }
                    else {
                        if (i == 9) {
                            last_view_position_x = ((channel_width+20)*3)+20;
                        }
                        
                        last_view_position_y = 20;
                    }
                }
                else if (i == 12 || i == 13 || i == 14) {
                    if ([[UIScreen mainScreen] bounds].size.height == 480) {
                        if (i == 12) {
                            last_view_position_x = ((channel_width+20)*6)+40;
                        }
                        
                        last_view_position_y = 20;
                    }
                    else {
                        if (i == 12) {
                            last_view_position_x = ((channel_width+20)*3)+20;
                        }
                        
                        last_view_position_y = 120;
                    }
                }
                else if (i == 15 || i == 16 || i == 17) {
                    if ([[UIScreen mainScreen] bounds].size.height == 480) {
                        if (i == 15) {
                            last_view_position_x = ((channel_width+20)*6)+40;
                        }
                        
                        last_view_position_y = 120;
                    }
                    else {
                        if (i == 15) {
                            last_view_position_x = ((channel_width+20)*3)+20;
                        }
                        
                        last_view_position_y = 220;
                    }
                }
                else if (i == 18 || i == 19 || i == 20) {
                    if ([[UIScreen mainScreen] bounds].size.height == 480) {
                        if (i == 18) {
                            last_view_position_x = ((channel_width+20)*9)+60;
                        }
                        
                        last_view_position_y = 20;
                    }
                    else {
                        if (i == 18) {
                            last_view_position_x = ((channel_width+20)*6)+40;
                        }
                        
                        last_view_position_y = 20;
                    }
                }
                else if (i == 21 || i == 22 || i == 23) {
                    if ([[UIScreen mainScreen] bounds].size.height == 480) {
                        if (i == 21) {
                            last_view_position_x = ((channel_width+20)*9)+60;
                        }
                        
                        last_view_position_y = 120;
                    }
                    else {
                        if (i == 21) {
                            last_view_position_x = ((channel_width+20)*6)+40;
                        }
                        
                        last_view_position_y = 120;
                    }
                }
                else {
                    last_view_position_y = 20;
                }
                
                //load unclicked channel icon
                
                S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
                override.contentType = @"image/jpeg";
                
                NSString *bucket = @"yapsterapp";
                NSString *photo_path = icon_explore_path_unclicked;
                //NSString *photo_path = @"/yapsterusers/uid/23/yaps/5/pictures/5-big.jpg";
                
                S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
                gpsur.key     = photo_path;
                gpsur.bucket  = bucket;
                gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
                gpsur.responseHeaderOverrides = override;
                
                NSURL *url = [[AmazonClientManager s3] getPreSignedURL:gpsur];
                
                NSData *image_data = [NSData dataWithContentsOfURL : url];
                
                UIImage *channel_image = [UIImage imageWithData:image_data];
                
                if (channel_image != nil) {
                    [channelImagesUnclicked setObject:channel_image forKey:[NSString stringWithFormat:@"%i", channel_id]];
                    
                    //DLog(@"IMAGE DATA: %@", channel_image);
                }
                
                //load clicked channel icons
                
                photo_path = icon_explore_path_clicked;
                //NSString *photo_path = @"yapsterchannels/comedy/explore/comedy_explore_unclicked.png";
                
                S3GetPreSignedURLRequest *gpsur2 = [[S3GetPreSignedURLRequest alloc] init];
                gpsur2.key     = photo_path;
                gpsur2.bucket  = bucket;
                gpsur2.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
                gpsur2.responseHeaderOverrides = override;
                
                NSURL *url2 = [[AmazonClientManager s3] getPreSignedURL:gpsur2];
                
                NSData *image_data2 = [NSData dataWithContentsOfURL : url2];
                
                UIImage *channel_image2 = [UIImage imageWithData:image_data2];
                
                if (channel_image2 != nil) {
                    [channelImagesClicked setObject:channel_image2 forKey:[NSString stringWithFormat:@"%i", channel_id]];
                }
                
                channel = [[UIView alloc] initWithFrame:CGRectMake(last_view_position_x+20, last_view_position_y, channel_width, channel_height)];
                //channel.layer.borderColor = [UIColor grayColor].CGColor;
                //channel.layer.borderWidth = 2.0f;
                channel_pic = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, channel_width-30, channel_height-30)];
                [channel_pic setBackgroundImage:channel_image forState:UIControlStateNormal];
                channel_pic.tag = [[[json objectAtIndex:i] objectForKey:@"channel_id"] intValue];
                [channel_pic addTarget:self action:@selector(selectChannel:) forControlEvents:UIControlEventTouchUpInside];
                channel_name = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, channel_width, 20)];
                channel_name.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
                channel_name.text = [[json objectAtIndex:i] objectForKey:@"channel_name"];
                channel_name.textAlignment = NSTextAlignmentCenter;
                
                [channel addSubview:channel_pic];
                [channel addSubview:channel_name];
                [channelsView addSubview:channel];
                
                NSMutableDictionary *channel_data = [[NSMutableDictionary alloc] init];
                
                NSNumber *channel_id = [[NSNumber alloc] initWithInt:[[[json objectAtIndex:i] objectForKey:@"channel_id"] intValue]];
                
                [channel_data setObject:[[json objectAtIndex:i] objectForKey:@"channel_name"] forKey:@"channel_name"];
                [channel_data setObject:channel_id forKey:@"channel_id"];
                [channel_data setObject:channel_image forKey:@"icon_unclicked"];
                [channel_data setObject:channel_image2 forKey:@"icon_clicked"];
                
                [sharedManager.sessionChannels addObject:channel_data];
            
                last_view_position_x = last_view_position_x+(channel.frame.size.width+20);
                
            }
            
            float channel_count = (float)json.count;
            float rows = 0.0f;
            
            if ([[UIScreen mainScreen] bounds].size.height == 480) {
                rows = channel_count / 6.0;
            }
            else {
                rows = channel_count / 9.0;
            }
            
            DLog(@"%f", ceilf(rows));
            
            CGFloat scrollViewWidth = 0.0f;
            
            scrollViewWidth = (ceilf(rows) * 320);
            
            pageControl.numberOfPages = round(rows);
            
            channelsView.contentSize = CGSizeMake(scrollViewWidth, channelsView.frame.size.height);
            
            if ([[UIScreen mainScreen] bounds].size.height == 480) {
                [pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-130.0f)] ;
            }
            else {
                [pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-120.0f)] ;
            }
            
            [pageControl setCurrentPage: 0] ;
            
            [pageControl setDefersCurrentPageDisplay: YES] ;
            [pageControl setType: DDPageControlTypeOnFullOffEmpty];
            [pageControl setOnColor: [UIColor colorWithRed:21.0f/255.0f green:212.0f/255.0f blue:0.0f alpha:1.0f]];
            [pageControl setOffColor: [UIColor colorWithRed:21.0f/255.0f green:212.0f/255.0f blue:0.0f alpha:1.0f]];
            [pageControl setIndicatorDiameter: 10.0f];
            [pageControl setIndicatorSpace: 15.0f];
            [topLayer addSubview: pageControl];
            
            pageControl.hidden = NO;
            
            separator.hidden = NO;
        }
        else {
            message.text = @"There are no channels to load right now.";
            message.hidden = NO;
            
            menuTable.hidden = YES;
        }
        
        [loadingData stopAnimating];
        loadingData.hidden = YES;
    }
    else if (connection == connection2) {
        //DLog(@"RESPONSE HASHTAGS: %@", responseBodyHashtags);
        
        NSData *data = [responseBodyHashtags dataUsingEncoding:NSUTF8StringEncoding];
        
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        trendingHashtags.scrollEnabled = NO;
        
        if (json.count > 0) {
            //trendingHashtags.backgroundColor = [UIColor blueColor];
            
            for (int i = 0; i < json.count; i++) {
                UIButton *hashtag_btn = [[UIButton alloc] init];
                
                if (i <= 3) {
                    if (i == 0) {
                        hashtag_btn.frame = CGRectMake(10, (10), 140, 30);
                    }
                    else if (i == 1) {
                        hashtag_btn.frame = CGRectMake(10, (60), 140, 30);
                    }
                    else if (i == 2) {
                        hashtag_btn.frame = CGRectMake(170, (10), 140, 30);
                    }
                    else if (i == 3) {
                        hashtag_btn.frame = CGRectMake(170, 60, 140, 30);
                    }
                
                    [hashtag_btn setTitle:[NSString stringWithFormat:@"#%@", [[json objectAtIndex:i] objectForKey:@"hashtag_name"]] forState:UIControlStateNormal];
                    [hashtag_btn setTitleColor:[UIColor colorWithRed:21.0/255.0 green:212.0/255.0 blue:0.0f alpha:1.0f] forState:UIControlStateNormal];
                    [hashtag_btn setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
                    hashtag_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    hashtag_btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    hashtag_btn.tag = [[[json objectAtIndex:i] objectForKey:@"hashtag_id"] intValue];
                    
                    [hashtag_btn addTarget:self action:@selector(searchHashtag:) forControlEvents:UIControlEventTouchUpInside];
                    
                    trendingHashtags.contentSize = CGSizeMake(320, (i*5)+(i*30));
                    [trendingHashtags addSubview:hashtag_btn];
                }
            }
            
            if ([[UIScreen mainScreen] bounds].size.height == 480) {
                trendingHashtags.frame = CGRectMake(trendingHashtags.frame.origin.x, 375, trendingHashtags.frame.size.width, 200);
            }
            else {
                trendingHashtags.frame = CGRectMake(trendingHashtags.frame.origin.x, 475, trendingHashtags.frame.size.width, 200);
            }
        }
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

-(IBAction)selectChannel:(id)sender {
    UIButton *button = sender;
    int channel_id = button.tag;
    
    double selectedChannel = channel_id;
    
    if (![selectedChannels containsObject:[NSNumber numberWithDouble:selectedChannel]]) {
        [selectedChannels addObject:[NSNumber numberWithDouble:selectedChannel]];
        
        [button setBackgroundImage:[channelImagesClicked objectForKey:[NSString stringWithFormat:@"%i", channel_id]] forState:UIControlStateNormal];
    }
    else {
        [selectedChannels removeObject:[NSNumber numberWithDouble:selectedChannel]];
        
        [button setBackgroundImage:[channelImagesUnclicked objectForKey:[NSString stringWithFormat:@"%i", channel_id]] forState:UIControlStateNormal];
    }
}

-(IBAction)searchHashtag:(id)sender {
    UIButton *button = sender;
    NSString *hashtag_title = button.titleLabel.text;
    
    searchResultsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultsVC"];
    
    searchResultsVC.hashtagSearch = true;
    searchResultsVC.hashtags_array = [[hashtag_title componentsSeparatedByString: @"#"] mutableCopy];
    
    searchResultsVC.search_text_for_label = hashtag_title;
    
    [self.navigationController pushViewController:searchResultsVC animated:YES];
}

- (IBAction)panLayer:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged) {
        //[pageControl removeFromSuperview];
        
        CGPoint point = [pan translationInView:self.topLayer];
        CGRect frame = self.topLayer.frame;
        frame.origin.x = self.layerPosition + point.x;
        
        if (frame.origin.x < 0) frame.origin.x = 0;
        
        self.topLayer.frame = frame;
        
        //DLog(@"%f", self.topLayer.frame.origin.x);
        
        /*
        if (self.topLayer.frame.origin.x <= 160) {
            if ([[UIScreen mainScreen] bounds].size.height == 480) {
                [pageControl setCenter: CGPointMake(self.view.center.x+point.x, self.view.bounds.size.height-130.0f)] ;
            }
            else {
                [pageControl setCenter: CGPointMake(self.view.center.x+point.x, self.view.bounds.size.height-120.0f)] ;
            }
        }
        else {
            if ([[UIScreen mainScreen] bounds].size.height == 480) {
                [pageControl setCenter: CGPointMake(self.view.center.x-point.x, self.view.bounds.size.height-130.0f)] ;
            }
            else {
                [pageControl setCenter: CGPointMake(self.view.center.x-point.x, self.view.bounds.size.height-120.0f)] ;
            }
        }*/
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.topLayer.frame.origin.x <= 160) {
            /*
            if ([[UIScreen mainScreen] bounds].size.height == 480) {
                [pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-130.0f)] ;
            }
            else {
                [pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-120.0f)] ;
            }
             */
            
            [self animateLayerToPoint:0];
            menuOpen = NO;
        }
        else {
            /*
            CGPoint point = [pan translationInView:self.topLayer];
            CGRect frame = self.topLayer.frame;
            frame.origin.x = self.layerPosition + point.x;
            
            if ([[UIScreen mainScreen] bounds].size.height == 480) {
                [pageControl setCenter: CGPointMake(self.view.center.x+point.x, self.view.bounds.size.height-130.0f)] ;
            }
            else {
                [pageControl setCenter: CGPointMake(self.view.center.x+point.x, self.view.bounds.size.height-120.0f)] ;
            
            }
             */
            
            [self animateLayerToPoint: VIEW_HIDDEN];
            menuOpen = YES;
            [searchBox resignFirstResponder];
            cancelButton.hidden = YES;
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
                         if (x == 0) {
                             //[self.view addSubview: pageControl];
                         }
                     }];
}

-(IBAction)toggleMenu {
    if (!menuOpen) {
        //[pageControl removeFromSuperview];
        [self animateLayerToPoint:VIEW_HIDDEN];
        menuOpen = YES;
        [UIView animateWithDuration:0.3
                         animations:^{
                             menuSearchBox.frame = CGRectMake(menuSearchBox.frame.origin.x, menuSearchBox.frame.origin.y, 220, menuSearchBox.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        menuSearchCancelButton.hidden = YES;
        [menuSearchBox resignFirstResponder];
        [searchBox resignFirstResponder];
        channelsView.scrollEnabled = NO;
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
        channelsView.scrollEnabled = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    /*//update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = channelsView.frame.size.width;
    int page = floor((channelsView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;*/
    
    if (sender == channelsView) {
        CGFloat pageWidth = channelsView.bounds.size.width ;
        float fractionalPage = channelsView.contentOffset.x / pageWidth ;
        NSInteger nearestNumber = lround(fractionalPage) ;
        
        if (pageControl.currentPage != nearestNumber)
        {
            pageControl.currentPage = nearestNumber ;
            
            if (channelsView.dragging)
                [pageControl updateCurrentPageDisplay] ;
        }
    }
    else if (sender == tutorialScrollView) {
        CGFloat pageWidth = tutorialScrollView.bounds.size.width ;
        float fractionalPage = tutorialScrollView.contentOffset.x / pageWidth ;
        NSInteger nearestNumber = lround(fractionalPage) ;
        
        if (tutorialPageControl.currentPage != nearestNumber)
        {
            tutorialPageControl.currentPage = nearestNumber;
            
            if (tutorialPageControl.currentPage == tutorialPageControl.numberOfPages-1) {
                [skipAll setTitle:@"Done" forState:UIControlStateNormal];
            }
            else {
                [skipAll setTitle:@"Skip All" forState:UIControlStateNormal];
            }
            
            if (tutorialScrollView.dragging)
                [tutorialPageControl updateCurrentPageDisplay] ;
        }
    }
    else if (sender == menuTable) {
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

-(IBAction)changePage {
    //update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = channelsView.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = channelsView.frame.size;
    [channelsView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
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
        
        if (![userFeedData.reyap_user isKindOfClass:[NSNull class]]) {
            rowHeight = rowHeight+50;
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
        
        NSString *dateString;
        
        if ([userFeedData.reyap_user isKindOfClass:[NSNull class]]) {
            cell.reyapUserImageView.hidden = YES;
            cell.btnReyapUser.hidden = YES;
            
            dateString = [NSString stringWithFormat:@"%@", userFeedData.yap_date_created];
            
            cell.btnUserPhoto.frame = CGRectMake(15, 13, cell.btnUserPhoto.frame.size.width, cell.btnUserPhoto.frame.size.height);
            cell.name.frame = CGRectMake(87, 13, cell.name.frame.size.width, cell.name.frame.size.height);
            //cell.yapDate.frame = CGRectMake(cell.yapDate.frame.origin.x, 65, cell.yapDate.frame.size.width, cell.yapDate.frame.size.height);
            cell.username.frame = CGRectMake(87, 34, cell.username.frame.size.width, cell.username.frame.size.height);
            cell.yapTitle.frame = CGRectMake(87, 63, cell.yapTitle.frame.size.width, cell.yapTitle.frame.size.height);
            cell.btnPlay.frame = CGRectMake(15, 100, cell.btnPlay.frame.size.width, cell.btnPlay.frame.size.height);
            cell.btnReyap.frame = CGRectMake(95, 100, cell.btnReyap.frame.size.width, cell.btnReyap.frame.size.height);
            cell.btnLike.frame = CGRectMake(180, 100, cell.btnLike.frame.size.width, cell.btnLike.frame.size.height);
            cell.yapPlays.frame = CGRectMake(36, 97, cell.yapPlays.frame.size.width, cell.yapPlays.frame.size.height);
            cell.yapReyaps.frame = CGRectMake(119, 97, cell.yapReyaps.frame.size.width, cell.yapReyaps.frame.size.height);
            cell.yapLikes.frame = CGRectMake(207, 97, cell.yapLikes.frame.size.width, cell.yapLikes.frame.size.height);
            cell.yapLength.frame = CGRectMake(275, 97, cell.yapLength.frame.size.width, cell.yapLength.frame.size.height);
        }
        else {
            cell.reyapUserImageView.hidden = NO;
            cell.btnReyapUser.hidden = NO;
            
            //cell.reyapUserImageView.frame = CGRectMake(65, 16, 21, 15);
            
            //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            dateString = [NSString stringWithFormat:@"%@", userFeedData.post_date_created];
            
            cell.btnUserPhoto.frame = CGRectMake(cell.btnUserPhoto.frame.origin.x, 65, cell.btnUserPhoto.frame.size.width, cell.btnUserPhoto.frame.size.height);
            cell.name.frame = CGRectMake(cell.name.frame.origin.x, 65, cell.name.frame.size.width, cell.name.frame.size.height);
            //cell.yapDate.frame = CGRectMake(cell.yapDate.frame.origin.x, 65, cell.yapDate.frame.size.width, cell.yapDate.frame.size.height);
            cell.username.frame = CGRectMake(cell.username.frame.origin.x, 86, cell.username.frame.size.width, cell.username.frame.size.height);
            cell.yapTitle.frame = CGRectMake(cell.yapTitle.frame.origin.x, 115, cell.yapTitle.frame.size.width, cell.yapTitle.frame.size.height);
            cell.btnPlay.frame = CGRectMake(cell.btnPlay.frame.origin.x, 152, cell.btnPlay.frame.size.width, cell.btnPlay.frame.size.height);
            cell.btnReyap.frame = CGRectMake(cell.btnReyap.frame.origin.x, 152, cell.btnReyap.frame.size.width, cell.btnReyap.frame.size.height);
            cell.btnLike.frame = CGRectMake(cell.btnLike.frame.origin.x, 152, cell.btnLike.frame.size.width, cell.btnLike.frame.size.height);
            cell.yapPlays.frame = CGRectMake(cell.yapPlays.frame.origin.x, 149, cell.yapPlays.frame.size.width, cell.yapPlays.frame.size.height);
            cell.yapReyaps.frame = CGRectMake(cell.yapReyaps.frame.origin.x, 149, cell.yapReyaps.frame.size.width, cell.yapReyaps.frame.size.height);
            cell.yapLikes.frame = CGRectMake(cell.yapLikes.frame.origin.x, 149, cell.yapLikes.frame.size.width, cell.yapLikes.frame.size.height);
            cell.yapLength.frame = CGRectMake(cell.yapLength.frame.origin.x, 149, cell.yapLength.frame.size.width, cell.yapLength.frame.size.height);
            
            [cell.btnReyapUser setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cell.btnReyapUser setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
            cell.btnReyapUser.frame = CGRectMake(87, 13, 140, 21);
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
        
        //cell.yapDate.text = [NSString stringWithFormat:@"%f", userFeedData.user_post_id];
        
        /*if (![userFeedData.picture_path isKindOfClass:[NSNull class]]) {
         //get profile photo
         NSURL *userPhotoPath = [NSURL URLWithString:userFeedData.picture_path];
         
         NSData *image_data = [NSData dataWithContentsOfURL:userPhotoPath];
         UIImage *profile_image = [UIImage imageWithData:image_data];
         
         [cell.btnUserPhoto setBackgroundImage:profile_image forState:UIControlStateNormal];
         }*/
        
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
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                });
            });
        }
        
        cell.name.text = [NSString stringWithFormat:@"%@ %@", userFeedData.first_name, userFeedData.last_name];
        //cell.yapDate.text = [NSString stringWithFormat:@"%@", dateString];
        [cell.username setTitle:[NSString stringWithFormat:@"@%@", userFeedData.username] forState:UIControlStateNormal];
        cell.yapTitle.text = [NSString stringWithFormat:@"%@", userFeedData.title];
        cell.yapPlays.text = [NSString stringWithFormat:@"%d", userFeedData.listen_count];
        cell.yapReyaps.text = [NSString stringWithFormat:@"%d", userFeedData.reyap_count];
        cell.yapLikes.text = [NSString stringWithFormat:@"%d", userFeedData.like_count];
        cell.yapLength.text = [NSString stringWithFormat:@"0:%@", userFeedData.yap_length];
        //cell.yapDate.text = [NSString stringWithFormat:@"0:%f", userFeedData.yap_id];
        
        if (userFeedData.listened_by_viewer == YES) {
            [cell.btnPlay setBackgroundImage:[UIImage imageNamed:@"bttn_play grn.png"] forState:UIControlStateNormal];
        }
        
        if (userFeedData.reyapped_by_viewer == YES) {
            [cell.btnReyap setBackgroundImage:[UIImage imageNamed:@"bttn_reyap blue.png"] forState:UIControlStateNormal];
        }
        
        if (userFeedData.liked_by_viewer == YES) {
            [cell.btnLike setBackgroundImage:[UIImage imageNamed:@"bttn_like red.png"] forState:UIControlStateNormal];
        }
    }
    else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
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
                        theIconImage = [UIImage imageNamed:@"bttn_explore grn.png"];
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
        
        if (indexPath.row == 3) {
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
                            [self toggleMenu];
                            
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
}

@end
