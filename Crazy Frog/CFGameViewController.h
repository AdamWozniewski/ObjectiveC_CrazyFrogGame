#import <UIKit/UIKit.h>
#import "CFLevelScene.h"
#import "SKTAudio.h"
#import "CFLevelManager.h"
#import "CFLevelScene.h"

extern NSString* const kNumberOfFlies;
extern NSString* const kLevelDistance;
extern NSString* const kNumberOfBadBees;
extern NSString* const kNumberOfWaterObstacles;
extern NSString* const kSpeed;
extern NSString* const kIsFloor;
extern NSString* const kLevelPrefix;
extern NSString* const kPrizeType;

@interface CFGameViewController : UIViewController
@property(nonatomic, strong) SKTAudio * audioManager;
@property (nonatomic, assign) NSInteger levelNumber;
@property (nonatomic, strong) CFLevelScene *levelScene;
@property (nonatomic, strong) CFLevelManager *levelManager;
- (id) initWithSize: (CGSize)size andLevelNumber: (NSInteger)levelNumber;
//- (void) jumpAction;
- (void) startGame;
- (IBAction)backButtonTapped;
- (IBAction)jumpAction;
@end
