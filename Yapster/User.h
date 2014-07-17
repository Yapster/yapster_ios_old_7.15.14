//
//  User.h
//  Yapster
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property int userIDNum;
@property(retain, nonatomic)NSString *userEmail;
@property(retain, nonatomic)NSString *userUsername;
@property(retain, nonatomic)NSString *userPassword;
@property(retain, nonatomic)NSString *userPhone;

-(id) initWithUserID: (int) uID andUserEmail: (NSString *) uEmail andUserName: (NSString *) uName andUserPassword: (NSString *) uPassword andUserPhone: (NSString *) uPhone;

@end
