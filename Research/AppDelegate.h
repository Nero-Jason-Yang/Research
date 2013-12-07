#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) dispatch_block_t backgroundSessionCompletionHandler;
@property (strong, nonatomic) dispatch_block_t didEnterBackgroundHandler;
@property (nonatomic) BOOL isBackground;

@end
