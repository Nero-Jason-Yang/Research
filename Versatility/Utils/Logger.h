#import <Foundation/Foundation.h>

@interface Logger : NSObject

+ (Logger *)defaultLogger;
- (id)initWithFilePath:(NSString *)filePath;
- (void)log:(NSString *)content;

@end

#ifdef DEBUG
#define NBLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define NBLog(format, ...) [Logger.defaultLogger log:[NSString stringWithFormat:format, ## __VA_ARGS__]]
#endif
