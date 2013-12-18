#import <Foundation/Foundation.h>
#import "AccountManager.h"
#import "BrowsingService.h"

typedef enum : uint8_t {
    BrowsingSortKey_Name,
    BrowsingSortKey_Size,
    BrowsingSortKey_Date,
    BrowsingSortKey_MIME,
} BrowsingSortKey;

@interface BrowsingCore : NSObject

@property (nonatomic) NSUInteger pageSize;
@property (nonatomic) BrowsingSortKey sortKey;
@property (nonatomic) BOOL sortAscending;
@property (nonatomic) BOOL showHidden;

@property (nonatomic,readonly) Account *account;
- (void)setAccount:(Account *)account completionHandler:(void (^)(NSError *error))handler;

@property (nonatomic,readonly) id<BrowsingFolder> root;

@end
