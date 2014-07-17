//
//  GetRecommendedUsers.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 3/31/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "GetRecommendedUsers.h"
#import "AppPhotoRecord.h"
#import "IconDownloader.h"

@interface GetRecommendedUsers ()

@end

@implementation GetRecommendedUsers

@synthesize usersTable;
@synthesize stream;
@synthesize username;
@synthesize password;
@synthesize retypePassword;
@synthesize firstName;
@synthesize lastName;
@synthesize email;
@synthesize DOB;
@synthesize city;
@synthesize state;
@synthesize zipcode;
@synthesize country;
@synthesize phone;
@synthesize description;
@synthesize json;
@synthesize followJson;
@synthesize unfollowJson;
@synthesize responseBodyUsers;
@synthesize responseBodyFollow;
@synthesize responseBodyUnfollow;
@synthesize followedUsers;
@synthesize recommendedUsersData;
@synthesize connection1;
@synthesize connection2;
@synthesize connection3;
@synthesize connection4;
@synthesize connection5;
@synthesize connection6;
@synthesize pendingOperations;
@synthesize photos;
@synthesize records;
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
	
    //sessionUserID = 28;
    //sessionID = 216;
    
    records = [NSMutableArray array];
    
    photos = [[NSMutableArray alloc] init];
    
    self.workingArray = [NSMutableArray array];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    startBtn.hidden = YES;
    
    followedUsers = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not load users." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alert show];*/
    }
    else {
        //build an info object and convert to json
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        
        NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        tempSessionUserID, @"user_id",
                                        tempSessionUserID, @"profile_user_id",
                                        tempSessionID, @"session_id",
                                        nil];
        
        NSError *error;
        
        //convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/users/recommended/"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:the_url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBodyUsers = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        //int responseCode = [urlResponse statusCode];
        
        if (!jsonData) {
            DLog(@"JSON error: %@", error);
        }
        
        connection3 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection3 start];
        
        if (connection3) {
            
        }
        else {
            //Error
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

-(IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)followOrUnfollowUser:(id)sender {
    UIButton *button = sender;
    int button_id = button.tag;
    
    NSNumber *user_id = [[recommendedUsersData objectAtIndex:button_id] objectForKey:@"id"];
    
    if (![followedUsers containsObject:user_id]) {
        
        [followedUsers addObject:user_id];
        
        [button setImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateNormal];
        
        if (followedUsers.count >= 5) {
            startBtn.hidden = NO;
        }
        else {
            startBtn.hidden = YES;
        }
        
        //follow user
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        
        NSDictionary *newDatasetInfo;
        NSData* jsonData;
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://api.yapster.co/api/0.0.1/yap/follow/request/"];
        
        NSError *error;
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          user_id, @"user_requested_id",
                          nil];
        
        //convert object to data
        jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:the_url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBodyFollow = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        if (!jsonData) {
            DLog(@"JSON error: %@", error);
        }
        else {
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            DLog(@"JSON: %@", JSONString);
        }
        
        connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection1 start];
    }
    else {
        [followedUsers removeObject:user_id];
        
        [button setImage:[UIImage imageNamed:@"icon_plus.png"]  forState:UIControlStateNormal];
        
        if (followedUsers.count >= 5) {
            startBtn.hidden = NO;
        }
        else {
            startBtn.hidden = YES;
        }
        
        //unfollow user
        NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
        NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
        
        NSDictionary *newDatasetInfo;
        NSData* jsonData;
        NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/yap/follow/unfollow/"];
        
        NSError *error;
        
        newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                          tempSessionUserID, @"user_id",
                          tempSessionID, @"session_id",
                          user_id, @"user_unfollowed_id",
                          nil];
        
        //convert object to data
        jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:the_url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        NSHTTPURLResponse* urlResponse = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
        
        responseBodyUnfollow = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        if (!jsonData) {
            DLog(@"JSON error: %@", error);
        }
        else {
            NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            DLog(@"JSON: %@", JSONString);
        }
        
        connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [connection2 start];
    }
}

