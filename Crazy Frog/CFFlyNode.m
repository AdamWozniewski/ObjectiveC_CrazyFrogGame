#import "CFFlyNode.h"
#import "Macros.h"

@implementation CFFlyNode
-(instancetype) init {
    if (self = [super init]) {
        self = [CFFlyNode spriteNodeWithImageNamed: @"Fly"];
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: IS_IPAD() ? self.size.height : self.size.height / 2.0];
    }
    return self;
}
@end
