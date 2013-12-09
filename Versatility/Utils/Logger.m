#import "Logger.h"

@interface Logger ()
@property (nonatomic) NSOutputStream *os;
@end

@implementation Logger

+ (Logger *)defaultLogger
{
    static Logger *logger;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (paths.count > 0) {
            NSString *path = [NSString stringWithFormat:@"%@", paths[0]];
            NSString *filePath = [path stringByAppendingPathComponent:@"log.txt"];
            logger = [[Logger alloc] initWithFilePath:filePath];
        }
    });
    return logger;
}

- (id)initWithFilePath:(NSString *)filePath
{
    if (self = [super init]) {
        NSOutputStream *os = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
        if (!os) {
            return nil;
        }
        [os open];
        NSParameterAssert(os.streamStatus == NSStreamStatusOpen || os.streamStatus == NSStreamStatusOpening);
        self.os = os;
    }
    return self;
}

- (void)dealloc
{
    [self.os close];
}

- (void)log:(NSString *)content
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSString *newContent = [NSString stringWithFormat:@"%@ - %@\n", dateString, content];
    
    @synchronized(self) {
        return [self write:newContent];
    }
}

- (void)write:(NSString *)content
{
    NSOutputStream *os = self.os;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    const uint8_t *buffer = data.bytes;
    NSUInteger size = data.length;
    while (os.hasSpaceAvailable) {
        NSInteger n = [os write:buffer maxLength:size];
        if (n <= 0 || n >= size) {
            return;
        }
        size -= n;
        buffer += n;
    }
}

@end
