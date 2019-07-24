#import <UIKit/UIKit.h>
#import "CFLevelScene.h"
#import "SKTAudio.h"
#import "CFLevelManager.h"
#import "CFLevelScene.h"
#import <iAd/iAd.h>

extern NSString* const kNumberOfFlies;
extern NSString* const kLevelDistance;
extern NSString* const kNumberOfBadBees;
extern NSString* const kNumberOfWaterObstacles;
extern NSString* const kSpeed;
extern NSString* const kIsFloor;
extern NSString* const kLevelPrefix;
extern NSString* const kPrizeType;

@interface CFGameViewController : UIViewController
@property(nonatomic, strong) SKTAudio *audioManager;
@property (nonatomic, assign) NSInteger levelNumber;
@property (nonatomic, strong) CFLevelScene *levelScene;
@property (nonatomic, strong) CFLevelManager *levelManager;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, assign) BOOL isGameOver;

@property (nonatomic, weak) IBOutlet UIButton *jumpButton;
@property (nonatomic, weak) IBOutlet UIView *pauseView;
@property (nonatomic, weak) IBOutlet UIButton *pauseButton;

@property (weak, nonatomic) IBOutlet UIButton *volumeButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabelPauseView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabelPauseView;
@property (weak, nonatomic) IBOutlet UIImageView *awardImagepauseView;
@property (weak, nonatomic) IBOutlet UIImageView *levelClearedImageView;
@property (nonatomic, weak) IBOutlet ADBannerView *bannerView;

- (id) initWithSize: (CGSize)size andLevelNumber: (NSInteger)levelNumber;
- (void) startGame;
- (IBAction) backButtonTapped;
- (IBAction) jumpAction;
- (void) updateScores;
- (IBAction) pauseAction;
- (void) showSceneAndPlay;
- (IBAction) repeatGameAction;
- (IBAction) resumeAction;
- (IBAction) changeVolumeAction;
- (void) showViewWithAward: (BOOL) isAward;
- (void) uiForPause;
- (void) nextLevelAction;
- (void) checkVolumeButton;
- (BOOL) bannerViewActionShouldBegin: (ADBannerView *)banner willLeaveApplication: (BOOL) willLeave;
- (void)bannerView: (ADBannerView *)banner didFailToReceiveAdWithError: (NSError *) error;
@end
