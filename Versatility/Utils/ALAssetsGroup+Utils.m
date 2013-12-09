#import "ALAssetsGroup+Utils.h"

@implementation ALAssetsGroup (Utils)

- (ALAsset *)assetAtIndex:(NSUInteger)index
{
    NSArray *array = [self assetsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
    return array.count > 0 ? array[0] : nil;
}

- (NSArray *)assetsAtIndexes:(NSIndexSet *)indexes
{
    NSMutableArray *array = [NSMutableArray array];
    [self enumerateAssetsAtIndexes:indexes options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [array addObject:result];
        }
    }];
    return array;
}

@end
