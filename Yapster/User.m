//
//  User.m
//  Yapster
//

#import "User.h"

@implementation User

@synthesize userIDNum;
@synthesize userEmail;
@synthesize userPassword;
@synthesize userUsername;
@synthesize userPhone;

-(id) initWithUserID: (int) uID andUserEmail: (NSString *) uEmail andUserName: (NSString *) uName andUserPassword: (NSString *) uPassword andUserPhone: (NSString *) uPhone {
    
    self = [super init];
    
    if (self) {
        userIDNum = uID;
        userEmail = uEmail;
        userUsername = uName;
        userPassword = uPassword;
        userPhone = uPhone;
    }
    
    return self;
}


@end
