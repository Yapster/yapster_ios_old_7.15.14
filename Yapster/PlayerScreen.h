//
//  PlayerScreen.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/23/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "Reachability.h"
#import "Playlist.h"
#import "MyManager.h"
#import "GeneralWebScreen.h"
#import <AWSRuntime/AWSRuntime.h>
#import "AmazonClientManager.h"
#import "ASIS3ObjectRequest.h"
#import "ZoomableView.h"
#import "AutoScrollLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@class UserProfile;
@class Stream;
@class SearchResults;
@class UserNotifications;

@interface PlayerScreen : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, AVAudioSessionDelegate, UIScrollViewAccessibilityDelegate, UIApplicationDelegate, AmazonServiceRequestDelegate>
{
    NSOperationQueue         *operationQueue;
    
    NSURL *current_yap_audio_url;
    
    NSTimer *timer;
}

@property(retain, nonatomic)Stream *stream;
@property(retain, nonatomic)GeneralWebScreen *generalWebScreenVC;
@property(retain, nonatomic)Playlist *playlistVC;
@property(retain, nonatomic)MyManager *sharedManager;
@property(retain, nonatomic)SearchResults *searchResultsVC;
@property double yap_to_play;
@property double user_id;
@property int index_of_yap_in_stream;
@property BOOL wasPaused;
@property BOOL yapFinishedPlaying;
@property BOOL isNotRecording;
@property BOOL interruptedOnPlayback;
@property BOOL cameFromYapScreen;
@property BOOL cameFromPushNotifications;
@property BOOL hashtags_flag;
@property BOOL user_tags_flag;
@property BOOL web_link_flag;
@property BOOL yap_picture_flag;
@property BOOL yap_picture_cropped_flag;
@property BOOL reyappedByViewer;
@property BOOL reyapped;
@property BOOL isReyap;
@property BOOL likedByViewer;
@property BOOL liked;
@property BOOL isPlaylist;
@property BOOL isSingleYap;
@property BOOL cameFromMenu;
@property double listen_id;
@property double reyap_user_id;
@property double reyap_id;
@property double after_yap;
@property double after_reyap;
@property double last_after_yap;
@property double last_after_reyap;
@property double user_to_view;
@property int counter;
@property int yap_length_int;
@property (nonatomic, strong) AVAudioRecorder *yapRecorder;
@property (nonatomic, strong) AVAudioPlayer *yapPlayer;
@property (nonatomic, strong) NSURL *tempRecFile;
@property (nonatomic, strong) NSData *recordingData;
@property(retain, nonatomic)NSString *responseBody;
@property(retain, nonatomic)NSString *responseBodyLikes;
@property(retain, nonatomic)NSString *responseBodyListens;
@property(retain, nonatomic)NSString *cameFrom;
@property(retain, nonatomic)NSString *profile_stream_type;
@property(retain, nonatomic)NSString *name_value;
@property(retain, nonatomic)NSString *username_value;
@property(retain, nonatomic)NSString *reyap_username_value;
@property(retain, nonatomic)NSString *yap_title_value;
@property(retain, nonatomic)NSString *yap_date_value;
@property(retain, nonatomic)NSString *object_type;
@property(retain, nonatomic)UIScrollView *hashtags_scroll;
@property(retain, nonatomic)UIScrollView *usertags_scroll;
@property(retain, nonatomic)UIButton *web_link_btn;
@property int yap_plays_value;
@property int yap_reyaps_value;
@property int yap_likes_value;
@property int yap_length_value;
@property(retain, nonatomic)NSString *yap_audio_path;
@property(retain, nonatomic)NSString *yap_picture_path;
@property(retain, nonatomic)NSString *yap_picture_cropped_path;
@property(retain, nonatomic)NSString *user_profile_picture_cropped_path;
@property(retain, nonatomic)NSString *web_link;
@property(retain, nonatomic)NSArray *hashtags_array;
@property(retain, nonatomic)NSArray *userstag_array;
@property(retain, nonatomic)S3GetPreSignedURLRequest *gpsur;
@property(retain, nonatomic)S3GetPreSignedURLRequest *gpsur_cropped_photo;
@property(retain, nonatomic)S3GetPreSignedURLRequest *gpsur_big_photo;

