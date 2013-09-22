#import "GridLayout.h"
#import "SceneViewController.h"

@implementation GridLayout

- (CGSize)collectionViewContentSize
{
    CGSize cellSize = self.delegate.cellSize;
    CGSize contentSizeForCells = self.delegate.contentSizeForCells;
    CGFloat width = contentSizeForCells.width * cellSize.width;
    CGFloat height = contentSizeForCells.height * cellSize.height;
    return CGSizeMake(width, height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGSize cellSize = self.delegate.cellSize;
    CGSize contentSizeForCells = self.delegate.contentSizeForCells;
    
    CGFloat f_left = (rect.origin.x / cellSize.width);
    CGFloat f_top = (rect.origin.y / cellSize.height);
    CGFloat f_right = (rect.origin.x + rect.size.width) / cellSize.width;
    CGFloat f_bottom = (rect.origin.y + rect.size.height) / cellSize.height;
    
    int i_left = f_left < 0 ? (int)f_left - 1 : (int)f_left;
    int i_top = f_top < 0 ? (int)f_top - 1 : (int)f_top;
    int i_right = f_right < 0 ? (int)f_right : (int)f_right + 1;
    int i_bottom = f_bottom < 0 ? (int)f_bottom : (int)f_bottom + 1;
    
    if (i_left < 0) {
        i_left = 0;
    }
    if (i_top < 0) {
        i_top = 0;
    }
    
    int width = contentSizeForCells.width;
    if (i_right >= width) {
        i_right = width - 1;
    }
    int height = contentSizeForCells.height;
    if (i_bottom >= height) {
        i_bottom = height - 1;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (int y = i_top; y <= i_bottom; y ++) {
        for (int x = i_left; x <= i_right; x ++) {
            int item = y * width + x;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
            id attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [array addObject:attributes];
        }
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGSize cellSize = self.delegate.cellSize;
    CGSize contentSizeForCells = self.delegate.contentSizeForCells;
    int y = indexPath.item / contentSizeForCells.width;
    int x = indexPath.item - y * contentSizeForCells.width;
    CGFloat centerX = (x + 0.5f) * cellSize.width;
    CGFloat centerY = (y + 0.5f) * cellSize.height;
    attributes.size = cellSize;
    attributes.center = CGPointMake(centerX, centerY);
    return attributes;
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    
//}

@end
