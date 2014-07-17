//
//  PlayerScreen.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/23/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "PlayerScreen.h"
#import "UserProfile.h"
#import "Stream.h"
#import "SearchResults.h"
#import "UserNotifications.h"

@interface PlayerScreen ()

@end

@implementation PlayerScreen

@synthesize index_of_yap_in_stream;
@synthesize stream;
@synthesize generalWebScreenVC;
@synthesize playlistVC;
@synthesize yap_to_play;
@synthesize user_id;
@synthesize isNotRecording;
@synthesize wasPaused;
@synthesize yapFinishedPlaying;
@synthesize interruptedOnPlayback;
@synthesize hashtags_flag;
@synthesize user_tags_flag;
@synthesize web_link_flag;
@synthesize reyappedByViewer;
@synthesize isReyap;
@synthesize cameFromMenu;
@synthesize reyapped;
@synthesize likedByViewer;
@synthesize liked;
@synthesize isPlaylist;
@synthesize isSingleYap;
@synthesize listen_id;
@synthesize reyap_user_id;
@synthesize after_yap;
@synthesize after_reyap;
@synthesize last_after_yap;
@synthesize last_after_reyap;
@synthesize user_to_view;
@synthesize responseBody;
@synthesize responseBodyLikes;
@synthesize responseBodyListens;
@synthesize cameFromYapScreen;
@synthesize cameFromPushNotifications;
@synthesize yap_picture_flag;
@synthesize yap_picture_cropped_flag;
@synthesize counter;
@synthesize yapRecorder;
@synthesize yapPlayer;
@synthesize recordingData;
@synthesize tempRecFile;
@synthesize cameFrom;
@synthesize profile_stream_type;
@synthesize name_value;
@synthesize username_value;
@synthesize reyap_username_value;
@synthesize reyap_id;
@synthesize listenData;
@synthesize yap_title_value;
@synthesize yap_date_value;
@synthesize yap_plays_value;
@synthesize yap_reyaps_value;
@synthesize yap_likes_value;
@synthesize yap_length_value;
@synthesize object_type;
@synthesize yap_length_int;
@synthesize yap_audio_path;
@synthesize yap_picture_path;
@synthesize yap_picture_cropped_path;
@synthesize user_profile_picture_cropped_path;
@synthesize hashtags_array;
@synthesize userstag_array;
@synthesize gpsur;
@synthesize gpsur_cropped_photo;
@synthesize gpsur_big_photo;
@synthesize hashtags_scroll;
@synthesize usertags_scroll;
@synthesize web_link_btn;

@synthesize timer;
@synthesize mainScrollView;
@synthesize playerView;
@synthesize big_photo;
@synthesize cropped_photo;
@synthesize mainBG;
@synthesize reyap_icon;
@synthesize yapControlsView;
@synthesize bigYapPhotoViewWrapper;
@synthesize bigYapPhotoView;
@synthesize bigYapPhotoScrollView;
@synthesize myZoomableView;
@synthesize loadingData;
@synthesize reyapUserImageView;
@synthesize web_link;
@synthesize playlistBtn;
@synthesize name;
@synthesize username;
@synthesize reyapUser;
@synthesize yapTitle;
@synthesize yapDate;
@synthesize labelReyapUser;
@synthesize backBtn;
@synthesize doneBtn;
@synthesize btnUserPhoto;
@synthesize btnYapPhotoCropped;
@synthesize btnPlay;
@synthesize btnReyap;
@synthesize btnLike;
@synthesize btnRewindYap;
@synthesize btnPlayOrPauseYap;
@synthesize btnForwardYap;
@synthesize yapPlays;
@synthesize yapReyaps;
@synthesize yapLikes;
@synthesize yapLength;
@synthesize currentTime;
@synthesize finalTime;
@synthesize UserProfileVC;
@synthesize searchResultsVC;
@synthesize progressBar;
@synthesize json;
@synthesize jsonAfterYap;
@synthesize userFeed;
@synthesize responseBodyListenId;
@synthesize responseBodyReyapYap;
@synthesize responseBodyLikeYap;
@synthesize connection1;
@synthesize connection2;
@synthesize connection3;
@synthesize connection4;
@synthesize connection5;
@synthesize connection6;
@synthesize connection7;
@synthesize connection8;
@synthesize connection9;
@synthesize sharedManager;
@synthesize playerItemYapAudio;
@synthesize image_download_manager;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enteredBackground:)
                                                 name:@"didEnterBackground"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willTerminateApp:)
                                                 name:@"willTerminate"
                                               object:nil];
    
    if (!cameFromMenu) {
        btnPlay.enabled = NO;
        progressBar.enabled = NO;
    }
    
    sharedManager = [MyManager sharedManager];
    image_download_manager = [SDWebImageManager sharedManager];
    
    DLog(@"VIew loaded");
    
    //DLog(@"playlist count %@", sharedManager.sessionCurrentPlaylist);
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    if (sharedManager.playlistYapsPlayer.playing) {
        [sharedManager.playlistYapsPlayer stop];
    }

    if (!yap_picture_flag) {
        loadingData.hidden = YES;
    }
    
    loadingData.hidden = NO;
    
    btnYapPhotoCropped.hidden = YES;
    
    cameFromWebScreen = false;
    cameFromPlaylist = false;
    cameFromSearchResults = false;
    cameFromProfileScreen = false;
    yapWasNotPlayed = false;
    
    //sharedManager.playerScreenYapsPlayer.delegate = self;
    
    bigYapPhotoScrollView.delegate = self;
    
    [[self bigYapPhotoScrollView] setMinimumZoomScale:1.0];
    [[self bigYapPhotoScrollView] setMaximumZoomScale:6.0];
    
    [btnYapPhotoCropped.layer setBorderColor:[UIColor whiteColor].CGColor];
    [btnYapPhotoCropped.layer masksToBounds];
    
    CALayer *imageLayer = btnYapPhotoCropped.layer;
    [imageLayer setCornerRadius:btnYapPhotoCropped.frame.size.width/2];
    [imageLayer setBorderWidth:1.0];
    [imageLayer setMasksToBounds:YES];
    
    hashtags_scroll = [[UIScrollView alloc] init];
    usertags_scroll = [[UIScrollView alloc] init];
    web_link_btn = [[UIButton alloc] init];
    
    /*
    if (sharedManager.sessionCurrentPlayingYap == nil || sharedManager.sessionCurrentPlayingYap.count == 0) {
        backBtn.enabled = NO;
        playlistBtn.enabled = NO;
        playerView.hidden = YES;
        btnYapPhotoCropped.hidden = YES;
        btnReyap.hidden = YES;
        btnLike.hidden = YES;
    }
    else if ([cameFrom isEqualToString:@"main_menu"]) {
        [loadingData stopAnimating];
        
        if (!sharedManager.playerScreenYapsPlayer.playing) {
            sharedManager.playerScreenYapsPlayer.currentTime = 0;
        }
        
        self.counter = 0;
        
        if (sharedManager.playerScreenYapsPlayer.playing) {
            [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_pause wt.png"] forState:UIControlStateNormal];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
        }
        else {
            [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_play.png"] forState:UIControlStateNormal];
        }
        
        if (self.counter < 10) {
            currentTime.text = [NSString stringWithFormat:@"00:0%i", self.counter];
        }
        else {
            currentTime.text = [NSString stringWithFormat:@"00:%i", self.counter];
        }
        
        if (yap_picture_flag) {
            [btnYapPhotoCropped setBackgroundImage:cropped_photo forState:UIControlStateNormal];
            bigYapPhotoView.image = big_photo;
            
            btnYapPhotoCropped.hidden = NO;
        }
        else {
            btnYapPhotoCropped.hidden = YES;
        }
    }
    else {
        backBtn.enabled = NO;
        playlistBtn.enabled = NO;
        playerView.hidden = YES;
        btnYapPhotoCropped.hidden = YES;
        btnReyap.hidden = YES;
        btnLike.hidden = YES;
    }*/
    
    /*
    if (!cameFromMenu) {
        backBtn.enabled = NO;
        playlistBtn.enabled = NO;
        playerView.hidden = YES;
        btnYapPhotoCropped.hidden = YES;
        btnReyap.hidden = YES;
        btnLike.hidden = YES;
    }*/
    
    bigYapPhotoView.contentMode = UIViewContentModeScaleAspectFit;
    
    CALayer *layer = doneBtn.layer;
    layer.backgroundColor = [[UIColor blackColor] CGColor];
    layer.borderColor = [[UIColor whiteColor] CGColor];
    layer.cornerRadius = 8.0f;
    layer.borderWidth = 1.0f;
    
    if (isPlaylist && !cameFromMenu) {
        BOOL index_to_play = 0;
        
        if (!cameFromMenu) {
            index_to_play = 0;
        }
        else {
            index_to_play = sharedManager.currentYapPlaying;
        }
        
        //DLog(@"%@", sharedManager.sessionCurrentPlayingYap);
        
        yap_to_play = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_to_play"] doubleValue];

        if ([[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"reyap_username_value"] isEqualToString:@""] || [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"reyap_username_value"] == nil) {
            object_type = @"yap";
            reyap_username_value = @"";
        }
        else {
            object_type = @"reyap";
            isReyap = YES;
            reyap_username_value = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"reyap_username_value"];
            reyap_user_id = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"reyap_user_id"] doubleValue];
            reyap_id = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"reyap_id"] doubleValue];
        }
        
        user_profile_picture_cropped_path = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"user_profile_picture_cropped_path"];
        
        user_profile_picture_cropped_path = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"user_profile_picture_cropped_path"];
        
        cameFrom = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"came_from"];
        reyappedByViewer = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"reyapped_by_viewer"] boolValue];
        likedByViewer = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"liked_by_viewer"] boolValue];
        user_id = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"user_id"] doubleValue];
        yap_audio_path = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_audio_path"];
        yap_picture_flag = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"picture_flag"] boolValue];
        yap_picture_path = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0]  valueForKey:@"picture_path"];
        yap_picture_cropped_flag = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"picture_cropped_flag"] boolValue];
        yap_picture_cropped_path = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"picture_cropped_path"];
        big_photo = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"big_photo"];
        cropped_photo = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"cropped_photo"];
        web_link_flag = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"web_link_flag"] boolValue];
        web_link = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"web_link"];
        name_value = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"name_value"];
        username_value = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"username_value"];
        yap_title_value = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_title_value"];
        hashtags_flag = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"hashtags_flag"] boolValue];
        hashtags_array = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"hashtags"];
        user_tags_flag = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"user_tags_flag"] boolValue];
        userstag_array = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"user_tags"];
        yap_date_value = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_date_value"];
        yap_plays_value = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_plays_value"] intValue];
        yap_reyaps_value = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_reyaps_value"] intValue];
        yap_likes_value = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_likes_value"] intValue];
        yap_length_value = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_length_value"] intValue];
    }
    
    if (isPlaylist && !cameFromMenu) {
        //[self loadMoreYapsToPlaylist];
    }
}

