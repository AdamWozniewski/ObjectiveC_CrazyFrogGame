#import <Foundation/Foundation.h>

@interface CFLevelManager : NSObject
@property (nonatomic, strong, readonly) NSArray *levelsUnlocked;
@property (nonatomic, strong) NSArray *levelsUnblocked;
@property (nonatomic, assign) NSInteger currentScores;

+ (id) instance;
- (void) saveLevelToUnblockedList: (NSInteger) levelNumber;
- (void) saveHighScore: (NSInteger) score;

- (NSInteger) highScore;
- (NSDictionary *) levelInformation: (NSInteger) levelNumber;
- (NSInteger) numberOfLevels;
@end
