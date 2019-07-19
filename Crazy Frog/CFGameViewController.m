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
    self.audioManager.isMusicOn = YES;

    self.levelManager = [CFLevelManager instance];

    [self configureScene];
    self.levelScene.delegate = self;
//    self.bannerView.delegate = self;
//    [self.bannerView setBackgroundColor: [UIColor clearColor]];

    [self showSceneAndPlay];
    [self.levelScene startGame];
    
    self.scoreLabel.textColor = [SKColor blackColor];
    self.scoreLabel.font = [UIFont fontWithName: @"Chalkboard-Bold" size: (IS_IPAD() ? 34.0 : 16.0)];
    self.pauseView.hidden = YES; // scena domyslnie jest ukryta
}


- (void) dealloc {
}

- (void) configureScene {
    SKView* skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    self.levelManager.currentScores = 0;
    
    self.levelScene = [[CFLevelScene alloc] initWithSize: skView.bounds.size andLevelNumber: self.levelNumber];
    self.levelScene.scaleMode = SKSceneScaleModeFill;
    [skView presentScene: self.levelScene];
    [self updateScores];
    
//    self.awardImagepauseView.image = [UIImage imageNamed: [NSString stringWithFormat: @"Award-%i", [[self.levelData objectForKey: kLevelPrefix] intValue]]];
    self.awardImagepauseView.image = [UIImage imageNamed: [NSString stringWithFormat: @"Award-%i", 1]];
//    [self.audioManager playBackgroundMusic: [NSString stringWithFormat: @"BackgroundMusic-%i.m4a", [[self.levelData objectForKey: kLevelPrefix] intValue]]];
    [self.audioManager playBackgroundMusic: [NSString stringWithFormat: @"BackgroundMusic-%i.m4a", 1]];
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
    [self.audioManager playSoundEffect: @"eat.m4a"];
    self.levelManager.currentScores += kFlyPoints;
    [self updateScores];
}
-(void) eventFinishLevel {
    if (!self.isGameOver) {
        self.isGameOver = YES;
        if (![self isMinimumScores]) {
            [self.audioManager playSoundEffect: @"lost.m4a"];
            [self pauseAction];
            [self showViewWithAward: NO];
        } else {
            [self.audioManager playSoundEffect: @"win.m4a"];
            [self pauseAction];
            [self showViewWithAward: YES];
        }
    }
}
-(NSDictionary *) levelData {
    return [self.levelManager levelInformation: self.levelNumber];
}
- (void) eventFinishedLevel {
    if (!self.isGameOver) {
        if (![self isMinimumScores]) {
            [self.audioManager playSoundEffect: @"lost.m4a"];
            [self eventWasted];
        }
        else {
            [self.audioManager playSoundEffect: @"win.m4a"];
            [self reportAchievementsForGameState];
        }
        self.isGameOver = YES;
    }
}
-(BOOL) isMinimumScores {
    if(([[self.levelData objectForKey: kNumberOfFlies] integerValue] * 0.5) <= self.levelManager.currentScores) {
        return YES;
    }
    return NO;
}

- (void) updateScores {
//    self.scoreLabel.text = [NSString stringWithFormat: @"%li / %li", (long) self.levelManager.currentScores, [[[self levelData] objectForKey: kNumberOfFlies] longValue]];
    self.scoreLabel.text = [NSString stringWithFormat: @"%li / %li", (long) self.levelManager.currentScores, (long)12];
    [self.levelManager saveHighScore: self.levelManager.currentScores];
    
    self.highScoreLabelPauseView.text = [NSString stringWithFormat: @"Najwyższy wynik: %li", (long) [self.levelManager highScore]];
//    self.scoreLabelPauseView.text = [NSString stringWithFormat: @"%li / %li x", (long)self.levelManager currentScores, [[[self levelData] objectForKey: kNumberOfFlies] longValue]];
    self.scoreLabelPauseView.text = [NSString stringWithFormat: @"%li / %li x", (long)self.levelManager.currentScores, (long)12];
    [[GameKitHelper sharedGameKitHelper] reportScore: self.levelManager.currentScores forLeaderbordId: @"nasz.klucz.apple.id"];
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
-(void) showViewWithAward: (BOOL) isAward {
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
-(IBAction)repeatGameAction {
    [self configureScene];
    [self showSceneAndPlay];
    [self.levelScene startGame];
}
-(void) resumeAction {
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
- (void) nextLevelAction {
    self.levelNumber++;
    if (self.levelNumber > [self.levelManager numberOfLevels]) {
        [self backButtonTapped];
        return;
    }
    [self.levelManager saveLevelToUnblockedList: self.levelNumber];
}
-(void) changeVolumeAction {
    self.audioManager.isMusicOn = !self.audioManager.isMusicOn;
    [self checkVolumeButton];
}
-(void) checkVolumeButton {
    if (self.audioManager.isMusicOn) {
        [self.volumeButton setImage:[UIImage imageNamed: @"VolumeOn"] forState: UIControlStateNormal];
    } else {
        [self.volumeButton setImage:[UIImage imageNamed: @"VolumeOff"] forState: UIControlStateNormal];
    }
}
-(void) showSceneAndPlay {
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
