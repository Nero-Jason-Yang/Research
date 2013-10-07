//
//  Character.m
//  Unknown
//
//  Created by Yang Jason on 13-10-7.
//
//

#import "Character.h"

@interface Character ()
{
    SPTextureAtlas *_atlas;
}
@end

@implementation Character

- (id)initWithAtlasFile:(NSString *)file fps:(float)fps
{
    if (self = [super init]) {
        _atlas = [SPTextureAtlas atlasWithContentsOfFile:file];
        _fps = fps;
    }
    return self;
}

- (SPMovieClip *)movieClipStartingWith:(NSString *)prefix
{
    NSArray *textures = [_atlas texturesStartingWith:prefix];
    SPMovieClip *mc = [SPMovieClip movieWithFrames:textures fps:_fps];
    return mc;
}

- (SPMovieClip *)walk
{
    return [self movieClipStartingWith:@"walk_"];
}

- (SPMovieClip *)climb
{
    return [self movieClipStartingWith:@"climb_"];
}

- (SPMovieClip *)standSide
{
    return [self movieClipStartingWith:@"standSide_"];
}

- (SPMovieClip *)standFace
{
    return [self movieClipStartingWith:@"standFace_"];
}

- (SPMovieClip *)fall
{
    return [self movieClipStartingWith:@"fall_"];
}

- (SPMovieClip *)happy
{
    return [self movieClipStartingWith:@"happy_"];
}

- (SPMovieClip *)lieProne
{
    return [self movieClipStartingWith:@"lieProne_"];
}

- (SPMovieClip *)hitSide
{
    NSArray *textures = [_atlas texturesStartingWith:@"hit_"];
    SPMovieClip *mc = [SPMovieClip movieWithFrames:textures fps:_fps];
    [mc addFrameWithTexture:[_atlas textureByName:@"hitEnd"]];
    return mc;
}

- (SPMovieClip *)hitSideBash
{
    NSArray *textures = [_atlas texturesStartingWith:@"hitBash_"];
    SPMovieClip *mc = [SPMovieClip movieWithFrames:textures fps:_fps];
    [mc addFrameWithTexture:[_atlas textureByName:@"hitEnd"]];
    return mc;
}

- (SPMovieClip *)hitDown
{
    NSArray *textures = [_atlas texturesStartingWith:@"hit_"];
    SPMovieClip *mc = [SPMovieClip movieWithFrames:textures fps:_fps];
    [mc addFrameWithTexture:[_atlas textureByName:@"hitEnd"]];
    return mc;
}

- (SPMovieClip *)hitDownBash
{
    NSArray *textures = [_atlas texturesStartingWith:@"hitBash_"];
    SPMovieClip *mc = [SPMovieClip movieWithFrames:textures fps:_fps];
    [mc addFrameWithTexture:[_atlas textureByName:@"hitEnd"]];
    return mc;
}

- (SPMovieClip *)hitUp
{
    NSArray *textures = [_atlas texturesStartingWith:@"hitUp_"];
    SPMovieClip *mc = [SPMovieClip movieWithFrames:textures fps:_fps];
    [mc addFrameWithTexture:[_atlas textureByName:@"hitEnd"]];
    return mc;
}

@end
