//
//  Listeners.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/25/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "Listeners.h"
#import "UserProfile.h"
#import "SearchResults.h"
#import "UserSettings.h"
#import "UserNotifications.h"
#import "AppPhotoRecord.h"
#import "IconDownloader.h"

@interface Listeners ()

@end

@implementation Listeners

@synthesize usersTable;
@synthesize the_user;
@synthesize follower_count;
@synthesize last_user_id;
@synthesize UserProfileVC;
@synthesize json;
@synthesize responseBodyFollowers;
@synthesize userFollowers;
@synthesize connection1;
@synthesize connection3;
@synthesize pendingOperations;
@synthesize photos;
@synthesize records;
@synthesize menuOpen;
@synthesize sharedManager;
@synthesize streamVC;
@synthesize searchResultsVC;
@synthesize UserSettingsVC;
@synthesize ReportAProblemVC;
@synthesize playerScreenVC;
@synthesize ExploreVC;
@synthesize menuSearchCancelButton;
@synthesize menuSearchBox;
@synthesize menuTable;
@synthesize menuKeys;
@synthesize menuItems;
@synthesize topLayer;
@synthesize layerPosition;
@synthesize isLoadingMorePosts;
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
	
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    sharedManager = [MyManager sharedManager];
    
    userFollowers = [[NSMutableArray alloc] init];
    
    postAmount = 10; //default, inital
    nextAmount = 15; //next amount
    numLoadedPosts = 0;
    
    usersTable.hidden = YES;
    
    records = [NSMutableArray array];
    
    photos = [[NSMutableArray alloc] init];
    
    self.workingArray = [NSMutableArray array];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    label_follower_count.text = [NSString stringWithFormat:@"%.0f", follower_count];
    [label_follower_count sizeToFit];
    label_follower_count.frame = CGRectMake(label_follower_count.frame.origin.x, label_follower_count.frame.origin.y+9, label_follower_count.frame.size.width, label_follower_count.frame.size.height);
    
    CGFloat constrainedWidth = 280.0f;
    CGSize sizeOfText;
    
    sizeOfText = [[NSString stringWithFormat:@"%f", follower_count] sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:16] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)];
    
    label_followers.frame = CGRectMake(label_follower_count.frame.size.width+20, label_followers.frame.origin.y, label_followers.frame.size.width, label_followers.frame.size.height);
    
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
    
    NSString *path;
    
    if (sharedManager.sessionCurrentPlayingYap != nil && sharedManager.sessionCurrentPlayingYap.count > 0) {
        //1
        path = [[NSBundle mainBundle] pathForResource:@"menulist" ofType:@"plist"];
        isFullMenu = true;
    }
    else {
        //1
        path = [[NSBundle mainBundle] pathForResource:@"menulist2" ofType:@"plist"];
        isFullMenu = false;
    }
    
    
    //2
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    self.menuItems = dict;
    
    //3
    NSArray *array = [[menuItems allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.menuKeys = array;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    /*
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
     */
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (userFollowers.count == 0) {
        loadingData.hidden = NO;
        [loadingData startAnimating];
        
        //get User Following data
        //build an info object and convert to json
        NSNumber *tempUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempProfileUserID = [[NSNumber alloc] initWithDouble:the_user];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        NSNumber *tempAmount = [[NSNumber alloc] initWithInt:postAmount];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempUserID, @"user_id",
                                        tempProfileUserID, @"profile_user_id",
                                        tempSessionID, @"session_id",
                                        tempAmount, @"amount",
                                        nil];
        
        NSError *error;
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/followers/"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:the_url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBodyFollowers = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
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
        }
        else {
            //Error
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[self cancelAllOperations];
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection1) {
        NSData *data = [responseBodyFollowers dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableArray *json_followers = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (json_followers.count > 0) {
            for (int i = 0; i < json_followers.count; i++) {
                NSArray *an_array = [[json_followers objectAtIndex:i] objectForKey:@"user"];

                [userFollowers addObject:an_array];
                
                last_user_id = [[[json_followers objectAtIndex:i] objectForKey:@"follower_request_id"] doubleValue];
            
                self.workingEntry = [[AppPhotoRecord alloc] init];
                
                if (![[an_array valueForKey:@"profile_cropped_picture_path"] isKindOfClass:[NSNull class]] && ![[an_array valueForKey:@"profile_cropped_picture_path"] isEqualToString:@""]) {
                    
                    if (self.workingEntry)
                    {
                        NSString *bucket = @"yapsterapp";
                        S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
                        
                        //get profile photo
                        S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
                        gpsur_cropped_photo.key     = [an_array valueForKey:@"profile_cropped_picture_path"];
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
            
            [usersTable reloadData];
            usersTable.hidden = NO;
            
            isLoadingMorePosts = false;
            
            numLoadedPosts = numLoadedPosts+postAmount;
            
            [loadingData stopAnimating];
            loadingData.hidden = YES;
        }
        else {
            if (numLoadedPosts < postAmount) {
                message.text = @"No users.";
                message.hidden = NO;
                
                usersTable.hidden = YES;
                
                [loadingData stopAnimating];
                loadingData.hidden = YES;
            }
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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

-(IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)goToUserProfile:(id)sender {
    UIButton *button = sender;
    int user_id = button.tag;
    
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
            usersTable.userInteractionEnabled = YES;
        }
        else {
            [self animateLayerToPoint: VIEW_HIDDEN];
            menuOpen = YES;
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
        //[self cancelAllOperations];
        
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

-(IBAction)toggleMenu {
    if (!menuOpen) {
        [self animateLayerToPoint:VIEW_HIDDEN];
        menuOpen = YES;
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
    if (aScrollView == usersTable) {
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
            NSNumber *tempUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
            NSNumber *tempProfileUserID = [[NSNumber alloc] initWithDouble:the_user];
            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
            
            if (isLoadingMorePosts == false) {
                isLoadingMorePosts = true;
                
                NSNumber *tempAmount = [[NSNumber alloc] initWithInt:postAmount];
                
                if ([userFollowers count] >= (numLoadedPosts-1)) {
                    DLog(@"loading...");
                    
                    NSNumber *tempAfter = [[NSNumber alloc] initWithInt:last_user_id];
                    
                    //DLog(@"after: %@", json);
                    
                    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                    tempUserID, @"user_id",
                                                    tempProfileUserID, @"profile_user_id",
                                                    tempSessionID, @"session_id",
                                                    tempAmount, @"amount",
                                                    tempAfter, @"after",
                                                    nil];
                    
                    NSError *error;
                    
                    //convert object to data
                    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                    
                    NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/followers/"];
                    
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                    [request setURL:the_url];
                    [request setHTTPMethod:@"POST"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    [request setHTTPBody:jsonData];
                    
                    NSHTTPURLResponse* urlResponse = nil;
                    
                    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                    
                    responseBodyFollowers = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    
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
                        
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if (tableView == usersTable) {
        return 1;
    }
    else {
        return [menuKeys count];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == usersTable) {
        return [userFollowers count];
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
    
    if (tableView == usersTable) {
        rowHeight = 95;
    }
    else {
        rowHeight = 52;
    }
    
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";

    UsersTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tableView == usersTable) {
        //NSNumber *user_id = [[NSNumber alloc] initWithInt:[[[userFollowers objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        if ([usersTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [usersTable setSeparatorInset:UIEdgeInsetsZero];
        }
        
        CALayer *imageLayer = cell.user_photo.layer;
        [imageLayer setCornerRadius:cell.user_photo.frame.size.width/2];
        [imageLayer setBorderWidth:0.0];
        [imageLayer setMasksToBounds:YES];
        
        // add a placeholder cell while waiting on table data
        NSUInteger nodeCount = [self.user_photo_entries count];
        
        //DLog(@"nodeCount %lu, user_photo_entries.count %lu", (unsigned long)nodeCount, (unsigned long)user_photo_entries.count);
        
        if (nodeCount > 0 && user_photo_entries.count == nodeCount)
        {
            AppPhotoRecord *photoRecord = [self.user_photo_entries objectAtIndex:indexPath.row];
            
            //DLog(@"indexPath.row %i, photoRecord.imageURLString %@", indexPath.row, photoRecord.imageURLString);
            
            // Only load cached images; defer new downloads until scrolling ends
            if (!photoRecord.actualPhoto)
            {
                if (usersTable.dragging == NO && usersTable.decelerating == NO)
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
        
        cell.label_name.text = [NSString stringWithFormat:@"%@ %@", [[userFollowers objectAtIndex:indexPath.row] objectForKey:@"first_name"], [[userFollowers objectAtIndex:indexPath.row] objectForKey:@"last_name"]];
        [cell.btn_username setTitle:[NSString stringWithFormat:@"@%@", [[userFollowers objectAtIndex:indexPath.row] objectForKey:@"username"]] forState:UIControlStateNormal];
        
        cell.user_photo.tag = [[[userFollowers objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.btn_username.tag = [[[userFollowers objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        
        [cell.user_photo addTarget:self action:@selector(goToUserProfile:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_username addTarget:self action:@selector(goToUserProfile:) forControlEvents:UIControlEventTouchUpInside];
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
    
    if (tableView == usersTable) {
        NSInteger row = indexPath.row;
        
        double user_id = [[[userFollowers objectAtIndex:row] objectForKey:@"id"] intValue];
        
        [self goToUserProfileFromCell:user_id];
    }
    else {
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
            
            UsersTableCell *cell = (UsersTableCell *)[self.usersTable cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            [cell.user_photo setBackgroundImage:photoRecord.actualPhoto forState:UIControlStateNormal];
            
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
        NSArray *visiblePaths = [self.usersTable indexPathsForVisibleRows];
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
