//
//  Playlist.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/1/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <QuartzCore/QuartzCore.h>
#import "Feed.h"
#import "PlaylistTableCell.h"
#import "Reachability.h"
#import "MyManager.h"
#import "GeneralWebScreen.h"
#import <AWSRuntime/AWSRuntime.h>
#import "AmazonClientManager.h"
#import "ASIS3ObjectRequest.h"
#import "SWTableViewCell.h"
#import "PhotoRecord.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"
#import "AFNetworking/AFNetworking.h"
#import <CoreImage/CoreImage.h>

@interface Playlist : UIViewController <UITableViewDataSource, UITableViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, AVAudioSessionDelegate, AmazonServiceRequestDelegate, SWTableViewCellDelegate, ImageDownloaderDelegate>
{
    IBOutlet UIActivityIndicatorView *loadingData;
    IBOutlet UILabel *message;
}

@property int counter;
@property BOOL interruptedOnPlayback;
@property (nonatomic, strong)AVAudioPlayer *yapPlayer;
@property(nonatomic, strong)NSTimer *timer;
@property(retain, nonatomic)MyManager *sharedManager;
@property(retain, nonatomic)GeneralWebScreen *generalWebScreenVC;
@property(retain, nonatomic)NSMutableArray *playlistFeed;
@property(retain, nonatomic)IBOutlet UITableView *theTable;
@property(retain, nonatomic)NSMutableArray *dictAllKeys;
@property(retain, nonatomic)NSMutableArray *dictAllValues;
@property(retain, nonatomic)UIAlertView *alertViewConfirmClear;
@property (nonatomic, strong)NSMutableArray *photos;
@property (nonatomic, strong)PendingOperations *pendingOperations;
@property(retain, nonatomic)NSMutableArray *records;

-(IBAction)goBack:(id)sender;
-(IBAction)clearPlaylist:(id)sender;
-(IBAction)goToLink:(id)sender;
-(void)openWebLink:(NSString *)web_link;
-(void)showYapInfoInBackground;

@end