-(void)getYapAudio {
    NSString *bucket = @"yapsterapp";
    NSString *audio_path = yap_audio_path;
    
    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
    override.contentType = @"audio/mpeg";
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //get yap audio
        gpsur = [[S3GetPreSignedURLRequest alloc] init];
        gpsur.key     = audio_path;
        gpsur.bucket  = bucket;
        gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
        gpsur.responseHeaderOverrides = override;
        
        NSString *url = [[[AmazonClientManager s3] getPreSignedURL:gpsur] absoluteString];
        
        current_yap_audio_url = [NSURL URLWithString:url];
        
        DLog(@"yap URL %@", current_yap_audio_url);
        
        recordingData = [NSData data];
        
        sharedManager.playerScreenYapsPlayer = [[AVPlayer alloc] init];
        sharedManager.playerScreenYapsPlayer.volume = 1;
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        if ([sharedManager.playerScreenYapsPlayer rate] != 0.0) {
            [sharedManager.playerScreenYapsPlayer pause];
            
            [sharedManager.playerScreenYapsPlayer seekToTime:kCMTimeZero];
        }
        
        playerItemYapAudio = [AVPlayerItem playerItemWithURL:current_yap_audio_url];
        
        [playerItemYapAudio addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        [playerItemYapAudio addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
        
        sharedManager.playerScreenYapsPlayer = [AVPlayer playerWithPlayerItem:playerItemYapAudio];
        sharedManager.playerScreenYapsPlayer = [AVPlayer playerWithURL:current_yap_audio_url];
        
        [sharedManager.playerScreenYapsPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
        
        //[sharedManager.playerScreenYapsPlayer play];
        
        //sharedManager.playerScreenYapsPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        //DLog(@"%@", sharedManager.playerScreenYapsPlayer.error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showYapInfoInBackground];
        });
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (object == sharedManager.playerScreenYapsPlayer && [keyPath isEqualToString:@"status"]) {
        if (sharedManager.playerScreenYapsPlayer.status == AVPlayerStatusReadyToPlay) {
            btnPlay.enabled = YES;
            progressBar.enabled = YES;
            [sharedManager.playerScreenYapsPlayer play];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
        }
        else if (sharedManager.playerScreenYapsPlayer.status == AVPlayerStatusFailed) {
            [self.timer invalidate];
        }
    }
    else if (object == playerItemYapAudio && [keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        if (playerItemYapAudio.playbackBufferEmpty) {
            [self.timer invalidate];
        }
    }
    
    else if (object == playerItemYapAudio && [keyPath isEqualToString:@"playbackLikelyToKeepUp"])
    {
        if (playerItemYapAudio.playbackLikelyToKeepUp)
        {
            [sharedManager.playerScreenYapsPlayer play];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
        }
    }
}

-(void)loadMoreYapsToPlaylist {
    if ([cameFrom isEqualToString:@"user_profile"]) {
        //build an info object and convert to json
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        NSNumber *tempUserToView = [[NSNumber alloc] initWithDouble:user_to_view];
        NSNumber *tempPostAmount = [[NSNumber alloc] initWithInt:10];
        
        NSNumber *tempAfterYap = [[NSNumber alloc] initWithInt:after_yap];
        NSNumber *tempAfterReyap = [[NSNumber alloc] initWithInt:after_reyap];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] init];
        
        if ([profile_stream_type isEqualToString:@"posts"]) {
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
        else if ([profile_stream_type isEqualToString:@"likes"]) {
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempUserToView, @"profile_user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              @"likes", @"stream_type",
                              tempAfterYap, @"after_yap",
                              nil];
        }
        else if ([profile_stream_type isEqualToString:@"listens"]) {
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempUserToView, @"profile_user_id",
                              tempSessionID, @"session_id",
                              tempPostAmount, @"amount",
                              @"listens", @"stream_type",
                              tempAfterYap, @"after_yap",
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
        
        if ([profile_stream_type isEqualToString:@"posts"]) {
            responseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        }
        else if ([profile_stream_type isEqualToString:@"likes"]) {
            responseBodyLikes = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        }
        else if ([profile_stream_type isEqualToString:@"listens"]) {
            responseBodyListens = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        }
        
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
            
        }
        else {
            DLog(@"COULD NOT CONNECT");
        }
    }
    else if ([cameFrom isEqualToString:@"home_stream"]) {
        //build an info object and convert to json
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        NSNumber *tempPostAmount = [[NSNumber alloc] initWithInt:10];
        
        NSNumber *tempAfterYap = [[NSNumber alloc] initWithInt:after_yap];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        tempPostAmount, @"amount",
                                        tempAfterYap, @"after",
                                        nil];
        
        NSError *error;
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/stream/load/"];
        
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
        
        connection6 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection6 start];
        
        if (connection6) {
            
        }
        else {
            DLog(@"COULD NOT CONNECT");
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    DLog(@"VIew DID appeared");
    
    //audio session
    [sharedManager.playerScreenAudioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [sharedManager.playerScreenAudioSession setActive:YES error:nil];
    
    if ([sharedManager.playerScreenYapsPlayer rate] != 0.0) {
        [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_pause wt.png"] forState:UIControlStateNormal];
    }
    
    if (cameFromMenu) {
        loadingData.hidden = YES;
        [loadingData stopAnimating];
    }
    
    if (sharedManager.sessionCurrentPlaylist.count == 0) {
        playlistBtn.enabled = NO;
    }
    
    if (sharedManager.sessionCurrentPlayingYap != nil  && sharedManager.sessionCurrentPlayingYap.count > 0 && [cameFrom isEqualToString:@"main_menu"]) {
        [loadingData stopAnimating];
    }
    
    if ((!cameFromWebScreen && !cameFromPlaylist && !cameFromSearchResults && !cameFromMenu && !isSingleYap && !cameFromProfileScreen) || yapWasNotPlayed) {
        //get yap listen_id
        NSError *error;
        
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        NSNumber *tempObjectId;
        
        if ([object_type isEqualToString:@"yap"]) {
            tempObjectId =[[NSNumber alloc] initWithDouble:yap_to_play];
        }
        else {
            tempObjectId =[[NSNumber alloc] initWithDouble:reyap_id];
        }
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        tempObjectId, @"obj",
                                        object_type, @"obj_type",
                                        nil];
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/listen/"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:the_url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        /*
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBodyListenId = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        */
        
        if (!jsonData) {
            DLog(@"JSON error: %@", error);
        }
        else {
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            DLog(@"JSON view did appear: %@", JSONString);
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    DLog(@"VIew will appear");
    
    if (sharedManager.sessionCurrentPlaylist.count == 0 && cameFromPlaylist) {
        DLog(@"playlist empty");
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playNextYapInPlaylist:)
                                                     name:@"yap_finished_playing_in_playlist_screen"
                                                   object:playlistVC.view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playOrPauseYap:)
                                                     name:@"play_or_pause_yap"
                                                   object:playlistVC.view];

        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(goToPreviousYap:)
                                                     name:@"go_to_previous_yap"
                                                   object:playlistVC.view];

        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(goToNextYap:)
                                                     name:@"go_to_next_yap"
                                                   object:playlistVC.view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadYapPhoto:)
                                                     name:@"load_yap_photo"
                                                   object:playlistVC.view];

        
        if (!cameFromMenu && !cameFromPlaylist && !cameFromProfileScreen && !cameFromWebScreen) {
            [self getYapAudio];
            
            [self.timer invalidate];
            [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_play.png"] forState:UIControlStateNormal];
            self.counter = 0;
            currentTime.text = @"00:00";
            self.progressBar.value = 0;
        }
        else if ([sharedManager.playerScreenYapsPlayer rate] == 0.0) {
            //btnPlay.enabled = NO;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:sharedManager.playerScreenYapsPlayer.currentItem];
        
        if (!cameFromMenu) {
            [self updateScreen];
        }
        
        if (cameFromPlaylist || cameFromMenu) {
            //DLog(@"%@", sharedManager.sessionCurrentPlayingYap);
            
            yap_to_play = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"yap_to_play"] doubleValue];
            
            if ([[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"reyap_username_value"] isEqualToString:@""] || [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"reyap_username_value"] == nil) {
                object_type = @"yap";
                reyap_username_value = @"";
            }
            else {
                object_type = @"reyap";
                isReyap = YES;
                reyap_username_value = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"reyap_username_value"];
                reyap_user_id = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"reyap_user_id"] doubleValue];
                reyap_id = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"reyap_id"] doubleValue];
            }
            
            DLog(@"REYAP USERNAME VALUE %@", [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"reyap_username_value"]);
            
            user_profile_picture_cropped_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"user_profile_picture_cropped_path"];
            
            user_profile_picture_cropped_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"user_profile_picture_cropped_path"];
            
            cameFrom = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"came_from"];
            reyappedByViewer = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"reyapped_by_viewer"] boolValue];
            likedByViewer = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"liked_by_viewer"] boolValue];
            user_id = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"user_id"] doubleValue];
            yap_audio_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"yap_audio_path"];
            yap_picture_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"picture_flag"] boolValue];
            yap_picture_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying]  valueForKey:@"picture_path"];
            yap_picture_cropped_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"picture_cropped_flag"] boolValue];
            yap_picture_cropped_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"picture_cropped_path"];
            big_photo = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"big_photo"];
            cropped_photo = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"cropped_photo"];
            web_link_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"web_link_flag"] boolValue];
            web_link = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"web_link"];
            name_value = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"name_value"];
            username_value = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"username_value"];
            yap_title_value = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"yap_title_value"];
            hashtags_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"hashtags_flag"] boolValue];
            hashtags_array = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"hashtags"];
            user_tags_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"user_tags_flag"] boolValue];
            userstag_array = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"user_tags"];
            yap_date_value = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"yap_date_value"];
            yap_plays_value = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"yap_plays_value"] intValue];
            yap_reyaps_value = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"yap_reyaps_value"] intValue];
            yap_likes_value = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"yap_likes_value"] intValue];
            yap_length_value = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"yap_length_value"] intValue];
            
            if (yap_picture_flag) {
                [btnYapPhotoCropped setBackgroundImage:cropped_photo forState:UIControlStateNormal];
                
                bigYapPhotoViewWrapper.backgroundColor = [UIColor blackColor];
                
                bigYapPhotoView = [[UIImageView alloc] init];
                bigYapPhotoView.image = big_photo;
                
                bigYapPhotoView.contentMode = UIViewContentModeScaleAspectFit;
                
                bigYapPhotoViewWrapper.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
                bigYapPhotoScrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
                
                bigYapPhotoView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
                
                for (UIView *subview in self.myZoomableView.subviews) {
                    [subview removeFromSuperview];
                }
                
                [[self myZoomableView] addSubview:bigYapPhotoView];
                
                loadingData.hidden = YES;
                [loadingData stopAnimating];
                
                btnYapPhotoCropped.enabled = YES;
                btnYapPhotoCropped.hidden = NO;
            }
            else {
                btnYapPhotoCropped.hidden = YES;
            }
            
            [btnUserPhoto setBackgroundImage:[UIImage imageNamed:@"placer holder_profile photo Large.png"] forState:UIControlStateNormal];
            
            
            [self.timer invalidate];
            
            AVPlayerItem *currentItem = sharedManager.playerScreenYapsPlayer.currentItem;
            CMTime currentPlayerTime = currentItem.currentTime; //playing time
            
            self.counter = CMTimeGetSeconds(currentPlayerTime);
            
            if (self.counter < 10) {
                currentTime.text = [NSString stringWithFormat:@"00:0%d", self.counter];
            }
            else {
                currentTime.text = [NSString stringWithFormat:@"00:%d", self.counter];
            }
            
            if ([sharedManager.playerScreenYapsPlayer rate] != 0.0) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
                
                DLog(@"STILL PLAYING");
            }
            else {
                [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_play.png"] forState:UIControlStateNormal];
            
                self.counter = sharedManager.currentYapPlayingTime;
                
                //DLog(@"IS NOT PLAYING %i", self.counter);
                
                if (self.counter < 10) {
                    currentTime.text = [NSString stringWithFormat:@"00:0%d", self.counter];
                }
                else {
                    currentTime.text = [NSString stringWithFormat:@"00:%d", self.counter];
                }
                
                //[self getYapAudio];
                
                int32_t timeScale = sharedManager.playerScreenYapsPlayer.currentItem.asset.duration.timescale;
                CMTime time = CMTimeMakeWithSeconds(self.counter, timeScale);
                [sharedManager.playerScreenYapsPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
                
                //sharedManager.playerScreenYapsPlayer.currentTime = self.counter;
            }
            
            [self updateScreen];
            
            if (isPlaylist && !cameFromMenu) {
                //[self loadMoreYapsToPlaylist];
            }
        }
        
        if (!cameFromMenu && !cameFromPlaylist && isSingleYap && !cameFromProfileScreen && !cameFromWebScreen) {
            //get yap listen_id
            NSError *error;
            
            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
            NSNumber *tempObjectId;
            
            if ([object_type isEqualToString:@"yap"]) {
                tempObjectId =[[NSNumber alloc] initWithDouble:yap_to_play];
            }
            else {
                tempObjectId =[[NSNumber alloc] initWithDouble:reyap_id];
            }
            
            NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            tempSessionUserID, @"user_id",
                                            tempSessionID, @"session_id",
                                            tempObjectId, @"obj",
                                            object_type, @"obj_type",
                                            nil];
            
            //convert object to data
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/listen/"];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:the_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonData];
            
            /*
            NSHTTPURLResponse* urlResponse = nil;
            
            NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
            
            responseBodyListenId = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            */
            
            if (!jsonData) {
                DLog(@"JSON error: %@", error);
            }
            else {
                NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                DLog(@"JSON view will appear: %@", JSONString);
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    if ([sharedManager.playerScreenYapsPlayer rate] == 0.0) {
        //set time listened
        NSError *error;
        
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        NSNumber *tempTimeListened = [[NSNumber alloc] initWithDouble:self.counter];
        NSNumber *tempListenID = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        tempTimeListened, @"time_listened",
                                        tempListenID, @"listen_id",
                                        nil];
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/listen/time_listened/"];
        
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
        
        connection9 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection9 start];
        
        if (connection9) {
            
        }
        else {
            //Error
        }
    }
    
}

