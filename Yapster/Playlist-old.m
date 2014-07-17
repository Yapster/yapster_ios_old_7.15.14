//
//  Playlist.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/1/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "Playlist.h"
#import "SWTableViewCell.h"

@interface Playlist ()

@end

@implementation Playlist

@synthesize yapPlayer;
@synthesize timer;
@synthesize counter;
@synthesize interruptedOnPlayback;
@synthesize sharedManager;
@synthesize generalWebScreenVC;
@synthesize playlistFeed;
@synthesize theTable;
@synthesize dictAllKeys;
@synthesize dictAllValues;
@synthesize alertViewConfirmClear;
@synthesize pendingOperations;
@synthesize photos;
@synthesize records;

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
    
    theTable.scrollsToTop = YES;
    
    sharedManager = [MyManager sharedManager];
    
    sharedManager.playlistYapsPlayer.delegate = self;
    
    records = [NSMutableArray array];
    
    photos = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    //audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    audioSession.delegate = self;
    
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [audioSession setActive:YES error:nil];
    
    //play first yap in playlist
    NSString *yap_audio_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:0] valueForKey:@"yap_audio_path"];
    NSData *yap_audio_data = [[sharedManager.sessionCurrentPlaylist objectAtIndex:0] valueForKey:@"recording_data"];
    
    if (![[[sharedManager.sessionCurrentPlaylist objectAtIndex:0] valueForKey:@"user_profile_picture_cropped_path"] isEqualToString:@""]) {
        //get cropped user profile photo
        NSString *bucket = @"yapsterapp";
        S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
        
        //get profile photo
        S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
        gpsur_cropped_photo.key     = [[sharedManager.sessionCurrentPlaylist objectAtIndex:0] valueForKey:@"user_profile_picture_cropped_path"];
        gpsur_cropped_photo.bucket  = bucket;
        gpsur_cropped_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
        gpsur_cropped_photo.responseHeaderOverrides = override;
        
        NSURL *url_cropped_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_cropped_photo];
        
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
            
            [theTable reloadData];
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
            
            [theTable reloadData];
            //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
        [self.pendingOperations.downloadQueue addOperation:datasource_download_operation];
    }
    
    if (yap_audio_data != nil) {
        sharedManager.playlistYapsPlayer = [[AVAudioPlayer alloc] initWithData:yap_audio_data error:nil];
        
        [sharedManager.playlistYapsPlayer prepareToPlay];
        sharedManager.playlistYapsPlayer.volume = 120;
        [sharedManager.playlistYapsPlayer setDelegate:self];
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        [sharedManager.playlistYapsPlayer play];
        
        sharedManager.currentYapPlaying = 0;
        
        [self showYapInfoInBackground];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
    }
    else {
        S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            });
            
            NSString *bucket = @"yapsterapp";
            //NSString *path = [NSString stringWithFormat:@"/%@", yap_picture_path];
            NSString *audio_path = yap_audio_path;
            
            //get yap audio
            S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
            gpsur.key     = audio_path;
            gpsur.bucket  = bucket;
            gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
            gpsur.responseHeaderOverrides = override;
            
            NSURL *url = [[AmazonClientManager s3] getPreSignedURL:gpsur];
            
            NSData *yap_audio_data;
            
            yap_audio_data = [NSData dataWithContentsOfURL:url];
            
            sharedManager.playlistYapsPlayer = [[AVAudioPlayer alloc] initWithData:yap_audio_data error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [sharedManager.playlistYapsPlayer prepareToPlay];
                sharedManager.playlistYapsPlayer.volume = 120;
                [sharedManager.playlistYapsPlayer setDelegate:self];
                
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                
                [sharedManager.playlistYapsPlayer play];
                
                sharedManager.currentYapPlaying = 0;
                
                [self showYapInfoInBackground];
                
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
                
                for (NSInteger j = 0; j < [theTable numberOfSections]; ++j)
                {
                    for (NSInteger i = 0; i < [theTable numberOfRowsInSection:j]; ++i)
                    { 
                        if (i == 0) {
                            PlaylistTableCell *cell = (PlaylistTableCell *)[theTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                            
                            cell.highlighted = false;
                            
                            cell.list_count.textColor = [UIColor greenColor];
                            cell.yap_title.textColor = [UIColor greenColor];
                            cell.yap_date.textColor = [UIColor greenColor];
                            cell.full_name.textColor = [UIColor greenColor];
                            
                            for (UIButton *button in [cell.hashtags_scroll subviews]) {
                                [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                            }
                            
                            for (UIButton *button in [cell.usertags_scroll subviews]) {
                                [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                            }
                            
                            [cell.web_link_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                        }
                    }
                }
                
                [theTable reloadData];
            });
            
        });
    }
    
    for (int i = 0; i < sharedManager.sessionCurrentPlaylist.count; i++) {
        if (![[[sharedManager.sessionCurrentPlaylist objectAtIndex:i] valueForKey:@"user_profile_picture_cropped_path"] isEqualToString:@""]) {
            //get cropped user profile photo
            NSString *bucket = @"yapsterapp";
            S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
            
            //get profile photo
            S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
            gpsur_cropped_photo.key     = [[sharedManager.sessionCurrentPlaylist objectAtIndex:i] valueForKey:@"user_profile_picture_cropped_path"];
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
                
                [theTable reloadData];
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
                
                [theTable reloadData];
                //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }];
            
            [self.pendingOperations.downloadQueue addOperation:datasource_download_operation];
        }
    }
}


