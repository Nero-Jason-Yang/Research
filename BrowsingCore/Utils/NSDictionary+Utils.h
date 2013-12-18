#import <Foundation/Foundation.h>

@interface NSDictionary (Utils)

- (NSString *)stringObjectForKey:(id)key;
- (NSDictionary *)dictionaryObjectForKey:(id)key;
- (NSArray *)arrayObjectForKey:(id)key;

@end