- (void)enteredBackground:(NSNotification *)notification {
    DLog(@"enteredBackground");
    
    if ([sharedManager.playerScreenYapsPlayer rate] == 0.0) {
        //set time listened
        NSError *error;
        
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        NSNumber *tempTimeListened = [[NSNumber alloc] initWithDouble:self.counter];
        NSNumber *tempListenID = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        tempTimeListened, @"time_listened",
                                        tempListenID, @"listen_id",
                                        nil];
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/listen/time_listened/"];
        
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
        
        connection9 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection9 start];
        
        if (connection9) {
            
        }
        else {
            //Error
        }
    }
    
}

- (void)willTerminateApp:(NSNotification *)notification {
    DLog(@"willTerminateApp");
    
    //set time listened
    NSError *error;
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempTimeListened = [[NSNumber alloc] initWithDouble:self.counter];
    NSNumber *tempListenID = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    tempTimeListened, @"time_listened",
                                    tempListenID, @"listen_id",
                                    nil];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/listen/time_listened/"];
    
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
    
    connection9 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection9 start];
    
    if (connection9) {
        
    }
    else {
        //Error
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.myZoomableView;
}

-(IBAction)backgroundQueue:(id)sender {
    NSString *bucket = @"yapsterapp";
    //NSString *audio_path = yap_audio_path;
    
    DLog(@"did background queue %@", yap_title_value);
    
    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
    //override.contentType = @"audio/mpeg";
    
    /*
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });*/
        
        /*
        //get yap audio
        gpsur = [[S3GetPreSignedURLRequest alloc] init];
        gpsur.key     = audio_path;
        gpsur.bucket  = bucket;
        gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
        gpsur.responseHeaderOverrides = override;
        
        NSString *url = [[[AmazonClientManager s3] getPreSignedURL:gpsur] absoluteString];
        
        current_yap_audio_url = [NSURL URLWithString:url];
        
        //DLog(@"yap URL %@", current_yap_audio_url);
        
        recordingData = [NSData data];
        
        //sharedManager.sessionCurrentPlayingYapData = [NSData dataWithContentsOfURL:url];
        
        //DLog(@"%@", sharedManager.sessionCurrentPlayingYapData);
        
        sharedManager.playerScreenYapsPlayer = [[AVPlayer alloc] init];
        //[sharedManager.playerScreenYapsPlayer prepareToPlay];
        sharedManager.playerScreenYapsPlayer.volume = 1;
        //[sharedManager.playerScreenYapsPlayer setDelegate:self];
         */
        
        
        //get yap photos: big and cropped
        NSMutableDictionary *playlistDic = [[NSMutableDictionary alloc] init];
    
        if (yap_picture_flag) {
            NSString *cropped_photo_path = yap_picture_cropped_path;
            
            //get yap image
            gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
            gpsur_cropped_photo.key     = cropped_photo_path;
            gpsur_cropped_photo.bucket  = bucket;
            gpsur_cropped_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
            gpsur_cropped_photo.responseHeaderOverrides = override;
            
            NSURL *url_cropped_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_cropped_photo];
            
            //NSData *data_cropped_photo;
  
            //[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] setValue:cropped_photo forKey:@"cropped_photo"];
            
            NSString *big_photo_path = yap_picture_path;
            
            //DLog(@"yap_picture_path: %@", yap_picture_path);
            
            //get big image
            gpsur_big_photo = [[S3GetPreSignedURLRequest alloc] init];
            gpsur_big_photo.key     = big_photo_path;
            gpsur_big_photo.bucket  = bucket;
            gpsur_big_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
            gpsur_big_photo.responseHeaderOverrides = override;
            
            NSURL *url_big_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_big_photo];
            
            //NSData *data_big_photo;
            
            [image_download_manager downloadWithURL:url_big_photo
                                                                options:0
                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // progression tracking code
             }
                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
             {
                 if (image && finished)
                 {
                     big_photo = image;
                     
                     bigYapPhotoViewWrapper.backgroundColor = [UIColor blackColor];
                     
                     bigYapPhotoView = [[UIImageView alloc] init];
                     bigYapPhotoView.image = big_photo;
                     
                     bigYapPhotoView.contentMode = UIViewContentModeScaleAspectFit;
                     
                     bigYapPhotoViewWrapper.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
                     bigYapPhotoScrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
                     
                     bigYapPhotoView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
                     
                     for (UIView *subview in self.myZoomableView.subviews) {
                         [subview removeFromSuperview];
                     }
                     
                     [[self myZoomableView] addSubview:bigYapPhotoView];
                     
                     [image_download_manager downloadWithURL:url_cropped_photo
                                                     options:0
                                                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
                      {
                          // progression tracking code
                      }
                                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                      {
                          if (image && finished)
                          {
                              cropped_photo = image;
                              
                              [btnYapPhotoCropped setBackgroundImage:cropped_photo forState:UIControlStateNormal];
                              
                              loadingData.hidden = YES;
                              [loadingData stopAnimating];
                              
                              btnYapPhotoCropped.enabled = YES;
                              btnYapPhotoCropped.hidden = NO;
                              
                              [playlistDic setObject:big_photo forKey:@"big_photo"];
                              [playlistDic setObject:cropped_photo forKey:@"cropped_photo"];
                              
                              [sharedManager.sessionCurrentPlayingYap setValue:big_photo forKey:@"big_photo"];
                              [sharedManager.sessionCurrentPlayingYap setValue:cropped_photo forKey:@"cropped_photo"];
                          }
                      }];
                 }
             }];
            
        }
        else {
            btnYapPhotoCropped.hidden = YES;
            
            loadingData.hidden = YES;
            [loadingData stopAnimating];
        }
    
        playerView.hidden = NO;
        btnReyap.hidden = NO;
        btnLike.hidden = NO;
            
        /*
        if (sharedManager.playlistYapsPlayer.playing) {
            [sharedManager.playlistYapsPlayer stop];
        }*/
                    
        if (!isPlaylist) {
            NSNumber *yap_to_play2 = [[NSNumber alloc] initWithDouble:yap_to_play];
            NSNumber *reyap_id2 = [[NSNumber alloc] initWithDouble:reyap_id];
            NSNumber *user_id2 = [[NSNumber alloc] initWithDouble:user_id];
            NSNumber *reyap_user_id2 = [[NSNumber alloc] initWithDouble:reyap_user_id];
            NSNumber *reyapped_by_viewer = [[NSNumber alloc] initWithBool:reyapped];
            NSNumber *liked_by_viewer = [[NSNumber alloc] initWithBool:liked];
            NSNumber *hashtags_flag2 = [[NSNumber alloc] initWithBool:hashtags_flag];
            NSNumber *user_tags_flag2 = [[NSNumber alloc] initWithBool:user_tags_flag];
            NSNumber *web_link_flag2 = [[NSNumber alloc] initWithBool:web_link_flag];
            NSNumber *yap_picture_flag2 = [[NSNumber alloc] initWithBool:yap_picture_flag];
            NSNumber *yap_picture_cropped_flag2 = [[NSNumber alloc] initWithBool:yap_picture_cropped_flag];
            NSNumber *yap_plays_value2 = [[NSNumber alloc] initWithInt:yap_plays_value];
            NSNumber *yap_reyaps_value2 = [[NSNumber alloc] initWithInt:yap_reyaps_value];
            NSNumber *yap_likes_value2 = [[NSNumber alloc] initWithInt:yap_likes_value];
            NSNumber *yap_length_value2 = [[NSNumber alloc] initWithInt:yap_length_value];
            NSNumber *yap_length_int2 = [[NSNumber alloc] initWithInt:yap_length_int];
            
            [playlistDic setObject:cameFrom forKey:@"came_from"];
            [playlistDic setObject:yap_to_play2 forKey:@"yap_to_play"];
            [playlistDic setObject:user_id2 forKey:@"user_id"];
            
            [playlistDic setObject:recordingData forKey:@"recording_data"];
            [playlistDic setObject:name_value forKey:@"name_value"];
            [playlistDic setObject:username_value forKey:@"username_value"];
            if (reyap_username_value != nil && ![reyap_username_value isEqualToString:@""]) {
                [playlistDic setObject:reyap_username_value forKey:@"reyap_username_value"];
                [playlistDic setObject:reyap_user_id2 forKey:@"reyap_user_id"];
                [playlistDic setObject:reyap_id2 forKey:@"reyap_id"];
            }
            [playlistDic setObject:reyapped_by_viewer forKey:@"reyapped_by_viewer"];
            [playlistDic setObject:liked_by_viewer forKey:@"liked_by_viewer"];
            [playlistDic setObject:yap_title_value forKey:@"yap_title_value"];
            [playlistDic setObject:yap_date_value forKey:@"yap_date_value"];
            [playlistDic setObject:yap_length_value2 forKey:@"yap_length_value"];
            [playlistDic setObject:object_type forKey:@"object_type"];
            [playlistDic setObject:yap_plays_value2 forKey:@"yap_plays_value"];
            [playlistDic setObject:yap_reyaps_value2 forKey:@"yap_reyaps_value"];
            [playlistDic setObject:yap_likes_value2 forKey:@"yap_likes_value"];
            [playlistDic setObject:yap_length_int2 forKey:@"yap_length_int"];
            
            if (yap_audio_path != nil && ![yap_audio_path isEqualToString:@""]) {
                [playlistDic setObject:yap_audio_path forKey:@"yap_audio_path"];
            }
            
            if (web_link_flag) {
                [playlistDic setValue:web_link_flag2 forKey:@"web_link_flag"];
                [playlistDic setValue:web_link forKey:@"web_link"];
            }
            
            if (yap_picture_flag) {
                [playlistDic setValue:yap_picture_flag2 forKey:@"picture_flag"];
                [playlistDic setValue:yap_picture_path forKey:@"picture_path"];
            }
            
            if (yap_picture_cropped_flag) {
                [playlistDic setValue:yap_picture_cropped_flag2 forKey:@"picture_cropped_flag"];
                [playlistDic setValue:yap_picture_cropped_path forKey:@"picture_cropped_path"];
            }
            
            if (hashtags_flag) {
                [playlistDic setValue:hashtags_flag2 forKey:@"hashtags_flag"];
                [playlistDic setValue:hashtags_array forKey:@"hashtags"];
            }
            
            if (user_tags_flag) {
                [playlistDic setValue:user_tags_flag2 forKey:@"user_tags_flag"];
                [playlistDic setValue:userstag_array forKey:@"user_tags"];
            }
            
            if (![user_profile_picture_cropped_path isEqualToString:@""]) {
                [playlistDic setValue:user_profile_picture_cropped_path forKey:@"user_profile_picture_cropped_path"];
            }
            else {
                [playlistDic setValue:@"" forKey:@"user_profile_picture_cropped_path"];
            }
            
            [sharedManager.sessionCurrentPlaylist addObject:playlistDic];
            
            BOOL found = false;
            
            for (int i = 0; i < sharedManager.sessionCurrentPlaylist.count; i++) {
                double this_yap = yap_to_play;
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
            
            sharedManager.sessionCurrentPlayingYap = [[NSMutableArray alloc] init];
            
            [sharedManager.sessionCurrentPlayingYap addObject:playlistDic];
            
            if (!cameFromMenu) {
                if (isSingleYap) {
                    sharedManager.currentYapPlaying = [sharedManager.sessionCurrentPlaylist count]-1;
                }
            }
        }
        
        backBtn.enabled = YES;
        playlistBtn.enabled = YES;
            
    //});
}

