#import "ParentEntity.h"
#import "ProjectManager.h"
#import "Database.h"
#import "VideoFileMO.h"
#import "PhotoFileMO.h"
#import "FileMO.h"

@implementation ParentEntity

+ (void)load
{
    [ProjectManager registerProject:@"ParentEntity" withClass:self.class];
}

- (id)init
{
    if (self = [super init]) {
        [self test];
    }
    return self;
}

- (void)test
{
    Database *db = [[Database alloc] initWithModelName:@"ParentEntity"];
    NSArray *files = [db fetchObjectsForEntity:@"File"];
    
    if (0 == files.count) {
        FileMO *fileMO = [db createObjectForEntity:@"File"];
        fileMO.name = @"first";
        
        PhotoFileMO *photoMO = [db createObjectForEntity:@"PhotoFile"];
        photoMO.name = @"second";
        photoMO.width = [NSNumber numberWithShort:240];
        photoMO.height = [NSNumber numberWithShort:320];
        
        VideoFileMO *videoMO = [db createObjectForEntity:@"VideoFile"];
        videoMO.name = @"third";
        videoMO.width = [NSNumber numberWithShort:240];
        videoMO.height = [NSNumber numberWithShort:320];
        videoMO.duration = [NSNumber numberWithLongLong:180];
        
        [db save];
    }
    else {
        NSArray *photos = [db fetchObjectsForEntity:@"PhotoFile"];
        NSParameterAssert(photos.count < files.count);
        NSArray *videos = [db fetchObjectsForEntity:@"VideoFile"];
        NSParameterAssert(videos.count < photos.count);
    }
}

@end
