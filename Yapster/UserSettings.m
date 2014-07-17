//
//  UserSettings.m
//  Yapster
//
//  Created by Abu-Bakar Bah on 4/21/14.
//  Copyright (c) 2014 Yapster. All rights reserved.
//

#import "UserSettings.h"

@interface UserSettings ()

@end

@implementation UserSettings

@synthesize menuItems;
@synthesize menuKeys;
@synthesize AboutYapsterVC;
@synthesize TermsOfServiceVC;
@synthesize PrivacyPolicyVC;
@synthesize ContactYapsterVC;

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
	
    //userSettingsLabels = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", sessionUsername], @"About Us", @"Terms and Services", @"Privacy Policy", @"Contact Us", nil];
    
    table.scrollEnabled = NO;
    
    table.delegate = self;
    
    loading.hidden = YES;
    
    //1
    NSString *path = [[NSBundle mainBundle] pathForResource:@"settingslist" ofType:@"plist"];
    
    //2
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    self.menuItems = dict;
    
    //3
    NSArray *array = [[menuItems allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.menuKeys = array;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [menuKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSString *key = [menuKeys objectAtIndex:section];
    
    NSArray *list = [menuItems objectForKey:key];
    
    return [list count];
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
            headerLabel.text = @"Accounts";
            return sectionHeaderView;
            break;
        case 1:
            headerLabel.text = @"Yapster";
            return sectionHeaderView;
            break;
        default:
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
    NSString *key = @"";
    
    key = [menuKeys objectAtIndex:section];
    
    return key;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    UserSettingsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    tableView.separatorColor = [UIColor greenColor];
    
    NSString *key = [menuKeys objectAtIndex:indexPath.section];
    
    NSArray *list = [menuItems objectForKey:key];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.label1.text = [NSString stringWithFormat:@"@%@", sessionUsername];
    }
    else {
        cell.label1.text = [list objectAtIndex:indexPath.row];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Determine the row/section on the tapped cell
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: {
                    UserSettingsNotifications *notificationSettingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSettingsNotificationsVC"];
                    
                    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                    
                    if (networkStatus == NotReachable) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        [alert show];
                    } else {
                        //Push to controller
                        [self.navigationController pushViewController:notificationSettingsVC animated:YES];
                    }
                    
                    break;
                }
            }
        break;
        case 1:
            switch (indexPath.row) {
                case 0: {
                    AboutYapster *aboutYapsterScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutYapsterVC"];
                    
                    self.AboutYapsterVC = aboutYapsterScreen;
                    
                    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                    
                    if (networkStatus == NotReachable) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        [alert show];
                    } else {
                        //Push to controller
                        [self.navigationController pushViewController:aboutYapsterScreen animated:YES];
                    }
                    
                    break;
                }
                case 1: {
                    TermsOfService *termsScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsOfServiceVC"];
                    
                    self.TermsOfServiceVC = termsScreen;
                    
                    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                    
                    if (networkStatus == NotReachable) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        [alert show];
                    } else {
                        //Push to User Settings controller
                        [self.navigationController pushViewController:termsScreen animated:YES];
                    }
                    
                    break;
                }
                case 2: {
                    PrivacyPolicy *privacyScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyVC"];
                    
                    self.PrivacyPolicyVC = privacyScreen;
                    
                    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                    
                    if (networkStatus == NotReachable) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        [alert show];
                    } else {
                        //Push to controller
                        [self.navigationController pushViewController:privacyScreen animated:YES];
                    }
                    
                    break;
                }
                case 3: {
                    ContactYapster *contactYapsterScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactYapsterVC"];
                    
                    self.ContactYapsterVC = contactYapsterScreen;
                    
                    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                    
                    if (networkStatus == NotReachable) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yapster" message:@"There seems to be no internet connection on your device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        [alert show];
                    } else {
                        //Push to controller
                        [self.navigationController pushViewController:contactYapsterScreen animated:YES];
                    }
                    
                    break;
                }
            }
        break;
    }
}



@end