-(void)showYapInfoInBackground {
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        NSMutableDictionary *yapInfo = [[NSMutableDictionary alloc] init];
        
        MPMediaItemArtwork *albumArt;
        
        AVPlayerItem *currentItem = sharedManager.playerScreenYapsPlayer.currentItem;
        CMTime duration = currentItem.duration; //total time
        CMTime currentPlayerTime = currentItem.currentTime; //playing time
        
        [yapInfo setObject:yap_title_value forKey:MPMediaItemPropertyTitle];
        [yapInfo setObject:name_value forKey:MPMediaItemPropertyArtist];
        [yapInfo setObject:@"Yapster" forKey:MPMediaItemPropertyAlbumTitle];
        [yapInfo setObject:[NSNumber numberWithFloat:CMTimeGetSeconds(duration)] forKey:MPMediaItemPropertyPlaybackDuration];
        [yapInfo setObject:[NSNumber numberWithFloat:CMTimeGetSeconds(currentPlayerTime)] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [yapInfo setObject:@1.0 forKey:MPNowPlayingInfoPropertyPlaybackRate];
      
        if (yap_picture_flag && big_photo != nil) {
            DLog(@"big_photo: %@", big_photo);
            
            albumArt = [[MPMediaItemArtwork alloc] initWithImage:big_photo];
            
            [yapInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        }
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:yapInfo]; 
    }
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if ( receivedEvent.type == UIEventTypeRemoteControl ) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlStop:
            case UIEventSubtypeRemoteControlTogglePlayPause:
                {
                    [self playOrPauseYap:btnPlayOrPauseYap];
                }
                break;
                
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
            case UIEventSubtypeRemoteControlBeginSeekingForward:
            case UIEventSubtypeRemoteControlEndSeekingBackward:
            case UIEventSubtypeRemoteControlEndSeekingForward:
            case UIEventSubtypeRemoteControlPreviousTrack:
                {
                    if (sharedManager.sessionCurrentPlaylist.count > 1) {
                        [self goToPreviousYap:btnForwardYap];
                    }
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                {
                    if (sharedManager.sessionCurrentPlaylist.count > 1) {
                        [self goToNextYap:btnForwardYap];
                    }
                }
                break;
                
            default:
                break;
        }
    }
}

- (void) audioPlayerBeginInterruption: (AVAudioPlayer *) player {
    if ([sharedManager.playerScreenYapsPlayer rate] != 0.0) {
        [sharedManager.playerScreenYapsPlayer pause];
        interruptedOnPlayback = YES;
    }
}

- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player {
    if (interruptedOnPlayback) {
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
        [sharedManager.playerScreenYapsPlayer play];
        
        [self showYapInfoInBackground];
        
        interruptedOnPlayback = NO;
    }
}

-(IBAction)goToPlaylist:(id)sender {
    playlistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaylistVC"];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        /*
        //Push to controller
        [self.navigationController pushViewController:playlistVC animated:YES];*/
        
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
            [self presentViewController:playlistVC animated:YES completion:nil];
        } else {
            [self presentModalViewController:playlistVC animated:YES];
        }
    }
}

