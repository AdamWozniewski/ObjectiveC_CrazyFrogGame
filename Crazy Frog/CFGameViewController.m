#import "CFGameViewController.h"
#import "CFLevelScene.h"
#import "SKTAudio.h"
#import "CFLevelManager.h"

NSString* const kViewTransformChanged = @"viewTransformChanged";
NSString* const kLevelDistance = @"levelDistance";
NSString* const kNumberOfBadBees = @"numberOfBadBees";
NSString* const kNumberOfFlies = @"numberOfFlies";
NSString* const kNumberOfWaterObstacles = @"numberOfWaterObstacles";
NSString* const kSpeed = @"speed";
NSString* const kIsFloor = @"isFloor";
NSString* const kLevelPrefix = @"levelPrefix";
NSString* const kPrizeType = @"prizeType";
NSInteger const kFlyPoints = 1;

@interface CFGameViewController ()
@end

@implementation CFGameViewController
- (void)viewDidLoad
{
    self.audioManager = [SKTAudio sharedInstance];
    self.audioManager.isMusicOn = YES;
    self.levelManager = [CFLevelManager instance];
    [self configureScene];
    self.levelScene.delegate = self;
    // Start game
    [self.levelScene startGame];
    
    [self.levelScene startGame];
}


- (void)dealloc {
}

- (void)configureScene {
    SKView* skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    self.levelManager.currentScores = 0;
    
    NSLog(@"%i", self.levelNumber);
    self.levelScene = [[CFLevelScene alloc] initWithSize: skView.bounds.size andLevelNumber: self.levelNumber];
    self.levelScene.scaleMode = SKSceneScaleModeFill;
    [skView presentScene: self.levelScene];
}

#pragma mark Game Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated: YES];
}
- (void) startGame {
    
}
- (IBAction)jumpAction {
    [self.levelScene jumpAction];
}

-(void) eventWasted {
    [self.audioManager playSoundEffect: @"frog.m4a"];
}
-(void) eventKilled {
    [self.audioManager playSoundEffect: @"eat.m4a"];
}
-(void) eventFinishLevel {
    [self.audioManager playSoundEffect: @"win.m4a"];
}
-(NSDictionary *) levelData {
    return [self.levelManager levelInformation: self.levelNumber];
}
-(BOOL) isMinimumScores {
    return NO;
}
@end
