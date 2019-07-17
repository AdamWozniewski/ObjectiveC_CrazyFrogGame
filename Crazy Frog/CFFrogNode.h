#import <SpriteKit/SpriteKit.h>

@interface CFFrogNode : SKSpriteNode

@property (nonatomic, strong) SKSpriteNode *tongue;
@property (nonatomic, strong) SKAction *eatAction;
- (void) jump;
- (void) eat;

@end