- (void)incrementCounter {
    self.counter++;
    
    if (self.counter < 10) {
        currentTime.text = [NSString stringWithFormat:@"00:0%i", self.counter];
    }
    else {
        currentTime.text = [NSString stringWithFormat:@"00:%i", self.counter];
    }
    
    if (self.counter > 0) {
        [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_pause wt.png"] forState:UIControlStateNormal];
    }
    else {
        [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_play.png"] forState:UIControlStateNormal];
    }
    
    [progressBar setValue:self.counter animated:YES];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)openWebLink {
    generalWebScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GeneralWebScreenVC"];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        generalWebScreenVC.web_link = web_link;
        
        //Push to controller
        [self.navigationController pushViewController:generalWebScreenVC animated:YES];
    }
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    jsonAfterYap = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    listenData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection1) {
       /* NSData *data = [responseBodyListenId dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *json_listen_id = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        */
        
        //NSLog(@"%@", listenData);
        
        sharedManager.currentListenId = [[listenData objectForKey:@"Listen_id"] doubleValue];
        
        //sharedManager.currentListenId = listen_id;
        
        DLog(@"LISTEN ID: %f", sharedManager.currentListenId);
        
        if (!cameFromPlaylist && !cameFromMenu) {
            if (!cameFromMenu) {
                if (sharedManager.sessionCurrentPlayingYap == nil || sharedManager.sessionCurrentPlayingYap.count == 0) {
                    [self performSelectorInBackground:@selector(backgroundQueue:) withObject:nil];
                }
                else if ([cameFrom isEqualToString:@"main_menu"]) {
                    loadingData.hidden = YES;
                    
                    [loadingData stopAnimating];
                }
                else {
                    [self performSelectorInBackground:@selector(backgroundQueue:) withObject:nil];
                }
            }
        }
    }
    else if (connection == connection2) {
        NSData *data = [responseBodyReyapYap dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *json_create_reyap = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        
        BOOL isValid = [[json_create_reyap objectForKey:@"valid"] boolValue];
        
        if (isValid) {
            DLog(@"IS VALID");
            if (!reyapped) {
                DLog(@"%@", json_create_reyap);
                
                [btnReyap setBackgroundImage:[UIImage imageNamed:@"bttn_reyap.png"] forState:UIControlStateNormal];
            
                double reyap_count = [yapReyaps.text doubleValue];
            
                yapReyaps.text = [NSString stringWithFormat:@"%0.0f", (reyap_count+1)];
                
                reyapped = true;
                
                NSNumber *reyapped_by_viewer2 = [[NSNumber alloc] initWithBool:reyapped];
                NSNumber *yap_reyaps_value2 = [[NSNumber alloc] initWithInt:reyap_count+1];
                
                [sharedManager.sessionCurrentPlayingYap setValue:yap_reyaps_value2 forKey:@"yap_reyaps_value"];
                
                [sharedManager.sessionCurrentPlayingYap setValue:reyapped_by_viewer2 forKey:@"reyapped_by_viewer"];
            }
            else {
                [btnReyap setBackgroundImage:[UIImage imageNamed:@"bttn_reyap wt-circle.png"] forState:UIControlStateNormal];
                
                double reyap_count = [yapReyaps.text doubleValue];
                
                yapReyaps.text = [NSString stringWithFormat:@"%0.0f", (reyap_count-1)];
                
                reyapped = false;
                
                NSNumber *reyapped_by_viewer2 = [[NSNumber alloc] initWithBool:reyapped];
                NSNumber *yap_reyaps_value2 = [[NSNumber alloc] initWithInt:reyap_count-1];
                
                [sharedManager.sessionCurrentPlayingYap setValue:yap_reyaps_value2 forKey:@"yap_reyaps_value"];
                
                [sharedManager.sessionCurrentPlayingYap setValue:reyapped_by_viewer2 forKey:@"reyapped_by_viewer"];
            }
        }
    }
    else if (connection == connection3) {
        NSData *data = [responseBodyLikeYap dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *json_create_like = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        BOOL isValid = [[json_create_like objectForKey:@"valid"] boolValue];
        
        if (isValid) {
            DLog(@"IS VALID");
            if (!liked) {
                DLog(@"%@", json_create_like);
                
                [btnLike setBackgroundImage:[UIImage imageNamed:@"bttn_like.png"] forState:UIControlStateNormal];
                
                double like_count = [yapLikes.text doubleValue];
                
                yapLikes.text = [NSString stringWithFormat:@"%0.0f", (like_count+1)];
                
                liked = true;
                
                NSNumber *liked_by_viewer2 = [[NSNumber alloc] initWithBool:liked];
                NSNumber *yap_likes_value2 = [[NSNumber alloc] initWithInt:like_count+1];
                
                [sharedManager.sessionCurrentPlayingYap setValue:yap_likes_value2 forKey:@"yap_likes_value"];
                
                [sharedManager.sessionCurrentPlayingYap setValue:liked_by_viewer2 forKey:@"liked_by_viewer"];
                
                //sharedManager.currentYapPlaying

            }
            else {
                [btnLike setBackgroundImage:[UIImage imageNamed:@"bttn_like wt-circle.png"] forState:UIControlStateNormal];
                
                double like_count = [yapLikes.text doubleValue];
                
                yapLikes.text = [NSString stringWithFormat:@"%0.0f", (like_count-1)];
                
                liked = false;
                
                NSNumber *liked_by_viewer2 = [[NSNumber alloc] initWithBool:liked];
                NSNumber *yap_likes_value2 = [[NSNumber alloc] initWithInt:like_count-1];
                
                [sharedManager.sessionCurrentPlayingYap setValue:yap_likes_value2 forKey:@"yap_likes_value"];
                
                [sharedManager.sessionCurrentPlayingYap setValue:liked_by_viewer2 forKey:@"liked_by_viewer"];
            }
            
            /*
            Feed *userFeedData = [stream.userFeed objectAtIndex:sharedManager.currentYapPlaying];
            
            NSLog(@"userFeedData.liked_by_viewer %hhd", userFeedData.liked_by_viewer);
            
            userFeedData.liked_by_viewer = liked;
            
            Feed *userFeedData2 = [stream.userFeed objectAtIndex:sharedManager.currentYapPlaying];
            
            NSLog(@"userFeedData2.liked_by_viewer %hhd", userFeedData2.liked_by_viewer);
             */
        }
    }
    
    if (connection == connection6) {
        //DLog(@"RESPONSE: %@", responseBody);
        
        //set up feed info array
        
        NSData *data;
        
        if ([cameFrom isEqualToString:@"user_profile"]) {
            if ([profile_stream_type isEqualToString:@"posts"]) {
                data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
            }
            else if ([profile_stream_type isEqualToString:@"likes"]) {
                data = [responseBodyLikes dataUsingEncoding:NSUTF8StringEncoding];
            }
            else if ([profile_stream_type isEqualToString:@"listens"]) {
                data = [responseBodyListens dataUsingEncoding:NSUTF8StringEncoding];
            }
        }
        else if ([cameFrom isEqualToString:@"home_stream"]) {
            data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        jsonAfterYap = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSDictionary *post_info;
        NSDictionary *yap_info;
        NSDictionary *user;
        NSDictionary *channel;
        NSDictionary *reyap_user_dic;
        
        if (jsonAfterYap.count > 0) {
            if (true) {
                for (int i = 0; i < jsonAfterYap.count; i++) {
                    post_info = [[jsonAfterYap objectAtIndex:i] objectForKey:@"post_info"];
                    yap_info = [[jsonAfterYap objectAtIndex:i] objectForKey:@"yap_info"];
                    user = [yap_info objectForKey:@"user"];
                    reyap_user_dic = [post_info objectForKey:@"reyap_user"];
                    
                    //create feed object
                    BOOL liked_by_viewer2 = [[post_info objectForKey:@"liked_by_viewer"] boolValue];
                    double user_post_id2 = [[[jsonAfterYap objectAtIndex:i] objectForKey:@"user_post_id"] doubleValue];
                    //DLog(@"after: %d", user_post_id);
                    int like_count2 = [[yap_info objectForKey:@"like_count"] intValue];
                    int reyap_count2 = [[yap_info objectForKey:@"reyap_count"] intValue];
                    NSArray *group2;
                    if (![[yap_info objectForKey:@"channel"] isKindOfClass:[NSNull class]]) {
                        channel = [yap_info objectForKey:@"channel"];
                        group2 = [[NSArray alloc] initWithObjects:channel, nil];
                    }
                    double google_plus_account_id2 = 0;
                    if (![[yap_info objectForKey:@"google_plus_account_id"] isKindOfClass:[NSNull class]]) {
                        google_plus_account_id2 = [[yap_info objectForKey:@"google_plus_account_id"]
                                                  doubleValue];
                    }
                    double facebook_account_id2 = 0;
                    if (![[yap_info objectForKey:@"facebook_account_id"] isKindOfClass:[NSNull class]]) {
                        facebook_account_id2 = [[yap_info objectForKey:@"facebook_account_id"] doubleValue];
                    }
                    double twitter_account_id2 = 0;
                    if (![[yap_info objectForKey:@"twitter_account_id"] isKindOfClass:[NSNull class]]) {
                        twitter_account_id2 = [[yap_info objectForKey:@"twitter_account_id"] doubleValue];
                    }
                    double linkedin_account_id2 = 0;
                    if (![[yap_info objectForKey:@"linkedin_account_id"] isKindOfClass:[NSNull class]]) {
                        linkedin_account_id2 = [[yap_info objectForKey:@"linkedin_account_id"] doubleValue];
                    }
                    
                    BOOL reyapped_by_viewer2 = [[post_info objectForKey:@"reyapped_by_viewer"] boolValue];
                    BOOL group_flag2 = [[yap_info objectForKey:@"channel_flag"] boolValue];
                    BOOL listened_by_viewer2 = [[post_info objectForKey:@"listened_by_viewer"] boolValue];
                    BOOL hashtags_flag2 = [[yap_info objectForKey:@"hashtags_flag"] boolValue];
                    BOOL is_deleted2 = [[yap_info objectForKey:@"is_deleted"] boolValue];
                    BOOL linkedin_shared_flag2 = [[yap_info objectForKey:@"linkedin_shared_flag"] boolValue];
                    BOOL facebook_shared_flag2 = [[yap_info objectForKey:@"facebook_shared_flag"] boolValue];
                    BOOL twitter_shared_flag2 = [[yap_info objectForKey:@"twitter_shared_flag"] boolValue];
                    BOOL google_plus_shared_flag2 = [[yap_info objectForKey:@"google_plus_shared_flag"] boolValue];
                    BOOL user_tags_flag2 = [[yap_info objectForKey:@"user_tags_flag"] boolValue];
                    BOOL web_link_flag2 = [[yap_info objectForKey:@"web_link_flag"] boolValue];
                    BOOL picture_flag2 = [[yap_info objectForKey:@"picture_flag"] boolValue];
                    BOOL picture_cropped_flag2 = [[yap_info objectForKey:@"picture_cropped_flag"] boolValue];
                    BOOL is_active2 = [[yap_info objectForKey:@"is_active"] boolValue];
                    int listen_count2 = [[yap_info objectForKey:@"listen_count"] intValue];
                    NSString *reyap_user2;
                    
                    if (![reyap_user_dic isKindOfClass:[NSNull class]]) {
                        reyap_user2 = [reyap_user_dic objectForKey:@"username"];
                    }
                    else {
                        reyap_user2 = @"";
                    }
                    
                    DLog(@"reyap_user %@", post_info);
                    
                    NSString *latitude2 = [yap_info objectForKey:@"latitude"];
                    NSString *longitude2 = [yap_info objectForKey:@"longitude"];
                    NSString *yap_longitude2 = [yap_info objectForKey:@"longitude"];
                    NSString *username2 = [user objectForKey:@"username"];
                    NSString *first_name2 = [user objectForKey:@"first_name"];
                    NSString *last_name2 = [user objectForKey:@"last_name"];
                    NSString *picture_path2 = [yap_info objectForKey:@"picture_path"];
                    NSString *picture_cropped_path2 = [yap_info objectForKey:@"picture_cropped_path"];
                    NSString *profile_picture_path2 = [user objectForKey:@"profile_picture_path"];
                    NSString *profile_cropped_picture_path2 = [user objectForKey:@"profile_cropped_picture_path"];
                    NSString *web_link2 = [yap_info objectForKey:@"web_link"];
                    NSString *yap_length2 = [yap_info objectForKey:@"length"];
                    double user_id2 = [[user objectForKey:@"id"] doubleValue];
                    double reyap_user_id2 = 0;
                    double yap_id2 = [[yap_info objectForKey:@"yap_id"] doubleValue];
                    double reyap_id2 = 0;
                    
                    if (![reyap_user2 isEqualToString:@""]) {
                        reyap_id2 = [[post_info objectForKey:@"reyap_id"] doubleValue];
                        reyap_user_id2 = [[reyap_user_dic objectForKey:@"id"] doubleValue];
                    }
                    
                    if ([profile_stream_type isEqualToString:@"posts"]) {
                        after_reyap = 0;
                        after_yap = 0;
                        
                        if (![reyap_user2 isEqualToString:@""]) {
                            after_reyap = reyap_id2;
                            last_after_reyap = after_reyap;
                        }
                        else {
                            if (last_after_reyap != 0) {
                                after_reyap = last_after_reyap;
                            }
                        }
                        
                        after_yap = yap_id2;
                    }
                    if ([profile_stream_type isEqualToString:@"likes"]) {
                        double like_id = [[[jsonAfterYap objectAtIndex:i] objectForKey:@"like_id"] doubleValue];
                        
                        after_yap = like_id;
                    }
                    if ([profile_stream_type isEqualToString:@"listens"]) {
                        double listen_id2 = [[[jsonAfterYap objectAtIndex:i] objectForKey:@"listen_id"] doubleValue];
                        
                        after_yap = listen_id2;
                    }
                    
                    NSString *yap_title2 = [yap_info objectForKey:@"title"];
                    NSString *audio_path2 = [yap_info objectForKey:@"audio_path"];
                    NSArray *user_tags2 = [yap_info objectForKey:@"user_tags"];
                    NSArray *hashtags2 = [yap_info objectForKey:@"hashtags"];
                    NSDate *post_date_created2 = [post_info objectForKey:@"date_created"];
                    NSDate *yap_date_created2 = [yap_info objectForKey:@"date_created"];
                    
                    Feed *UserActualFeedObject = [[Feed alloc] initWithYapId: (int) yap_id2 andReyapId: (double) reyap_id2 andUserPostId: (double) user_post_id2 andLikedByViewer: (BOOL) liked_by_viewer2 andReyapUser: (NSString *) reyap_user2 andLikeCount: (int) like_count2 andReyapCount: (int) reyap_count2 andGroup: (NSArray *) group2 andGooglePlusAccountId: (double) google_plus_account_id2 andFacebookAccountId: (double) facebook_account_id2 andTwitterAccountId: (double) twitter_account_id2 andLinkedinAccountId: (double) linkedin_account_id2 andReyappedByViewer: (BOOL) reyapped_by_viewer2 andListenedByViewer: (BOOL) listened_by_viewer2 andHashtagsFlag: (BOOL) hashtags_flag2 andLinkedinSharedFlag: (BOOL) linkedin_shared_flag2 andFacebookSharedFlag: (BOOL) facebook_shared_flag2 andTwitterSharedFlag: (BOOL) twitter_shared_flag2 andGooglePlusSharedFlag: (BOOL) google_plus_shared_flag2 andUserTagsFlag: (BOOL) user_tags_flag2 andWebLinkFlag: (BOOL) web_link_flag2 andPictureFlag: (BOOL) picture_flag2 andPictureCroppedFlag: (BOOL) picture_cropped_flag2 andIsActive: (BOOL) is_active2 andGroupFlag: (BOOL) group_flag2 andIsDeleted: (BOOL) is_deleted2 andListenCount: (int) listen_count2 andLatitude: (NSString *) latitude2 andLongitude: (NSString *) longitude2 andYapLongitude: (NSString *) yap_longitude2 andUsername: (NSString *) username2 andFirstName: (NSString *) first_name2 andLastName: (NSString *) last_name2 andPicturePath: (NSString *) picture_path2 andPictureCroppedPath: (NSString *) picture_cropped_path2 andProfilePicturePath: (NSString *) profile_picture_path2 andProfileCroppedPicturePath: (NSString *) profile_cropped_picture_path2 andWebLink: (NSString *) web_link2 andYapLength: (NSString *) yap_length2 andUserId: (double) user_id2 andReyapUserId: (double) reyap_user_id2 andYapTitle: (NSString *) yap_title2 andAudioPath: (NSString *) audio_path2 andUserTags: (NSArray *) user_tags2 andHashtags: (NSArray *) hashtags2 andPostDateCreated: (NSDate *) post_date_created2 andYapDateCreated: (NSDate *) yap_date_created2];
                    
                    //add user object to user info array
                    [userFeed addObject:UserActualFeedObject];
                    
                    NSNumber *yap_to_play3 = [[NSNumber alloc] initWithDouble:UserActualFeedObject.yap_id];
                    NSNumber *user_id3 = [[NSNumber alloc] initWithDouble:UserActualFeedObject.user_id];
                    NSNumber *reyap_user_id3 = [[NSNumber alloc] initWithDouble:UserActualFeedObject.reyap_user_id];
                    NSNumber *reyapped_by_viewer3 = [[NSNumber alloc] initWithBool:UserActualFeedObject.reyapped_by_viewer];
                    NSNumber *liked_by_viewer3 = [[NSNumber alloc] initWithBool:UserActualFeedObject.liked_by_viewer];
                    NSNumber *hashtags_flag3 = [[NSNumber alloc] initWithBool:UserActualFeedObject.hashtags_flag];
                    NSNumber *user_tags_flag3 = [[NSNumber alloc] initWithBool:UserActualFeedObject.user_tags_flag];
                    NSNumber *web_link_flag3 = [[NSNumber alloc] initWithBool:UserActualFeedObject.web_link_flag];
                    NSNumber *yap_picture_flag3 = [[NSNumber alloc] initWithBool:UserActualFeedObject.picture_flag];
                    NSNumber *yap_picture_cropped_flag3 = [[NSNumber alloc] initWithBool:UserActualFeedObject.picture_cropped_flag];
                    NSNumber *yap_plays_value3 = [[NSNumber alloc] initWithInt:UserActualFeedObject.listen_count];
                    NSNumber *yap_reyaps_value3 = [[NSNumber alloc] initWithInt:UserActualFeedObject.reyap_count];
                    NSNumber *yap_likes_value3 = [[NSNumber alloc] initWithInt:UserActualFeedObject.like_count];
                    NSNumber *yap_length_value3 = [[NSNumber alloc] initWithInt:[UserActualFeedObject.yap_length intValue]];
                    NSNumber *yap_length_int3 = [[NSNumber alloc] initWithInt:[UserActualFeedObject.yap_length intValue]];
                    
                    NSMutableDictionary *playlistDic = [[NSMutableDictionary alloc] init];
                    
                    [playlistDic setObject:yap_to_play3 forKey:@"yap_to_play"];
                    [playlistDic setObject:user_id3 forKey:@"user_id"];
                    
                    [playlistDic setObject:[NSString stringWithFormat:@"%@ %@", UserActualFeedObject.first_name, UserActualFeedObject.last_name] forKey:@"name_value"];
                    [playlistDic setObject:UserActualFeedObject.username forKey:@"username_value"];
                    
                    NSString *dateString;
                    
                    if (UserActualFeedObject.reyap_user != nil && ![UserActualFeedObject.reyap_user isEqualToString:@""]) {
                        [playlistDic setObject:UserActualFeedObject.reyap_user forKey:@"reyap_username_value"];
                        [playlistDic setObject:reyap_user_id3 forKey:@"reyap_user_id"];
                        [playlistDic setObject:@"reyap" forKey:@"object_type"];
                        dateString = [NSString stringWithFormat:@"%@", UserActualFeedObject.post_date_created];
                    }
                    else {
                        [playlistDic setObject:@"yap" forKey:@"object_type"];
                        dateString = [NSString stringWithFormat:@"%@", UserActualFeedObject.yap_date_created];
                    }
                    
                    [playlistDic setObject:reyapped_by_viewer3 forKey:@"reyapped_by_viewer"];
                    [playlistDic setObject:liked_by_viewer3 forKey:@"liked_by_viewer"];
                    [playlistDic setObject:UserActualFeedObject.title forKey:@"yap_title_value"];
                    
                    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    
                    NSRange range = [dateString rangeOfString:@"."];
                    
                    dateString = [dateString substringToIndex:range.location];
                    
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
                    [playlistDic setObject:yap_length_value3 forKey:@"yap_length_value"];
                    [playlistDic setObject:yap_plays_value3 forKey:@"yap_plays_value"];
                    [playlistDic setObject:yap_reyaps_value3 forKey:@"yap_reyaps_value"];
                    [playlistDic setObject:yap_likes_value3 forKey:@"yap_likes_value"];
                    [playlistDic setObject:yap_length_int3 forKey:@"yap_length_int"];
                    
                    if (UserActualFeedObject.audio_path != nil && ![UserActualFeedObject.audio_path isEqualToString:@""]) {
                        [playlistDic setObject:UserActualFeedObject.audio_path forKey:@"yap_audio_path"];
                    }
                    
                    if (UserActualFeedObject.web_link_flag) {
                        [playlistDic setValue:web_link_flag3 forKey:@"web_link_flag"];
                        [playlistDic setValue:UserActualFeedObject.web_link forKey:@"web_link"];
                    }
                    
                    if (UserActualFeedObject.picture_flag) {
                        [playlistDic setValue:yap_picture_flag3 forKey:@"picture_flag"];
                        [playlistDic setValue:UserActualFeedObject.picture_path forKey:@"picture_path"];
                    }
                    
                    if (UserActualFeedObject.picture_cropped_flag) {
                        [playlistDic setValue:yap_picture_cropped_flag3 forKey:@"picture_cropped_flag"];
                        [playlistDic setValue:UserActualFeedObject.picture_cropped_path forKey:@"picture_cropped_path"];
                    }
                    
                    if (UserActualFeedObject.hashtags_flag) {
                        [playlistDic setValue:hashtags_flag3 forKey:@"hashtags_flag"];
                        [playlistDic setValue:UserActualFeedObject.hashtags forKey:@"hashtags"];
                    }
                    
                    if (UserActualFeedObject.user_tags_flag) {
                        [playlistDic setValue:user_tags_flag3 forKey:@"user_tags_flag"];
                        [playlistDic setValue:UserActualFeedObject.user_tags forKey:@"user_tags"];
                    }
                    
                    if (![UserActualFeedObject.profile_cropped_picture_path isEqualToString:@""]) {
                        [playlistDic setValue:UserActualFeedObject.profile_cropped_picture_path forKey:@"user_profile_picture_cropped_path"];
                    }
                    else {
                        [playlistDic setValue:@"" forKey:@"user_profile_picture_cropped_path"];
                    }
                    
                    if (![sharedManager.sessionCurrentPlaylist containsObject:playlistDic]) {
                        [sharedManager.sessionCurrentPlaylist addObject:playlistDic];
                    }
                }
            }
            
            //[self loadMoreYapsToPlaylist];
        }
    }
}

-(IBAction)goBack:(id)sender {
    DLog(@"go back");
    
    cameFromPlayerScreen = YES;
    
    if (!cameFromPushNotifications) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UserNotifications *notificationsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserNotificationsVC"];
        
        //Push to controller
        [self.navigationController pushViewController:notificationsVC animated:YES];
    }
}

-(IBAction)goToUserProfile:(id)sender {
    UIButton *button = sender;
    double user_id2 = button.tag;
    NSString *the_username = button.titleLabel.text;
    
    NSRange range = [the_username rangeOfString:@"@"];
    the_username = [[the_username substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //user handle listen click
    NSError *error;
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    //NSNumber *tempUserHandleClicked = [[NSNumber alloc] initWithDouble:user_id2];
    NSNumber *tempListenId = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
    NSNumber *time_clicked = [[NSNumber alloc] initWithDouble:self.counter];
    
    NSMutableDictionary *newDatasetInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    time_clicked, @"time_clicked",
                                    tempListenId, @"listen_id",
                                    nil];
    
    NSURL *the_url;
    
    if (the_username != [NSString stringWithFormat:@"@%@", sessionUsername]) {
        [newDatasetInfo setValue:the_username forKey:@"user_handle_clicked"];
        
        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/listen/user_handle_clicked/"];
    }
    else {
        the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/listen/user_yapped_clicked/"];
    }
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
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
    
    connection5 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection5 start];
    
    if (connection5) {
        
    }
    else {
        //Error
    }
    
    UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
    
    UserProfileVC.userToView = user_id2;
    
    //Push to controller
    [self.navigationController pushViewController:UserProfileVC animated:YES];
}

-(IBAction)goToUserProfileFromPhoto:(id)sender {
    UIButton *button = sender;
    double user_id2 = button.tag;
    
    //user handle listen click
    NSError *error;
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    //NSNumber *tempUserHandleClicked = [[NSNumber alloc] initWithDouble:user_id2];
    NSNumber *tempListenId = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
    NSNumber *time_clicked = [[NSNumber alloc] initWithDouble:self.counter];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    time_clicked, @"time_clicked",
                                    tempListenId, @"listen_id",
                                    username_value, @"user_handle_clicked",
                                    nil];
    
    NSURL *the_url;
    
    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/listen/user_yapped_clicked/"];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
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
    
    connection5 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection5 start];
    
    if (connection5) {
        
    }
    else {
        //Error
    }
    
    UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
    
    UserProfileVC.userToView = user_id2;
    
    //Push to controller
    [self.navigationController pushViewController:UserProfileVC animated:YES];
}

