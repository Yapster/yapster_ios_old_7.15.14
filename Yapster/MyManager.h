//
//  MyManager.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/2/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <QuartzCore/QuartzCore.h>

@interface MyManager : NSObject {
    NSMutableArray *sessionCurrentPlaylist;
    NSMutableArray *sessionCurrentPlayingYap;
    NSData *sessionCurrentPlayingYapData;
    AVAudioSession *playerScreenAudioSession;
    AVPlayer *playerScreenYapsPlayer;
    AVAudioPlayer *playlistYapsPlayer;
    NSString *userDeviceToken;
    NSString *notificationType;
    NSMutableArray *sessionChannels;
    NSDictionary *userInfo;
    int currentYapPlaying;
    int currentYapPlayingTime;
    double currentListenId;
    BOOL appLaunchedWithNotification;
}

@property (nonatomic, retain) NSMutableArray *sessionCurrentPlaylist;
@property (nonatomic, retain) NSMutableArray *sessionCurrentPlayingYap;
@property (nonatomic, retain) NSData *sessionCurrentPlayingYapData;
@property (nonatomic, strong) AVPlayer *playerScreenYapsPlayer;
@property (nonatomic, strong) AVAudioPlayer *playlistYapsPlayer;
@property (nonatomic, strong) AVAudioSession *playerScreenAudioSession;
@property (nonatomic, strong) NSMutableArray *sessionChannels;
@property (nonatomic, strong) NSString *userDeviceToken;
@property (nonatomic, strong) NSDictionary *userInfo;
@property int currentYapPlaying;
@property int currentYapPlayingTime;
@property double currentListenId;
@property BOOL appLaunchedWithNotification;
@property NSString *notificationType;

+ (id)sharedManager;

@end
