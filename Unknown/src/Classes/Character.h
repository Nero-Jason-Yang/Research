//
//  Character.h
//  Unknown
//
//  Created by Yang Jason on 13-10-7.
//
//

#import <Foundation/Foundation.h>

@interface Character : NSObject

- (id)initWithAtlasFile:(NSString *)file fps:(float)fps;

@property (nonatomic) float fps;

- (SPMovieClip *)walk;
- (SPMovieClip *)climb;
- (SPMovieClip *)standSide;
- (SPMovieClip *)standFace;
- (SPMovieClip *)fall;
- (SPMovieClip *)happy;
- (SPMovieClip *)lieProne;
- (SPMovieClip *)hitSide;
- (SPMovieClip *)hitSideBash;
- (SPMovieClip *)hitDown;
- (SPMovieClip *)hitDownBash;
- (SPMovieClip *)hitUp;

@end
