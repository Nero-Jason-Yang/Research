//
//  Grids.m
//  Unknown
//
//  Created by Jason Yang on 13-10-8.
//
//

#import "Grids.h"

@implementation Grids

- (id)init
{
    if (self = [super init]) {
        CGSize size = UIScreen.mainScreen.bounds.size;
        for (int i = 0; i * 32 < size.height; i ++) {
            for (int j = 0; j * 64 < size.width; j ++) {
                uint color = (((i + j) % 2) == 0) ? 0x000000 : 0xffffff;
                SPQuad *quad = [SPQuad quadWithWidth:64 height:32 color:color];
                quad.x = j * 64;
                quad.y = i * 32;
                [self addChild:quad];
            }
        }
    }
    return self;
}

@end
