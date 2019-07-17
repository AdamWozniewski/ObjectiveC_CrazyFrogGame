#import "CFWaterObstacle.h"

@implementation CFWaterObstacle
-(instancetype) initWithObstacleNumber: (NSUInteger)number {
    if (self = [super init]) {
        self = [CFWaterObstacle spriteNodeWithImageNamed:
                [NSString stringWithFormat:@"WaterObstacle-%i", number]];
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: self.size];
    }
    return self;
}
@end
