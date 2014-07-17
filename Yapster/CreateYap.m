//
//  CreateYap.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/5/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "CreateYap.h"
#import "BucketList.h"
#import "DDPageControl.h"
#import "UserProfile.h"
#import "Stream.h"

@interface CreateYap ()

@end

@implementation CreateYap

@synthesize cropPhotoForYapVC;
@synthesize playerScreenVC;
@synthesize timer;
@synthesize timerLabel;
@synthesize usersToTag;
@synthesize channelImagesUnclicked;
@synthesize channelImagesClicked;
@synthesize yapRecorder;
@synthesize yapPlayer;
@synthesize tempRecFile;
@synthesize isNotRecording;
@synthesize channelsLoaded;
@synthesize picture_flag;
@synthesize picture_cropped_flag;
@synthesize hashtags_flag;
@synthesize user_tags_flag;
@synthesize web_link_flag;
@synthesize web_link;
@synthesize hashtags_array;
@synthesize user_tags;
@synthesize groupToAdd;
@synthesize lastAddedGroup;
@synthesize after_follower_request_id;
@synthesize isLoadingMorePosts;
@synthesize last_object_id;
@synthesize numLoadedUsers;
@synthesize counter;
@synthesize last_user_yap_id;
@synthesize deleteIntact;
@synthesize lockIntact;
@synthesize hashtags;
@synthesize link;
@synthesize yapPhoto;
@synthesize yapPhotoImg;
@synthesize createYapJson;
@synthesize json;
@synthesize userFollowers;
@synthesize userFollowing;
@synthesize fullUsersData;
@synthesize responseBodyProfile;
@synthesize responseBody;
@synthesize responseBodyFollowersAndFollowing;
@synthesize responseBodyCreateYap;
@synthesize responseBodySearchUsers;
@synthesize searchButton;
@synthesize cancelButton;
@synthesize searchBox;
@synthesize panGesture;
@synthesize connection1;
@synthesize connection2;
@synthesize connection3;
@synthesize connection4;
@synthesize connection5;
@synthesize connection6;
@synthesize audioPath;
@synthesize bigPicturePath;
@synthesize smallPicturePath;
@synthesize pendingOperations;
@synthesize photos;
@synthesize records;

#ifndef __IPHONE_7_0
typedef void (^PermissionBlock)(BOOL granted);
#endif

- (PendingOperations *)pendingOperations {
    if (!pendingOperations) {
        pendingOperations = [[PendingOperations alloc] init];
    }
    return pendingOperations;
}

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
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
	
    sessionCroppedPhoto = nil;
    sessionUnCroppedPhoto = nil;
    
    records = [NSMutableArray array];
    
    photos = [[NSMutableArray alloc] init];
    
    postAmount = 10; //default, inital
    nextAmount = 15; //next amount
    numLoadedPosts = 0;
    
    usersTable.showsVerticalScrollIndicator = NO;
    
    pageControl = [[DDPageControl alloc] init];
    
    pageControlBeingUsed = NO;
    channelsLoaded = NO;
    
    groupsView.showsHorizontalScrollIndicator = NO;
    groupsView.showsVerticalScrollIndicator = NO;
    
    channelImagesUnclicked = [[NSMutableDictionary alloc] init];
    channelImagesClicked = [[NSMutableDictionary alloc] init];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(40, 0, 0, 0);
    usersTable.contentInset = inset;
    
    userFollowing = [[NSMutableArray alloc] init];
    userFollowers = [[NSMutableArray alloc] init];
    fullUsersData = [[NSMutableArray alloc] init];
    usersToTag = [[NSMutableArray alloc] init];
    
    yapPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
    //yapPhoto.frame = CGRectMake(yapPhoto.frame.origin.x, yapPhoto.frame.origin.y, yapPhoto.frame.size.width, 143);
    
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        hashtagsView.frame = CGRectMake(hashtagsView.frame.origin.x, hashtagsView.frame.origin.y, hashtagsView.frame.size.width, 336);
        usertagsView.frame = CGRectMake(usertagsView.frame.origin.x, usertagsView.frame.origin.y, usertagsView.frame.size.width, 336);
        groupsView.frame = CGRectMake(groupsView.frame.origin.x, 65, groupsView.frame.size.width, 336);
        pageControl.frame = CGRectMake(pageControl.frame.origin.x, 360, pageControl.frame.size.width, pageControl.frame.size.height);
        linksView.frame = CGRectMake(linksView.frame.origin.x, linksView.frame.origin.y, linksView.frame.size.width, 336);
        photoView.frame = CGRectMake(photoView.frame.origin.x, photoView.frame.origin.y, linksView.frame.size.width, 336);
        usersTable.frame = CGRectMake(usersTable.frame.origin.x, usersTable.frame.origin.y, usersTable.frame.size.width, 272);
    }
    else {
        hashtagsView.frame = CGRectMake(hashtagsView.frame.origin.x, hashtagsView.frame.origin.y, hashtagsView.frame.size.width, hashtagsView.frame.size.height);
        usertagsView.frame = CGRectMake(usertagsView.frame.origin.x, usertagsView.frame.origin.y, usertagsView.frame.size.width, usertagsView.frame.size.height);
        groupsView.frame = CGRectMake(groupsView.frame.origin.x, groupsView.frame.origin.y, groupsView.frame.size.width, groupsView.frame.size.height);
        linksView.frame = CGRectMake(linksView.frame.origin.x, linksView.frame.origin.y, linksView.frame.size.width, linksView.frame.size.height);
        photoView.frame = CGRectMake(photoView.frame.origin.x, photoView.frame.origin.y, linksView.frame.size.width, linksView.frame.size.height);
        usersTable.frame = CGRectMake(usersTable.frame.origin.x, usersTable.frame.origin.y, usersTable.frame.size.width, usersTable.frame.size.height);
    }
    
    searchBox.delegate = self;
    
    UIView *leftFieldSearchBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    UIView *rightFieldSearchBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 0)];
    
    searchBox.leftViewMode = UITextFieldViewModeAlways;
    searchBox.leftView     = leftFieldSearchBox;
    searchBox.rightViewMode = UITextFieldViewModeAlways;
    searchBox.rightView    = rightFieldSearchBox;
    
    //search box placeholder color
    if ([searchBox respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        searchBox.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search Users" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    yapTitle.delegate = self;
    hashtags.delegate = self;
    link.delegate = self;
    yapBtn.adjustsImageWhenHighlighted = NO;
    
    deleteIntact = NO;
    lockIntact = NO;
    
    bottomYapOptions.scrollEnabled = YES;
    
    [bottomYapOptions setShowsHorizontalScrollIndicator:NO];
    [bottomYapOptions setShowsVerticalScrollIndicator:NO];
    
    [bottomYapOptions setContentSize:CGSizeMake(320, 63)];
    
    //check for screen height, and adjust controls as appropriate
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        yapBtn.frame = CGRectMake(yapBtn.frame.origin.x, 150, yapBtn.frame.size.width, yapBtn.frame.size.height);
        bottomYapOptions.frame = CGRectMake(bottomYapOptions.frame.origin.x, 401, bottomYapOptions.frame.size.width, bottomYapOptions.frame.size.height);
    }
    else {
        yapBtn.frame = CGRectMake(yapBtn.frame.origin.x, 212, yapBtn.frame.size.width, yapBtn.frame.size.height);
        bottomYapOptions.frame = CGRectMake(bottomYapOptions.frame.origin.x, 489, bottomYapOptions.frame.size.width, bottomYapOptions.frame.size.height);
    }
    
    isNotRecording = YES;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    [audioSession setActive:YES error:nil];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"VoiceFile"];
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatAppleIMA4],
                                    AVFormatIDKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    [NSNumber numberWithInt: 1],
                                    AVNumberOfChannelsKey,
                                    AVAudioQualityMin,
                                    AVEncoderAudioQualityKey,
                                    nil];
    
    tempRecFile = [NSURL fileURLWithPath:soundFilePath];
    
    yapRecorder = [[AVAudioRecorder alloc] initWithURL:tempRecFile settings:recordSettings error:nil];
    
    [yapRecorder setDelegate:self];
    [yapRecorder prepareToRecord];
    
    bottomYapOptions.hidden = YES;
    
    //get last user yap id
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    
    NSError *error;
    
    //call user profile info
    NSDictionary *profileDataInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     tempSessionUserID, @"user_id",
                                     tempSessionID, @"session_id",
                                     tempSessionUserID, @"profile_user_id",
                                     nil];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:profileDataInfo options:kNilOptions  error:&error];
    
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/profile/info/"];
    
    NSMutableURLRequest *request_info = [[NSMutableURLRequest alloc] init];
    [request_info setURL:the_url];
    [request_info setHTTPMethod:@"POST"];
    [request_info setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request_info setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request_info setHTTPBody:jsonData];
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request_info returningResponse: &urlResponse error: &error];
    
    responseBodyProfile = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    if (!jsonData) {
        DLog(@"JSON error: %@", error);
    }
    
    connection5 = [[NSURLConnection alloc] initWithRequest:request_info delegate:self];
    
    [connection5 start];
    
    if (connection5) {
        
    }
    else {
        //Error
    }
    
}

-(BOOL)validateUrl:(NSString *)candidate {
    /*
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];*/
    
    BOOL is_valid = false;
    
    if ([candidate rangeOfString:@"http://"].location != NSNotFound || [candidate rangeOfString:@"https://"].location != NSNotFound || [candidate rangeOfString:@"www."].location != NSNotFound) {
        is_valid = true;
    }
    
    return is_valid;
}

