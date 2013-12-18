#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AccountMO : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * creationDate;

@end
