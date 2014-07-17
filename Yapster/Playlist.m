//
//  Playlist.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/1/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "Playlist.h"
#import "SWTableViewCell.h"
#import "PlayerScreen.h"
#import "Stream.h"
#import "AppPhotoRecord.h"
#import "IconDownloader.h"

@interface Playlist ()

@end

@implementation Playlist

@synthesize yapPlayer;
@synthesize timer;
@synthesize counter;
@synthesize interruptedOnPlayback;
@synthesize sharedManager;
@synthesize generalWebScreenVC;
@synthesize playerScreenVC;
@synthesize streamVC;
@synthesize playlistFeed;
@synthesize theTable;
@synthesize dictAllKeys;
@synthesize dictAllValues;
@synthesize alertViewConfirmClear;
@synthesize pendingOperations;
@synthesize photos;
@synthesize records;
@synthesize backBtn;
@synthesize json;
@synthesize responseBodyListenId;
@synthesize connection1;
@synthesize connection2;
@synthesize playerItemYapAudio;
@synthesize image_download_manager;
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
    image_download_manager = [SDWebImageManager sharedManager];
    
    //audio session
    [sharedManager.playerScreenAudioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [sharedManager.playerScreenAudioSession setActive:YES error:nil];
    
    //sharedManager.playerScreenYapsPlayer.delegate = playerScreenVC.self;
    
    records = [NSMutableArray array];
    
    photos = [[NSMutableArray alloc] init];
    
    self.workingArray = [NSMutableArray array];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yapFinishedPlaying:)
                                                 name:@"yap_finished_playing"
                                               object:playerScreenVC.view];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    if (playlistScreenFirstLoaded) {
        tutorialViewWrapper = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, [[UIScreen mainScreen] bounds].size.height)];
        
        UILabel *title = [[UILabel alloc] init];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            title.frame = CGRectMake(0, 20, tutorialViewWrapper.frame.size.width, 30);
        }
        else {
            title.frame = CGRectMake(0, 30, tutorialViewWrapper.frame.size.width, 30);
        }
        
        title.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
        title.text = @"How To Use Your Playlist";
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
        tutorialScrollView.scrollEnabled = NO;
        tutorialScrollView.contentSize = CGSizeMake(tutorialScrollView.frame.size.width, tutorialScrollView.frame.size.height);
        
        UIImageView *first_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tutorialScrollView.frame.size.width, tutorialScrollView.frame.size.height)];
        first_image.image = [UIImage imageNamed:@"playlist01.png"];
        
        UIButton *done = [[UIButton alloc] init];
        [done setTitle:@"Done" forState:UIControlStateNormal];
        [done setFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];
        [done setTitleColor:[UIColor colorWithRed:21.0f/255.0f green:212.0f/255.0f blue:0.0f alpha:1.0f  ] forState:UIControlStateNormal];
        done.titleLabel.textAlignment = NSTextAlignmentRight;
        done.userInteractionEnabled = YES;
        
        [done addTarget:self action:@selector(closeTutorial) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            done.frame = CGRectMake(tutorialScrollView.frame.size.width-35, tutorialViewWrapper.bounds.size.height-36, 60, 30);
        }
        else {
            done.frame = CGRectMake(tutorialScrollView.frame.size.width-35, tutorialViewWrapper.bounds.size.height-56, 60, 30);
        }
        
        tutorialScrollView.backgroundColor = [UIColor whiteColor];
        tutorialViewWrapper.backgroundColor = [UIColor whiteColor];
        
        [tutorialScrollView addSubview:first_image];
        [tutorialViewWrapper addSubview:done];
        [tutorialViewWrapper addSubview:tutorialScrollView];
        
        [self.view addSubview: tutorialViewWrapper];
        
        playlistScreenFirstLoaded = false;
    }
    
    for (int i = 0; i < sharedManager.sessionCurrentPlaylist.count; i++) {
        self.workingEntry = [[AppPhotoRecord alloc] init];
        
        NSString *profile_cropped_picture_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:i] valueForKey:@"user_profile_picture_cropped_path"];
        
        if (![[[sharedManager.sessionCurrentPlaylist objectAtIndex:i] valueForKey:@"user_profile_picture_cropped_path"] isEqualToString:@""]) {
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
        
        [theTable reloadData];
        
        DLog(@"user_photo_entries.count %i", user_photo_entries.count);
    }
}

-(void)closeTutorial {
    [tutorialViewWrapper removeFromSuperview];
    [tutorialPageControl removeFromSuperview];
}