-(IBAction)start:(id)sender {
    stream = [self.storyboard instantiateViewControllerWithIdentifier:@"Stream"];
    
    //Push to next view controller
    [self.navigationController pushViewController:stream animated:YES];
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection1) {
        NSData *data = [responseBodyFollow dataUsingEncoding:NSUTF8StringEncoding];
        
        followJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", followJson);
        
        if (json.count > 0) {
            BOOL valid = [[followJson objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not follow this user at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else {
                currentFollowingCount = currentFollowingCount+1;
                
                labelCurrentFollowingCount.text = [NSString stringWithFormat:@"(%i/5)", currentFollowingCount];
                
                [usersTable reloadData];
                
                DLog(@"USER FOLLOWED");
            }
        }
    }
    else if (connection == connection2) {
        NSData *data = [responseBodyUnfollow dataUsingEncoding:NSUTF8StringEncoding];
        
        unfollowJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        DLog(@"%@", unfollowJson);
        
        if (json.count > 0) {
            BOOL valid = [[unfollowJson objectForKey:@"valid"] boolValue];
            
            if (!valid) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"Could not unfollow this user at this time. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            else { 
                currentFollowingCount = currentFollowingCount-1;
                
                labelCurrentFollowingCount.text = [NSString stringWithFormat:@"(%i/5)", currentFollowingCount];
                
                [usersTable reloadData];
                
                DLog(@"USER UNFOLLOWED");
            }
        }
    }
    if (connection == connection3) {
        //DLog(@"%@", json);
        
        NSData *data = [responseBodyUsers dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableArray *json_users_to_follow = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //DLog(@"%@", json_users_to_follow);
        
        recommendedUsersData = [[NSMutableArray alloc] init];
        NSMutableDictionary *user_dic = [[NSMutableDictionary alloc] init];
        
        if (json_users_to_follow.count > 0) {
            for (int i = 0; i < json_users_to_follow.count; i++) {
                user_dic = [[json_users_to_follow objectAtIndex:i] objectForKey:@"user"];
                
                [recommendedUsersData addObject:user_dic];
                
                self.workingEntry = [[AppPhotoRecord alloc] init];
                
                if (![[user_dic objectForKey:@"profile_cropped_picture_path"] isKindOfClass:[NSNull class]] && ![[user_dic objectForKey:@"profile_cropped_picture_path"] isEqualToString:@""]) {
                    
                    if (self.workingEntry)
                    {
                        NSString *bucket = @"yapsterapp";
                        S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
                        
                        //get profile photo
                        S3GetPreSignedURLRequest *gpsur_cropped_photo = [[S3GetPreSignedURLRequest alloc] init];
                        gpsur_cropped_photo.key     = [user_dic objectForKey:@"profile_cropped_picture_path"];
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
            }
            
            [loadingData stopAnimating];
            loadingData.hidden = YES;
            
            usersTable.hidden = NO;
            [usersTable reloadData];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recommendedUsersData count];
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
    
    UsersTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([usersTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [usersTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    CALayer *imageLayer = cell.user_photo.layer;
    [imageLayer setCornerRadius:cell.user_photo.frame.size.width/2];
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
            if (self.usersTable.dragging == NO && self.usersTable.decelerating == NO)
            {
                [self startIconDownload:photoRecord forIndexPath:indexPath];
            }
            
            // if a download is deferred or in progress, return a placeholder image
            [cell.user_photo setBackgroundImage:[UIImage imageNamed:@"placer holder_profile photo Large.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.user_photo setBackgroundImage:photoRecord.actualPhoto forState:UIControlStateNormal];
        }
    }
    
    cell.label_name.text = [NSString stringWithFormat:@"%@ %@", [[recommendedUsersData objectAtIndex:indexPath.row] objectForKey:@"first_name"], [[recommendedUsersData objectAtIndex:indexPath.row] objectForKey:@"last_name"]];
    //[cell.label_name sizeToFit];
    cell.label_username.text = [NSString stringWithFormat:@"@%@", [[recommendedUsersData objectAtIndex:indexPath.row] objectForKey:@"username"]];
    //[cell.label_name sizeToFit];
    
    if ([followedUsers containsObject:[[recommendedUsersData objectAtIndex:indexPath.row] objectForKey:@"id"]]) {
        [cell.addOrRemoveBtn setImage:[UIImage imageNamed:@"icon_selected.png"] forState:UIControlStateNormal];
    }
    else {
        [cell.addOrRemoveBtn setImage:[UIImage imageNamed:@"icon_plus.png"] forState:UIControlStateNormal];
    }
    
    cell.addOrRemoveBtn.tag = indexPath.row;
    
    [cell.addOrRemoveBtn addTarget:self action:@selector(followOrUnfollowUser:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            
            UsersTableCell *cell = (UsersTableCell *)[self.usersTable cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            [cell.user_photo setBackgroundImage:photoRecord.actualPhoto forState:UIControlStateNormal];
            
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
        NSArray *visiblePaths = [self.usersTable indexPathsForVisibleRows];
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
