#import <Foundation/Foundation.h>

@interface CFLevelManager : NSObject
@property (nonatomic, strong, readonly) NSArray *levelsUnlocked;
@property (nonatomic, assign) NSInteger currentScores;
@property (nonatomic, strong) NSArray *levelsUnblocked;

+ (id) instance;
- (void) saveLevelToUnblockedList: (NSInteger) levelNumber;
- (void) saveHighScore: (NSInteger) score;

- (NSInteger) highScore;
- (NSDictionary *) levelInformation: (NSInteger) levelNumber;
- (NSInteger) numberOfLevels;
@end