-(void)yapFinishedPlaying:(NSNotification *)notification {
    DLog(@"yap finished playing");
    
    [theTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender {
    cameFromPlaylist = true;
    
    /*if (sharedManager.sessionCurrentPlaylist.count == 0) {
        streamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Stream"];
        
        [self.navigationController pushViewController:streamVC animated:YES];
    }
    else {*/
        if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissModalViewControllerAnimated:YES];
        }
    //}
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
            [sharedManager.sessionCurrentPlaylist removeAllObjects];
            
            if ([sharedManager.playerScreenYapsPlayer rate] != 0.0) {
                [sharedManager.playerScreenYapsPlayer pause];
            }
            
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        generalWebScreenVC.web_link = web_link;
        
        //Push to controller
        [self.navigationController pushViewController:generalWebScreenVC animated:YES];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection2) {
        NSData *data = [responseBodyListenId dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *json_listen_id = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        sharedManager.currentListenId = [[json_listen_id objectForKey:@"Listen_id"] doubleValue];
        
        DLog(@"LISTEN ID FROM PLAYLIST: %f", sharedManager.currentListenId);
    }
}

-(void)showYapInfoInBackground {
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        NSMutableDictionary *yapInfo = [[NSMutableDictionary alloc] init];
        
        MPMediaItemArtwork *albumArt;
        
        NSString *yap_title_value = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"yap_title_value"];
        NSString *name_value = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"name_value"];
        
        AVPlayerItem *currentItem = sharedManager.playerScreenYapsPlayer.currentItem;
        CMTime duration = currentItem.duration; //total time
        CMTime currentPlayerTime = currentItem.currentTime; //playing time
        
        [yapInfo setObject:yap_title_value forKey:MPMediaItemPropertyTitle];
        [yapInfo setObject:name_value forKey:MPMediaItemPropertyArtist];
        [yapInfo setObject:@"Yapster" forKey:MPMediaItemPropertyAlbumTitle];
        [yapInfo setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(duration)] forKey:MPMediaItemPropertyPlaybackDuration];
        [yapInfo setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(currentPlayerTime)] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [yapInfo setObject:@1.0 forKey:MPNowPlayingInfoPropertyPlaybackRate];
        
        BOOL yap_picture_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"picture_flag"] boolValue];
        
        UIImage *yap_picture = [[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying] valueForKey:@"big_photo"];
        
        if (yap_picture_flag && yap_picture != nil) {
            albumArt = [[MPMediaItemArtwork alloc] initWithImage:yap_picture];
            
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
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"play_or_pause_yap"
                                                                        object:self.view];
                }
                break;
                
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
            case UIEventSubtypeRemoteControlBeginSeekingForward:
            case UIEventSubtypeRemoteControlEndSeekingBackward:
            case UIEventSubtypeRemoteControlEndSeekingForward:
            case UIEventSubtypeRemoteControlPreviousTrack:
                {
                    if (sharedManager.sessionCurrentPlaylist.count > 1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"go_to_previous_yap"
                                                                            object:self.view];
                    }
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                {
                    if (sharedManager.sessionCurrentPlaylist.count > 1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"go_to_next_yap"
                                                                            object:self.view];
                    }
                }
                break;
                
            default:
                break;
        }
    }
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    /*[[NSNotificationCenter defaultCenter] postNotificationName:@"yap_finished_playing_in_playlist_screen"
                                                        object:self.view];*/
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
            cell.profilePhoto.image = [UIImage imageNamed:@"placer holder_profile photo Large.png"];
        }
        else
        {
            cell.profilePhoto.image = photoRecord.actualPhoto;
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
    
    [cell.list_count setTextColor:[UIColor whiteColor]];
    
    [cell.yap_title setTextColor:[UIColor whiteColor]];
    
    [cell.yap_date setTextColor:[UIColor whiteColor]];
    
    [cell.full_name setTextColor:[UIColor whiteColor]];
    
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
            
            [hashtag_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
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
            
            [usertag_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
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
        
    }
    else {
        cell.usertags_scroll.hidden = YES;
    }
    
    if ([[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"web_link_flag"]) {
        NSString *web_link = [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"web_link"];
        
        [cell.web_link_btn setTitle:[NSString stringWithFormat:@"%@", web_link] forState:UIControlStateNormal];
        [cell.web_link_btn setFont:[UIFont fontWithName:@"Helvetica Neue" size:13]];
        
        [cell.web_link_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
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
    
    //DLog(@"CELL COUNT: %lu", (unsigned long)sharedManager.sessionCurrentPlaylist.count);
    
    if (sharedManager.sessionCurrentPlayingYap.count > 0) {
        //DLog(@"%f", [[[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"yap_to_play"] doubleValue]);
        //DLog(@"%@", sharedManager.sessionCurrentPlayingYap);
    
        //double current_yap_in_playlist = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"yap_to_play"] doubleValue];
        //double current_playing_yap = [[[sharedManager.sessionCurrentPlayingYap objectAtIndex:0] valueForKey:@"yap_to_play"] doubleValue];
    
        if (indexPath.row == sharedManager.currentYapPlaying) {
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
    
    cell.delegate = self;
    cell.rightUtilityButtons = [self rightButtonForDelete];

    [loadingData stopAnimating];
    loadingData.hidden = YES;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //set time listened
    NSError *error;
    
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    //NSNumber *tempTimeListened = [[NSNumber alloc] initWithDouble:sharedManager.playerScreenYapsPlayer.currentTime];
    NSNumber *tempListenID = [[NSNumber alloc] initWithDouble:sharedManager.currentListenId];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    //tempTimeListened, @"time_listened",
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
    
    connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection2 start];
    
    if (connection2) {
        
    }
    else {
        //Error
    }
    
    if ([sharedManager.playerScreenYapsPlayer rate] != 0.0) {
        [sharedManager.playerScreenYapsPlayer pause];
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
    //NSData *yap_audio_data = [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"recording_data"];
    
    //DLog(@"%@", [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"yap_audio_path"]);
    
    //DLog(@"%@", yap_audio_path);
    
    NSString *bucket = @"yapsterapp";
    NSString *audio_path = yap_audio_path;
    
    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
    override.contentType = @"audio/mpeg";
    
    //get yap audio
    S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
    gpsur.key     = audio_path;
    gpsur.bucket  = bucket;
    gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
    gpsur.responseHeaderOverrides = override;
    
    NSString *url = [[[AmazonClientManager s3] getPreSignedURL:gpsur] absoluteString];
    
    NSURL *current_yap_audio_url = [NSURL URLWithString:url];
    
    sharedManager.playerScreenYapsPlayer = [[AVPlayer alloc] init];
    sharedManager.playerScreenYapsPlayer.volume = 1;
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    if ([sharedManager.playerScreenYapsPlayer rate] != 0.0) {
        [sharedManager.playerScreenYapsPlayer pause];
        
        int32_t timeScale = sharedManager.playerScreenYapsPlayer.currentItem.asset.duration.timescale;
        CMTime time = CMTimeMakeWithSeconds(0.0, timeScale);
        [sharedManager.playerScreenYapsPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
    
    playerItemYapAudio = [AVPlayerItem playerItemWithURL:current_yap_audio_url];
    
    sharedManager.playerScreenYapsPlayer = [AVPlayer playerWithPlayerItem:playerItemYapAudio];
    sharedManager.playerScreenYapsPlayer = [AVPlayer playerWithURL:current_yap_audio_url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:sharedManager.playerScreenYapsPlayer.currentItem];
    
    [sharedManager.playerScreenYapsPlayer play];
    
    //sharedManager.playerScreenYapsPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [self showYapInfoInBackground];
    
    sharedManager.sessionCurrentPlayingYap = [[NSMutableArray alloc] init];
    
    [sharedManager.sessionCurrentPlayingYap addObject:[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row]];
    
    sharedManager.currentYapPlaying = indexPath.row;
    
    //get new yap listen_id
    NSNumber *tempObjectId;
    
    NSString *object_type = [[NSString alloc] init];
    
    double reyap_id2 = 0;
    
    if ([[[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"reyap_username_value"] isEqualToString:@""] || [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"reyap_username_value"] == nil) {
        object_type = @"yap";
    }
    else {
        object_type = @"reyap";
    }
    
    double yap_to_play2 = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"yap_to_play"] doubleValue];
    reyap_id2 = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"reyap_id"] doubleValue];
    
    if ([object_type isEqualToString:@"yap"]) {
        tempObjectId =[[NSNumber alloc] initWithDouble:yap_to_play2];
    }
    else {
        tempObjectId =[[NSNumber alloc] initWithDouble:reyap_id2];
    }
    
    NSDictionary *newDatasetInfo2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    tempObjectId, @"obj",
                                    object_type, @"obj_type",
                                    nil];
    
    //convert object to data
    NSData* jsonData2 = [NSJSONSerialization dataWithJSONObject:newDatasetInfo2 options:kNilOptions  error:&error];
    
    NSURL *the_url2 = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/listen/"];
    
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] init];
    [request2 setURL:the_url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request2 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request2 setHTTPBody:jsonData2];
    
    NSHTTPURLResponse* urlResponse2 = nil;
    
    NSData *returnData2 = [NSURLConnection sendSynchronousRequest: request2 returningResponse: &urlResponse2 error: &error];
    
    responseBodyListenId = [[NSString alloc] initWithData:returnData2 encoding:NSUTF8StringEncoding];
    
    if (!jsonData2) {
        DLog(@"JSON error: %@", error);
    }
    else {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData2 bytes] length:[jsonData2 length] encoding:NSUTF8StringEncoding];
        DLog(@"JSON: %@", JSONString);
    }
    
    connection2 = [[NSURLConnection alloc] initWithRequest:request2 delegate:self];
    
    [connection2 start];
    
    if (connection2) {
        
    }
    else {
        //Error
    }
    
    override = [[S3ResponseHeaderOverrides alloc] init];
    
    BOOL yap_picture_flag = [[[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"picture_flag"] boolValue];
    NSString *yap_picture_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row]  valueForKey:@"picture_path"];
    NSString *yap_picture_cropped_path = [[sharedManager.sessionCurrentPlaylist objectAtIndex:indexPath.row] valueForKey:@"picture_cropped_path"];
    
    if (yap_picture_flag) {
        //get yap photos: big and cropped
        
        NSString *big_photo_path = yap_picture_path;
        NSString *cropped_photo_path = yap_picture_cropped_path;
        
        //get big image
        S3GetPreSignedURLRequest *gpsur_big_photo = [[S3GetPreSignedURLRequest alloc] init];
        gpsur_big_photo.key     = big_photo_path;
        gpsur_big_photo.bucket  = bucket;
        gpsur_big_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
        gpsur_big_photo.responseHeaderOverrides = override;
        
        NSURL *url_big_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_big_photo];

        __block UIImage *big_photo;
        
        [image_download_manager downloadWithURL:url_big_photo
                                        options:0
                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
         }
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (image && finished)
             {
                 big_photo = image;
                 
                 [sharedManager.sessionCurrentPlayingYap setValue:big_photo forKey:@"big_photo"];
                 
                 //get cropped image
                 S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
                 gpsur_cropped_photo.key     = cropped_photo_path;
                 gpsur_cropped_photo.bucket  = bucket;
                 gpsur_cropped_photo.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
                 gpsur_cropped_photo.responseHeaderOverrides = override;
                 
                 NSURL *url_cropped_photo = [[AmazonClientManager s3] getPreSignedURL:gpsur_cropped_photo];
                 
                 __block UIImage *cropped_photo;
                 
                 [image_download_manager downloadWithURL:url_cropped_photo
                                                 options:0
                                                progress:^(NSInteger receivedSize, NSInteger expectedSize)
                  {
                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                  }
                                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                  {
                      if (image && finished)
                      {
                          cropped_photo = image;
                          
                          [sharedManager.sessionCurrentPlayingYap setValue:cropped_photo forKey:@"cropped_photo"];
                      }
                  }];
             }
         }];
      
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
        [sharedManager.playerScreenYapsPlayer seekToTime:kCMTimeZero];
        [sharedManager.playerScreenYapsPlayer pause];
    }
    
    [sharedManager.sessionCurrentPlaylist removeObjectAtIndex:rowOfTheCell];
    
    if (sharedManager.sessionCurrentPlaylist.count > 0) {
        if (rowOfTheCell == sharedManager.currentYapPlaying) {
            if (rowOfTheCell > 0) {
                sharedManager.currentYapPlaying = rowOfTheCell-1;
            }
            else {
                if (sharedManager.sessionCurrentPlaylist.count == 1) {
                    sharedManager.currentYapPlaying = 0;
                }
                else {
                    sharedManager.currentYapPlaying = rowOfTheCell+1;
                }
            }
            
            sharedManager.sessionCurrentPlayingYap = [[NSMutableArray alloc] init];
            
            [sharedManager.sessionCurrentPlayingYap addObject:[sharedManager.sessionCurrentPlaylist objectAtIndex:sharedManager.currentYapPlaying]]; 
        }
        else {
            if (rowOfTheCell < sharedManager.currentYapPlaying) {
                sharedManager.currentYapPlaying = sharedManager.currentYapPlaying-1;
            }
        }
        
        [user_photo_entries removeObjectAtIndex:rowOfTheCell];
        
        [theTable reloadData];
    }
    else {
        sharedManager.sessionCurrentPlayingYap = nil;
        
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
            
            PlaylistTableCell *cell = (PlaylistTableCell *)[self.theTable cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.profilePhoto.image = photoRecord.actualPhoto;
            
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
