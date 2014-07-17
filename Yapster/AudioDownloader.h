//
//  AudioDownloader.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 6/18/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSRuntime/AWSRuntime.h>
#import "AmazonClientManager.h"
#import "MyManager.h"

@interface AudioDownloader : NSOperation<AVAudioPlayerDelegate, AVAudioSessionDelegate, AmazonServiceRequestDelegate>
{
    double              yapId;
    NSString       *audioPath;
    NSMutableData        *audioData;
    
    BOOL           isExecuting;
    BOOL           isFinished;
}

@property(retain, nonatomic)MyManager *sharedManager;

-(id)initWithYapId:(double)theYapId andAudioPath:(NSString *)theAudioPath;

-(void)finish;
-(void)initialize;
-(void)setAudioData:(NSMutableData *)theAudioData;

@end
