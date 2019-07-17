#import "CFBeeNode.h"
#import "Macros.h"

@implementation CFBeeNode
-(instancetype) init {
    if (self = [super init]) {
        self = [CFBeeNode spriteNodeWithImageNamed: @"BadBee"];
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: IS_IPAD() ? self.size.height : self.size.height / 2.0];
    }
    return self;
}
@end
