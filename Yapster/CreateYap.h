//
//  CreateYap.h
//  Yapster
//
//  Created by Abu-Bakar Bah on 5/5/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "GlobalVars.h"
#import "UsersTableCell.h"
#import "Reachability.h"
#import "CropPhotoForYap.h"
#import <AWSRuntime/AWSRuntime.h>
#import "AmazonClientManager.h"
#import "PlayerScreen.h"
#import "PhotoRecord.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"
#import "AFNetworking/AFNetworking.h"
#import <CoreImage/CoreImage.h>

@class DDPageControl;
@class UserProfile;

@interface CreateYap : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, AmazonServiceRequestDelegate, ImageDownloaderDelegate>
{
    
    IBOutlet UITextField *yapTitle;
    IBOutlet UIButton *deleteBtn;
    IBOutlet UIButton *playBtn;
    IBOutlet UIButton *stopBtn;
    IBOutlet UIButton *lockBtn;
    IBOutlet UIButton *yapBtn;
    IBOutlet UIButton *postBtn;
    IBOutlet UIButton *addHashtagsBtn;
    IBOutlet UIButton *addUsertagsBtn;
    IBOutlet UIButton *addGroupsBtn;
    IBOutlet UIButton *addLinksBtn;
    IBOutlet UIButton *addPhotoBtn;
    IBOutlet UIButton *backBtn;
    IBOutlet UIButton *doneBtn;
    IBOutlet UIScrollView *bottomYapOptions;
    IBOutlet UIImageView *mainBG;
    IBOutlet UIView *timeView;
    IBOutlet UIView *controlsView;
    IBOutlet UIView *mainYapView;
    IBOutlet UIView *hashtagsView;
    IBOutlet UIView *usertagsView;
    IBOutlet UIScrollView *groupsView;
    IBOutlet UIView *linksView;
    IBOutlet UIView *photoView;
    IBOutlet UIView *View;
    IBOutlet UILabel *pressAndHoldTutorialLabel;
    IBOutlet UILabel *weblinkTutorialLabel;
    IBOutlet UILabel *hashtagTutorialLabel;
    IBOutlet UILabel *channelsTutorialLabel;
    IBOutlet UILabel *currentTime;
    IBOutlet UILabel *finalTime;
    IBOutlet UITableView *usersTable;
    IBOutlet UIActivityIndicatorView *loadingData;
    IBOutlet UILabel *message;
    IBOutlet DDPageControl *pageControl;
    CGPoint originalCenter;
    UIView *tutorialViewWrapper;
    UIScrollView *tutorialScrollView;
    UIButton *skipAll;
    DDPageControl *tutorialPageControl;
    UILabel *title;
    
    UIImagePickerController *picker;
    UIImagePickerController *picker2;
    
    NSMutableArray *buckets;
    
    BOOL pageControlBeingUsed;
    BOOL yap_title_edited;
    BOOL hashtags_edited;
    BOOL links_edited;
    
    double user_yap_id;
    NSMutableArray *objects;
    
    float firstX;
    float firstY;
    
    int postAmount;
    int nextAmount;
    int numLoadedPosts;
}