-(IBAction)goToReyapUserProfile:(id)sender {
    UIButton *button = sender;
    double user_id2 = button.tag;
    
    //reyap user handle listen click
    NSError *error;
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempListenId = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
    NSNumber *time_clicked = [[NSNumber alloc] initWithDouble:self.counter];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    time_clicked, @"time_clicked",
                                    tempListenId, @"listen_id",
                                    nil];
    
    NSURL *the_url;
    
    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/listen/user_reyapped_clicked/"];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
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
    
    connection5 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection5 start];
    
    if (connection5) {
        
    }
    else {
        //Error
    }
    
    UserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileVC"];
    
    UserProfileVC.userToView = user_id2;
    
    //Push to controller
    [self.navigationController pushViewController:UserProfileVC animated:YES];
}

-(IBAction)searchHashtag:(id)sender {
    UIButton *button = sender;
    double the_hashtag_id = button.tag;
    NSString *hashtag_title = button.titleLabel.text;
    
    //hashtag listen click
    NSError *error;
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempHashtagClicked = [[NSNumber alloc] initWithDouble:the_hashtag_id];
    NSNumber *tempListenId = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
    NSNumber *time_clicked = [[NSNumber alloc] initWithDouble:self.counter];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    tempHashtagClicked, @"hashtag_clicked",
                                    time_clicked, @"time_clicked",
                                    tempListenId, @"listen_id",
                                    nil];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/listen/hashtag_clicked/"];
    
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
    
    connection4 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection4 start];
    
    if (connection4) {
        
    }
    else {
        //Error
    }
    
    searchResultsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultsVC"];
    
    searchResultsVC.hashtagSearch = true;
    searchResultsVC.hashtags_array = [[hashtag_title componentsSeparatedByString: @"#"] mutableCopy];
    
    [self.navigationController pushViewController:searchResultsVC animated:YES];
}

-(IBAction)playOrPauseYap:(id)sender {
    if (sharedManager.playlistYapsPlayer.playing) {
        [sharedManager.playlistYapsPlayer stop];
    }
    
    if ([sharedManager.playerScreenYapsPlayer rate] != 0.0) {
        sharedManager.currentYapPlayingTime = CMTimeGetSeconds(sharedManager.playerScreenYapsPlayer.currentItem.currentTime);
        
        [sharedManager.playerScreenYapsPlayer pause];
        [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_play.png"] forState:UIControlStateNormal];
        [self.timer invalidate];
        
        wasPaused = true;
    }
    else {
        [sharedManager.playerScreenYapsPlayer play];
        
        [self showYapInfoInBackground];
        
        [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_pause wt.png"] forState:UIControlStateNormal];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
        
        wasPaused = false;
        
        if (yapFinishedPlaying) {
            //get yap listen_id
            NSError *error;
            
            NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
            NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
            NSNumber *tempObjectId;
            
            if ([object_type isEqualToString:@"yap"]) {
                tempObjectId =[[NSNumber alloc] initWithDouble:yap_to_play];
            }
            else {
                tempObjectId =[[NSNumber alloc] initWithDouble:reyap_id];
            }
            
            //NSLog(@"object_typedfdf %@ %@", object_type, );
            
            NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            tempSessionUserID, @"user_id",
                                            tempSessionID, @"session_id",
                                            tempObjectId, @"obj",
                                            object_type, @"obj_type",
                                            nil];
            
            //convert object to data
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/listen/"];
            
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
            
            connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection1 start];
            
            if (connection1) {
                
            }
            else {
                //Error
            }
            
            double listen_count = [yapPlays.text doubleValue];
            
            NSNumber *yap_listens_value2 = [[NSNumber alloc] initWithInt:listen_count+1];
            
            [sharedManager.sessionCurrentPlayingYap setValue:yap_listens_value2 forKey:@"yap_plays_value"];
            
            yapPlays.text = [NSString stringWithFormat:@"%0.0f", (listen_count+1)];
            
            yapFinishedPlaying = false;
        }
    }
}

-(void)loadYapPhoto:(NSNotification *) notification {
    if (yap_picture_flag) {
        cropped_photo = [sharedManager.sessionCurrentPlayingYap valueForKey:@"cropped_photo"];
        big_photo = [sharedManager.sessionCurrentPlayingYap valueForKey:@"big_photo"];
        
        if (cropped_photo != nil)
            [btnYapPhotoCropped setBackgroundImage:cropped_photo forState:UIControlStateNormal];
        
        if (big_photo != nil) {
            bigYapPhotoViewWrapper.backgroundColor = [UIColor blackColor];
            
            bigYapPhotoView = [[UIImageView alloc] init];
            bigYapPhotoView.image = big_photo;
            
            bigYapPhotoView.contentMode = UIViewContentModeScaleAspectFit;
            
            bigYapPhotoViewWrapper.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
            bigYapPhotoScrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
            
            bigYapPhotoView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
            
            for (UIView *subview in self.myZoomableView.subviews) {
                [subview removeFromSuperview];
            }
            
            [[self myZoomableView] addSubview:bigYapPhotoView];
            
            btnYapPhotoCropped.enabled = YES;
            btnYapPhotoCropped.hidden = NO;
        }
        
        loadingData.hidden = YES;
        [loadingData stopAnimating];
    }
    else {
        btnYapPhotoCropped.hidden = YES;
    }
}

-(void)playNextYapInPlaylist:(NSNotification *)notification {
    DLog(@"playNextYapInPlaylist");
    
    [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_play.png"] forState:UIControlStateNormal];
    self.counter = 0;
    currentTime.text = @"00:00";
    self.progressBar.value = 0;
    [self.timer invalidate];
    
    if (isPlaylist) {
        /*
         yap_to_play = 0;
         object_type = @"";
         reyap_username_value = @"";
         isReyap = NO;
         reyap_username_value = @"";
         reyap_user_id = 0;
         
         user_profile_picture_cropped_path = @"";
         
         user_profile_picture_cropped_path = @"";
         
         reyappedByViewer = NO;
         likedByViewer = NO;
         user_id = 0;
         yap_audio_path = @"";
         yap_picture_flag = NO;
         yap_picture_path = @"";
         yap_picture_cropped_flag = NO;
         yap_picture_cropped_path = @"";
         big_photo = nil;
         web_link_flag = NO;
         web_link = @"";
         name_value = @"";
         username_value = @"";
         yap_title_value = @"";
         hashtags_flag = NO;
         hashtags_array = [[NSMutableArray alloc] init];
         user_tags_flag = NO;
         userstag_array = [[NSMutableArray alloc] init];
         yap_date_value = [[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_date_value"];
         yap_plays_value = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_plays_value"] intValue];
         yap_reyaps_value = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_reyaps_value"] intValue];
         yap_likes_value = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_likes_value"] intValue];
         yap_length_value = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_length_value"] intValue];*/
        
        //play next yap in playlist
        int next_yap = sharedManager.currentYapPlaying+1;
        
        [self playYapAtIndex:next_yap];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"yap_finished_playing"
                                                            object:self.view];
    }
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    [sharedManager.playerScreenYapsPlayer seekToTime:kCMTimeZero];
    [sharedManager.playerScreenYapsPlayer pause];
    
    sharedManager.currentYapPlayingTime = CMTimeGetSeconds(sharedManager.playerScreenYapsPlayer.currentItem.currentTime);
    
    [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_play.png"] forState:UIControlStateNormal];
    self.counter = 0;
    currentTime.text = @"00:00";
    self.progressBar.value = 0;
    [self.timer invalidate];
    
    yapFinishedPlaying = true;
    
    DLog(@"FINISHED");
    
    //set time listened
    NSError *error;
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempTimeListened = [[NSNumber alloc] initWithDouble:yap_length_value];
    NSNumber *tempListenID = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    tempTimeListened, @"time_listened",
                                    tempListenID, @"listen_id",
                                    nil];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/listen/time_listened/"];
    
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
    
    connection9 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection9 start];
    
    if (connection9) {
        
    }
    else {
        //Error
    }
    
    cameFromMenu = NO;
    
    if (isPlaylist) {
        //play next yap in playlist
        int next_yap = sharedManager.currentYapPlaying+1;
        
        [self playYapAtIndex:next_yap];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"yap_finished_playing"
                                                            object:self.view];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVPlayer *)player successfully:(BOOL)flag{
    
}

