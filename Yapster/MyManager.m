//
//  MyManager.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/2/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "MyManager.h"

@implementation MyManager

@synthesize sessionCurrentPlaylist;
@synthesize playerScreenAudioSession;
@synthesize playerScreenYapsPlayer;
@synthesize sessionCurrentPlayingYapData;
@synthesize playlistYapsPlayer;
@synthesize currentYapPlaying;
@synthesize sessionChannels;
@synthesize sessionCurrentPlayingYap;
@synthesize userDeviceToken;
@synthesize currentYapPlayingTime;
@synthesize currentListenId;
@synthesize userInfo;
@synthesize appLaunchedWithNotification;
@synthesize notificationType;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static MyManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        sessionCurrentPlaylist = [[NSMutableArray alloc] init];
        sessionCurrentPlayingYap = [[NSMutableArray alloc] init];
        sessionChannels = [[NSMutableArray alloc] init];
        sessionCurrentPlayingYapData = [[NSData alloc] init];
        playerScreenAudioSession = [AVAudioSession sharedInstance];
        currentYapPlayingTime = 0;
        currentListenId = 0;
        userInfo = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