@property (nonatomic, strong) CropPhotoForYap *cropPhotoForYapVC;
@property(retain, nonatomic)PlayerScreen *playerScreenVC;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timerLabel;
@property (nonatomic, strong) NSMutableArray *usersToTag;
@property (nonatomic, strong) NSMutableDictionary *channelImagesUnclicked;
@property (nonatomic, strong) NSMutableDictionary *channelImagesClicked;
@property int groupToAdd;
@property int lastAddedGroup;
@property int after_follower_request_id;
@property (nonatomic, strong) AVAudioRecorder *yapRecorder;
@property (nonatomic, strong) AVAudioPlayer *yapPlayer;
@property (nonatomic, strong) NSURL *tempRecFile;
@property BOOL isNotRecording;
@property BOOL channelsLoaded;
@property BOOL picture_flag;
@property BOOL picture_cropped_flag;
@property BOOL hashtags_flag;
@property BOOL user_tags_flag;
@property (nonatomic, strong) NSString *web_link;
@property BOOL web_link_flag;
@property(retain, nonatomic)NSMutableArray *hashtags_array;
@property(retain, nonatomic)NSArray *user_tags;
@property int counter;
@property double last_user_yap_id;
@property BOOL deleteIntact;
@property BOOL lockIntact;
@property BOOL isLoadingMorePosts;
@property double last_object_id;
@property double numLoadedUsers;
@property (nonatomic, strong) IBOutlet UITextField *hashtags;
@property (nonatomic, strong) IBOutlet UITextField *link;
@property (nonatomic, strong) IBOutlet UIImage *yapPhotoImg;
@property (nonatomic, strong) IBOutlet UIImageView *yapPhoto;
@property(retain, nonatomic)NSMutableDictionary *createYapJson;
@property(retain, nonatomic)NSArray *json;
@property(retain, nonatomic)NSString *responseBodyProfile;
@property(retain, nonatomic)NSString *responseBody;
@property(retain, nonatomic)NSString *responseBodyFollowersAndFollowing;
@property(retain, nonatomic)NSString *responseBodyCreateYap;
@property(retain, nonatomic)NSString *responseBodySearchUsers;
@property(retain, nonatomic)NSMutableArray *userFollowers;
@property(retain, nonatomic)NSMutableArray *userFollowing;
@property(retain, nonatomic)NSMutableArray *fullUsersData;
@property(retain, nonatomic)IBOutlet UIButton *searchButton;
@property(retain, nonatomic)IBOutlet UIButton *cancelButton;
@property(retain, nonatomic)IBOutlet UITextField *searchBox;
@property(retain, nonatomic)NSURLConnection *connection1;
@property(retain, nonatomic)NSURLConnection *connection2;
@property(retain, nonatomic)NSURLConnection *connection3;
@property(retain, nonatomic)NSURLConnection *connection4;
@property(retain, nonatomic)NSURLConnection *connection5;
@property(retain, nonatomic)NSURLConnection *connection6;
@property(retain, nonatomic)NSString *audioPath;
@property(retain, nonatomic)NSString *bigPicturePath;
@property(retain, nonatomic)NSString *smallPicturePath;
@property(nonatomic, strong)NSMutableArray *photos;
@property(nonatomic, strong)PendingOperations *pendingOperations;
@property(retain, nonatomic)NSMutableArray *records;
@property(retain, nonatomic)UIPanGestureRecognizer *panGesture;

-(IBAction)showCancelButton:(id)sender;
-(IBAction)cancelSearch:(id)sender;
-(IBAction)createYap:(UILongPressGestureRecognizer *) recognizer;
-(void)lockYap;
-(void)deleteYap;
-(IBAction)deleteYap_SB:(id)sender;
-(IBAction)lockYap_SB:(id)sender;
-(IBAction)unlockYap:(id)sender;
-(IBAction)addHashtags:(id)sender;
-(IBAction)addUsertags:(id)sender;
-(IBAction)addGroups:(id)sender;
-(IBAction)addLinks:(id)sender;
-(IBAction)addPhoto:(id)sender;
-(IBAction)closeAddHashtags:(id)sender;
-(IBAction)closeAddUsertags:(id)sender;
-(IBAction)closeAddGroups:(id)sender;
-(IBAction)closeAddLinks:(id)sender;
-(IBAction)closeAddPhoto:(id)sender;
-(IBAction)addUsersToTag:(id)sender;
-(void)startRecording;
-(IBAction)playback:(id)sender;
-(IBAction)stopYap:(id)sender;
-(IBAction)changePage;
-(IBAction)addGroup:(id)sender;
-(IBAction)choosePhotoFromAlbum:(id)sender;
-(IBAction)takePhotoFromCamera:(id)sender;
-(IBAction)goBack:(id)sender;
-(IBAction)postYap:(id)sender;
-(IBAction)yap_title_edited:(id)sender;
-(IBAction)hashtags_edited:(id)sender;
-(IBAction)links_edited:(id)sender;
-(IBAction)searchUsers:(id)sender;
-(BOOL)validateUrl:(NSString *)candidate;
-(void)closeTutorial;

@end