-(void)updateScreen {
    [hashtags_scroll removeFromSuperview];
    [usertags_scroll removeFromSuperview];
    [web_link_btn removeFromSuperview];
    
    //load profile user photo if they have one
    if (![user_profile_picture_cropped_path isEqualToString:@""]) {
        //get cropped user profile photo
        NSString *bucket = @"yapsterapp";
        S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
        
        S3GetPreSignedURLRequest *gpsur_cropped_photo_user = [[S3GetPreSignedURLRequest alloc] init];
        gpsur_cropped_photo_user.key     = user_profile_picture_cropped_path;
        gpsur_cropped_photo_user.bucket  = bucket;
        gpsur_cropped_photo_user.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
        gpsur_cropped_photo_user.responseHeaderOverrides = override;
        
        NSURL *url_cropped_photo_user = [[AmazonClientManager s3] getPreSignedURL:gpsur_cropped_photo_user];
        
        __block UIImage *cropped_photo_user;
        
        [image_download_manager downloadWithURL:url_cropped_photo_user
                                        options:0
                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (image && finished)
             {
                 CALayer *imageLayer = btnUserPhoto.layer;
                 [imageLayer setCornerRadius:btnUserPhoto.frame.size.width/2];
                 [imageLayer setBorderWidth:0.0];
                 [imageLayer setMasksToBounds:YES];
                 
                 cropped_photo_user = image;
                 
                 [btnUserPhoto setBackgroundImage:cropped_photo_user forState:UIControlStateNormal];
             }
         }];
    }
    
    if ([reyap_username_value isKindOfClass:[NSNull class]] || [reyap_username_value isEqualToString:@""] || reyap_username_value == nil) {
        reyapUser.hidden = YES;
        reyap_icon.hidden = YES;
    }
    else {
        [reyapUser setTitle:[NSString stringWithFormat:@"@%@", reyap_username_value] forState:UIControlStateNormal];
        reyapUser.hidden = NO;
        reyap_icon.hidden = NO;
    }
    
    name.text = name_value;
    [username setTitle:[NSString stringWithFormat:@"@%@", username_value] forState:UIControlStateNormal];
    yapTitle.text = yap_title_value;
    yapDate.text = yap_date_value;
    yapPlays.text = [NSString stringWithFormat:@"%i", yap_plays_value];
    yapReyaps.text = [NSString stringWithFormat:@"%i", yap_reyaps_value];
    yapLikes.text = [NSString stringWithFormat:@"%i", yap_likes_value];
    yapLength.text = [NSString stringWithFormat:@"%i", yap_length_value];
    
    if (yap_length_value < 10) {
        yapLength.text = [NSString stringWithFormat:@"00:0%i", yap_length_value];
    }
    else {
        yapLength.text = [NSString stringWithFormat:@"00:%i", yap_length_value];
    }
    
    progressBar.maximumValue = yap_length_value;
    
    progressBar.value = CMTimeGetSeconds(sharedManager.playerScreenYapsPlayer.currentTime);
    
    btnUserPhoto.tag = user_id;
    username.tag = user_id;
    reyapUser.tag = reyap_user_id;
    
    if (!hashtags_flag) {
        yapControlsView.frame = CGRectMake(6, 115, 320, 38);
    }
    else {
        yapControlsView.frame = CGRectMake(6, 135, 320, 38);
        
        for (UIView *subview in [hashtags_scroll subviews]) {
            [subview removeFromSuperview];
        }

        hashtags_scroll.frame = CGRectMake(92, yapTitle.frame.origin.y+yapTitle.frame.size.height+2, 213, yapTitle.frame.size.height);
        
        hashtags_scroll.userInteractionEnabled = YES;
        hashtags_scroll.scrollEnabled = YES;
        hashtags_scroll.showsHorizontalScrollIndicator = NO;
        hashtags_scroll.showsVerticalScrollIndicator = NO;
        
        [username.superview addSubview:hashtags_scroll];
        
        //CGFloat constrainedWidth = 280.0f;
        //CGSize sizeOfText;
        float last_width = 0.0f;
        float max_width = 0.0f;
        
        for (int i = 0; i < hashtags_array.count; i++) {
            UIButton *hashtag_btn = [[UIButton alloc] init];
            if (![cameFrom isEqualToString:@"create_yap"]) {
                [hashtag_btn setTitle:[NSString stringWithFormat:@"#%@", [[hashtags_array objectAtIndex:i] valueForKey:@"hashtag_name"]] forState:UIControlStateNormal];
            }
            else {
                [hashtag_btn setTitle:[NSString stringWithFormat:@"#%@", [hashtags_array objectAtIndex:i]] forState:UIControlStateNormal];
            }
            [hashtag_btn setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
            [hashtag_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            hashtag_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            hashtag_btn.userInteractionEnabled = YES;
            
            hashtag_btn.tag = [[[hashtags_array objectAtIndex:i] valueForKey:@"hashtag_id"] intValue];
            
            [hashtag_btn addTarget:self action:@selector(searchHashtag:) forControlEvents:UIControlEventTouchUpInside];
            
            //sizeOfText = [[NSString stringWithFormat:@"#%@", [[hashtags_array objectAtIndex:i] valueForKey:@"hashtag_name"]] sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:16] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)];
            
            [hashtag_btn sizeToFit];
            
            if (i == 0) {
                hashtag_btn.frame = CGRectMake(0, 0, hashtag_btn.frame.size.width, hashtags_scroll.frame.size.height);
            }
            else {
                hashtag_btn.frame = CGRectMake(max_width, 0, hashtag_btn.frame.size.width, hashtags_scroll.frame.size.height);
            }
            
            last_width = hashtag_btn.frame.size.width;
            max_width = max_width+last_width+5;
            
            [hashtags_scroll addSubview:hashtag_btn];
            
            [hashtags_scroll setContentSize:CGSizeMake(max_width, hashtags_scroll.frame.size.height)];
        }
    }
    
    if (!user_tags_flag && [userstag_array count] == 0) {
        if (!hashtags_flag && [hashtags_array count] == 0) {
            yapControlsView.frame = CGRectMake(6, 115, 320, 38);
        }
        else {
            yapControlsView.frame = CGRectMake(6, 135, 320, 38);
        }
    }
    else {
        if (!hashtags_flag && [hashtags_array count] == 0) {
            yapControlsView.frame = CGRectMake(6, 135, 320, 38);
        }
        else {
            yapControlsView.frame = CGRectMake(6, 155, 320, 38);
        }
        
        for (UIView *subview in [usertags_scroll subviews]) {
            [subview removeFromSuperview];
        }
        
        if (!hashtags_flag && [hashtags_array count] == 0) {
            usertags_scroll.frame = CGRectMake(92, yapTitle.frame.origin.y+yapTitle.frame.size.height+2, 213, yapTitle.frame.size.height);
        }
        else {
            usertags_scroll.frame = CGRectMake(92, yapTitle.frame.origin.y+yapTitle.frame.size.height+22, 213, yapTitle.frame.size.height);
        }
        
        usertags_scroll.userInteractionEnabled = YES;
        usertags_scroll.scrollEnabled = YES;
        usertags_scroll.showsHorizontalScrollIndicator = NO;
        usertags_scroll.showsVerticalScrollIndicator = NO;
        
        [username.superview addSubview:usertags_scroll];
        
        CGFloat constrainedWidth = 280.0f;
        CGSize sizeOfText;
        float last_width = 0.0f;
        float max_width = 0.0f;
        
        for (int i = 0; i < userstag_array.count; i++) {
            UIButton *usertag_btn = [[UIButton alloc] init];
            [usertag_btn setTitle:[NSString stringWithFormat:@"@%@", [[userstag_array objectAtIndex:i] valueForKey:@"username"]] forState:UIControlStateNormal];
            [usertag_btn setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
            [usertag_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            usertag_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            usertag_btn.userInteractionEnabled = YES;
            
            usertag_btn.tag = [[[userstag_array objectAtIndex:i] valueForKey:@"id"] intValue];
            [usertag_btn addTarget:self action:@selector(goToUserProfile:) forControlEvents:UIControlEventTouchUpInside];
            
            sizeOfText = [[NSString stringWithFormat:@"@%@", [[userstag_array objectAtIndex:i] valueForKey:@"username"]] sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:16] constrainedToSize:CGSizeMake(constrainedWidth, CGFLOAT_MAX)];
            
            [usertag_btn sizeToFit];
            
            if (i == 0) {
                usertag_btn.frame = CGRectMake(0, 0, usertag_btn.frame.size.width, usertags_scroll.frame.size.height);
            }
            else {
                usertag_btn.frame = CGRectMake(max_width, 0, usertag_btn.frame.size.width, usertags_scroll.frame.size.height);
            }
            
            last_width = usertag_btn.frame.size.width;
            max_width = max_width+last_width+5;
            
            [usertags_scroll addSubview:usertag_btn];
            
            [usertags_scroll setContentSize:CGSizeMake(max_width, usertags_scroll.frame.size.height)];
        }
    }
    
    if (!web_link_flag) {
        if (!hashtags_flag && [hashtags_array count] == 0) {
            yapControlsView.frame = CGRectMake(6, 135, 320, 38);
        }
        else {
            yapControlsView.frame = CGRectMake(6, 155, 320, 38);
        }
    }
    else {
        if (!hashtags_flag && [hashtags_array count] == 0) {
            yapControlsView.frame = CGRectMake(6, 155, 320, 38);
        }
        else {
            yapControlsView.frame = CGRectMake(6, 175, 320, 38);
        }
        
        [web_link_btn setTitle:[NSString stringWithFormat:@"%@", web_link] forState:UIControlStateNormal];
        [web_link_btn setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
        [web_link_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        web_link_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [web_link_btn setLineBreakMode:NSLineBreakByTruncatingTail];
        
        web_link_btn.userInteractionEnabled = YES;
        
        [web_link_btn addTarget:self action:@selector(openWebLink) forControlEvents:UIControlEventTouchUpInside];
        
        if (!hashtags_flag && [hashtags_array count] == 0) { //no hashtags
            if (!user_tags_flag && [userstag_array count] == 0) { //and no usertags
                web_link_btn.frame = CGRectMake(92, yapTitle.frame.origin.y+yapTitle.frame.size.height+2, 213, yapTitle.frame.size.height);
            }
            else { //has usertags
                web_link_btn.frame = CGRectMake(92, yapTitle.frame.origin.y+yapTitle.frame.size.height+22, 213, yapTitle.frame.size.height);
            }
        }
        else { //has hashtags
            if (!user_tags_flag && [userstag_array count] == 0) { //no usertags
                web_link_btn.frame = CGRectMake(92, yapTitle.frame.origin.y+yapTitle.frame.size.height+22, 213, yapTitle.frame.size.height);
            }
            else { //has usertags
                web_link_btn.frame = CGRectMake(92, yapTitle.frame.origin.y+yapTitle.frame.size.height+42, 213, yapTitle.frame.size.height);
            }
        }
        
        [username.superview addSubview:web_link_btn];
    }
    
    if (reyappedByViewer) {
        [btnReyap setBackgroundImage:[UIImage imageNamed:@"bttn_reyap.png"] forState:UIControlStateNormal];
        reyapped = reyappedByViewer;
    }
    else {
        [btnReyap setBackgroundImage:[UIImage imageNamed:@"bttn_reyap wt-circle.png"] forState:UIControlStateNormal];
        reyapped = false;
    }
    
    if (likedByViewer) {
        if (cameFromPlaylist) {
            DLog(@"LIKED BY VIEWER");
        }
        
        [btnLike setBackgroundImage:[UIImage imageNamed:@"bttn_like.png"] forState:UIControlStateNormal];
        liked = likedByViewer;
    }
    else {
        if (cameFromPlaylist) {
            DLog(@"NOT LIKED BY VIEWER");
        }
        
        [btnLike setBackgroundImage:[UIImage imageNamed:@"bttn_like wt-circle.png"] forState:UIControlStateNormal];
        liked = NO;
    }
    
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        mainBG.frame = CGRectMake(mainBG.frame.origin.x, mainBG.frame.origin.y, mainBG.frame.size.width, 700);
        [mainScrollView setContentSize:(CGSizeMake(320, 720))];
    }
    else {
        mainBG.frame = CGRectMake(mainBG.frame.origin.x, mainBG.frame.origin.y, mainBG.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
        [mainScrollView setContentSize:(CGSizeMake(320, [[UIScreen mainScreen] bounds].size.height))];
    }
}

-(IBAction)goToPreviousYap:(id)sender {
    cameFromPlaylist = false;
    isSingleYap = false;
    
    cameFromMenu = NO;
    
    if ([sharedManager.playerScreenYapsPlayer rate] != 0.0) {
        [sharedManager.playerScreenYapsPlayer pause];
        [sharedManager.playerScreenYapsPlayer seekToTime:kCMTimeZero];
    }
    
    self.counter = 0;
    currentTime.text = [NSString stringWithFormat:@"00:00"];
    [self.timer invalidate];
    
    [sharedManager.playerScreenYapsPlayer seekToTime:kCMTimeZero];
    
    int yap_index = sharedManager.currentYapPlaying-1;
    
    if (yap_index < 0)
        yap_index = 1;
    
    DLog(@"yap_index previous %i", yap_index);
    
    [self playYapAtIndex:yap_index];

    [self showYapInfoInBackground];
    
    //set time listened
    NSError *error;
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempTimeListened = [[NSNumber alloc] initWithDouble:yap_length_value];
    NSNumber *tempListenID = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    tempTimeListened, @"time_listened",
                                    tempListenID, @"listen_id",
                                    nil];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/listen/time_listened/"];
    
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
    
    connection9 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection9 start];
    
    if (connection9) {
        
    }
    else {
        //Error
    }
}

-(IBAction)goToNextYap:(id)sender {
    cameFromPlaylist = false;
    isSingleYap = false;
    
    cameFromMenu = NO;
    
    if ([sharedManager.playerScreenYapsPlayer rate] != 0.0) {
        [sharedManager.playerScreenYapsPlayer pause];
    }
    
    self.counter = 0;
    currentTime.text = [NSString stringWithFormat:@"00:00"];
    [self.timer invalidate];
    
    [sharedManager.playerScreenYapsPlayer seekToTime:kCMTimeZero];
    
    int yap_index = sharedManager.currentYapPlaying+1;
    
    DLog(@"yap_index next %i", yap_index);
    
    [self playYapAtIndex:yap_index];
    
    [self showYapInfoInBackground];
    
    //set time listened
    NSError *error;
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempTimeListened = [[NSNumber alloc] initWithDouble:yap_length_value];
    NSNumber *tempListenID = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    tempTimeListened, @"time_listened",
                                    tempListenID, @"listen_id",
                                    nil];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/listen/time_listened/"];
    
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
    
    connection9 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection9 start];
    
    if (connection9) {
        
    }
    else {
        //Error
    }
}