-(IBAction)postYap:(id)sender {
    if (lockIntact) {
        [yapRecorder pause];
        
        yapBtn.enabled = YES;
        playBtn.hidden = NO;
        lockIntact = NO;
        
        [currentTime setTextColor:[UIColor whiteColor]];
        
        UIImage *btnImage = [UIImage imageNamed:@"bttn_Yap Origi.png"];
        [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        btnImage = [UIImage imageNamed:@"bttn_lock.png"];
        [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        [self.timer invalidate];
    }
    
    self.view.userInteractionEnabled = NO;
    self.view.alpha = 0.5f;
    
    [yapTitle resignFirstResponder];
    
    loadingData.frame = CGRectMake(loadingData.frame.origin.x, 60, loadingData.frame.size.width, loadingData.frame.size.height);
    
    loadingData.hidden = NO;
    [loadingData startAnimating];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        
        NSString *bucketName1 = [NSString stringWithFormat:@"yapsterapp"];
        
        
        //get new user yap id
        
        S3ListObjectsRequest  *listObjectRequest = [[S3ListObjectsRequest alloc] initWithName:bucketName1];
        listObjectRequest.prefix = [NSString stringWithFormat:@"yapsterusers/uid/%0.0f/yaps/", sessionUserID];
        
        S3ListObjectsResponse *listObjectResponse = [[AmazonClientManager s3] listObjects:listObjectRequest];
        if(listObjectResponse.error != nil)
        {
            DLog(@"Error: %@", listObjectResponse.error);
            [objects addObject:@"Unable to load objects!"];
        }
        else
        {
            S3ListObjectsResult *listObjectsResults = listObjectResponse.listObjectsResult;
            
            if (objects == nil) {
                objects = [[NSMutableArray alloc] initWithCapacity:[listObjectsResults.objectSummaries count]];
            }
            else {
                [objects removeAllObjects];
            }
            
            // By default, listObjects will only return 1000 keys
            // This code will fetch all objects in bucket.
            // NOTE: This could cause the application to run out of memory
            NSString *lastKey = @"";
            for (S3ObjectSummary *objectSummary in listObjectsResults.objectSummaries) {
                [objects addObject:[objectSummary key]];
                lastKey = [objectSummary key];
            }
            
            while (listObjectsResults.isTruncated) {
                listObjectRequest = [[S3ListObjectsRequest alloc] initWithName:bucketName1];
                listObjectRequest.marker = lastKey;
                
                listObjectResponse = [[AmazonClientManager s3] listObjects:listObjectRequest];
                if(listObjectResponse.error != nil)
                {
                    DLog(@"Error: %@", listObjectResponse.error);
                    [objects addObject:@"Unable to load objects!"];
                    
                    break;
                }
                
                listObjectsResults = listObjectResponse.listObjectsResult;
                
                for (S3ObjectSummary *objectSummary in listObjectsResults.objectSummaries) {
                    [objects addObject:[objectSummary key]];
                    lastKey = [objectSummary key];
                }
            }
        }
        
        //DLog(@"OBJECT COUNT: %lu", (unsigned long)[objects count]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (([objects count]+1)==1) {
                user_yap_id = [objects count]+1;
            }
            else {
                user_yap_id = ([objects count]/3)+1;
            }
            
            user_yap_id = last_user_yap_id+1;
            
            //save yap data
        
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
            if (networkStatus == NotReachable) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"We could not create your yap at this time. Try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 [alert show];
            }
            else {
                audioPath = [NSString stringWithFormat:@"yapsterusers/uid/%0.0f/yaps/%0.0f/audio/%0.0f", sessionUserID, user_yap_id, user_yap_id];
                bigPicturePath = [NSString stringWithFormat:@"yapsterusers/uid/%0.0f/yaps/%0.0f/pictures/%0.0f-big.jpg", sessionUserID, user_yap_id, user_yap_id];
                smallPicturePath = [NSString stringWithFormat:@"yapsterusers/uid/%0.0f/yaps/%0.0f/pictures/%0.0f-cropped.jpg", sessionUserID, user_yap_id, user_yap_id];
                
                //build an info object and convert to json
                NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
                NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
                
                NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                
                NSString *trimmedYapTitle = [yapTitle.text stringByTrimmingCharactersInSet:whitespace];
                NSUInteger trimmedYapTitleLength = [trimmedYapTitle length];
                NSNumber *yap_length = [[NSNumber alloc] initWithInt:self.counter];
                web_link = [link.text stringByTrimmingCharactersInSet:whitespace];
                NSUInteger trimmedWebLinkLength = [web_link length];
                
                if (links_edited == true && trimmedWebLinkLength > 0 && ![web_link isEqualToString:@"http://"] && ![web_link isEqualToString:@"https://"]) {
                    web_link_flag = true;
                }
                else {
                    web_link_flag = false;
                }
                
                NSString *picture_cropped_path;
                
                if (sessionCroppedPhoto != nil) {
                    picture_cropped_flag = true;
                 }
                else {
                    picture_cropped_flag = false;
                }
                
                picture_cropped_path = smallPicturePath;
                
                NSString *picture_path;
                
                if (sessionUnCroppedPhoto != nil) {
                    picture_flag = true;
                }
                else {
                    picture_flag = false;
                }
                
                picture_path = bigPicturePath;
                
                NSString *hashtags_text = hashtags.text;
                NSUInteger hashtagsLength = [hashtags_text length];
                
                hashtags_array = [[NSMutableArray alloc] init];
                
                if (hashtags_edited == true && hashtagsLength > 0) {
                    hashtags_flag = true;
                    NSString *hashtags_text = [hashtags.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    hashtags_array = [[hashtags_text componentsSeparatedByString: @"#"] mutableCopy];
                    [hashtags_array removeObject:@""];
                }
                else {
                    hashtags_flag = false;
                    //hashtags_array = nil;
                }
                
                user_tags = [[NSArray alloc] init];
                
                if ([usersToTag count] > 0) {
                    user_tags_flag = true;
                    user_tags = usersToTag;
                }
                else {
                    user_tags_flag = false;
                    //user_tags = nil;
                }
                
                NSString *audio_path = audioPath;
                
                NSNumber *channel_id = [NSNumber alloc];
                
                if (groupToAdd != 0) {
                    channel_id = [NSNumber numberWithInt:groupToAdd];
                }
                else {
                    channel_id = [NSNumber numberWithInt:0];
                }
                
                if (yap_title_edited == false || trimmedYapTitleLength == 0 || [yapTitle.text isEqualToString:@"Title of Yap"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a yap title." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                    
                    self.view.userInteractionEnabled = YES;
                    self.view.alpha = 1.0f;
                    
                    [loadingData stopAnimating];
                    loadingData.hidden = YES;
                }
                else if (links_edited == true > 0 && ![self validateUrl:web_link]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Please enter a valid URL for the link. e.g.: 'http://example.com' or 'www.example.com'." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                    
                    self.view.userInteractionEnabled = YES;
                    self.view.alpha = 1.0f;
                    
                    [loadingData stopAnimating];
                    loadingData.hidden = YES;
                }
                else {
                    
                    //store audio file
                    NSString *bucketName = [NSString stringWithFormat:@"yapsterapp"];
                    
                    NSData *data = [NSData dataWithContentsOfURL:tempRecFile];
                    
                    S3PutObjectRequest *request = [[S3PutObjectRequest alloc] initWithKey:audioPath inBucket:bucketName];
                    
                    request.contentType = @"audio/mpeg";
                    request.data = data;
                    
                    S3PutObjectResponse *response = [[AmazonClientManager s3] putObject:request];
                    
                    if (response.error != nil) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"We could not create your yap at this time. Try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        [alert show];
                        
                        self.view.userInteractionEnabled = YES;
                        self.view.alpha = 1.0f;
                        
                        [loadingData stopAnimating];
                        loadingData.hidden = YES;
                    }
                    else {
                        //store yap photo
                        
                        NSString *bucketName = [NSString stringWithFormat:@"yapsterapp"];
                        
                        NSData *data;
                        NSData *data2;
                        
                        //first store big photo
                        
                        if (sessionUnCroppedPhoto != nil) {
                            data = [NSData dataWithData:UIImageJPEGRepresentation(sessionUnCroppedPhoto, 0.1)];
                        }
                        else {
                            data = [NSData dataWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"placer holder_profile photo Large.png"], 0.1)];
                        }
                        
                        S3PutObjectRequest *request_big_photo = [[S3PutObjectRequest alloc] initWithKey:bigPicturePath inBucket:bucketName];
                        
                        request_big_photo.contentType = @"image/jpeg";
                        
                        request_big_photo.data = data;
                        
                        S3PutObjectResponse *response = [[AmazonClientManager s3] putObject:request_big_photo];
                        
                        if (response.error != nil) {
                            DLog(@"Error: %@", response.error);
                        }
                        
                        //then store cropped photo

                        if (sessionCroppedPhoto != nil) {
                            data2 = [NSData dataWithData:UIImageJPEGRepresentation(sessionCroppedPhoto, 0.1)];
                        }
                        else {
                            data2 = [NSData dataWithData:UIImageJPEGRepresentation([UIImage imageNamed:@"placer holder_profile photo Large.png"], 0.1)];
                        }
                        
                        S3PutObjectRequest *request_small_photo = [[S3PutObjectRequest alloc] initWithKey:smallPicturePath inBucket:bucketName];
                        
                        request_small_photo.contentType = @"image/jpeg";
                        
                        request_small_photo.data = data2;
                        
                        S3PutObjectResponse *response2 = [[AmazonClientManager s3] putObject:request_small_photo];
                        
                        if (response2.error != nil) {
                            DLog(@"Error: %@", response2.error);
                        }
                        
                
                        /*DLog(@"Title: %@", yapTitle.text);
                        DLog(@"yap_length %@", yap_length);
                        DLog(@"web_link %@", web_link);
                        DLog(@"web_link_flag %hhd", web_link_flag);
                        DLog(@"picture_flag %hhd", picture_flag);
                        DLog(@"picture_path %@", picture_path);
                        DLog(@"picture_cropped_flag %hhd", picture_cropped_flag);
                        DLog(@"picture_cropped_path %@", picture_cropped_path);
                        DLog(@"hashtags_flag %hhd", hashtags_flag);
                        DLog(@"hashtags_array %@", hashtags_array);
                        DLog(@"user_tags_flag %hhd", user_tags_flag);
                        DLog(@"user_tags %@", user_tags);
                        DLog(@"audio_path %@", audio_path);
                        DLog(@"channel_id %@", channel_id);*/
                        
                        NSNumber *tempWebLinkFlag = [[NSNumber alloc] initWithBool:web_link_flag];
                        NSNumber *tempPictureFlag = [[NSNumber alloc] initWithBool:picture_flag];
                        NSNumber *tempPictureCroppedFlag = [[NSNumber alloc] initWithBool:picture_cropped_flag];
                        NSNumber *tempHashtagsFlag = [[NSNumber alloc] initWithBool:hashtags_flag];
                        NSNumber *tempUserTagsFlag = [[NSNumber alloc] initWithBool:user_tags_flag];
                        
                        NSDictionary *newDatasetInfo;
                        
                        newDatasetInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          tempSessionUserID, @"user_id",
                                          tempSessionID, @"session_id",
                                          yapTitle.text, @"title",
                                          yap_length, @"length",
                                          audio_path, @"audio_path",
                                          nil];
                        
                        if (web_link_flag) {
                            [newDatasetInfo setValue:tempWebLinkFlag forKey:@"web_link_flag"];
                            [newDatasetInfo setValue:web_link forKey:@"web_link"];
                        }
                        
                        if (picture_flag) {
                            [newDatasetInfo setValue:tempPictureFlag forKey:@"picture_flag"];
                            [newDatasetInfo setValue:picture_path forKey:@"picture_path"];
                        }
                        
                        if (picture_cropped_flag) {
                            [newDatasetInfo setValue:tempPictureCroppedFlag forKey:@"picture_cropped_flag"];
                            [newDatasetInfo setValue:picture_cropped_path forKey:@"picture_cropped_path"];
                        }
                        
                        if (hashtags_flag) {
                            [newDatasetInfo setValue:tempHashtagsFlag forKey:@"hashtags_flag"];
                            [newDatasetInfo setValue:hashtags_array forKey:@"hashtags"];
                        }
                        
                        if (user_tags_flag) {
                            [newDatasetInfo setValue:tempUserTagsFlag forKey:@"user_tags_flag"];
                            [newDatasetInfo setValue:user_tags forKey:@"user_tags"];
                        }
                        
                        if (channel_id != [NSNumber numberWithInt:0]) {
                            NSNumber *tempChannelFlag = [[NSNumber alloc] initWithBool:true];
                            
                            [newDatasetInfo setValue:tempChannelFlag forKey:@"channel_flag"];
                            [newDatasetInfo setValue:channel_id forKey:@"channel_id"];
                        }
                        
                        /*if (channel_id != [NSNumber numberWithInt:0]) {
                            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        yapTitle.text, @"title",
                                        yap_length, @"length",
                                        web_link, @"web_link",
                                        tempWebLinkFlag, @"web_link_flag",
                                        tempPictureFlag, @"picture_flag",
                                        picture_path, @"picture_path",
                                        tempPictureCroppedFlag, @"picture_cropped_flag",
                                        picture_cropped_path, @"picture_cropped_path",
                                        tempHashtagsFlag, @"hashtags_flag",
                                        hashtags_array, @"hashtags",
                                        tempUserTagsFlag, @"user_tags_flag",
                                        user_tags, @"user_tags",
                                        audio_path, @"audio_path",
                                        channel_id, @"channel_id",
                                        nil];
                        }
                        else {
                            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              tempSessionUserID, @"user_id",
                                              tempSessionID, @"session_id",
                                              yapTitle.text, @"title",
                                              yap_length, @"length",
                                              web_link, @"web_link",
                                              tempWebLinkFlag, @"web_link_flag",
                                              tempPictureFlag, @"picture_flag",
                                              picture_path, @"picture_path",
                                              tempPictureCroppedFlag, @"picture_cropped_flag",
                                              picture_cropped_path, @"picture_cropped_path",
                                              tempHashtagsFlag, @"hashtags_flag",
                                              hashtags_array, @"hashtags",
                                              tempUserTagsFlag, @"user_tags_flag",
                                              user_tags, @"user_tags",
                                              audio_path, @"audio_path",
                                              nil];
                        }*/
        
                        NSError *error;
                        
                        //convert object to data
                        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                        
                        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/create/"];
                        
                        NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] init];
                        [request2 setURL:the_url];
                        [request2 setHTTPMethod:@"POST"];
                        [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                        [request2 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [request2 setHTTPBody:jsonData];
                        
                        NSHTTPURLResponse* urlResponse = nil;
                        
                        NSData *returnData = [NSURLConnection sendSynchronousRequest: request2 returningResponse: &urlResponse error: &error];
                        
                        responseBodyCreateYap = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                        
                        if (!jsonData) {
                            DLog(@"JSON error: %@", error);
                        }
                        else {
                            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                            DLog(@"JSON: %@", JSONString);
                        }
                        
                        connection4 = [[NSURLConnection alloc] initWithRequest:request2 delegate:self];
                        
                        [connection4 start];
                        
                        if (connection4) {
                            
                        }
                        else {
                            //Error
                        }
                    
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    }
                }
            }
        });
    });
}

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    DLog(@"didReceiveResponse called: %@", response);
}

