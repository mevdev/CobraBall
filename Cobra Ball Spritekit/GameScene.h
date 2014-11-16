//
//  GameScene.h
//  Cobra Ball Spritekit
//

//  Copyright (c) 2014 Robert Linnemann. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class JSTileMap;

@interface GameScene : SKScene

@property (strong, nonatomic) JSTileMap* tiledMap;
@property (strong, nonatomic) SKNode* worldNode;//weak

- (void) swapToNextMap;

- (void)moveWorld:(CGPoint)delta;
@end