-(void)playYapAtIndex:(int)yap_index {
    if (([sharedManager.sessionCurrentPlaylist count] >= yap_index+1) && yap_index >= 0) {
        btnYapPhotoCropped.hidden = YES;
        loadingData.hidden = YES;

        DLog(@"next_yap: %i yap_count: %lu", yap_index, (unsigned long)[sharedManager.sessionCurrentPlaylist count]);
        
        yap_to_play = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"yap_to_play"] doubleValue];

        if ([[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"reyap_username_value"] isEqualToString:@""] || [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"reyap_username_value"] == nil) {
            object_type = @"yap";
            reyap_username_value = @"";
        }
        else {
            object_type = @"reyap";
            isReyap = YES;
            reyap_username_value = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"reyap_username_value"];
            reyap_user_id = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"reyap_user_id"] doubleValue];
            reyap_id = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"reyap_id"] doubleValue];
        }
        
        //DLog(@"reyap_username_valued %@", [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"reyap_username_value"]);
        
        user_profile_picture_cropped_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"user_profile_picture_cropped_path"];
        
        user_profile_picture_cropped_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"user_profile_picture_cropped_path"];
        
        cameFrom = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"came_from"];
        reyappedByViewer = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"reyapped_by_viewer"] boolValue];
        likedByViewer = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"liked_by_viewer"] boolValue];
        user_id = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"user_id"] doubleValue];
        yap_audio_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"yap_audio_path"];
        yap_picture_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"picture_flag"] boolValue];
        yap_picture_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index]  valueForKey:@"picture_path"];
        yap_picture_cropped_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"picture_cropped_flag"] boolValue];
        yap_picture_cropped_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"picture_cropped_path"];
        big_photo = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"big_photo"];
        cropped_photo = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"cropped_photo"];
        web_link_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"web_link_flag"] boolValue];
        web_link = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"web_link"];
        name_value = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"name_value"];
        username_value = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"username_value"];
        yap_title_value = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"yap_title_value"];
        
        hashtags_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"hashtags_flag"] boolValue];
        hashtags_array = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"hashtags"];
        user_tags_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"user_tags_flag"] boolValue];
        userstag_array = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"user_tags"];
        yap_date_value = [[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"yap_date_value"];
        yap_plays_value = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"yap_plays_value"] intValue];
        yap_reyaps_value = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"yap_reyaps_value"] intValue];
        yap_likes_value = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"yap_likes_value"] intValue];
        yap_length_value = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index] valueForKey:@"yap_length_value"] intValue];
        
        if (yap_index < sharedManager.currentYapPlaying) {
            sharedManager.currentYapPlaying = sharedManager.currentYapPlaying-1;
        }
        else {
            sharedManager.currentYapPlaying = sharedManager.currentYapPlaying+1;
        }
        
        DLog(@"sharedManager.currentYapPlaying %i", sharedManager.currentYapPlaying);
        
        /*
        id objectInstance;
        NSUInteger indexKey = 0;
        
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
        for (objectInstance in [sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index])
            [mutableDictionary setObject:objectInstance forKey:[NSNumber numberWithUnsignedInt:indexKey++]];*/
        
        sharedManager.sessionCurrentPlayingYap = [[NSMutableArray alloc] init];
        
        [sharedManager.sessionCurrentPlayingYap addObject:[sharedManager.sessionCurrentPlaylist objectAtIndex:yap_index]];
        
        [btnUserPhoto setBackgroundImage:[UIImage imageNamed:@"placer holder_profile photo Large.png"] forState:UIControlStateNormal];
        
        [image_download_manager cancelAll];
        
        loadingData.hidden = NO;
        [loadingData startAnimating];
        
        backBtn.enabled = NO;
        
        [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_pause wt.png"] forState:UIControlStateNormal];
        
        [self updateScreen];
        
        [self getYapAudio];
        
        //get yap listen_id
        NSError *error;
        
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        NSNumber *tempObjectId;
        
        if ([object_type isEqualToString:@"yap"]) {
            tempObjectId =[[NSNumber alloc] initWithDouble:yap_to_play];
        }
        else {
            tempObjectId =[[NSNumber alloc] initWithDouble:reyap_id];
        }
        
        //NSLog(@"object_typedfdf %@ %@", object_type, );
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionID, @"session_id",
                                        tempObjectId, @"obj",
                                        object_type, @"obj_type",
                                        nil];
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/listen/"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:the_url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        /*
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBodyListenId = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        */
        
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
    else {
        DLog(@"LAST: next_yap: %i yap_count: %lu", yap_index, (unsigned long)[sharedManager.sessionCurrentPlaylist count]);
        
        [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_play.png"] forState:UIControlStateNormal];
        self.counter = 0;
        currentTime.text = @"00:00";
        self.progressBar.value = 0;
        [self.timer invalidate];
    }
}

-(IBAction)currentTimeSliderValueChanged:(id)sender
{
    if (self.timer) {
        [timer invalidate];
    }
    
    self.counter = progressBar.value;
    
    if (self.counter < 10) {
        currentTime.text = [NSString stringWithFormat:@"00:0%d", self.counter];
    }
    else {
        currentTime.text = [NSString stringWithFormat:@"00:%d", self.counter];
    }
}

-(IBAction)currentTimeSliderTouchUpInside:(id)sender {
    [sharedManager.playerScreenYapsPlayer pause];
    
    int32_t timeScale = sharedManager.playerScreenYapsPlayer.currentItem.asset.duration.timescale;
    CMTime time = CMTimeMakeWithSeconds(progressBar.value, timeScale);
    [sharedManager.playerScreenYapsPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [btnPlayOrPauseYap setBackgroundImage:[UIImage imageNamed:@"bttn_pause wt.png"] forState:UIControlStateNormal];
    
    //[sharedManager.playerScreenYapsPlayer prepareToPlay];
    [sharedManager.playerScreenYapsPlayer play];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
}

-(IBAction)reyapOrUnreyapYap:(id)sender {
    __block NSError *error;
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempObjectId;
    
    if ([object_type isEqualToString:@"yap"]) {
        tempObjectId =[[NSNumber alloc] initWithDouble:yap_to_play];
    }
    else {
        tempObjectId =[[NSNumber alloc] initWithDouble:reyap_id];
    }
    NSNumber *tempListenId = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
    NSNumber *time_clicked = [[NSNumber alloc] initWithDouble:self.counter];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    tempObjectId, @"obj",
                                    object_type, @"obj_type",
                                    tempListenId, @"listen_id",
                                    time_clicked, @"time_clicked",
                                    nil];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSURL *the_url;
    
    if (!reyapped) {
        the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/reyap/"];
    }
    else {
        the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/unreyap/"];
    }
    
    DLog(@"THE URL: %@", the_url);
    
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
        
        responseBodyReyapYap = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
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

-(IBAction)likeOrUnlikeYap:(id)sender {
    __block NSError *error;
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempObjectId;
    
    if ([object_type isEqualToString:@"yap"]) {
        tempObjectId =[[NSNumber alloc] initWithDouble:yap_to_play];
    }
    else {
        tempObjectId =[[NSNumber alloc] initWithDouble:reyap_id];
    }
    NSNumber *tempListenId = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
    NSNumber *time_clicked = [[NSNumber alloc] initWithDouble:self.counter];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    tempObjectId, @"obj",
                                    object_type, @"obj_type",
                                    tempListenId, @"listen_id",
                                    time_clicked, @"time_clicked",
                                    nil];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSURL *the_url;
    
    if (!liked) {
        the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/like/"];
    }
    else {
        the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/unlike/"];
    }
    
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
        
        responseBodyLikeYap = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
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
                
            }
            else {
                //Error
            }
        });
    });
}

-(IBAction)showBigYapPhoto:(id)sender {
    //photo listen click
    NSError *error;
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];;
    NSNumber *tempListenId = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
    NSNumber *time_clicked = [[NSNumber alloc] initWithDouble:self.counter];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    time_clicked, @"time_clicked",
                                    tempListenId, @"listen_id",
                                    nil];
    
    NSURL *the_url;
    
    the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/listen/picture_clicked/"];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
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
    
    connection5 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection5 start];
    
    if (connection5) {
        
    }
    else {
        //Error
    }
    
    mainScrollView.hidden = YES;
    bigYapPhotoViewWrapper.hidden = NO;
}

-(IBAction)hideBigYapPhoto:(id)sender {
    self.bigYapPhotoScrollView.zoomScale = 1.0;
    
    bigYapPhotoViewWrapper.hidden = YES;
    mainScrollView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
