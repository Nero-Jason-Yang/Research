#import "ALAssetTransformer.h"
#import "ALAssetsLibrary+Utils.m"

@implementation ALAssetTransformer

+ (ALAssetsLibrary *)defaultLibrary
{
    static ALAssetsLibrary *library;
    if (!library) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            library = [[ALAssetsLibrary alloc] init];
        });
    }
    return library;
}

+ (void)initialize {
    NSParameterAssert(self == ALAssetTransformer.class);
    ALAssetTransformer *transformer = [[ALAssetTransformer alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:@"ALAssetTransformer"];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [ALAsset class];
}

- (id)transformedValue:(id)value {
    NSParameterAssert([value isKindOfClass:ALAsset.class]);
    ALAsset *asset = value;
    NSData *data = [asset.defaultRepresentation.url.absoluteString dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

- (id)reverseTransformedValue:(id)value {
    return nil;
    NSString *string = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string];
    __block ALAsset *asset;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        asset = [[ALAssetTransformer defaultLibrary] assetForURL:url];
    });
    return asset;
}

@end
