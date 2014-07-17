//
//  UserSettingsNotifications.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/21/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "UserSettingsNotifications.h"

@interface UserSettingsNotifications ()

@end

@implementation UserSettingsNotifications

@synthesize jsonFetch;
@synthesize json;
@synthesize connection1;
@synthesize connection2;
@synthesize connection3;
@synthesize settingsResponseBody;
@synthesize notify_for_mentions;
@synthesize notify_for_reyaps;
@synthesize notify_for_likes;
@synthesize notify_for_new_followers;
@synthesize notify_for_yapster;

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
    
    labels = [NSArray arrayWithObjects:@"Notify for mentions", @"Notify for reyaps", @"Notify for likes", @"Notify for new followers", @"Notify for Yapster alerts", nil];
	
    table.scrollEnabled = NO;
    
    table.delegate = self;
    
    //get settings
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    
    NSDictionary *newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    tempSessionUserID, @"user_id",
                                    tempSessionID, @"session_id",
                                    nil];
    
    NSError *error;
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
    
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/users/settings/load/"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:the_url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &urlResponse error: &error];
    
    settingsResponseBody = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    if (!jsonData) {
        DLog(@"JSON error: %@", error);
    }
    
    connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection1 start];
    
    if (connection1) {
        
    }
    else {
        //Error
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)updateSwitch:(id)sender {
    UISwitch *theSwitch = sender;
    
    /*
     notify_for_mentions = [[current_settings objectForKey:@"notify_for_mentions"] boolValue];
     notify_for_reyaps = [[current_settings objectForKey:@"notify_for_reyaps"] boolValue];
     notify_for_likes = [[current_settings objectForKey:@"notify_for_likes"] boolValue];
     notify_for_new_followers = [[current_settings objectForKey:@"notify_for_new_followers"] boolValue];
     notify_for_yapster_notifications = [[current_settings objectForKey:@"notify_for_yapster_notifications"] boolValue];
     */
    
    //change settings
    NSNumber *tempSessionUserID = [[NSNumber alloc] initWithDouble:sessionUserID];
    NSNumber *tempSessionID = [[NSNumber alloc] initWithDouble:sessionID];
    NSNumber *tempSettingValue;
    
    NSDictionary *newDatasetInfo;
    NSData* jsonData;
    NSURL *the_url = [[NSURL alloc] initWithString:@"http://www.api.yapster.co/api/0.0.1/users/settings/edit/"];
    
    NSError *error;
    
    switch (theSwitch.tag) {
        case 0: {
            if (theSwitch.on) {
                tempSettingValue = [[NSNumber alloc] initWithBool:1];
            }
            else {
                tempSettingValue = [[NSNumber alloc] initWithBool:0];
            }
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            tempSessionUserID, @"user_id",
                                            tempSessionID, @"session_id",
                                            tempSettingValue, @"notify_for_mentions",
                                            nil];
            
            //convert object to data
            jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:the_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonData];
            
            if (!jsonData) {
                DLog(@"JSON error: %@", error);
            }
            
            connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection2 start];
            
            break;
        }
        case 1: {
            if (theSwitch.on) {
                tempSettingValue = [[NSNumber alloc] initWithBool:1];
            }
            else {
                tempSettingValue = [[NSNumber alloc] initWithBool:0];
            }
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempSettingValue, @"notify_for_reyaps",
                              nil];
            
            //convert object to data
            jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:the_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonData];
            
            if (!jsonData) {
                DLog(@"JSON error: %@", error);
            }
            
            connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection2 start];
            
            break;
        }
        case 2: {
            if (theSwitch.on) {
                tempSettingValue = [[NSNumber alloc] initWithBool:1];
            }
            else {
                tempSettingValue = [[NSNumber alloc] initWithBool:0];
            }
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempSettingValue, @"notify_for_likes",
                              nil];
            
            //convert object to data
            jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:the_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonData];
            
            if (!jsonData) {
                DLog(@"JSON error: %@", error);
            }
            
            connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection2 start];
            
            break;
        }
        case 3: {
            if (theSwitch.on) {
                tempSettingValue = [[NSNumber alloc] initWithBool:1];
            }
            else {
                tempSettingValue = [[NSNumber alloc] initWithBool:0];
            }
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempSettingValue, @"notify_for_new_followers",
                              nil];
            
            //convert object to data
            jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:the_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonData];
            
            if (!jsonData) {
                DLog(@"JSON error: %@", error);
            }
            
            connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection2 start];
            
            break;
        }
        case 4: {
            if (theSwitch.on) {
                tempSettingValue = [[NSNumber alloc] initWithBool:1];
            }
            else {
                tempSettingValue = [[NSNumber alloc] initWithBool:0];
            }
            
            //DLog(@"BOOL Value: %@", tempSettingValue);
            
            newDatasetInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              tempSessionUserID, @"user_id",
                              tempSessionID, @"session_id",
                              tempSettingValue, @"notify_for_yapster",
                              nil];
            
            //convert object to data
            jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions  error:&error];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:the_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setHTTPBody:jsonData];
            
            if (!jsonData) {
                DLog(@"JSON error: %@", error);
            }
            
            connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [connection2 start];
            
            break;
        }
        default:
            break;
    }
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    jsonFetch = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == connection1) {
        NSData *data = [settingsResponseBody dataUsingEncoding:NSUTF8StringEncoding];
        
        jsonFetch = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSDictionary *current_settings = jsonFetch;
        
        notify_for_mentions = [[current_settings objectForKey:@"notify_for_mentions"] boolValue];
        notify_for_reyaps = [[current_settings objectForKey:@"notify_for_reyaps"] boolValue];
        notify_for_likes = [[current_settings objectForKey:@"notify_for_likes"] boolValue];
        notify_for_new_followers = [[current_settings objectForKey:@"notify_for_new_followers"] boolValue];
        notify_for_yapster = [[current_settings objectForKey:@"notify_for_yapster"] boolValue];
        
        [table reloadData];
    }
    else if (connection == connection2) {
        DLog(@"%@", json);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [labels count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = 60, padding = 10;
    
    CGRect frame = CGRectMake(25,padding,320 - 2*padding,headerHeight-2*padding);
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, tableView.frame.size.width, headerHeight)];
    sectionHeaderView.backgroundColor = [UIColor blackColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame: frame];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [headerLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
    [sectionHeaderView addSubview:headerLabel];
    
    switch (section) {
        case 0:
            headerLabel.text = [NSString stringWithFormat:@"@%@", sessionUsername];
            return sectionHeaderView;
            break;
    }
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"@%@", sessionUsername];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    UserSettingsNotificationsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    cell.userInteractionEnabled = YES;
    
    tableView.separatorColor = [UIColor greenColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.label1.text = [labels objectAtIndex:indexPath.row];
    cell.switch1.tag = indexPath.row;
 
    //switch on or off based on current settings values
    if (indexPath.row == 0) {
        if (notify_for_mentions) {
            cell.switch1.on = YES;
        }
        else {
            cell.switch1.on = NO;
        }
    }
    else if (indexPath.row == 1) {
        if (notify_for_reyaps) {
            cell.switch1.on = YES;
        }
        else {
            cell.switch1.on = NO;
        }
    }
    else if (indexPath.row == 2) {
        if (notify_for_likes) {
            cell.switch1.on = YES;
        }
        else {
            cell.switch1.on = NO;
        }
    }
    else if (indexPath.row == 3) {
        if (notify_for_new_followers) {
            cell.switch1.on = YES;
        }
        else {
            cell.switch1.on = NO;
        }
    }
    else if (indexPath.row == 4) {
        if (notify_for_yapster) {
            cell.switch1.on = YES;
        }
        else {
            cell.switch1.on = NO;
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
