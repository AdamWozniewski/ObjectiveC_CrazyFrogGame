#import "CFGameViewController.h"
#import "CFLevelScene.h"
#import "SKTAudio.h"
#import "CFLevelManager.h"
#import "Macros.h"
#import "GameKitHelper.h"
#import "AchievementsHelper.h"
#import <iAd/iAd.h>

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

@interface CFGameViewController () <SceneDelegate, ADBannerViewDelegate>
@end

@implementation CFGameViewController
- (void)viewDidLoad {
    self.audioManager = [SKTAudio sharedInstance];
    self.levelManager = [CFLevelManager instance];
    [self configureScene];
    
    [self showSceneAndPlay];
    [self.levelScene startGame];
    
    self.scoreLabel.textColor = [SKColor blackColor];
    self.scoreLabel.font = [UIFont fontWithName: @"ChalkboardSE-Bold"
                                           size: (IS_IPAD() ? 34.0 : 16.0)];
    self.scoreLabelPauseView.textColor = [SKColor whiteColor];
    self.scoreLabelPauseView.font = [UIFont fontWithName: @"ChalkboardSE-Bold"
                                                    size: (IS_IPAD() ? 44.0 : 26.0)];
    self.highScoreLabelPauseView.textColor = [SKColor whiteColor];
    self.highScoreLabelPauseView.font = [UIFont fontWithName: @"ChalkboardSE-Bold"
                                                        size: (IS_IPAD() ? 32.0 : 18.0)];
    
//    self.bannerView.delegate = self;
//    [self.bannerView setBackgroundColor: [UIColor clearColor]];
    
}
- (void) dealloc {
}
- (void) configureScene {
    SKView* skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    self.levelManager.currentScores = 0;
    [self updateScores];
    
    self.levelScene = [[CFLevelScene alloc] initWithSize: skView.bounds.size andLevelNumber: self.levelNumber];
    self.levelScene.scaleMode = SKSceneScaleModeFill;
    [skView presentScene: self.levelScene];
    
//    self.awardImagePauseView.image = [UIImage imageNamed: [NSString stringWithFormat: @"Award-%i", [[self.levelData objectForKey: kLevelPrefix] intValue]]];
    self.levelScene.delegate = self;
    self.levelScene.scaleMode = SKSceneScaleModeFill;
    [skView presentScene: self.levelScene];
    [self.audioManager playBackgroundMusic: [NSString stringWithFormat: @"BackgroundMusic-%i.m4a", [[self.levelData objectForKey: kLevelPrefix] intValue]]];
    
    self.isGameOver = NO;
}

#pragma mark Game Actions

- (IBAction) backButtonTapped {
    [self.navigationController popViewControllerAnimated: YES];
}
- (IBAction)jumpAction {
    [self.levelScene jumpAction];
}

