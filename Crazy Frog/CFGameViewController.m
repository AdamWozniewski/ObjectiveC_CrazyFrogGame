#import "CFGameViewController.h"
#import "CFLevelScene.h"
#import "SKTAudio.h"
#import "CFLevelManager.h"
#import "Macros.h"

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

@interface CFGameViewController () <SceneDelegate>
@end

@implementation CFGameViewController
- (void)viewDidLoad {
    self.audioManager = [SKTAudio sharedInstance];
    self.audioManager.isMusicOn = YES;

    self.levelManager = [CFLevelManager instance];

    [self configureScene];
    self.levelScene.delegate = self;

    [self.levelScene startGame];
    
    self.scoreLabel.textColor = [SKColor blackColor];
    self.scoreLabel.font = [UIFont fontWithName: @"Chalkboard-Bold" size: (IS_IPAD() ? 34.0 : 16.0)];
}


- (void)dealloc {
}

- (void)configureScene {
    SKView* skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    self.levelManager.currentScores = 0;
    
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
    self.levelManager.currentScores += kFlyPoints;
    [self updateScores];
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

- (void) updateScores {
    self.scoreLabel.text = [NSString stringWithFormat: @"%li / %li", (long) self.levelManager.currentScores, [[[self levelData] objectForKey: kNumberOfFlies] longValue]];
    
    [self.levelManager saveHighScore: self.levelManager.currentScores];
}
@end
