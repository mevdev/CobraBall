//
//  GameScene.m
//  Cobra Ball Spritekit
//
//  Created by Robert Linnemann on 11/12/14.
//  Copyright (c) 2014 Robert Linnemann. All rights reserved.
//

#import "GameScene.h"
#import "JSTileMap.h"

@implementation GameScene



-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        // put anchor point in center of scene
//        self.anchorPoint = CGPointMake(0.5,0.5);
        
        // create a world Node to allow for easy panning & zooming
        SKNode* worldNode = [[SKNode alloc] init];
        worldNode.name = @"world";
        [self addChild:worldNode];
        self.worldNode = worldNode;
        
        // load initial map
        [self swapToNextMap];
        [self createHud];

    }
    return self;
}



- (void) loadTileMap:(NSString*)tileMap
{
#ifdef DEBUG
    NSLog(@"loading map named %@", tileMap);
#endif
    
    self.tiledMap = [JSTileMap mapNamed:@"office.tmx"]; //tileMap];
    if (self.tiledMap)
    {
//        [self
        // center map on scene's anchor point
        CGRect mapBounds = [self.tiledMap calculateAccumulatedFrame];
        self.tiledMap.position = CGPointMake(mapBounds.size.width/2.0, mapBounds.size.height/2.0);
//        self.tiledMap.position = CGPointZero;
        [self.worldNode addChild:self.tiledMap];
        self.worldNode.zPosition = 1.0f;
        [self.tiledMap runAction:[SKAction moveTo:CGPointMake(-200, -200) duration:6.0f]];
        NSLog(@"%@,%@",@(self.worldNode.frame.size.height),@(self.worldNode.frame.size.width));
    }
    else
    {
        NSLog(@"Uh Oh....");
    }
    
    
//    SKSpriteNode *something = [SKSpriteNode spriteNodeWithImageNamed:@"chair.png"];
//    something.position= CGPointMake(10.0f, 10.0f);
//    [self.worldNode addChild:something];
}


- (void) swapToNextMap
{
    static NSMutableArray* fileArray = nil;
    static int arrayIndex = 0;
    
    if (!fileArray)
    {
        fileArray = [NSMutableArray array];
        
        NSError* error = nil;
        NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] resourcePath] error:&error];
        for (NSString* filename in files)
        {
            if ([[[filename pathExtension] lowercaseString] rangeOfString:@"tmx"].location != NSNotFound)
            {
                [fileArray addObject:filename];
            }
        }
        
        
    }
    
    if (fileArray.count)
    {
        if (arrayIndex >= fileArray.count)		// wrap bounds
            arrayIndex = 0;
        
        [self.tiledMap removeFromParent];
        
        // reset the world's position and scale each time we change maps
        self.worldNode.position = CGPointZero;
        self.worldNode.xScale = 1.0;
        self.worldNode.yScale = 1.0;
        
        [self loadTileMap:fileArray[arrayIndex]];
        arrayIndex++;
    }
}


#pragma mark - HUD motherfuckser!
//break this out into an object...
-(void)createHud {
    
    SKLabelNode *timeLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-BoldItalic"];
    timeLabel.position = CGPointMake(0, self.size.height-40);
    [timeLabel setText:@"30"];
    timeLabel.fontSize = 16.0f;
    timeLabel.zPosition = 100;
    timeLabel.fontColor = [UIColor yellowColor];
    [self addChild:timeLabel];
    
    SKLabelNode *logLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-BoldItalic"];
    logLabel.fontSize = 16.0f;
    logLabel.position = CGPointMake(70, self.size.height-40);
    [logLabel setText:@"debug"];
    logLabel.fontColor = [UIColor whiteColor];
    logLabel.zPosition = 100;
    [self addChild:logLabel];
    
}


-(void)refreshHud {
    
}

#pragma mark - touches and movement.


- (void)moveWorld:(CGPoint)delta {
    
    self.worldNode = [self childNodeWithName:@"world"];
    
    CGPoint curPos = self.worldNode.position;
    self.worldNode.position = CGPointMake(curPos.x + delta.x, curPos.y - delta.y);
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *t= touches.allObjects[0];
    CGPoint actualPoint = [t locationInNode:self.tiledMap];
//    SKSpriteNode *node = [self.tiledMap tileAt]
  
    NSLog(@"touchScene: {%@,%@}",@(actualPoint.x),@(actualPoint.y));
    //Layer? Coord?
    TMXLayerInfo *layerInfo = [self.tiledMap.layers objectAtIndex:1];
    CGPoint coords = [layerInfo.layer coordForPoint:actualPoint];
//        CGPoint coords = [self.tiledMap.layers[0] coordForPoint:actualPoint];
//f    CGPoint coords = [self.tiledMap.layers[0] coordForPoint:actualPoint];
    NSLog(@"coords: {%@,%@}",@(coords.x),@(coords.y));
//    - (CGPoint)coordForPoint:(CGPoint)point;
    SKSpriteNode *nodeFound = (SKSpriteNode *)[layerInfo.layer nodeAtPoint:actualPoint];
    [nodeFound runAction:[SKAction sequence:@[[SKAction scaleTo:0.2f duration:0.5f],[SKAction scaleTo:1.0f duration:1.0f] ]]];

    
//    TMXLayer *firstLayer = (TMXLayer *)self.tiledMap.layers[0];
//    SKSpriteNode *foundNode = [firstLayer tileAt:actualPoint];

    
    
    //What to do with this though?
    
//    - (SKSpriteNode*)tileAt:(CGPoint)point;
}

// update map label to always be near bottom of scene view
-(void)didChangeSize:(CGSize)oldSize
{
    //    self.mapNameLabel.position = CGPointMake(0, -self.size.height/2.0 + 30);
}

#pragma mark - Update Tick

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}
@end
