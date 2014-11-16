//
//  GameViewController.m
//  Cobra Ball Spritekit
//
//  Created by Robert Linnemann on 11/12/14.
//  Copyright (c) 2014 Robert Linnemann. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@interface GameViewController ()

@property (weak, nonatomic) GameScene *scene;

@end

@implementation SKScene (Unarchive)

//+ (instancetype)unarchiveFromFile:(NSString *)file {
//    /* Retrieve scene file path from the application bundle */
//    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
//    /* Unarchive the file to an SKScene object */
//    NSData *data = [NSData dataWithContentsOfFile:nodePath
//                                          options:NSDataReadingMappedIfSafe
//                                            error:nil];
//    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    [arch setClass:self forClassName:@"SKScene"];
//    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
//    [arch finishDecoding];
//    
//    return scene;
//}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.

    
    // Create and configure the scene.
    GameScene *scene = [GameScene sceneWithSize:skView.bounds.size];
//        scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.scaleMode = SKSceneScaleModeResizeFill;
    self.scene = scene;
    
    // Present the scene.
    [skView presentScene:scene];
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(runTapGesture:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.delegate = self;
    [self.view addGestureRecognizer:panRecognizer];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleZoom:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - Gestures

- (IBAction)runTapGesture:(UITapGestureRecognizer *)sender
{

//    CGPoint trans = [sender locationInView:self.view];
//    [self.scene moveWorld:trans]; //touch in view...
    
//    [self.scene swapToNextMap];
//    self.scene.til
//    NSLog(@"tap {%@,%@}",@(trans.x),@(trans.y));
//    CGPoint curPos = self.scene.worldNode.position;
//    self.scene.worldNode.position = CGPointMake(curPos.x + trans.x, curPos.y - trans.y);

}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender
{
//    CGPoint trans = [sender locationInView:self.view];

//    CGPoint trans = self.scene.worldNode.position;
//    trans.y =20;
//    trans.x = 20;
    
    
//    NSLog(@"%@,%@",@(self.scene.worldNode.position.x),@(self.scene.worldNode.position.y));
//    NSLog(@"%@,%@",@(trans.position.),@(self.scene.worldNode.position.y));

    
    CGPoint trans = [sender translationInView:self.view];
    CGPoint curPos = self.scene.worldNode.position;
    NSLog(@"%@,%@",@(self.scene.worldNode.position.x),@(self.scene.worldNode.position.y));
    self.scene.worldNode.position = CGPointMake(curPos.x + trans.x, curPos.y - trans.y);
    [sender setTranslation:CGPointZero inView:self.view];
    
    
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
    //Get delta!!! // is this translation?
    }
    if (sender.state == UIGestureRecognizerStateEnded) { /*finish animations? */ }
}

- (IBAction)handleZoom:(UIPinchGestureRecognizer *)sender
{
    static CGFloat startScale = 1;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        startScale = self.scene.worldNode.xScale;
    }
    CGFloat newScale = startScale * sender.scale;
    self.scene.worldNode.xScale = MIN(2.0, MAX(newScale, .5));
    self.scene.worldNode.yScale = self.scene.worldNode.xScale;
}

#pragma mark - stupid shit

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
