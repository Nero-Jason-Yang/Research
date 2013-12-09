#import "ALAsset+Properties.h"

@implementation ALAsset (Properties)

- (BOOL)isPhoto
{
    return [self.type isEqualToString:ALAssetTypePhoto];
}

- (BOOL)isVideo
{
    return [self.type isEqualToString:ALAssetTypeVideo];
}

- (NSDate *)creationDate
{
    return [self valueForProperty:ALAssetPropertyDate];
}

#pragma mark internal

- (NSString *)type
{
    return [self valueForProperty:ALAssetPropertyType];
}

@end
