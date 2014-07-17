//
//  Explore.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/29/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"
#import "Feed.h"
#import "StreamCell.h"
#import "Reachability.h"
#import "SearchResults.h"
#import "MyManager.h"

@class UserProfile;
@class UserSettings;
@class UserNotifications;
@class ReportAProblem;
@class Stream;
@class DDPageControl;
@class CreateYap;

@interface Explore : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    IBOutlet UIActivityIndicatorView *loadingData;
    IBOutlet UIActivityIndicatorView *loadingMoreData;
    IBOutlet UILabel *message;
    IBOutlet UIScrollView *channelsView;
    UIView *tutorialViewWrapper;
    UIScrollView *tutorialScrollView;
    UIButton *skipAll;
    IBOutlet UIScrollView *trendingHashtags;
    IBOutlet DDPageControl *pageControl;
    DDPageControl *tutorialPageControl;
    IBOutlet UIImageView *separator;
    
    int postAmount;
    int nextAmount;
    int numLoadedPosts;
    BOOL pageControlBeingUsed;
    BOOL isFullMenu;
    BOOL playerActive;
}

@property BOOL menuOpen;
@property(retain, nonatomic)MyManager *sharedManager;
@property(retain, nonatomic)Feed *userFeedObject;
@property(retain, nonatomic)StreamCell *streamCell;
@property(retain, nonatomic)UserSettings *UserSettingsVC;
@property(retain, nonatomic)ReportAProblem *ReportAProblemVC;
@property(retain, nonatomic)UserProfile *UserProfileVC;
@property(retain, nonatomic)Stream *streamVC;
@property(retain, nonatomic)SearchResults *searchResultsVC;
@property(retain, nonatomic)PlayerScreen *playerScreenVC;
@property(retain, nonatomic)Playlist *playlistVC;
@property(retain, nonatomic)Explore *ExploreVC;
@property(retain, nonatomic)CreateYap *createYapVC;
@property(retain, nonatomic)IBOutlet UIButton *menuSearchCancelButton;
@property(retain, nonatomic)IBOutlet UITextField *menuSearchBox;
@property(retain, nonatomic)NSTimer *timer;
@property(retain, nonatomic)IBOutlet UITableView *theTable;
@property (strong, nonatomic) IBOutlet UITableView *menuTable;
@property (nonatomic, strong) NSMutableDictionary *channelImagesUnclicked;
@property (nonatomic, strong) NSMutableDictionary *channelImagesClicked;
@property (strong, nonatomic) NSArray *menuKeys;
@property (strong, nonatomic) NSMutableArray *selectedChannels;
@property (strong, nonatomic) NSDictionary *menuItems;
@property (nonatomic) IBOutlet UIView *topLayer;
@property (nonatomic) CGFloat layerPosition;
@property(retain, nonatomic)IBOutlet UILabel *noMorePostsMessage;
@property(retain, nonatomic)NSArray *json;
@property(retain, nonatomic)NSString *responseBody;
@property(retain, nonatomic)NSString *responseBodyHashtags;
@property(retain, nonatomic)NSMutableArray *userFeed;
@property(retain, nonatomic)IBOutlet UIButton *searchButton;
@property(retain, nonatomic)IBOutlet UIButton *cancelButton;
@property(retain, nonatomic)IBOutlet UITextField *searchBox;
@property(retain, nonatomic)NSURLConnection *connection1;
@property(retain, nonatomic)NSURLConnection *connection2;
@property(retain, nonatomic)NSURLConnection *connection3;
@property(retain, nonatomic)NSURLConnection *connection4;
@property(retain, nonatomic)NSURLConnection *connection5;
@property(retain, nonatomic)NSURLConnection *connection6;

-(IBAction)toggleMenu;
-(IBAction)showCancelButton:(id)sender;
-(IBAction)cancelSearch:(id)sender;
-(IBAction)doSearch:(id)sender;
-(IBAction)goToYapScreen:(id)sender;
-(IBAction)changePage;
-(void)closeTutorial;
-(IBAction)searchHashtag:(id)sender;

@end
