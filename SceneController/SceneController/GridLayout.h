#import <UIKit/UIKit.h>

@protocol GridLayoutDelegate <NSObject>
- (CGSize)cellSize;
- (CGSize)contentSizeForCells;
@end

@interface GridLayout : UICollectionViewLayout
@property (nonatomic,weak) id<GridLayoutDelegate> delegate;
@end
