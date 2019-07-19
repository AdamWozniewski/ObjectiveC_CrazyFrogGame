#import "CFFrogNode.h"
#import "Macros.h"
@interface CFFrogNode ()
@end
@implementation CFFrogNode

- (id) init {
    if (self = [super init]) {
        NSMutableArray *eatingUpFrogArray = [NSMutableArray array];
        SKTextureAtlas *eatingUpFrogTexture = [SKTextureAtlas atlasNamed: @"frog"];
        for (int i = 1; i < eatingUpFrogTexture.textureNames.count * 0.25; ++ i) {
            NSString *suffix = IS_IPAD() ? @"~ipad" : @"~iphone";
            NSString *txt = [NSString
                             stringWithFormat: @"frog_%02d%@", i, suffix];
            [eatingUpFrogArray addObject: [eatingUpFrogTexture textureNamed: txt]];
        }
        NSArray *eatingDownFrogArray = [NSArray arrayWithArray: [[eatingUpFrogArray reverseObjectEnumerator] allObjects]];
        NSArray *eatingFrogArray = [eatingUpFrogArray arrayByAddingObjectsFromArray: eatingDownFrogArray];
        self = [CFFrogNode spriteNodeWithTexture: [eatingFrogArray firstObject]];
        self.anchorPoint = CGPointZero;

        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        // Fizyka dla obiektu: http://insyncapp.net/SKPhysicsBodyPathGenerator.html
        CGPathMoveToPoint(path, NULL, IS_RETINA_DISPLAY() ? 20 : 40 - offsetX, IS_RETINA_DISPLAY() ? 80 : 160 - offsetY);
        CGPathAddLineToPoint(path, NULL, IS_RETINA_DISPLAY() ? 60 : 120 - offsetX, IS_RETINA_DISPLAY() ? 80 : 160 - offsetY);
        CGPathAddLineToPoint(path, NULL, IS_RETINA_DISPLAY() ? 70 : 140 - offsetX, IS_RETINA_DISPLAY() ? 20 : 40 - offsetY);
        CGPathAddLineToPoint(path, NULL, IS_RETINA_DISPLAY() ? 5 : 10 - offsetX, IS_RETINA_DISPLAY() ? 20 : 40 - offsetY);
        CGPathCloseSubpath(path);

        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath: path];
        self.physicsBody.mass = 0.1;
        self.physicsBody.allowsRotation = NO;

        self.eatAction = [SKAction animateWithTextures: eatingFrogArray timePerFrame: 0.1];
        [self createTongue];
    }
    return self;
}
- (void) jump {
    [self.physicsBody setVelocity: CGVectorMake(0.0, 0.0)];
    [self.physicsBody applyImpulse: CGVectorMake(0.0, IS_IPAD() ? 90.0 : 60.0)];
}
- (void) eat {
    
    [self createTongue];
    CGPoint tongueFinishPoint = IS_IPAD() ? CGPointMake(200.0, 200.0) : CGPointMake(120.0, 120.0);
    CGPoint tongueStartPoint = CGPointMake(self.size.width / 2, self.size.height / 2);
    self.tongue.position = tongueStartPoint;
    SKAction *showTongue = [SKAction performSelector: @selector(changeTongueVisibility) onTarget: self];
    SKAction *moveUpTongue = [SKAction moveTo: tongueFinishPoint duration: 0.3];
    SKAction *moveDownTongue = [SKAction moveTo: tongueStartPoint duration: 0.3];
    SKAction *hideTongue = [SKAction performSelector: @selector(changeTongueVisibility) onTarget: self];
    [self.tongue runAction: [SKAction sequence: @[showTongue, moveUpTongue, moveDownTongue, hideTongue]]];
    [self runAction: self.eatAction];
}
- (void) createTongue {
    if (!self.tongue) {
        self.tongue = [SKSpriteNode spriteNodeWithColor: [SKColor clearColor] size: CGSizeMake(40.0, 40.0)];
        self.tongue.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        self.tongue.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: self.tongue.size];
        self.tongue.physicsBody.affectedByGravity = NO;
        self.tongue.physicsBody.mass = 0.001;
        self.tongue.hidden = YES;
        [self addChild: self.tongue];
    }
}
- (void) changeTongueVisibility {
    self.tongue.hidden = !self.tongue.hidden;
}
@end