-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data
{
    DLog(@"didReceiveData called");
}

-(void)request:(AmazonServiceRequest *)request didSendData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    DLog(@"didSendData called: %d - %d / %d", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    DLog(@"didFailWithError called: %@", error);
}

-(IBAction)yap_title_edited:(id)sender {
    if ([yapTitle.text isEqualToString:@"Title of Yap"]) {
        yapTitle.text = @"";
    }
    
    yap_title_edited = true;
}

-(IBAction)hashtags_edited:(id)sender {
    hashtags_edited = true;
}

-(IBAction)links_edited:(id)sender {
    links_edited = true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = 0;
    
    if (textField == hashtags) {
        newLength = [textField.text length] + [string length] - range.length;
        
        return (newLength > 30) ? NO : YES;
    }
    else if (textField == yapTitle) {
        newLength = [textField.text length] + [string length] - range.length;
        
        return (newLength > 100) ? NO : YES;
    }
    
    return (newLength > 30) ? NO : YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (yapScreenFirstLoaded) {
        tutorialViewWrapper = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, [[UIScreen mainScreen] bounds].size.height)];
        
        title = [[UILabel alloc] init];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            title.frame = CGRectMake(0, 20, tutorialViewWrapper.frame.size.width, 30);
        }
        else {
            title.frame = CGRectMake(0, 30, tutorialViewWrapper.frame.size.width, 30);
        }
        
        title.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
        title.text = @"WHAT'S A YAP AND HOW?";
        title.textAlignment = NSTextAlignmentCenter;
        
        [tutorialViewWrapper addSubview:title];
        
        tutorialScrollView = [[UIScrollView alloc] init];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            tutorialScrollView.frame = CGRectMake(30, title.frame.origin.y+title.frame.size.height, 240, [[UIScreen mainScreen] bounds].size.height-80);
        }
        else {
            tutorialScrollView.frame = CGRectMake(30, title.frame.origin.y+title.frame.size.height+10, 240, [[UIScreen mainScreen] bounds].size.height-140);
        }
        
        //tutorialScrollView.center =  CGPointMake(tutorialViewWrapper.frame.size.width / 2, tutorialScrollView.frame.size.height);
        tutorialScrollView.delegate = self;
        tutorialScrollView.pagingEnabled = YES;
        tutorialScrollView.scrollEnabled = YES;
        tutorialScrollView.contentSize = CGSizeMake(tutorialScrollView.frame.size.width*3, tutorialScrollView.frame.size.height);
        
        UIImageView *first_image = [[UIImageView alloc] init];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            first_image.frame = CGRectMake(0, 0, tutorialScrollView.frame.size.width, tutorialScrollView.frame.size.height);
        }
        else {
            first_image.frame = CGRectMake(0, 0, tutorialScrollView.frame.size.width, tutorialScrollView.frame.size.height-40);
        }
        
        first_image.image = [UIImage imageNamed:@"yap01.png"];
        
        UIImageView *second_image = [[UIImageView alloc] init];
        
        second_image.frame = CGRectMake(tutorialScrollView.frame.size.width, 0, tutorialScrollView.frame.size.width, tutorialScrollView.frame.size.height);
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            second_image.frame = CGRectMake(tutorialScrollView.frame.size.width, 0, tutorialScrollView.frame.size.width, tutorialScrollView.frame.size.height);
        }
        else {
            second_image.frame = CGRectMake(tutorialScrollView.frame.size.width, 0, tutorialScrollView.frame.size.width, tutorialScrollView.frame.size.height);
        }
        
        second_image.image = [UIImage imageNamed:@"yap02.png"];
        
        UIImageView *third_image = [[UIImageView alloc] initWithFrame:CGRectMake(tutorialScrollView.frame.size.width*2, 0, tutorialScrollView.frame.size.width, tutorialScrollView.frame.size.height)];
        third_image.image = [UIImage imageNamed:@"yap03.png"];
        
        tutorialPageControl = [[DDPageControl alloc] init];
        tutorialPageControl.numberOfPages = 3;
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
        
        tutorialScrollView.backgroundColor = [UIColor whiteColor];
        tutorialViewWrapper.backgroundColor = [UIColor whiteColor];
        
        [tutorialScrollView addSubview:first_image];
        [tutorialScrollView addSubview:second_image];
        [tutorialScrollView addSubview:third_image];
        [tutorialViewWrapper addSubview:tutorialPageControl];
        [tutorialViewWrapper addSubview:skipAll];
        [tutorialViewWrapper addSubview:tutorialScrollView];
        
        [self.view addSubview: tutorialViewWrapper];
        
        yapScreenFirstLoaded = false;
    }
}

-(void)closeTutorial {
    [tutorialViewWrapper removeFromSuperview];
    [tutorialPageControl removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    if (sessionCroppedPhoto != nil) {
        yapPhoto.image = sessionCroppedPhoto;
    }
    
    //DLog(@"%@", yapPhotoImg);
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    NSFileManager *fileHandler = [NSFileManager defaultManager];
    [fileHandler removeItemAtPath:tempRecFile error:nil];
    yapRecorder = nil;
    tempRecFile = nil;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
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
        
        self.photos = [[NSMutableArray alloc] init];
        self.records = [[NSMutableArray alloc] init];
        
        [self cancelAllOperations];
        
        fullUsersData = [[NSMutableArray alloc] init];
    }
    else {
        searchBox.text = @"";
    }
}