- (void)incrementCounter {
    self.counter++;
}


- (void) audioPlayerBeginInterruption: (AVAudioPlayer *) player {
    if (sharedManager.playlistYapsPlayer.playing) {
        [sharedManager.playlistYapsPlayer pause];
        interruptedOnPlayback = YES;
    }
}

- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player {
    if (interruptedOnPlayback) {
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        [sharedManager.playlistYapsPlayer play];
        
        [self showYapInfoInBackground];
        
        interruptedOnPlayback = NO;
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    self.counter = 0;
    [self.timer invalidate];
    
    //play next yap
    int next_yap = sharedManager.currentYapPlaying+1;
    
    NSLog(@"next_yap: %i yap_count: %lu", next_yap, (unsigned long)[sharedManager.sessionCurrentPlaylist count]);
    
    if ([sharedManager.sessionCurrentPlaylist count] > next_yap) {
        NSString *yap_audio_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:next_yap] valueForKey:@"yap_audio_path"];
        NSData *yap_audio_data = [[sharedManager.sessionCurrentPlaylist objectAtIndex:next_yap] valueForKey:@"recording_data"];
        
        if (yap_audio_data != nil) {
            sharedManager.playlistYapsPlayer = [[AVAudioPlayer alloc] initWithData:yap_audio_data error:nil];
            
            [sharedManager.playlistYapsPlayer prepareToPlay];
            sharedManager.playlistYapsPlayer.volume = 120;
            [sharedManager.playlistYapsPlayer setDelegate:self];
            
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            
            [sharedManager.playlistYapsPlayer play];
            
            //highlight current cell in the playlist
            //NSMutableArray *cells = [[NSMutableArray alloc] init];
            for (NSInteger j = 0; j < [theTable numberOfSections]; ++j)
            {
                for (NSInteger i = 0; i < [theTable numberOfRowsInSection:j]; ++i)
                {
                    
                    if (i != next_yap) {
                        PlaylistTableCell *cell = (PlaylistTableCell *)[theTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                        
                        cell.highlighted = false;
                        
                        cell.list_count.textColor = [UIColor whiteColor];
                        cell.yap_title.textColor = [UIColor whiteColor];
                        cell.yap_date.textColor = [UIColor whiteColor];
                        cell.full_name.textColor = [UIColor whiteColor];
                        
                        for (UIButton *button in [cell.hashtags_scroll subviews]) {
                            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        }
                        
                        for (UIButton *button in [cell.usertags_scroll subviews]) {
                            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        }
                        
                        [cell.web_link_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    else {
                        PlaylistTableCell *cell = (PlaylistTableCell *)[theTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                        
                        cell.highlighted = false;
                        
                        cell.list_count.textColor = [UIColor greenColor];
                        cell.yap_title.textColor = [UIColor greenColor];
                        cell.yap_date.textColor = [UIColor greenColor];
                        cell.full_name.textColor = [UIColor greenColor];
                        
                        for (UIButton *button in [cell.hashtags_scroll subviews]) {
                            [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                        }
                        
                        for (UIButton *button in [cell.usertags_scroll subviews]) {
                            [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                        }
                        
                        [cell.web_link_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                    }
                }
            }
            
            [theTable reloadData];
            
            sharedManager.currentYapPlaying = next_yap;
            
            [self showYapInfoInBackground];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
        }
        else {
            S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                });
                
                NSString *bucket = @"yapsterapp";
                //NSString *path = [NSString stringWithFormat:@"/%@", yap_picture_path];
                NSString *audio_path = yap_audio_path;
                
                //get yap audio
                S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
                gpsur.key     = audio_path;
                gpsur.bucket  = bucket;
                gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
                gpsur.responseHeaderOverrides = override;
                
                NSURL *url = [[AmazonClientManager s3] getPreSignedURL:gpsur];
                
                NSData *yap_audio_data;
                
                yap_audio_data = [NSData dataWithContentsOfURL:url];
                
                sharedManager.playlistYapsPlayer = [[AVAudioPlayer alloc] initWithData:yap_audio_data error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sharedManager.playlistYapsPlayer prepareToPlay];
                    sharedManager.playlistYapsPlayer.volume = 120;
                    [sharedManager.playlistYapsPlayer setDelegate:self];
                    
                    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                    
                    [sharedManager.playlistYapsPlayer play];
                    
                    for (NSInteger j = 0; j < [theTable numberOfSections]; ++j)
                    {
                        for (NSInteger i = 0; i < [theTable numberOfRowsInSection:j]; ++i)
                        {
                            
                            if (i != next_yap) {
                                PlaylistTableCell *cell = (PlaylistTableCell *)[theTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                                
                                cell.highlighted = false;
                                
                                cell.list_count.textColor = [UIColor whiteColor];
                                cell.yap_title.textColor = [UIColor whiteColor];
                                cell.yap_date.textColor = [UIColor whiteColor];
                                cell.full_name.textColor = [UIColor whiteColor];
                                
                                for (UIButton *button in [cell.hashtags_scroll subviews]) {
                                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                }
                                
                                for (UIButton *button in [cell.usertags_scroll subviews]) {
                                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                }
                                
                                [cell.web_link_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            }
                            else {
                                PlaylistTableCell *cell = (PlaylistTableCell *)[theTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                                
                                cell.highlighted = false;
                                
                                cell.list_count.textColor = [UIColor greenColor];
                                cell.yap_title.textColor = [UIColor greenColor];
                                cell.yap_date.textColor = [UIColor greenColor];
                                cell.full_name.textColor = [UIColor greenColor];
                                
                                for (UIButton *button in [cell.hashtags_scroll subviews]) {
                                    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                                }
                                
                                for (UIButton *button in [cell.usertags_scroll subviews]) {
                                    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                                }
                                
                                [cell.web_link_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                            }
                        }
                    }
                    
                    [theTable reloadData];
                    
                    sharedManager.currentYapPlaying = next_yap;
                    
                    [self showYapInfoInBackground];
                    
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
                });
                
            });
        }
    }
    else {
        for (NSInteger j = 0; j < [theTable numberOfSections]; ++j)
        {
            for (NSInteger i = 0; i < [theTable numberOfRowsInSection:j]; ++i)
            {
                PlaylistTableCell *cell = (PlaylistTableCell *)[theTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                
                cell.highlighted = false;
                
                cell.list_count.textColor = [UIColor whiteColor];
                cell.yap_title.textColor = [UIColor whiteColor];
                cell.yap_date.textColor = [UIColor whiteColor];
                cell.full_name.textColor = [UIColor whiteColor];
                
                for (UIButton *button in [cell.hashtags_scroll subviews]) {
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                
                for (UIButton *button in [cell.usertags_scroll subviews]) {
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                
                [cell.web_link_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
        [theTable reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender {
    cameFromPlaylist = true;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirmClear {
	alertViewConfirmClear = [[UIAlertView alloc]
                              initWithTitle:@"Clear Playlist"
                              message:@"Are you sure you want to clear your playlist?"
                              delegate:self
                              cancelButtonTitle:@"Don't clear"
                              otherButtonTitles:nil];
	
	[alertViewConfirmClear addButtonWithTitle:@"Clear"];
	[alertViewConfirmClear show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == alertViewConfirmClear) {
        if (buttonIndex == 1) {
            [sharedManager.playlistYapsPlayer stop];
            
            [sharedManager.sessionCurrentPlaylist removeAllObjects];
            
            theTable.hidden = YES;
            message.text = @"Your playlist is empty.";
            message.hidden = NO;
        }
        
    }
}

-(IBAction)clearPlaylist:(id)sender {
    [self confirmClear];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(IBAction)goToLink:(id)sender {
    UIButton *web_link_btn = sender;
    int row = (int)web_link_btn.tag;
    
    NSString *web_link = [[sharedManager.sessionCurrentPlaylist objectAtIndex:row] valueForKey:@"web_link"];
    
    [self openWebLink:web_link];
}

-(void)openWebLink:(NSString *)web_link {
    generalWebScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GeneralWebScreenVC"];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        generalWebScreenVC.web_link = web_link;
        
        //Push to controller
        [self.navigationController pushViewController:generalWebScreenVC animated:YES];
    }
}

-(void)showYapInfoInBackground {
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        NSMutableDictionary *yapInfo = [[NSMutableDictionary alloc] init];
        //MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imagedNamed:@"AlbumArt"]];
        
        NSString *yap_title = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"yap_title_value"];
        NSString *full_name = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"name_value"];
        
        [yapInfo setObject:yap_title forKey:MPMediaItemPropertyTitle];
        [yapInfo setObject:full_name forKey:MPMediaItemPropertyArtist];
        [yapInfo setObject:@"Yapster" forKey:MPMediaItemPropertyAlbumTitle];
        //[songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:yapInfo];
        
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sharedManager.sessionCurrentPlaylist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 60;
    
    if ([[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"hashtags_flag"]) {
        rowHeight = rowHeight+30;
    }
    
    if ([[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"user_tags_flag"]) {
        rowHeight = rowHeight+30;
    }
    
    if ([[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"web_link_flag"]) {
        rowHeight = rowHeight+30;
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
    
    PlaylistTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([theTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [theTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    theTable.separatorColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CALayer *imageLayer = cell.profilePhoto.layer;
    [imageLayer setCornerRadius:cell.profilePhoto.frame.size.width/2];
    [imageLayer setBorderWidth:0.0];
    [imageLayer setMasksToBounds:YES];
    
    if (self.photos.count > indexPath.row) {
        PhotoRecord *aRecord = [self.photos objectAtIndex:indexPath.row];
        
        if (aRecord.hasImage) {
            
            //[((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
            cell.profilePhoto.image = aRecord.image;
        }
        else if (aRecord.isFailed) {
            [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
            cell.profilePhoto.image = [UIImage imageNamed:@"placer holder_profile photo Large.jpg"];
        }
        else {
            
            //[((UIActivityIndicatorView *)cell.accessoryView) startAnimating];
            cell.profilePhoto.image = [UIImage imageNamed:@"placer holder_profile photo Large.jpg"];
            
            if (!tableView.dragging && !tableView.decelerating) {
                [self startOperationsForPhotoRecord:aRecord atIndexPath:indexPath];
            }
        }
    }
    
    if ([[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"reyap_username_value"] == nil) {
        cell.reyap_icon.hidden = YES;
        cell.yap_title.frame = CGRectMake(33, cell.yap_title.frame.origin.y, cell.yap_title.frame.size.width, cell.yap_title.frame.size.height);
    }
    else {
        cell.reyap_icon.hidden = NO;
        cell.yap_title.frame = CGRectMake(69, cell.yap_title.frame.origin.y, cell.yap_title.frame.size.width, cell.yap_title.frame.size.height);
    }
    
    cell.list_count.text = [NSString stringWithFormat:@"%i", indexPath.row+1];
    cell.yap_title.text = [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"yap_title_value"];
    cell.yap_date.text = [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"yap_date_value"];
    cell.full_name.text = [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"name_value"];
    
    if (!sharedManager.playlistYapsPlayer.playing) {
        [cell.list_count setTextColor:[UIColor whiteColor]];
    }
    else {
        if (sharedManager.currentYapPlaying == indexPath.row) {
            [cell.list_count setTextColor:[UIColor greenColor]];
        }
        else {
            [cell.list_count setTextColor:[UIColor whiteColor]];
        }
    }
    
    if (!sharedManager.playlistYapsPlayer.playing) {
        [cell.yap_title setTextColor:[UIColor whiteColor]];
    }
    else {
        if (sharedManager.currentYapPlaying == indexPath.row) {
            [cell.yap_title setTextColor:[UIColor greenColor]];
        }
        else {
            [cell.yap_title setTextColor:[UIColor whiteColor]];
        }
    }
    
    if (!sharedManager.playlistYapsPlayer.playing) {
        [cell.yap_date setTextColor:[UIColor whiteColor]];
    }
    else {
        if (sharedManager.currentYapPlaying == indexPath.row) {
            [cell.yap_date setTextColor:[UIColor greenColor]];
        }
        else {
            [cell.yap_date setTextColor:[UIColor whiteColor]];
        }
    }
    
    if (!sharedManager.playlistYapsPlayer.playing) {
        [cell.full_name setTextColor:[UIColor whiteColor]];
    }
    else {
        if (sharedManager.currentYapPlaying == indexPath.row) {
            [cell.full_name setTextColor:[UIColor greenColor]];
        }
        else {
            [cell.full_name setTextColor:[UIColor whiteColor]];
        }
    }
    
    if ([[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"hashtags_flag"]) {
        cell.hashtags_scroll.hidden = NO;
        
        NSArray *hashtags_array = [[NSMutableArray alloc] init];
        
        hashtags_array = [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"hashtags"];
        
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
        float max_scrollview_width = 233.0f;
        
        for (int i = 0; i < hashtags_array.count; i++) {
            UIButton *hashtag_btn = [[UIButton alloc] init];
            [hashtag_btn setTitle:[NSString stringWithFormat:@"#%@", [[hashtags_array objectAtIndex:i] valueForKey:@"hashtag_name"]] forState:UIControlStateNormal];
            [hashtag_btn setFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
            
            if (!sharedManager.playlistYapsPlayer.playing) {
                [hashtag_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else {
                if (sharedManager.currentYapPlaying == indexPath.row) {
                    [hashtag_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                }
                else {
                    [hashtag_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
            
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
            max_width = max_width+last_width+10;
            current_scrollview_width = current_scrollview_width+max_width;
            
            if (current_scrollview_width > max_scrollview_width) {
                current_scrollview_width = max_scrollview_width;
            }
            
            [cell.hashtags_scroll setContentSize:CGSizeMake(max_width, cell.hashtags_scroll.frame.size.height)];
            
            cell.hashtags_scroll.frame = CGRectMake(cell.hashtags_scroll.frame.origin.x, cell.hashtags_scroll.frame.origin.y, current_scrollview_width, cell.hashtags_scroll.frame.size.height);
        }
    }
    else {
        cell.hashtags_scroll.hidden = YES;
    }
    
    if ([[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"user_tags_flag"]) {
        cell.usertags_scroll.hidden = NO;
        
        NSArray *usertags_array = [[NSMutableArray alloc] init];
        
        usertags_array = [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"user_tags"];
        
        for (UIView *subview in [cell.usertags_scroll subviews]) {
            [subview removeFromSuperview];
        }
        
        if (![[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"hashtags_flag"]) {
            cell.usertags_scroll.frame = CGRectMake(cell.usertags_scroll.frame.origin.x, 55, cell.usertags_scroll.frame.size.width, cell.usertags_scroll.frame.size.height);
        }
        
        cell.usertags_scroll.userInteractionEnabled = YES;
        cell.usertags_scroll.scrollEnabled = YES;
        cell.usertags_scroll.showsHorizontalScrollIndicator = NO;
        cell.usertags_scroll.showsVerticalScrollIndicator = NO;
        
        float last_width = 0.0f;
        float max_width = 0.0f;
        float current_scrollview_width = 0.0f;
        float max_scrollview_width = 233.0f;
        
        for (int i = 0; i < usertags_array.count; i++) {
            UIButton *usertag_btn = [[UIButton alloc] init];
            [usertag_btn setTitle:[NSString stringWithFormat:@"@%@", [[usertags_array objectAtIndex:i] valueForKey:@"username"]] forState:UIControlStateNormal];
            [usertag_btn setFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
            
            if (!sharedManager.playlistYapsPlayer.playing) {
                [usertag_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else {
                if (sharedManager.currentYapPlaying == indexPath.row) {
                    [usertag_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                }
                else {
                    [usertag_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
            
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
            max_width = max_width+last_width+10;
            current_scrollview_width = current_scrollview_width+max_width;
            
            if (current_scrollview_width > max_scrollview_width) {
                current_scrollview_width = max_scrollview_width;
            }
            
            [cell.usertags_scroll setContentSize:CGSizeMake(max_width, cell.usertags_scroll.frame.size.height)];
            
            cell.usertags_scroll.frame = CGRectMake(cell.usertags_scroll.frame.origin.x, cell.usertags_scroll.frame.origin.y, current_scrollview_width, cell.usertags_scroll.frame.size.height);
        }
        
    }
    else {
        cell.usertags_scroll.hidden = YES;
    }
    
    if ([[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"web_link_flag"]) {
        NSString *web_link = [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"web_link"];
        
        [cell.web_link_btn setTitle:[NSString stringWithFormat:@"%@", web_link] forState:UIControlStateNormal];
        [cell.web_link_btn setFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
        
        if (!sharedManager.playlistYapsPlayer.playing) {
            [cell.web_link_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else {
            if (sharedManager.currentYapPlaying == indexPath.row) {
                [cell.web_link_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            }
            else {
                [cell.web_link_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
        cell.web_link_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        cell.web_link_btn.userInteractionEnabled = YES;
        
        cell.web_link_btn.tag = indexPath.row;
        
        cell.web_link_btn.hidden = NO;
        
        BOOL hashtags_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"hashtags_flag"] boolValue];
        BOOL user_tags_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"user_tags_flag"] boolValue];
        
        if (!hashtags_flag) { //no hashtags
            if (!user_tags_flag) { //and no usertags
                cell.web_link_btn.frame = CGRectMake(cell.web_link_btn.frame.origin.x, 55, cell.web_link_btn.frame.size.width, cell.web_link_btn.frame.size.height);
            }
            else { //has usertags
                cell.web_link_btn.frame = CGRectMake(cell.web_link_btn.frame.origin.x, 82, cell.web_link_btn.frame.size.width, cell.web_link_btn.frame.size.height);
            }
        }
        else { //has hashtags
            if (!user_tags_flag) { //no usertags
                cell.web_link_btn.frame = CGRectMake(cell.web_link_btn.frame.origin.x, 82, cell.web_link_btn.frame.size.width, cell.web_link_btn.frame.size.height);
            }
            else { //has usertags
                cell.web_link_btn.frame = CGRectMake(cell.web_link_btn.frame.origin.x, 113, cell.web_link_btn.frame.size.width, cell.web_link_btn.frame.size.height);
            }
        }
    }
    else {
        cell.web_link_btn.hidden = YES;
    }
    
    cell.delegate = self;
    cell.rightUtilityButtons = [self rightButtonForDelete];

    [loadingData stopAnimating];
    loadingData.hidden = YES;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (sharedManager.playlistYapsPlayer.playing) {
        [sharedManager.playlistYapsPlayer stop];
    }
    
    for (NSInteger j = 0; j < [theTable numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [theTable numberOfRowsInSection:j]; ++i)
        {
            
            if (i != indexPath.row) {
                PlaylistTableCell *cell = (PlaylistTableCell *)[theTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                
                cell.highlighted = false;
                
                cell.list_count.textColor = [UIColor whiteColor];
                cell.yap_title.textColor = [UIColor whiteColor];
                cell.yap_date.textColor = [UIColor whiteColor];
                cell.full_name.textColor = [UIColor whiteColor];
                
                for (UIButton *button in [cell.hashtags_scroll subviews]) {
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                
                for (UIButton *button in [cell.usertags_scroll subviews]) {
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                
                [cell.web_link_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else {
                PlaylistTableCell *cell = (PlaylistTableCell *)[theTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                
                cell.highlighted = false;
                
                cell.list_count.textColor = [UIColor greenColor];
                cell.yap_title.textColor = [UIColor greenColor];
                cell.yap_date.textColor = [UIColor greenColor];
                cell.full_name.textColor = [UIColor greenColor];
                
                for (UIButton *button in [cell.hashtags_scroll subviews]) {
                    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                }
                
                for (UIButton *button in [cell.usertags_scroll subviews]) {
                    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                }
                
                [cell.web_link_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            }
        }
    }
    
    [theTable reloadData];
    
    PlaylistTableCell *cell = (PlaylistTableCell *)[theTable cellForRowAtIndexPath:indexPath];
    cell.list_count.textColor = [UIColor greenColor];
    cell.yap_title.textColor = [UIColor greenColor];
    cell.yap_date.textColor = [UIColor greenColor];
    cell.full_name.textColor = [UIColor greenColor];
    
    for (UIButton *button in [cell.hashtags_scroll subviews]) {
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    
    for (UIButton *button in [cell.usertags_scroll subviews]) {
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    
    [cell.web_link_btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    NSString *yap_audio_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"yap_audio_path"];
    NSData *yap_audio_data = [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"recording_data"];
    
    NSLog(@"%@", [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"yap_audio_path"]);
    
    //NSLog(@"%@", yap_audio_path);
    
    if (yap_audio_data != nil) {
        sharedManager.playlistYapsPlayer = [[AVAudioPlayer alloc] initWithData:yap_audio_data error:nil];
        
        [sharedManager.playlistYapsPlayer prepareToPlay];
        sharedManager.playlistYapsPlayer.volume = 120;
        [sharedManager.playlistYapsPlayer setDelegate:self];
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        [sharedManager.playlistYapsPlayer play];
        
        sharedManager.currentYapPlaying = indexPath.row;
        
        [self showYapInfoInBackground];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
    }
    else {
        S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            });
            
            NSString *bucket = @"yapsterapp";
            //NSString *path = [NSString stringWithFormat:@"/%@", yap_picture_path];
            NSString *audio_path = yap_audio_path;
            
            //get yap audio
            S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
            gpsur.key     = audio_path;
            gpsur.bucket  = bucket;
            gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
            gpsur.responseHeaderOverrides = override;
            
            NSURL *url = [[AmazonClientManager s3] getPreSignedURL:gpsur];
            
            NSData *yap_audio_data;
            
            yap_audio_data = [NSData dataWithContentsOfURL:url];
            
            sharedManager.playlistYapsPlayer = [[AVAudioPlayer alloc] initWithData:yap_audio_data error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [sharedManager.playlistYapsPlayer prepareToPlay];
                sharedManager.playlistYapsPlayer.volume = 120;
                [sharedManager.playlistYapsPlayer setDelegate:self];
                
                [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                
                [sharedManager.playlistYapsPlayer play];
                
                sharedManager.currentYapPlaying = indexPath.row;
                
                [self showYapInfoInBackground];
                
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
            });
            
        });
    }
}

- (NSArray *)rightButtonForDelete
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    SWTableViewCell *current_cell = cell;
    
    NSIndexPath *pathOfTheCell = [theTable indexPathForCell:current_cell];
    NSInteger rowOfTheCell = [pathOfTheCell row];
    
    if (rowOfTheCell == sharedManager.currentYapPlaying) {
        [sharedManager.playlistYapsPlayer stop];
    }
    
    [sharedManager.sessionCurrentPlaylist removeObjectAtIndex:rowOfTheCell];
    
    if (sharedManager.sessionCurrentPlaylist.count > 0) {
        [theTable reloadData];
    }
    else {
        theTable.hidden = YES;
        message.text = @"Your playlist is empty.";
        message.hidden = NO;
    }
    
    [current_cell hideUtilityButtonsAnimated:YES];
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
    if (!theTable.hidden) {
        NSIndexPath *indexPath = downloader.indexPathInTableView;
        PhotoRecord *theRecord = downloader.photoRecord;
        [self.photos replaceObjectAtIndex:indexPath.row withObject:theRecord];
        [theTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
    }
}


#pragma mark -
#pragma mark - UIScrollView delegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self suspendAllOperations];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnscreenCells];
        [self resumeAllOperations];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenCells];
    [self resumeAllOperations];
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
    NSSet *visibleRows = [NSSet setWithArray:[theTable indexPathsForVisibleRows]];
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
