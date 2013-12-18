#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AccountMO.h"


@interface AuthorizableAccountMO : AccountMO

@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSDate * lastAuthorizedDate;

@end