-(IBAction)searchUsers:(id)sender {
    NSString *search_text = [searchBox.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (![search_text isEqualToString:@""]) {
        NSMutableArray *userhandles_array = [[NSMutableArray alloc] init];
        
        BOOL userSearch = false;
        BOOL textSearch = false;
        
        if ([search_text rangeOfString:@"@"].location != NSNotFound) {
            userhandles_array = [[search_text componentsSeparatedByString: @"@"] mutableCopy];
            [userhandles_array removeObject:@""];
            
            userSearch = true;
            textSearch = false;
        }
        else {
            userSearch = false;
            
            search_text = searchBox.text;
            
            textSearch = true;
        }
        
        //build an info object and convert to json
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        NSNumber *tempPostAmount = [[NSNumber alloc] initWithDouble:postAmount];
        
        NSDictionary *newDatasetInfo;
        
        NSError *error;
        
        //convert object to data
        
        NSURL *the_url;
        
        if (userSearch) {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/yap/user_handles/people_search/"];
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              userhandles_array, @"user_handles_searched",
                              nil];
        }
        else if (textSearch) {
            the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/search/yap/text/people_search/"];
            
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
        
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBodySearchUsers = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
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
            self.photos = [[NSMutableArray alloc] init];
            self.records = [[NSMutableArray alloc] init];
            fullUsersData = [[NSMutableArray alloc] init];
            [self cancelAllOperations];
            numLoadedPosts = 0;
            usersTable.hidden = YES;
            
            loadingData.hidden = NO;
            
            [loadingData startAnimating];
        }
        else {
            //Error
        }
    }
    
    [searchBox resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == searchBox) {
        [self searchUsers:searchBox];
    }
    
    [textField resignFirstResponder];
    
    return NO;
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    createYapJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection5) { //date for last user yap id
        NSData *data = [responseBodyProfile dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *json_profile = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //DLog(@"%@", json_profile);
        
        NSMutableArray *last_user_yap_id_array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (json_profile.count > 0) {
            last_user_yap_id_array = [json_profile objectForKey:@"last_user_yap_id"];
            
            DLog(@"last_user_yap_id_array %@", last_user_yap_id_array);
            
            if (![last_user_yap_id_array isKindOfClass:[NSNull class]] && [last_user_yap_id_array count] > 0) {
                last_user_yap_id = [[[last_user_yap_id_array objectAtIndex:0] objectForKey:@"user_yap_id"] doubleValue];
            }
            
            //DLog(@"USER YAP ID: %f", last_user_yap_id);
        }
        else {
            last_user_yap_id = 0;
        }
    }
    else if (connection == connection1) { //data for "Tag Users" table
        DLog(@"%@", json);
        
        NSData *data = [responseBodyFollowersAndFollowing dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableArray *json_following_and_followers = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
        
        if (json_following_and_followers.count > 0) {
            for (int i = 0; i < json_following_and_followers.count; i++) {
                NSString *relationship_type = [[json_following_and_followers objectAtIndex:i] objectForKey:@"relationship_type"];

                NSArray *an_array;
                
                NSSet *uniqueUsers;
                
                if ([relationship_type isEqualToString:@"follower"]) {
                    uniqueUsers = [NSSet setWithArray:[json_following_and_followers valueForKey:@"user"]];
                    an_array = [NSMutableArray arrayWithArray:[uniqueUsers allObjects]];
                }
                else if ([relationship_type isEqualToString:@"following"]) {
                    uniqueUsers = [NSSet setWithArray:[json_following_and_followers valueForKey:@"user_requested"]];
                    an_array = [NSMutableArray arrayWithArray:[uniqueUsers allObjects]];
                }
                
                [fullUsersData addObject:an_array];
                    
                after_follower_request_id = [[[json_following_and_followers objectAtIndex:i] objectForKey:@"follower_request_id"] intValue];
                
                DLog(@"%@", fullUsersData);
                
                NSString *profile_picture_path = [[fullUsersData objectAtIndex:i] objectForKey:@"profile_picture_path"];
                NSString *profile_cropped_picture_path = [[fullUsersData objectAtIndex:i] objectForKey:@"profile_cropped_picture_path"];
                
                if (![profile_picture_path isEqualToString:@""]) {
                    //get cropped user profile photo
                    NSString *bucket = @"yapsterapp";
                    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
                    
                    //get profile photo
                    S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
                    gpsur_cropped_photo.key     = profile_cropped_picture_path;
                    gpsur_cropped_photo.bucket  = bucket;
                    gpsur_cropped_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
                    gpsur_cropped_photo.responseHeaderOverrides = override;
                    
                    NSURL *url_cropped_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_cropped_photo];
                    
                    //NSData *data_cropped_photo = [NSData dataWithContentsOfURL:url_cropped_photo];
                    
                    //UIImage *cropped_photo = [UIImage imageWithData:data_cropped_photo];
                    
                    NSURL *datasourceURL = url_cropped_photo;
                    NSURLRequest *request = [NSURLRequest requestWithURL:datasourceURL];
                    
                    AFHTTPRequestOperation *datasource_download_operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                    
                    [datasource_download_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        PhotoRecord *record = [[PhotoRecord alloc] init];
                        record.URL = datasourceURL;
                        record.name = @"";
                        [records addObject:record];
                        record = nil;
                        
                        self.photos = records;
                        
                        [usersTable reloadData];
                        //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    }];
                    
                    [self.pendingOperations.downloadQueue addOperation:datasource_download_operation];
                }
                else {
                    NSURL *datasourceURL = [NSURL URLWithString:@"http://i.imgur.com/HHL5lOB.jpg"];
                    NSURLRequest *request = [NSURLRequest requestWithURL:datasourceURL];
                    
                    AFHTTPRequestOperation *datasource_download_operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                    
                    [datasource_download_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        PhotoRecord *record = [[PhotoRecord alloc] init];
                        record.URL = datasourceURL;
                        record.name = @"";
                        [records addObject:record];
                        record = nil;
                        
                        self.photos = records;
                        
                        [usersTable reloadData];
                        //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    }];
                    
                    [self.pendingOperations.downloadQueue addOperation:datasource_download_operation];
                }
            }
            
            loadingData.hidden = YES;
            [loadingData stopAnimating];
            
            usersTable.hidden = NO;
            [usersTable reloadData];
        }
        else {
            loadingData.hidden = YES;
            [loadingData stopAnimating];
            
            //message.text = @"No users to tag.";
            //message.hidden = NO;
        }
    }
    /*
    else if (connection == connection2) {
        NSData *data = [responseBodyFollowing dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableArray *json_following = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (json_following.count > 0) {
            for (int i = 0; i < json_following.count; i++) {
                NSArray *an_array = [[json_following objectAtIndex:i] objectForKey:@"user_requested"];
                
                [userFollowing addObject:an_array];
            }
            
            NSMutableArray *followers_data;
            NSMutableArray *following_data;
            
            if (userFollowers.count > 0) {
                for (int x = 0; x < userFollowers.count; x++) {
                    followers_data = [userFollowers objectAtIndex:x];
                    
                    [fullUsersData addObject:followers_data];
                }
            }
            
            if (userFollowing.count > 0) {
                for (int y = 0; y < userFollowing.count; y++) {
                    following_data = [userFollowing objectAtIndex:y];
                    
                    if (![fullUsersData containsObject:following_data]) {
                        [fullUsersData addObject:following_data];
                    }
                }
            }
            
            if (fullUsersData.count == 0) {
                message.text = @"No users to tag.";
                message.hidden = NO;
                
                usersTable.hidden = YES;
            }
            else {
                //last_object_id = [fullUsersData lastObject];
                
                [usersTable reloadData];
                usersTable.hidden = NO;
            }
            
            [loadingData stopAnimating];
            loadingData.hidden = YES;
        }
    }*/
    else if (connection == connection3) {   
        NSData *data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
        
        json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if (json.count > 0) {
            UIView *channel;
            UIButton *channel_pic;
            UILabel *channel_name;
            
            NSString *icon_yap_path_unclicked;
            NSString *icon_yap_path_clicked;
            
            int channel_id = 0;
            int last_view_position_x = 0;
            int last_view_position_y = 0;
            int channel_width = 80;
            int channel_height = 80;
            
            for (int i = 0; i < json.count; i++) {
                icon_yap_path_unclicked = [[json objectAtIndex:i] objectForKey:@"icon_yap_path_unclicked"];
                icon_yap_path_clicked = [[json objectAtIndex:i] objectForKey:@"icon_yap_path_clicked"];
                channel_id = [[[json objectAtIndex:i] objectForKey:@"channel_id"] intValue];
                
                if (i == 3 || i == 4 || i == 5) {
                    if (i == 3) {
                        last_view_position_x = 0;
                    }
                    
                    last_view_position_y = 120;
                }
                else if (i == 6 || i == 7 || i == 8) {
                    if (i == 6) {
                        last_view_position_x = 0;
                    }
                    
                    last_view_position_y = 220;
                }
                else if (i == 9 || i == 10 || i == 11) {
                    if (i == 9) {
                        last_view_position_x = ((channel_width+20)*3)+20;
                    }
                    
                    last_view_position_y = 20;
                }
                else if (i == 12 || i == 13 || i == 14) {
                    if (i == 12) {
                        last_view_position_x = ((channel_width+20)*3)+20;
                    }
                    
                    last_view_position_y = 120;
                }
                else if (i == 15 || i == 16 || i == 17) {
                    if (i == 15) {
                        last_view_position_x = ((channel_width+20)*3)+20;
                    }
                    
                    last_view_position_y = 220;
                }
                else if (i == 18 || i == 19 || i == 20) {
                    if (i == 18) {
                        last_view_position_x = ((channel_width+20)*6)+40;
                    }
                    
                    last_view_position_y = 20;
                }
                else if (i == 21 || i == 22 || i == 23) {
                    if (i == 21) {
                        last_view_position_x = ((channel_width+20)*6)+40;
                    }
                    
                    last_view_position_y = 120;
                }
                else {
                    last_view_position_y = 20;
                }
                
                //load unclicked channel icons
                
                S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
                override.contentType = @"image/jpeg";
                
                NSString *bucket = @"yapsterapp";
                NSString *photo_path = icon_yap_path_unclicked;
                //NSString *photo_path = @"yapsterchannels/comedy/explore/comedy_explore_unclicked.png";
                
                S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
                gpsur.key     = photo_path;
                gpsur.bucket  = bucket;
                gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
                gpsur.responseHeaderOverrides = override;
                
                NSURL *url = [[AmazonClientManager s3] getPreSignedURL:gpsur];
                
                NSData *image_data = [NSData dataWithContentsOfURL : url];
                
                UIImage *channel_image = [UIImage imageWithData:image_data];
                
                //DLog(@"channel name: %@", [[json objectAtIndex:i] objectForKey:@"channel_name"]);
                
                if (channel_image != nil) {
                    [channelImagesUnclicked setObject:channel_image forKey:[NSString stringWithFormat:@"%i", channel_id]];
                }
                
                //load clicked channel icons

                photo_path = icon_yap_path_clicked;
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
                [channel_pic addTarget:self action:@selector(addGroup:) forControlEvents:UIControlEventTouchUpInside];
                channel_name = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, channel_width, 20)];
                channel_name.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
                channel_name.text = [[json objectAtIndex:i] objectForKey:@"channel_name"];
                channel_name.textColor = [UIColor whiteColor];
                channel_name.textAlignment = NSTextAlignmentCenter;
                
                [channel addSubview:channel_pic];
                [channel addSubview:channel_name];
                [groupsView addSubview:channel];
                
                last_view_position_x = last_view_position_x+(channel.frame.size.width+20);
            }
            
            float channel_count = (float)json.count;
            float rows = channel_count / 9.0;
            
            //DLog(@"%f", ceilf(rows));
            
            CGFloat scrollViewWidth = 0.0f;
            
            scrollViewWidth = (ceilf(rows) * 320);
            
            pageControl.numberOfPages = round(rows);
            
            groupsView.contentSize = CGSizeMake(scrollViewWidth, groupsView.frame.size.height);
            
            [pageControl setCenter: CGPointMake(self.view.center.x, self.view.bounds.size.height-100.0f)] ;
            [pageControl setCurrentPage: 0] ;
            
            [pageControl setDefersCurrentPageDisplay: YES] ;
            [pageControl setType: DDPageControlTypeOnFullOffEmpty];
            [pageControl setOnColor: [UIColor whiteColor]];
            [pageControl setOffColor: [UIColor whiteColor]];
            [pageControl setIndicatorDiameter: 10.0f];
            [pageControl setIndicatorSpace: 15.0f];
            [self.view addSubview: pageControl];
            
            pageControl.hidden = NO;
            
            [loadingData stopAnimating];
            loadingData.hidden = YES;
            
            channelsLoaded = YES;
        }
        else {
            message.text = @"There are no channels to load right now.";
            message.hidden = NO;
        }
    }
    else if (connection == connection4) {
        NSData *data = [responseBodyCreateYap dataUsingEncoding:NSUTF8StringEncoding];
        
        createYapJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", createYapJson);
        
        if (![createYapJson isKindOfClass:[NSNull class]]) {
            BOOL valid = [[createYapJson objectForKey:@"valid"] boolValue];
            //double new_yap_id = [[createYapJson objectForKey:@"Yap_id"] doubleValue];
            
            if (valid == true) {
                /*playerScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerScreenVC"];
                
                NSMutableArray *new_hashtags_array = [[NSMutableArray alloc] init];
                NSMutableDictionary *new_hashtags_dic = [[NSMutableDictionary alloc] init];
                
                for (NSString *item in hashtags_array) {
                    [new_hashtags_dic setObject:item forKey:@"hashtag_name"];
                    [new_hashtags_array addObject:new_hashtags_dic];
                }
                
                playerScreenVC.reyap_username_value = @"";
                playerScreenVC.cameFrom = @"create_yap";
                playerScreenVC.yap_to_play = new_yap_id;
                playerScreenVC.object_type = @"yap";       
                playerScreenVC.reyappedByViewer = false;
                playerScreenVC.user_id = sessionUserID;
                playerScreenVC.yap_audio_path = audioPath; 
                playerScreenVC.yap_picture_flag = picture_flag;
                playerScreenVC.yap_picture_path = bigPicturePath;
                playerScreenVC.yap_picture_cropped_flag = picture_cropped_flag;
                playerScreenVC.yap_picture_cropped_path = smallPicturePath;
                playerScreenVC.web_link_flag = web_link_flag;
                playerScreenVC.web_link = web_link;
                playerScreenVC.name_value = [NSString stringWithFormat:@"%@ %@", sessionFirstName, sessionLastName];
                playerScreenVC.username_value = [NSString stringWithFormat:@"@%@", sessionUsername];
                playerScreenVC.yap_title_value = [NSString stringWithFormat:@"%@", yapTitle.text];
                playerScreenVC.hashtags_flag = hashtags_flag;
                playerScreenVC.hashtags_array = hashtags_array;
                playerScreenVC.user_tags_flag = user_tags_flag;
                playerScreenVC.userstag_array = user_tags;
                playerScreenVC.yap_date_value = @"Just now";
                playerScreenVC.yap_plays_value = 1;
                playerScreenVC.yap_reyaps_value = 0;
                playerScreenVC.yap_likes_value = 0;
                playerScreenVC.yap_length_value = self.counter;
                playerScreenVC.cameFromYapScreen = true;
                
                //Push to controller
                [self.navigationController pushViewController:playerScreenVC animated:YES];*/
                
                UserProfile *userProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
                
                userProfileVC.userToView = sessionUserID;
                userProfileVC.cameFromMenu = YES;
                
                //Push to controller
                [self.navigationController pushViewController:userProfileVC animated:YES];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"We could not create your yap at this time. Try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                
                self.view.userInteractionEnabled = YES;
                self.view.alpha = 1.0f;
                
                [loadingData stopAnimating];
                loadingData.hidden = YES;
            }
        }
        else {
            
        }
    }
    else if (connection == connection6) {
        //DLog(@"%@", responseBodySearchUsers);
        
        NSData *data = [responseBodySearchUsers dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableArray *json_following_and_followers = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        
        if (json_following_and_followers.count > 0) {
            for (int i = 0; i < json_following_and_followers.count; i++) {
                //NSString *relationship_type = [[json_following_and_followers objectAtIndex:i] objectForKey:@"relationship_type"];
                
                NSArray *an_array;
                
                an_array = [json_following_and_followers objectAtIndex:i];
                
                [fullUsersData addObject:an_array];
                
                after_follower_request_id = [[[json_following_and_followers objectAtIndex:i] objectForKey:@"follower_request_id"] intValue];
                
                NSString *profile_picture_path = [[fullUsersData objectAtIndex:i] objectForKey:@"profile_picture_path"];
                NSString *profile_cropped_picture_path = [[fullUsersData objectAtIndex:i] objectForKey:@"profile_cropped_picture_path"];
                
                if (![profile_picture_path isEqualToString:@""]) {
                    //get cropped user profile photo
                    NSString *bucket = @"yapsterapp";
                    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
                    
                    //get profile photo
                    S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
                    gpsur_cropped_photo.key     = profile_cropped_picture_path;
                    gpsur_cropped_photo.bucket  = bucket;
                    gpsur_cropped_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
                    gpsur_cropped_photo.responseHeaderOverrides = override;
                    
                    NSURL *url_cropped_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_cropped_photo];
                    
                    //NSData *data_cropped_photo = [NSData dataWithContentsOfURL:url_cropped_photo];
                    
                    //UIImage *cropped_photo = [UIImage imageWithData:data_cropped_photo];
                    
                    NSURL *datasourceURL = url_cropped_photo;
                    NSURLRequest *request = [NSURLRequest requestWithURL:datasourceURL];
                    
                    AFHTTPRequestOperation *datasource_download_operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                    
                    [datasource_download_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        PhotoRecord *record = [[PhotoRecord alloc] init];
                        record.URL = datasourceURL;
                        record.name = @"";
                        [records addObject:record];
                        record = nil;
                        
                        self.photos = records;
                        
                        [usersTable reloadData];
                        //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    }];
                    
                    [self.pendingOperations.downloadQueue addOperation:datasource_download_operation];
                }
                else {
                    NSURL *datasourceURL = [NSURL URLWithString:@"http://i.imgur.com/HHL5lOB.jpg"];
                    NSURLRequest *request = [NSURLRequest requestWithURL:datasourceURL];
                    
                    AFHTTPRequestOperation *datasource_download_operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                    
                    [datasource_download_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        PhotoRecord *record = [[PhotoRecord alloc] init];
                        record.URL = datasourceURL;
                        record.name = @"";
                        [records addObject:record];
                        record = nil;
                        
                        self.photos = records;
                        
                        [usersTable reloadData];
                        //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    }];
                    
                    [self.pendingOperations.downloadQueue addOperation:datasource_download_operation];
                }
            }
            
            loadingData.hidden = YES;
            [loadingData stopAnimating];
            
            usersTable.hidden = NO;
            [usersTable reloadData];
        }
        else {
            loadingData.hidden = YES;
            [loadingData stopAnimating];
            
            //message.text = @"No users to tag.";
            //message.hidden = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if (aScrollView == groupsView) {
        /*//update the page when more than 50% of the previous/next page is visible
        CGFloat pageWidth = groupsView.frame.size.width;
        int page = floor((groupsView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        pageControl.currentPage = page;*/
        
        CGFloat pageWidth = groupsView.bounds.size.width ;
        float fractionalPage = groupsView.contentOffset.x / pageWidth ;
        NSInteger nearestNumber = lround(fractionalPage) ;
        
        if (pageControl.currentPage != nearestNumber)
        {
            pageControl.currentPage = nearestNumber ;
            
            // if we are dragging, we want to update the page control directly during the drag
            if (groupsView.dragging)
                [pageControl updateCurrentPageDisplay] ;
        }
    }
    else if (aScrollView == tutorialScrollView) {
        CGFloat pageWidth = tutorialScrollView.bounds.size.width ;
        float fractionalPage = tutorialScrollView.contentOffset.x / pageWidth ;
        NSInteger nearestNumber = lround(fractionalPage) ;
        
        if (tutorialPageControl.currentPage != nearestNumber)
        {
            tutorialPageControl.currentPage = nearestNumber;
            
            if (tutorialPageControl.currentPage == tutorialPageControl.numberOfPages-1) {
                title.text = @"Features of The Yap";
                [skipAll setTitle:@"Done" forState:UIControlStateNormal];
            }
            else if (tutorialPageControl.currentPage == tutorialPageControl.numberOfPages-2) {
                title.text = @"";
                [skipAll setTitle:@"Skip All" forState:UIControlStateNormal];
            }
            else {
                title.text = @"WHAT'S A YAP AND HOW?";
                [skipAll setTitle:@"Skip All" forState:UIControlStateNormal];
            }
            
            if (tutorialScrollView.dragging)
                [tutorialPageControl updateCurrentPageDisplay] ;
        }
    }
    else if (aScrollView == usersTable) {
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
            NSNumber *tempAfter = [[NSNumber alloc] initWithDouble:after_follower_request_id];
            
            if (isLoadingMorePosts == false) {
                isLoadingMorePosts = true;
                
                NSNumber *tempAmount = [[NSNumber alloc] initWithInt:postAmount];
                
                if ([fullUsersData count] >= (numLoadedUsers-1)) {
                    DLog(@"loading...");
                    
                    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                    tempSessionUserID, @"user_id",
                                                    tempSessionID, @"session_id",
                                                    tempSessionUserID, @"follower_request_id",
                                                    tempAmount, @"amount",
                                                    tempAfter, @"after",
                                                    nil];
                    
                    NSError *error;
                    
                    //convert object to data
                    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
                    
                    NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/following_and_followers/"];
                    
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                    [request setURL:the_url];
                    [request setHTTPMethod:@"POST"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    [request setHTTPBody:jsonData];
                    
                    NSHTTPURLResponse* urlResponse = nil;
                    
                    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
                    
                    responseBodyFollowersAndFollowing = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                    
                    //int responseCode = [urlResponse statusCode];
                    
                    if (!jsonData) {
                        DLog(@"JSON error: %@", error);
                    }
                    else {
                        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                        DLog(@"JSON: %@", JSONString);
                    }
                    
                    //connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                    
                    //[connection1 start];
                    
                    /*
                    if (connection1) {
                        loadingData.hidden = NO;
                        
                        [loadingData startAnimating];
                    }
                    else {
                        //Error
                    }
                     */
                }
            }
            
            //DLog(@"num posts: %i", numLoadedPosts);
        }
    }
}

-(IBAction)changePage {
    //update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = groupsView.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = groupsView.frame.size;
    [groupsView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
    
    [self suspendAllOperations];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
    
    [self loadImagesForOnscreenCells];
    [self resumeAllOperations];
}

-(IBAction)goBack:(id)sender {
    if (yapPlayer.playing) {
        [yapPlayer stop];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Start Recording Yap

-(void)startRecording {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    [audioSession setActive:YES error:nil];
    
    [yapRecorder record];
}

-(IBAction)playback:(id)sender {
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [audioSession setActive:YES error:nil];
    
    yapPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tempRecFile error:nil];
    [yapPlayer prepareToPlay];
    yapPlayer.volume = 1;
    [yapPlayer setDelegate:self];
    playBtn.hidden = YES;
    stopBtn.hidden = NO;
    yapBtn.enabled = NO;
    [yapPlayer play];
}

-(IBAction)stopYap:(id)sender {
    playBtn.hidden = NO;
    stopBtn.hidden = YES;
    yapBtn.enabled = YES;
    [yapPlayer stop];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    playBtn.hidden = NO;
    stopBtn.hidden = YES;
    
    if (self.counter < 40) {
        yapBtn.enabled = YES;
    }
}

- (void)incrementCounter {
    self.counter++;
    deleteIntact = NO;
    lockIntact = YES;
    
    if (self.counter == 1) {
        pressAndHoldTutorialLabel.hidden = YES;
        
        controlsView.hidden = NO;
        deleteBtn.hidden = NO;
        lockBtn.hidden = NO;
        
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragGesture:)];
        [yapBtn addGestureRecognizer:panGesture];
        
        [yapBtn setUserInteractionEnabled:YES];
    }
    
    if (self.counter <= 40) {
        if (self.counter < 10) {
            currentTime.text = [NSString stringWithFormat:@"00:0%i", self.counter];
        }
        else {
            currentTime.text = [NSString stringWithFormat:@"00:%i", self.counter];
            
            if (self.counter >= 30) {
                [currentTime setTextColor:[UIColor redColor]];
            }
        }
    }
    else {
        [yapRecorder stop];
        
        yapBtn.enabled = NO;
        lockBtn.enabled = NO;
        playBtn.hidden = NO;
        
        postBtn.hidden = NO;
        bottomYapOptions.hidden = NO;
        
        [currentTime setTextColor:[UIColor whiteColor]];
        
        UIImage *btnImage = [UIImage imageNamed:@"bttn_Yap Origi.png"];
        [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        if (lockIntact) {
            UIImage *btnImage = [UIImage imageNamed:@"bttn_lock.png"];
            [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        }
        
        [self.timer invalidate];
        
        self.counter = 40;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

-(IBAction)createYap:(UILongPressGestureRecognizer *) recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
            [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    UIImage *btnImage = [UIImage imageNamed:@"bttn_yap filled green.png"];
                    [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                    
                    playBtn.hidden = YES;
                    postBtn.hidden = YES;
                    bottomYapOptions.hidden = YES;
                    
                    
                    
                    timeView.hidden = NO;
                    
                    [self startRecording];
                    
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:@"Yapster Requires Microphone Access"
                                                     message:@"Please enable Microphone access for Yapster in Settings / Privacy / Microphone"
                                                    delegate:nil
                                           cancelButtonTitle:@"Dismiss"
                                           otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        originalCenter = yapBtn.center;
        
        if (self.counter >= 1) {
            //if ([recognizer locationInView:self.view].y < 280) {
            
                yapBtn.center = CGPointMake([recognizer locationInView:self.view].x-40,
                                            [recognizer locationInView:self.view].y-80);
                
                yapBtn.frame = CGRectMake(yapBtn.frame.origin.x, yapBtn.frame.origin.y, 66, 66);
                
                float x_point = [recognizer locationInView:self.view].x;
                float y_point = [recognizer locationInView:self.view].y;
                
                //DLog(@"%f", x_point);
                //DLog(@"%f", y_point);
                
                //if yap button intersects with delete button
                if ((x_point > -10 && x_point <= 148) && (y_point > 110 && y_point <= 230)) {
                    UIImage *btnImage = [UIImage imageNamed:@"bttn_delete select.png"];
                    [deleteBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                    
                    btnImage = [UIImage imageNamed:@"bttn_yap red.png"];
                    [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                }
                else {
                    //if yap button intersects with lock button
                    if ((x_point > 250 && x_point <= 310) && (y_point > 110 && y_point <= 230)) {
                        UIImage *btnImage = [UIImage imageNamed:@"bttn_lock green.png"];
                        [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                        
                        btnImage = [UIImage imageNamed:@"bttn_yap green.png"];
                        [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                    }
                    else {
                        UIImage *btnImage = [UIImage imageNamed:@"bttn_lock.png"];
                        [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                        btnImage = [UIImage imageNamed:@"bttn_delete.png"];
                        [deleteBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                        
                        btnImage = [UIImage imageNamed:@"bttn_yap filled green.png"];
                        [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                    }
                }
            //}
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded){
        float x_point = [recognizer locationInView:self.view].x;
        float y_point = [recognizer locationInView:self.view].y;
        
        if ((x_point > -10 && x_point <= 148) && (y_point > 110 && y_point <= 230)) {
            deleteIntact = YES;
            
            yapBtn.center = originalCenter;
            
            if ([[UIScreen mainScreen] bounds].size.height == 480) {
                yapBtn.frame = CGRectMake(93, 150, 143, 143);
            }
            else {
                yapBtn.frame = CGRectMake(93, 212, 143, 143);
            }
            
            UIImage *btnImage = [[UIImage alloc] init];
 
            btnImage = [UIImage imageNamed:@"bttn_delete select.png"];
            [deleteBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
            
            btnImage = [UIImage imageNamed:@"bttn_yap red.png"];
            [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
            
            [self deleteYap];
            
            yapBtn.enabled = YES;
        }
        else if ((x_point > 250 && x_point <= 310) && (y_point > 110 && y_point <= 230)) {
            if (lockBtn.enabled) {
                lockIntact = YES;
                
                yapBtn.center = originalCenter;
                
                if ([[UIScreen mainScreen] bounds].size.height == 480) {
                    yapBtn.frame = CGRectMake(93, 150, 143, 143);
                }
                else {
                    yapBtn.frame = CGRectMake(93, 212, 143, 143);
                }
                
                UIImage *btnImage = [[UIImage alloc] init];
                
                btnImage = [UIImage imageNamed:@"bttn_lock green.png"];
                [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                
                btnImage = [UIImage imageNamed:@"bttn_yap filled green.png"];
                [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                
                [self.timer invalidate];
                
                [self lockYap];
                
                yapBtn.enabled = NO;
            }
        }
        else {
            lockIntact = NO;
            deleteIntact = NO;
            
            yapBtn.center = originalCenter;
            
            if ([[UIScreen mainScreen] bounds].size.height == 480) {
                yapBtn.frame = CGRectMake(93, 150, 143, 143);
            }
            else {
                yapBtn.frame = CGRectMake(93, 212, 143, 143);
            }
            
            UIImage *btnImage = [UIImage imageNamed:@"bttn_Yap Origi.png"];
            [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
            
            if (self.counter > 0) {
                deleteBtn.hidden = NO;
                playBtn.hidden = NO;
                lockBtn.hidden = NO;
                lockIntact = NO;
                
                if (self.counter >= 7) {
                    postBtn.hidden = NO;
                    bottomYapOptions.hidden = NO;
                }
            }
            else {
                timeView.hidden = YES;
            }
            
            [yapRecorder pause];
            
            [self.timer invalidate];

        }
    }
}

-(void)deleteYap {
    if (deleteIntact) {
        NSFileManager *fileHandler = [NSFileManager defaultManager];
        [fileHandler removeItemAtPath:tempRecFile error:nil];
        tempRecFile = nil;
        tempRecFile = [[NSURL alloc] init];
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        NSString *soundFilePath = [docsDir
                                   stringByAppendingPathComponent:@"VoiceFile"];
        
        NSDictionary *recordSettings = [NSDictionary
                                        dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kAudioFormatAppleIMA4],
                                        AVFormatIDKey,
                                        [NSNumber numberWithFloat:44100.0],
                                        AVSampleRateKey,
                                        [NSNumber numberWithInt: 1],
                                        AVNumberOfChannelsKey,
                                        AVAudioQualityMin,
                                        AVEncoderAudioQualityKey,
                                        nil];
        
        tempRecFile = [NSURL fileURLWithPath:soundFilePath];
        
        yapRecorder = [[AVAudioRecorder alloc] initWithURL:tempRecFile settings:recordSettings error:nil];
        
        self.counter = 0;
        
        currentTime.text = @"00:00";
        currentTime.textColor = [UIColor whiteColor];
        
        UIImage *btnImage = [UIImage imageNamed:@"bttn_Yap Origi.png"];
        [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        btnImage = [UIImage imageNamed:@"bttn_lock.png"];
        [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        btnImage = [UIImage imageNamed:@"bttn_delete.png"];
        [deleteBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        playBtn.hidden = YES;
        lockBtn.hidden = YES;
        deleteBtn.hidden = YES;
        bottomYapOptions.hidden = YES;
        postBtn.hidden = YES;
        timeView.hidden = YES;
        lockIntact = NO;
        yapBtn.enabled = YES;
        lockBtn.enabled = YES;
        
        pressAndHoldTutorialLabel.hidden = NO;
        
        [yapBtn removeGestureRecognizer:panGesture];
        
        [self.timer invalidate];
    }
}

-(IBAction)deleteYap_SB:(id)sender {
    NSFileManager *fileHandler = [NSFileManager defaultManager];
    [fileHandler removeItemAtPath:tempRecFile error:nil];
    tempRecFile = nil;
    tempRecFile = [[NSURL alloc] init];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"VoiceFile"];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatAppleIMA4],
                                    AVFormatIDKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    [NSNumber numberWithInt: 1],
                                    AVNumberOfChannelsKey,
                                    AVAudioQualityMin,
                                    AVEncoderAudioQualityKey,
                                    nil];
    
    tempRecFile = [NSURL fileURLWithPath:soundFilePath];
    
    yapRecorder = [[AVAudioRecorder alloc] initWithURL:tempRecFile settings:recordSettings error:nil];
    
    self.counter = 0;
    
    currentTime.text = @"00:00";
    currentTime.textColor = [UIColor whiteColor];
    
    UIImage *btnImage = [UIImage imageNamed:@"bttn_Yap Origi.png"];
    [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    btnImage = [UIImage imageNamed:@"bttn_lock.png"];
    [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    btnImage = [UIImage imageNamed:@"bttn_delete.png"];
    [deleteBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    playBtn.hidden = YES;
    lockBtn.hidden = YES;
    deleteBtn.hidden = YES;
    postBtn.hidden = YES;
    bottomYapOptions.hidden = YES;
    timeView.hidden = YES;
    lockIntact = NO;
    deleteIntact = NO;
    yapBtn.enabled = YES;
    lockBtn.enabled = YES;
    
    pressAndHoldTutorialLabel.hidden = NO;
    
    [yapBtn removeGestureRecognizer:panGesture];
    
    [self.timer invalidate];
}

-(void)lockYap {
    if (lockIntact) {
        if (yapPlayer.playing) {
            [yapPlayer stop];
            playBtn.hidden = NO;
            stopBtn.hidden = YES;
        }
        
        if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
            [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    [self startRecording];
                    
                    playBtn.hidden = YES;
                    
                    timeView.hidden = NO;
                    
                    yapBtn.enabled = NO;
                    
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
                    
                    postBtn.hidden = YES;
                    bottomYapOptions.hidden = YES;
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:@"Yapster Requires Microphone Access"
                                                    message:@"Please enable Microphone access for Yapster in Settings / Privacy / Microphone"
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
}

-(IBAction)lockYap_SB:(id)sender {
    if (!lockIntact) {
        if (yapPlayer.playing) {
            [yapPlayer stop];
            playBtn.hidden = NO;
            stopBtn.hidden = YES;
        }
        
        if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
            [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    [self startRecording];
                    
                    playBtn.hidden = YES;
                    
                    timeView.hidden = NO;
                    
                    yapBtn.enabled = NO;
                    
                    UIImage *btnImage = [UIImage imageNamed:@"bttn_yap green.png"];
                    [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                    
                    btnImage = [UIImage imageNamed:@"bttn_lock green.png"];
                    [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                    
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
                    
                    postBtn.hidden = YES;
                    bottomYapOptions.hidden = YES;
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:@"Yapster Requires Microphone Access"
                                                    message:@"Please enable Microphone access for Yapster in Settings / Privacy / Microphone"
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
}

-(IBAction)unlockYap:(id)sender {
    if (lockIntact) {
        [yapRecorder pause];
        
        yapBtn.enabled = YES;
        playBtn.hidden = NO;
        lockIntact = NO;
        
        [currentTime setTextColor:[UIColor whiteColor]];
        
        UIImage *btnImage = [UIImage imageNamed:@"bttn_Yap Origi.png"];
        [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        btnImage = [UIImage imageNamed:@"bttn_lock.png"];
        [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        [self.timer invalidate];
        
        if (self.counter >= 7) {
            postBtn.hidden = NO;
            bottomYapOptions.hidden = NO;
        }
    }
}

#pragma mark UIPanGestureRecognizer selector
- (void) dragGesture:(UIPanGestureRecognizer *) thePanGesture{
    CGPoint translation = [thePanGesture translationInView:self.view];
    
    float x_point = yapBtn.center.x + translation.x;
    float y_point = yapBtn.center.y + translation.y;
    
    switch (thePanGesture.state) {
        case UIGestureRecognizerStateBegan:{
            originalCenter = yapBtn.center;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            DLog(@"%f", x_point);
            DLog(@"%f", y_point);
            
            yapBtn.center = CGPointMake(yapBtn.center.x + translation.x,
                                           yapBtn.center.y + translation.y);
            yapBtn.frame = CGRectMake(yapBtn.frame.origin.x, yapBtn.frame.origin.y, 66, 66);
            
            //if yap button intersects with delete button
            if ((x_point > -10 && x_point <= 95) && (y_point > 37 && y_point <= 147)) {
                UIImage *btnImage = [UIImage imageNamed:@"bttn_delete select.png"];
                [deleteBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                
                btnImage = [UIImage imageNamed:@"bttn_yap red.png"];
                [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
            }
            else {
                //if yap button intersects with lock button
                if ((x_point > 223 && x_point <= 310) && (y_point > 40 && y_point <= 145)) {
                    UIImage *btnImage = [UIImage imageNamed:@"bttn_lock green.png"];
                    [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                    
                    btnImage = [UIImage imageNamed:@"bttn_yap green.png"];
                    [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                }
                else {
                    UIImage *btnImage = [UIImage imageNamed:@"bttn_lock.png"];
                    [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                    btnImage = [UIImage imageNamed:@"bttn_delete.png"];
                    [deleteBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                    
                    btnImage = [UIImage imageNamed:@"bttn_Yap Origi.png"];
                    [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                }
            } 
        }
        
            break;
        case UIGestureRecognizerStateEnded:{
            if ((x_point > -10 && x_point <= 95) && (y_point > 37 && y_point <= 147)) {
                deleteIntact = YES;
            }
            else if ((x_point > 223 && x_point <= 310) && (y_point > 40 && y_point <= 145)) {
                if (lockBtn.enabled) {
                    lockIntact = YES;
                }
            }
            else {
                lockIntact = NO;
                deleteIntact = NO;
            }
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 yapBtn.center = originalCenter;
                             }
                             completion:^(BOOL finished){
                                 if ([[UIScreen mainScreen] bounds].size.height == 480) {
                                     yapBtn.frame = CGRectMake(93, 150, 143, 143);
                                 }
                                 else {
                                     yapBtn.frame = CGRectMake(93, 212, 143, 143);
                                 }
                                 
                                 UIImage *btnImage = [[UIImage alloc] init];
                                 
                                 
                                 if (!lockIntact) {
                                     btnImage = [UIImage imageNamed:@"bttn_lock.png"];
                                     [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                                     
                                     if (!deleteIntact) {
                                         btnImage = [UIImage imageNamed:@"bttn_delete.png"];
                                         [deleteBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                                     }
                                     else {
                                         btnImage = [UIImage imageNamed:@"bttn_delete select.png"];
                                         [deleteBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                                         
                                         btnImage = [UIImage imageNamed:@"bttn_yap red.png"];
                                         [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                                         
                                         [self deleteYap];
                                         
                                         yapBtn.enabled = YES;
                                     }
                                 }
                                 else {
                                     btnImage = [UIImage imageNamed:@"bttn_lock green.png"];
                                     [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                                     
                                     btnImage = [UIImage imageNamed:@"bttn_yap green.png"];
                                     [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
                                     
                                     [self lockYap];
                                     
                                     yapBtn.enabled = NO;
                                 }
                             }];
        }
            break;
        default:
            break;
    }
    
    [thePanGesture setTranslation:CGPointZero inView:self.view];
}

-(IBAction)addHashtags:(id)sender {
    //cancel connections to prevent a break in the flow of the system while switching between subviews
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    [loadingData stopAnimating];
    loadingData.hidden = YES;
    
    mainBG.hidden = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    if (yapRecorder.recording) {
        yapBtn.enabled = YES;
    }
        
    mainYapView.hidden = YES;
    hashtagsView.hidden = NO;
    usertagsView.hidden = YES;
    groupsView.hidden = YES;
    linksView.hidden = YES;
    photoView.hidden = YES;
    doneBtn.hidden = NO;
    
    pageControl.hidden = YES;
    
    pressAndHoldTutorialLabel.hidden = YES;
    channelsTutorialLabel.hidden = YES;
    backBtn.hidden = YES;
    postBtn.hidden = YES;
    controlsView.hidden = YES;
    deleteIntact = NO;
    lockIntact = NO;
    
    [currentTime setTextColor:[UIColor whiteColor]];
    
    UIImage *btnImage = [UIImage imageNamed:@"bttn_Yap Origi.png"];
    [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    btnImage = [UIImage imageNamed:@"bttn_lock.png"];
    [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    [self.timer invalidate];
    
    btnImage = [UIImage imageNamed:@"hashtag_clicked.png"];
    [addHashtagsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"usertag_unclicked.png"];
    [addUsertagsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"channel_unclicked.png"];
    [addGroupsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"link_unclicked.png"];
    [addLinksBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"photo_unclicked.png"];
    [addPhotoBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

-(IBAction)addUsertags:(id)sender {
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    self.photos = [[NSMutableArray alloc] init];
    self.records = [[NSMutableArray alloc] init];
    
    [loadingData stopAnimating];
    loadingData.hidden = YES;
    
    mainBG.hidden = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    mainYapView.hidden = YES;
    hashtagsView.hidden = YES;
    usertagsView.hidden = NO;
    groupsView.hidden = YES;
    linksView.hidden = YES;
    photoView.hidden = YES;
    doneBtn.hidden = NO;
    usersTable.hidden = YES;
    
    pageControl.hidden = YES;
    
    pressAndHoldTutorialLabel.hidden = YES;
    channelsTutorialLabel.hidden = YES;
    backBtn.hidden = YES;
    postBtn.hidden = YES;
    controlsView.hidden = YES;
    deleteIntact = NO;
    lockIntact = NO;
    
    [currentTime setTextColor:[UIColor whiteColor]];
    
    UIImage *btnImage = [UIImage imageNamed:@"bttn_Yap Origi.png"];
    [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    btnImage = [UIImage imageNamed:@"bttn_lock.png"];
    [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    [self.timer invalidate];
    
    btnImage = [UIImage imageNamed:@"hashtag_unclicked.png"];
    [addHashtagsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"usertag_clicked.png"];
    [addUsertagsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"channel_unclicked.png"];
    [addGroupsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"link_unclicked.png"];
    [addLinksBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"photo_unclicked.png"];
    [addPhotoBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not load users." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alert show];*/
    }
    else {
        userFollowers = nil;
        userFollowers = [[NSMutableArray alloc] init];
        userFollowing = nil;
        userFollowing = [[NSMutableArray alloc] init];
        fullUsersData = nil;
        fullUsersData = [[NSMutableArray alloc] init];
        
        //build an info object and convert to json
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        NSNumber *tempAmount = [[NSNumber alloc] initWithDouble:postAmount];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        tempSessionUserID, @"follower_request_id",
                                        tempAmount, @"amount",
                                        nil];
        
        NSError *error;
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/following_and_followers/"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:the_url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBodyFollowersAndFollowing = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        //int responseCode = [urlResponse statusCode];
        
        if (!jsonData) {
            DLog(@"JSON error: %@", error);
        }
        else {
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            DLog(@"JSON: %@", JSONString);
        }
        
        //connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        //[connection1 start];
        
        /*
        if (connection1) {
            loadingData.hidden = NO;
             
             [loadingData startAnimating];
        }
        else {
            //Error
        }*/
    }
}

-(IBAction)addGroups:(id)sender {
    //cancel connections to prevent a break in the flow of the system while switching between subviews
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    [loadingData stopAnimating];
    loadingData.hidden = YES;
    
    mainYapView.hidden = YES;
    hashtagsView.hidden = YES;
    usertagsView.hidden = YES;
    groupsView.hidden = NO;
    channelsTutorialLabel.hidden = NO;
    linksView.hidden = YES;
    photoView.hidden = YES;
    doneBtn.hidden = NO;
    usersTable.hidden = YES;
    
    pageControl.hidden = NO;
    
    pressAndHoldTutorialLabel.hidden = YES;
    backBtn.hidden = YES;
    postBtn.hidden = YES;
    controlsView.hidden = YES;
    deleteIntact = NO;
    lockIntact = NO;
    
    [currentTime setTextColor:[UIColor whiteColor]];
    
    UIImage *btnImage = [UIImage imageNamed:@"bttn_Yap Origi.png"];
    [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    btnImage = [UIImage imageNamed:@"bttn_lock.png"];
    [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    [self.timer invalidate];
    
    btnImage = [UIImage imageNamed:@"hashtag_unclicked.png"];
    [addHashtagsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"usertag_unclicked.png"];
    [addUsertagsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"channel_clicked.png"];
    [addGroupsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"link_unclicked.png"];
    [addLinksBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"photo_unclicked.png"];
    [addPhotoBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not load users." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alert show];*/
    }
    else {
        groupsView.hidden = NO;
        //mainBG.hidden = YES;
        //self.view.backgroundColor = [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
        
        if (!channelsLoaded) {
            //build an info object and convert to json
            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
            
            NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            tempSessionUserID, @"user_id",
                                            tempSessionID, @"session_id",
                                            nil];
            
            NSError *error;
            
            //convert object to data
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/channels/load/"];
            
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
            
            connection3 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection3 start];
            
            if (connection3) {
                pageControl.hidden = YES;
                [loadingData startAnimating];
                loadingData.hidden = NO;
            }
            else {
                //Error
            }
        }
    }
}

-(IBAction)addGroup:(id)sender {
    UIButton *button = sender;
    int group_id = button.tag;
    
    groupToAdd = group_id;
    
    if (lastAddedGroup != 0) {
        if (lastAddedGroup != groupToAdd) {
            UIButton *last_button = (UIButton *)[self.view viewWithTag:lastAddedGroup];
            [last_button setBackgroundImage:[channelImagesUnclicked objectForKey:[NSString stringWithFormat:@"%i", lastAddedGroup]] forState:UIControlStateNormal];
        }
        else {
            [button setBackgroundImage:[channelImagesUnclicked objectForKey:[NSString stringWithFormat:@"%i", lastAddedGroup]] forState:UIControlStateNormal];
        }
    }
    
    if (lastAddedGroup != groupToAdd) {
        [button setBackgroundImage:[channelImagesClicked objectForKey:[NSString stringWithFormat:@"%i", groupToAdd]] forState:UIControlStateNormal];
    }
    else {
        groupToAdd = 0;
    }
    
    lastAddedGroup = groupToAdd;
}

-(IBAction)addLinks:(id)sender {
    //cancel connections to prevent a break in the flow of the system while switching between subviews
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    [loadingData stopAnimating];
    loadingData.hidden = YES;
    
    mainBG.hidden = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    mainYapView.hidden = YES;
    hashtagsView.hidden = YES;
    usertagsView.hidden = YES;
    groupsView.hidden = YES;
    linksView.hidden = NO;
    photoView.hidden = YES;
    doneBtn.hidden = NO;
    
    pageControl.hidden = YES;
    
    pressAndHoldTutorialLabel.hidden = YES;
    channelsTutorialLabel.hidden = YES;
    backBtn.hidden = YES;
    postBtn.hidden = YES;
    controlsView.hidden = YES;
    deleteIntact = NO;
    lockIntact = NO;
    
    [currentTime setTextColor:[UIColor whiteColor]];
    
    UIImage *btnImage = [UIImage imageNamed:@"bttn_Yap Origi.png"];
    [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    btnImage = [UIImage imageNamed:@"bttn_lock.png"];
    [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    [self.timer invalidate];
    
    btnImage = [UIImage imageNamed:@"hashtag_unclicked.png"];
    [addHashtagsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"usertag_unclicked.png"];
    [addUsertagsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"channel_unclicked.png"];
    [addGroupsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"link_clicked.png"];
    [addLinksBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"photo_unclicked.png"];
    [addPhotoBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

-(IBAction)addPhoto:(id)sender {
    //cancel connections to prevent a break in the flow of the system while switching between subviews
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    [loadingData stopAnimating];
    loadingData.hidden = YES;
    
    mainBG.hidden = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    mainYapView.hidden = YES;
    hashtagsView.hidden = YES;
    usertagsView.hidden = YES;
    groupsView.hidden = YES;
    linksView.hidden = YES;
    photoView.hidden = NO;
    doneBtn.hidden = NO;
    
    //[yapPhoto.layer setCornerRadius:yapPhoto.frame.size.width/2];
    //[yapPhoto.layer setBorderWidth:1.0];
    [yapPhoto.layer setBorderColor:[UIColor whiteColor].CGColor];
    [yapPhoto.layer masksToBounds];
    
    CALayer *imageLayer = yapPhoto.layer;
    [imageLayer setCornerRadius:yapPhoto.frame.size.width/2];
    [imageLayer setBorderWidth:1.0];
    [imageLayer setMasksToBounds:YES];
    
    pageControl.hidden = YES;
    
    pressAndHoldTutorialLabel.hidden = YES;
    channelsTutorialLabel.hidden = YES;
    backBtn.hidden = YES;
    postBtn.hidden = YES;
    controlsView.hidden = YES;
    deleteIntact = NO;
    lockIntact = NO;
    
    [currentTime setTextColor:[UIColor whiteColor]];
    
    UIImage *btnImage = [UIImage imageNamed:@"bttn_Yap Origi.png"];
    [yapBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    btnImage = [UIImage imageNamed:@"bttn_lock.png"];
    [lockBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    [self.timer invalidate];
    
    btnImage = [UIImage imageNamed:@"hashtag_unclicked.png"];
    [addHashtagsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"usertag_unclicked.png"];
    [addUsertagsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"channel_unclicked.png"];
    [addGroupsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"link_unclicked.png"];
    [addLinksBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    btnImage = [UIImage imageNamed:@"photo_clicked.png"];
    [addPhotoBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

-(IBAction)closeAddHashtags:(id)sender {
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    [loadingData stopAnimating];
    loadingData.hidden = YES;
    
    mainYapView.hidden = NO;
    hashtagsView.hidden = YES;
    doneBtn.hidden = YES;
    [yapTitle resignFirstResponder];
    [hashtags resignFirstResponder];
    
    if (self.counter >= 7) {
        postBtn.hidden = NO;
    }
    
    if (self.counter < 40) {
        yapBtn.enabled = YES;
    }
    
    pageControl.hidden = YES;
    
    backBtn.hidden = NO;
    controlsView.hidden = NO;
    deleteIntact = NO;
    lockIntact = NO;
    
    [currentTime setTextColor:[UIColor whiteColor]];
    
    UIImage *btnImage = [UIImage imageNamed:@"hashtag_unclicked.png"];
    [addHashtagsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

-(IBAction)closeAddUsertags:(id)sender {
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    [loadingData stopAnimating];
    loadingData.hidden = YES;
    
    mainYapView.hidden = NO;
    usertagsView.hidden = YES;
    doneBtn.hidden = YES;
    [yapTitle resignFirstResponder];
    
    if (self.counter >= 7) {
        postBtn.hidden = NO;
    }
    
    if (self.counter < 40) {
        yapBtn.enabled = YES;
    }
    
    pageControl.hidden = YES;
    
    backBtn.hidden = NO;
    controlsView.hidden = NO;
    deleteIntact = NO;
    lockIntact = NO;
    
    [currentTime setTextColor:[UIColor whiteColor]];
    
    UIImage *btnImage = [UIImage imageNamed:@"usertag_unclicked.png"];
    [addUsertagsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

-(IBAction)closeAddGroups:(id)sender {
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    [loadingData stopAnimating];
    loadingData.hidden = YES;
    
    mainYapView.hidden = NO;
    groupsView.hidden = YES;
    channelsTutorialLabel.hidden = YES;
    doneBtn.hidden = YES;
    [yapTitle resignFirstResponder];
    
    if (self.counter >= 7) {
        postBtn.hidden = NO;
    }
    
    if (self.counter < 40) {
        yapBtn.enabled = YES;
    }
    
    pageControl.hidden = YES;
    
    backBtn.hidden = NO;
    controlsView.hidden = NO;
    deleteIntact = NO;
    lockIntact = NO;
    
    [currentTime setTextColor:[UIColor whiteColor]];
    
    UIImage *btnImage = [UIImage imageNamed:@"channel_unclicked.png"];
    [addGroupsBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    mainBG.hidden = NO;
    self.view.backgroundColor = [UIColor clearColor];
}

-(IBAction)closeAddLinks:(id)sender {
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    [loadingData stopAnimating];
    loadingData.hidden = YES;
    
    mainYapView.hidden = NO;
    linksView.hidden = YES;
    doneBtn.hidden = YES;
    [yapTitle resignFirstResponder];
    [link resignFirstResponder];
    
    if (self.counter >= 7) {
        postBtn.hidden = NO;
    }
    
    if (self.counter < 40) {
        yapBtn.enabled = YES;
    }
    
    pageControl.hidden = YES;
    
    backBtn.hidden = NO;
    controlsView.hidden = NO;
    deleteIntact = NO;
    lockIntact = NO;
    
    [currentTime setTextColor:[UIColor whiteColor]];
    
    UIImage *btnImage = [UIImage imageNamed:@"link_unclicked.png"];
    [addLinksBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

-(IBAction)closeAddPhoto:(id)sender {
    [connection1 cancel];
    [connection2 cancel];
    [connection3 cancel];
    [connection4 cancel];
    [connection5 cancel];
    [connection6 cancel];
    
    [loadingData stopAnimating];
    loadingData.hidden = YES;
    
    mainYapView.hidden = NO;
    photoView.hidden = YES;
    doneBtn.hidden = YES;
    [yapTitle resignFirstResponder];
    [link resignFirstResponder];
    
    if (self.counter >= 7) {
        postBtn.hidden = NO;
    }
    
    if (self.counter < 40) {
        yapBtn.enabled = YES;
    }
    
    pageControl.hidden = YES;
    
    backBtn.hidden = NO;
    controlsView.hidden = NO;
    deleteIntact = NO;
    lockIntact = NO;
    
    [currentTime setTextColor:[UIColor whiteColor]];
    
    UIImage *btnImage = [UIImage imageNamed:@"photo_unclicked.png"];
    [addPhotoBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
}

-(IBAction)addUsersToTag:(id)sender {
    UIButton *button = sender;
    int button_id = button.tag;
    //NSNumber *user_id = [NSNumber numberWithInt:button_id];
    
    if (![usersToTag containsObject:[[fullUsersData objectAtIndex:button_id] objectForKey:@"username"]]) {
        NSString *username = [[fullUsersData objectAtIndex:button_id] objectForKey:@"username"];
        
        NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimmedUsername = [username stringByTrimmingCharactersInSet:whitespace];
        NSUInteger trimmedUsernameLength = [trimmedUsername length];
        
        int current_length = 0;
        
        if (usersToTag.count > 0) {
            for (int i = 0; i < usersToTag.count; i++) {
                current_length = current_length + [[NSString stringWithFormat:@"%@", [usersToTag objectAtIndex:i]] length];
            }
        }
        else {
            current_length = 0;
        }
        
        if (trimmedUsernameLength <= 30) {
            if (current_length <= 30) {
                [usersToTag addObject:username];
                
                [usersTable reloadData];
                
                DLog(@"USER TAGGED");
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"You've hit your user tag limit." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"You've hit your user tag limit." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
    else {
        [usersToTag removeObject:[[fullUsersData objectAtIndex:button_id] objectForKey:@"username"]];
        
        [usersTable reloadData];
        
        DLog(@"USER UNTAGGED");
    }
    
}

-(IBAction)choosePhotoFromAlbum:(id)sender {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:NULL];
}

-(IBAction)takePhotoFromCamera:(id)sender {
    picker2 = [[UIImagePickerController alloc] init];
    picker2.delegate = self;
    [picker2 setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker2 animated:YES completion:NULL];
}

-(void) imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //mainBG.image = image;
    
    cropPhotoForYapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CropPhotoForYapVC"];
    
    self.cropPhotoForYapVC = cropPhotoForYapVC;
    cropPhotoForYapVC.fullImage = image;
    
    //Push to User Settings controller
    [self.navigationController pushViewController:cropPhotoForYapVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fullUsersData count];
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
    
    UsersTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([usersTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [usersTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    CALayer *imageLayer = cell.user_photo.layer;
    [imageLayer setCornerRadius:cell.user_photo.frame.size.width/2];
    [imageLayer setBorderWidth:0.0];
    [imageLayer setMasksToBounds:YES];
    
    //DLog(@"%@", self.photos);
    
    if (self.photos.count > indexPath.row) {
        DLog(@"self.photos %@", self.photos);
        
        PhotoRecord *aRecord = [self.photos objectAtIndex:indexPath.row];
        
        if (aRecord.hasImage) {
            
            //[((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
            [cell.user_photo setBackgroundImage:aRecord.image forState:UIControlStateNormal];
            
        }
        else if (aRecord.isFailed) {
            [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
            [cell.user_photo setBackgroundImage:[UIImage imageNamed:@"placer holder_profile photo Large.jpg"] forState:UIControlStateNormal];
            
        }
        else {
            
            //[((UIActivityIndicatorView *)cell.accessoryView) startAnimating];
            [cell.user_photo setBackgroundImage:[UIImage imageNamed:@"placer holder_profile photo Large.jpg"] forState:UIControlStateNormal];
            
            if (!tableView.dragging && !tableView.decelerating) {
                [self startOperationsForPhotoRecord:aRecord atIndexPath:indexPath];
            }
        }
    }
    
    cell.label_name.text = [NSString stringWithFormat:@"%@ %@", [[fullUsersData objectAtIndex:indexPath.row] objectForKey:@"first_name"], [[fullUsersData objectAtIndex:indexPath.row] objectForKey:@"last_name"]];
    //[cell.label_name sizeToFit];
    cell.label_username.text = [NSString stringWithFormat:@"@%@", [[fullUsersData objectAtIndex:indexPath.row] objectForKey:@"username"]];
    //[cell.label_name sizeToFit];
    
    if ([usersToTag containsObject:[[fullUsersData objectAtIndex:indexPath.row] objectForKey:@"username"]]) {
        [cell.addOrRemoveBtn setBackgroundImage:[UIImage imageNamed:@"bttn_check.png"] forState:UIControlStateNormal];
    }
    else {
        [cell.addOrRemoveBtn setBackgroundImage:[UIImage imageNamed:@"bttn_plus white.png"] forState:UIControlStateNormal];
    }
    
    cell.addOrRemoveBtn.tag = indexPath.row;
    
    [cell.addOrRemoveBtn addTarget:self action:@selector(addUsersToTag:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - Operations

- (void)startOperationsForPhotoRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath {
    if (!record.hasImage) {
        [self startImageDownloadingForRecord:record atIndexPath:indexPath];
    }
}

- (void)startImageDownloadingForRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath {
    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        ImageDownloader *imageDownloader = [[ImageDownloader alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}


#pragma mark -
#pragma mark - ImageDownloader delegate


- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader {
    if (!usersTable.hidden) {
        NSIndexPath *indexPath = downloader.indexPathInTableView;
        PhotoRecord *theRecord = downloader.photoRecord;
        [self.photos replaceObjectAtIndex:indexPath.row withObject:theRecord];
        [usersTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
    }
}


#pragma mark -
#pragma mark - UIScrollView delegate



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnscreenCells];
        [self resumeAllOperations];
    }
}


#pragma mark -
#pragma mark - Cancelling, suspending, resuming queues / operations


- (void)suspendAllOperations {
    [self.pendingOperations.downloadQueue setSuspended:YES];
    [self.pendingOperations.filtrationQueue setSuspended:YES];
}


- (void)resumeAllOperations {
    [self.pendingOperations.downloadQueue setSuspended:NO];
    [self.pendingOperations.filtrationQueue setSuspended:NO];
}


- (void)cancelAllOperations {
    [self.pendingOperations.downloadQueue cancelAllOperations];
    [self.pendingOperations.filtrationQueue cancelAllOperations];
}


- (void)loadImagesForOnscreenCells {
    NSSet *visibleRows = [NSSet setWithArray:[usersTable indexPathsForVisibleRows]];
    NSMutableSet *pendingOperations2 = [NSMutableSet setWithArray:[self.pendingOperations.downloadsInProgress allKeys]];
    [pendingOperations2 addObjectsFromArray:[self.pendingOperations.filtrationsInProgress allKeys]];
    
    NSMutableSet *toBeCancelled = [pendingOperations2 mutableCopy];
    NSMutableSet *toBeStarted = [visibleRows mutableCopy];
    
    [toBeStarted minusSet:pendingOperations2];
    
    [toBeCancelled minusSet:visibleRows];
    
    for (NSIndexPath *anIndexPath in toBeCancelled) {
        
        ImageDownloader *pendingDownload = [self.pendingOperations.downloadsInProgress objectForKey:anIndexPath];
        [pendingDownload cancel];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:anIndexPath];
        
    }
    toBeCancelled = nil;
    
    for (NSIndexPath *anIndexPath in toBeStarted) {
        PhotoRecord *recordToProcess;
        if (self.photos.count > anIndexPath.row) {
            recordToProcess = [self.photos objectAtIndex:anIndexPath.row];
            [self startOperationsForPhotoRecord:recordToProcess atIndexPath:anIndexPath];
        }
    }
    toBeStarted = nil;
    
}


@end
