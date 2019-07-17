#import "CFLevelManager.h"

NSString *const kLevelsUnblocked = @"kLevelsUnblocked";
NSString *const kHighScore = @"kHighScore";
@implementation CFLevelManager
+ (id) instance {
    static dispatch_once_t onceToken;
    static CFLevelManager *shared;
    dispatch_once(&onceToken, ^{
        shared = [[CFLevelManager alloc] init];
        [shared saveLevelToUnblockedList: 1];
//        [shared saveLevelToUnblockedList: 2];
//        [shared saveLevelToUnblockedList: 3];
//        [shared saveLevelToUnblockedList: 4];
//        [shared saveLevelToUnblockedList: 5];
//        [shared saveLevelToUnblockedList: 6];

        
    });
    return shared;
}

- (NSArray *)levelsUnblocked {
    return [NSArray arrayWithArray: [[NSUserDefaults standardUserDefaults] objectForKey: kLevelsUnblocked]];
}
- (void) saveLevelToUnblockedList:(NSInteger)levelNumber {
    NSMutableArray* levels = [NSMutableArray array];
    [levels addObject: [NSNumber numberWithInteger: levelNumber]];
    
    if (![self.levelsUnblocked containsObject: [NSNumber numberWithInteger: levelNumber]]) {
        [levels addObjectsFromArray: self.levelsUnblocked];
        [[NSUserDefaults standardUserDefaults] setObject: levels forKey: kLevelsUnblocked];
    }
}
- (NSDictionary*)levelInformation: (NSInteger)levelNumber {
    NSString* path = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat: @"Levels/Level%li",
                                                              (long)levelNumber] ofType: @"plist"];
    NSDictionary* result = [[NSDictionary alloc] initWithContentsOfFile: path];
    return result;
}
- (NSInteger) highScore {
    return [[[NSUserDefaults standardUserDefaults] objectForKey: kHighScore] integerValue];
}
- (void) saveHighScore:(NSInteger)score {
    if (score > [self highScore]) {
        [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInteger: score] forKey: kHighScore];
    }
}
- (NSInteger) numberOfLevels {
    NSString* bundlePath = [NSString stringWithFormat: @"%@/Levels", [[NSBundle mainBundle] bundlePath]];
    NSArray* directoryContent  = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: bundlePath
                                                                                     error: nil];
    NSInteger numberOfFileInFolder = [directoryContent  count];
    return numberOfFileInFolder;
}
@end