@property(nonatomic, strong) NSTimer *timer;
@property(retain, nonatomic)IBOutlet UIScrollView *mainScrollView;
@property(retain, nonatomic)IBOutlet UIView *playerView;
@property(retain, nonatomic)IBOutlet UIImage *cropped_photo;
@property(retain, nonatomic)IBOutlet UIImage *big_photo;
@property(retain, nonatomic)IBOutlet UIImageView *mainBG;
@property(retain, nonatomic)IBOutlet UIImageView *reyap_icon;
@property(retain, nonatomic)IBOutlet UIView *yapControlsView;
@property(retain, nonatomic)IBOutlet UIView *bigYapPhotoViewWrapper;
@property(retain, nonatomic)UIImageView *bigYapPhotoView;
@property(nonatomic, strong)IBOutlet UIScrollView *bigYapPhotoScrollView;
@property(retain, nonatomic)IBOutlet ZoomableView *myZoomableView;
@property(retain, nonatomic)IBOutlet UIActivityIndicatorView *loadingData;
@property(retain, nonatomic)IBOutlet UIImageView *reyapUserImageView;
@property(retain, nonatomic)IBOutlet UIButton *playlistBtn;
@property(retain, nonatomic)IBOutlet UILabel *name;
@property(retain, nonatomic)IBOutlet UIButton *username;
@property(retain, nonatomic)IBOutlet UIButton *reyapUser;
@property(retain, nonatomic)IBOutlet AutoScrollLabel *yapTitle;
@property(retain, nonatomic)IBOutlet UILabel *yapDate;
@property(retain, nonatomic)IBOutlet UILabel *labelReyapUser;
@property(retain, nonatomic)IBOutlet UIButton *backBtn;
@property(retain, nonatomic)IBOutlet UIButton *doneBtn;
@property(retain, nonatomic)IBOutlet UIButton *btnUserPhoto;
@property(retain, nonatomic)IBOutlet UIButton *btnYapPhotoCropped;
@property(retain, nonatomic)IBOutlet UIButton *btnPlay;
@property(retain, nonatomic)IBOutlet UIButton *btnReyap;
@property(retain, nonatomic)IBOutlet UIButton *btnLike;
@property(retain, nonatomic)IBOutlet UIButton *btnRewindYap;
@property(retain, nonatomic)IBOutlet UIButton *btnPlayOrPauseYap;
@property(retain, nonatomic)IBOutlet UIButton *btnForwardYap;
@property(retain, nonatomic)IBOutlet UILabel *yapPlays;
@property(retain, nonatomic)IBOutlet UILabel *yapReyaps;
@property(retain, nonatomic)IBOutlet UILabel *yapLikes;
@property(retain, nonatomic)IBOutlet UILabel *yapLength;
@property(retain, nonatomic)IBOutlet UILabel *currentTime;
@property(retain, nonatomic)IBOutlet UILabel *finalTime;
@property(retain, nonatomic)IBOutlet UISlider *progressBar;
@property(retain, nonatomic)NSArray *json;
@property(retain, nonatomic)NSArray *jsonAfterYap;
@property(retain, nonatomic)NSMutableArray *userFeed;
@property(retain, nonatomic)NSDictionary *listenData;
@property(retain, nonatomic)NSString *responseBodyListenId;
@property(retain, nonatomic)NSString *responseBodyReyapYap;
@property(retain, nonatomic)NSString *responseBodyLikeYap;
@property(retain, nonatomic)NSURLConnection *connection1;
@property(retain, nonatomic)NSURLConnection *connection2;
@property(retain, nonatomic)NSURLConnection *connection3;
@property(retain, nonatomic)NSURLConnection *connection4;
@property(retain, nonatomic)NSURLConnection *connection5;
@property(retain, nonatomic)NSURLConnection *connection6;
@property(retain, nonatomic)NSURLConnection *connection7;
@property(retain, nonatomic)NSURLConnection *connection8;
@property(retain, nonatomic)NSURLConnection *connection9;
@property(retain, nonatomic)AVPlayerItem *playerItemYapAudio;

@property(retain, nonatomic)UserProfile *UserProfileVC;
@property(retain, nonatomic)SDWebImageManager *image_download_manager;

-(IBAction)goBack:(id)sender;
-(IBAction)goToUserProfile:(id)sender;
-(IBAction)goToUserProfileFromPhoto:(id)sender;
-(IBAction)goToReyapUserProfile:(id)sender;
-(IBAction)searchHashtag:(id)sender;
-(IBAction)playOrPauseYap:(id)sender;
-(IBAction)goToPreviousYap:(id)sender;
-(IBAction)goToNextYap:(id)sender;
-(IBAction)currentTimeSliderValueChanged:(id)sender;
-(IBAction)currentTimeSliderTouchUpInside:(id)sender;
-(IBAction)reyapOrUnreyapYap:(id)sender;
-(IBAction)likeOrUnlikeYap:(id)sender;
-(IBAction)showBigYapPhoto:(id)sender;
-(IBAction)hideBigYapPhoto:(id)sender;
-(IBAction)goToPlaylist:(id)sender;
-(IBAction)backgroundQueue:(id)sender;
-(void)openWebLink;
-(void)showYapInfoInBackground;
-(void)updateScreen;
-(void)loadMoreYapsToPlaylist;
-(void)playYapAtIndex:(int)yap_index;
-(void)playNextYapInPlaylist:(NSNotification *)notification;
-(void)itemDidFinishPlaying:(NSNotification *) notification;
-(void)loadYapPhoto:(NSNotification *) notification;
-(void)getYapAudio;

@end
