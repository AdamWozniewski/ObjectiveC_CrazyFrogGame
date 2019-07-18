#import <SpriteKit/SpriteKit.h>
#import "CFFrogNode.h"
#import "PBParallaxScrolling.h"

@protocol SceneDelegate <NSObject>
-(void) eventKilled;
-(void) eventWasted;
-(void) eventFinishedLevel;
-(NSDictionary *) levelData;
-(BOOL) isMinimumScores;
@end
@interface CFLevelScene : SKScene <SKPhysicsContactDelegate>
@property (nonatomic, assign) NSInteger levelNumber;
@property (nonatomic, assign) NSInteger levelDistance;
@property (nonatomic, assign) BOOL isFloor;
@property (nonatomic, assign) NSInteger numberOfFlies;
@property (nonatomic, assign) NSInteger numberOfWaterObstacles;
@property (nonatomic, assign) NSInteger numberOfBadBees;
@property (nonatomic, strong) CFFrogNode* frog;
@property (nonatomic, strong) SKSpriteNode* water;
@property (nonatomic, strong) NSMutableArray* flyObstacles;
@property (nonatomic, strong) NSMutableArray* waterObstacles;
@property (nonatomic, strong) NSMutableArray* badBeesObstacles;
@property (nonatomic, strong) PBParallaxScrolling* parallaxBackground;
@property (nonatomic, weak) id <SceneDelegate> delegate;
@property (nonatomic, strong) SKSpriteNode *award;

-(id) initWithSize: (CGSize)size andLevelNumber: (NSInteger)levelNumber;
-(void) initializeGameWithLevel: (NSInteger) levelNumber;
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void) jumpAction;
-(void) startGame;
-(void) updateAward: (NSTimeInterval) currentTime;
@end