-(void) eventWasted {
    [self.audioManager playSoundEffect: @"frog.m4a"];
    self.isGameOver = YES;
    [self pauseAction];
}
-(void) eventKilled {
    [self.audioManager playSoundEffect: @"eat.wav"];
    self.levelManager.currentScores += kFlyPoints;
    [self updateScores];
}
- (NSDictionary *)levelData {
    return [self.levelManager levelInformation: self.levelNumber];
}
- (void) eventFinishedLevel {
    if (!self.isGameOver) {
        self.isGameOver = YES;
        if (![self isMinimumScores]) {
            [self.audioManager playSoundEffect: @"lost.m4a"];
            [self pauseAction];
            [self showViewWithAward: NO];
        }
        else {
            [self.audioManager playSoundEffect: @"win.m4a"];
//            [self reportAchievementsForGameState];
            [self pauseAction];
            [self showViewWithAward: YES];
        }
    }
}
-(BOOL) isMinimumScores {
    if (([[self.levelData objectForKey: kNumberOfFlies] integerValue] * 0.5) <= self.levelManager.currentScores) return YES;
    return NO;
}
- (void) updateScores {
    self.scoreLabel.text = [NSString stringWithFormat: @"%li / %li", (long) self.levelManager.currentScores, [[[self levelData] objectForKey: kNumberOfFlies] longValue]];
    [self.levelManager saveHighScore: self.levelManager.currentScores];
    
    self.highScoreLabelPauseView.text = [NSString stringWithFormat: @"Najwyższy wynik: %li", (long) [self.levelManager highScore]];
    self.scoreLabelPauseView.text = [NSString stringWithFormat: @"%li / %li x", (long)self.levelManager.currentScores, [[[self levelData] objectForKey: kNumberOfFlies] longValue]];
//    [[GameKitHelper sharedGameKitHelper] reportScore: self.levelManager.currentScores forLeaderbordId: @"nasz.klucz.apple.id"];
}
-(IBAction) pauseAction {
    [self uiForPause];
    [self showViewWithAward: NO];
    [self.audioManager pauseBackgroundMusic];
}
-(void) uiForPause {
    self.levelScene.view.paused = YES;
    self.pauseView.hidden = NO;
    self.pauseButton.hidden = YES;
    self.jumpButton.hidden = YES;
}
- (void) showViewWithAward: (BOOL) isAward {
    if (!isAward) {
        self.levelClearedImageView.hidden = YES;
        self.awardImagepauseView.hidden = YES;
        self.pauseView.alpha = 0.9;
    } else {
        self.levelClearedImageView.hidden = NO;
        self.awardImagepauseView.hidden = NO;
        self.pauseView.alpha = 1.0;
    }
}
- (IBAction)repeatGameAction {
    [self configureScene];
    [self showSceneAndPlay];
    [self.levelScene startGame];
}
- (void) resumeAction {
    if (self.isGameOver) {
        if (!self.awardImagepauseView.hidden) {
            [self nextLevelAction];
        }
        if (self.levelNumber > [self.levelManager numberOfLevels]) return;
        [self configureScene];
        [self showSceneAndPlay];
        [self.levelScene startGame];
        self.isGameOver = NO;
    }
    [self showSceneAndPlay];
}
- (void)nextLevelAction {
    self.levelNumber += 1;
    if (self.levelNumber > [self.levelManager numberOfLevels]) {
        [self backButtonTapped];
        return;
    }
    [self.levelManager saveLevelToUnblockedList: self.levelNumber];
}
- (void) changeVolumeAction {
    self.audioManager.isMusicOn = !self.audioManager.isMusicOn;
    [self checkVolumeButton];
}
- (void) checkVolumeButton {
    if (self.audioManager.isMusicOn) {
        [self.volumeButton setImage:[UIImage imageNamed: @"VolumeOn"] forState: UIControlStateNormal];
    } else {
        [self.volumeButton setImage:[UIImage imageNamed: @"VolumeOff"] forState: UIControlStateNormal];
    }
}
- (void) showSceneAndPlay {
    self.pauseView.hidden = YES;
    self.pauseButton.hidden = NO;
    self.jumpButton.hidden = NO;
    [self.audioManager resumeBackgroundMusic];
    self.levelScene.view.paused = NO;
}
- (void) reportAchievementsForGameState {
    NSMutableArray *achv = [NSMutableArray array];
    [achv addObject: [AchievementsHelper prizeWithType: [self.levelData objectForKey: kPrizeType]]];
    [[GameKitHelper sharedGameKitHelper] reportAchievements: achv];
}
//- (void)bannerView: (ADBannerView*)banner didFailToReceiveAdWithError: (NSError*) error {
//    NSLog(@"iAd error: %@", error);
//    [self.bannerView removeFromSuperview];
//    self.bannerView = nil;
//}
//- (BOOL)bannerViewActionShouldBegin: (ADBannerView*)banner willLeaveApplication: (BOOL) willLeave {
//    [self pauseAction];
//    return YES;
//}
@end
