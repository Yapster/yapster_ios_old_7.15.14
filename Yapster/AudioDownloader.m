//
//  AudioDownloader.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/18/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "AudioDownloader.h"

@implementation AudioDownloader

#define BLOCK_SIZE 1024 * 1024

@synthesize sharedManager;

-(id)initWithYapId:(double)theYapId andAudioPath:(NSString *)theAudioPath
{
    self = [super init];
    if (self)
    {
        yapId      = theYapId;
        audioPath = theAudioPath;
        
        isExecuting = NO;
        isFinished  = NO;
        
        sharedManager = [MyManager sharedManager];
    }
    
    return self;
}

#pragma mark - Overwriding NSOperation Methods

-(void)start
{
    // Makes sure that start method always runs on the main thread.
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    //audioData = [[NSMutableData alloc] init];
    
    int startRange = 0;
    int endRange = BLOCK_SIZE;
    
    [sharedManager.playerScreenAudioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [sharedManager.playerScreenAudioSession setActive:YES error:nil];
    
    [self willChangeValueForKey:@"isExecuting"];
    isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self performSelectorOnMainThread:@selector(initialize) withObject:nil waitUntilDone:NO];
    
    NSString *bucketName = [NSString stringWithFormat:@"yapsterapp"];
    NSString *keyName    = audioPath;
    
    // Puts the file as an object in the bucket.
    S3GetObjectRequest *getObjectRequest = [[S3GetObjectRequest alloc] initWithKey:keyName withBucket:bucketName];
    //[getObjectRequest setRangeStart:startRange rangeEnd:endRange];
    getObjectRequest.delegate = self;
    
    [[AmazonClientManager s3] getObject:getObjectRequest];
}

-(BOOL)isConcurrent
{
    return YES;
}

-(BOOL)isExecuting
{
    return isExecuting;
}

-(BOOL)isFinished
{
    return isFinished;
}

#pragma mark - AmazonServiceRequestDelegate Implementations

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    NSLog(@"IS COMPLETED");
    
    NSData *audio_data = [[NSData alloc] initWithData:response.body];
    [self performSelectorOnMainThread:@selector(setAudioData:) withObject:audio_data waitUntilDone:NO];
    
    [self finish];
}

-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data
{
    // The progress bar for downlaod is just an estimate. In order to accurately reflect the progress bar, you need to first retrieve the file size.
    NSLog(@"Received %d bytes of data", [data length]);
    
    audioData = [[NSMutableData alloc] init];
    
    [audioData appendData:data];
    
    sharedManager.sessionCurrentPlayingYapData = audioData;
    
    AVAudioPlayer *new_player = [[AVAudioPlayer alloc] initWithData:sharedManager.sessionCurrentPlayingYapData error:nil];
    
    sharedManager.playerScreenYapsPlayer = new_player;
    
    //NSLog(@"THE DATA %@", audioData);
    
    if (!sharedManager.playerScreenYapsPlayer.playing) {
        NSLog(@"THE DATA");
        
        [sharedManager.playerScreenYapsPlayer setDelegate:self];
        
        [sharedManager.playerScreenYapsPlayer prepareToPlay];
        sharedManager.playerScreenYapsPlayer.volume = 120;
        
        [sharedManager.playerScreenYapsPlayer play];
    }
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    
    [self finish];
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)exception
{
    NSLog(@"%@", exception);
    
    [self finish];
}

#pragma mark - Helper Methods

-(void)finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    isExecuting = NO;
    isFinished  = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

-(void)initialize
{
    audioData = nil;
}

-(void)setAudioData:(NSMutableData *)theAudioData
{
    audioData = theAudioData;
}

@end
