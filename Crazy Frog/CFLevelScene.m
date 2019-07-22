static const uint32_t kCharacterCategory         =  0x1 << 0;
static const uint32_t kTongueCategory            =  0x1 << 1;
static const uint32_t kFlyCategory               =  0x1 << 3;
static const uint32_t kBeeCategory               =  0x1 << 4;
static const uint32_t kWaterObstacleCategory     =  0x1 << 5;
static const uint32_t kFloorCategory             =  0x1 << 6;
static const uint32_t kWaterCategory             =  0x1 << 7;
static const uint32_t kAwardCategory             =  0x1 << 8;

#import "CFLevelScene.h"
#import "CFFrogNode.h"
#import "CFFlyNode.h"
#import "CFWaterObstacle.h"
#import "CFBeeNode.h"
#import "SKTUtils.h"
#import "PBParallaxScrolling.h"
#import "Macros.h"
#import "CFGameViewController.h"

@interface CFLevelScene () <SKPhysicsContactDelegate>
@end

@implementation CFLevelScene
- (id)initWithSize: (CGSize)size andLevelNumber: (NSInteger) levelNumber {
    if (self = [super initWithSize: size]) {
        self.physicsWorld.contactDelegate = self;
        self.levelNumber = levelNumber;
        self.backgroundColor = [SKColor whiteColor];
        self.flyObstacles = [NSMutableArray new];
        self.waterObstacles = [NSMutableArray new];
        self.badBeesObstacles = [NSMutableArray new];
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = 0.2;
        [self.motionManager startAccelerometerUpdates];
    }
    return self;
}
- (void) startGame {
    [self initializeGameWithLevel: self.levelNumber];
}
- (void) didSimulatePhysics {
    self.xAcceleration = (self.motionManager.accelerometerData.acceleration.y * 0.75) + (self.xAcceleration * 0.25);
    self.frog.physicsBody.velocity = CGVectorMake(self.xAcceleration * (IS_IPAD() ? 1200.0 : 600), self.frog.physicsBody.velocity.dy);
}
- (void) initializeGameWithLevel: (NSInteger) levelNumber {
    self.levelDistance = [[[self.delegate levelData] objectForKey: kLevelDistance] intValue];
    CGFloat speed = [[[self.delegate levelData] objectForKey: kSpeed] floatValue];
    self.speed = IS_IPAD() ? speed : speed * 0.75;
    self.numberOfFlies = [[[self.delegate levelData] objectForKey: kNumberOfFlies] intValue];
    self.numberOfWaterObstacles = [[[self.delegate levelData] objectForKey: kNumberOfWaterObstacles] intValue];
    self.numberOfBadBees = [[[self.delegate levelData] objectForKey: kNumberOfBadBees] intValue];
    self.isFloor = [[[self.delegate levelData] objectForKey: kIsFloor] boolValue];
    NSArray *imageNames = @[[NSString stringWithFormat:@"Background-%i", [[[self.delegate levelData] objectForKey: kLevelPrefix] intValue]]];
    PBParallaxScrolling *parallax = [[PBParallaxScrolling alloc] initWithBackgrounds: imageNames
                                                                                size: self.size
                                                                           direction: kPBParallaxBackgroundDirectionLeft
                                                                        fastestSpeed: self.speed * 0.5
                                                                    andSpeedDecrease: kPBParallaxBackgroundDefaultSpeedDifferential];
    NSLog(@"%i", self.numberOfFlies);
    self.parallaxBackground = parallax;
    [self addChild: parallax];
    [self createFrog];
    [self createFloor];
    [self createAward];
}
- (void) createFrog {
    self.frog = [CFFrogNode new];
    [self.frog setPosition: CGPointMake(200.0, CGRectGetMidY(self.frame))];
    [self.frog setName: @"Frog"];
    [self addChild: self.frog];
    
    self.frog.physicsBody.categoryBitMask = kCharacterCategory;
    self.frog.physicsBody.collisionBitMask = kWaterCategory;
    self.frog.physicsBody.contactTestBitMask = kWaterObstacleCategory;
    
    self.frog.tongue.physicsBody.categoryBitMask = kTongueCategory;
    self.frog.tongue.physicsBody.collisionBitMask = 0x0;
    self.frog.tongue.physicsBody.contactTestBitMask = kFlyCategory | kBeeCategory;
}
- (void) jumpAction {
    [self.frog jump];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode: self];
        [self enumerateChildNodesWithName: @"Award" usingBlock: ^(SKNode *node, BOOL *stop) {
            if ([node containsPoint: location]) {
                [self.delegate eventFinishedLevel];
            }
        }];
    }
    [self.frog eat];
}
- (void)update: (NSTimeInterval)currentTime {
    CGFloat minYposition = self.frog.size.height;
    CGFloat maxYPosition = self.size.height - self.frog.size.height;
    if (self.flyObstacles.count < self.numberOfFlies) {
        CGPoint randomPosition = CGPointMake(RandomFloatRange(self.size.width, self.levelDistance),
                                             RandomFloatRange(minYposition, maxYPosition));
        [self createFlyWithLocation: randomPosition];
    }
    if (self.badBeesObstacles.count < self.numberOfBadBees) {
        CGPoint randomPosition = CGPointMake(RandomFloatRange(self.size.width, self.levelDistance),
                                             RandomFloatRange(minYposition, maxYPosition));
        [self createBadBeesWithLocation: randomPosition];
    }
    if (self.waterObstacles.count < self.numberOfWaterObstacles) {
        CGPoint randomPosition = CGPointMake(RandomFloatRange(self.size.width, self.levelDistance),
                                             self.water.size.height);
        [self createWaterObstacleWithLocation: randomPosition];
    }
    [self updateObstacles: currentTime];
    [self.parallaxBackground update: currentTime];
    [self updateAward: currentTime];
}
- (void) createFlyWithLocation: (CGPoint) location {
    SKSpriteNode *fly = [CFFlyNode new];
    fly.position = location;
    [fly setName:@"Fly"];
    
    fly.physicsBody.affectedByGravity = NO;
    fly.physicsBody.dynamic = YES;
    fly.physicsBody.categoryBitMask = kFlyCategory;
    fly.physicsBody.collisionBitMask = 0x0;
    fly.physicsBody.contactTestBitMask = kTongueCategory;
    
    [self.flyObstacles addObject:fly];
    [self addChild: fly];
}
- (void) createBadBeesWithLocation: (CGPoint)location {
    SKSpriteNode *bee = [CFBeeNode new];
    bee.position = location;
    [bee setName:@"Bee"];
    
    bee.physicsBody.affectedByGravity = NO;
    bee.physicsBody.dynamic = YES;
    bee.physicsBody.categoryBitMask = kBeeCategory;
    bee.physicsBody.collisionBitMask = 0x0;
    bee.physicsBody.contactTestBitMask = kTongueCategory;
    
    [self.badBeesObstacles addObject: bee];
    [self addChild: bee];
}
- (void) createWaterObstacleWithLocation: (CGPoint)location {
    SKSpriteNode *obstacle = [SKSpriteNode spriteNodeWithImageNamed:
                              [NSString stringWithFormat:@"WaterObstacle-%i",
                               [[[self.delegate levelData] objectForKey: kLevelPrefix] intValue]]];
    obstacle.position = location;
    obstacle.zPosition = 997;
    obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: obstacle.size];
    obstacle.physicsBody.affectedByGravity = NO;
    obstacle.physicsBody.allowsRotation = NO;
    obstacle.physicsBody.dynamic = YES;
    obstacle.physicsBody.categoryBitMask = kWaterObstacleCategory;
    obstacle.physicsBody.collisionBitMask = kWaterCategory;
    obstacle.physicsBody.contactTestBitMask = kCharacterCategory;
    
    [self.waterObstacles addObject: obstacle];
    [self addChild: obstacle];
    
}
- (void) updateObstacles: (NSTimeInterval)currentTime {
    for(int i = 0; i < self.flyObstacles.count; i++) {
        SKSpriteNode *obstacle = (SKSpriteNode *)self.flyObstacles[i];
        if (![obstacle.name isEqualToString: @"Killed"]) {
            CGPoint position = obstacle.position;
            position.x = obstacle.position.x - (i % 2 ? self.speed : self.speed * 1.5);
            obstacle.position = position;
            if (position.x < - self.size.width) {
                [obstacle removeFromParent];
            }
        }
    }
    
    for(int i = 0; i < self.badBeesObstacles.count; i++) {
        SKSpriteNode *obstacle = (SKSpriteNode *)self.badBeesObstacles[i];
        if (![obstacle.name isEqualToString: @"Killed"]) {
            CGPoint position = obstacle.position;
            position.x = obstacle.position.x - (i % 2 ? self.speed : self.speed * 0.75);
            obstacle.position = position;
            if (position.x < - self.size.width) {
                [obstacle removeFromParent];
            }
        }
    }
    
    for(int i = 0; i < self.waterObstacles.count; i++) {
        SKSpriteNode *obstacle = (SKSpriteNode *)self.waterObstacles[i];
        CGPoint position = obstacle.position;
        position.x = obstacle.position.x - self.speed;
        obstacle.position = position;
        if (position.x < self.size.width) {
            obstacle.physicsBody.affectedByGravity = YES;
        }
        if (position.x < - self.size.width) {
            [obstacle removeFromParent];
        }
    }
}
- (void) didBeginContact:(SKPhysicsContact *)contact {
    uint32_t bitMaskA = contact.bodyA.categoryBitMask;
    uint32_t bitMaskB = contact.bodyB.categoryBitMask;
    
    if ((((bitMaskA & kTongueCategory) != 0 && (bitMaskB & kFlyCategory) != 0) ||
         ((bitMaskB & kTongueCategory) != 0 && (bitMaskA & kFlyCategory) != 0)) &&
        !self.frog.tongue.hidden) {
        SKNode *fly;
        if ([contact.bodyA.node.name isEqualToString:@"Fly"]) {
            fly = contact.bodyA.node;
        } else {
            fly = contact.bodyB.node;
        }
        if (![contact.bodyA.node.name isEqualToString:@"Killed"] &&
            ![contact.bodyB.node.name isEqualToString:@"Killed"]) {
            if([self.delegate respondsToSelector:@selector(eventKilled)]) {
                [self.delegate eventKilled];
            }
            [fly setName: @"Killed"];
            SKAction* setTextureAction = [SKAction setTexture: [SKTexture textureWithImageNamed: @"BlueStar"] resize: YES];
            SKAction* wait = [SKAction waitForDuration: 1.0];
            SKAction* remove = [SKAction removeFromParent];
            [fly runAction: [SKAction sequence: @[setTextureAction, wait, remove]]];
        }
    }
    if ((((bitMaskA & kTongueCategory) != 0 && (bitMaskB & kBeeCategory) != 0) ||
         ((bitMaskB & kTongueCategory) != 0 && (bitMaskA & kBeeCategory) != 0)) &&
        !self.frog.tongue.hidden) {
        SKNode *badBee;
        if ([contact.bodyA.node.name isEqualToString:@"BadBee"]) {
            badBee = contact.bodyA.node;
        } else {
            badBee = contact.bodyB.node;
        }
        [badBee setName: @"Killed"];
        SKAction* setTextureAction = [SKAction setTexture: [SKTexture textureWithImageNamed: @"BlueStar"] resize: YES];
        SKAction* wait = [SKAction waitForDuration: 1.5];
        SKAction* wasted = [SKAction runBlock:^{
            [self.delegate eventWasted];
        }];
        SKAction* remove = [SKAction removeFromParent];
        [badBee runAction: [SKAction sequence: @[setTextureAction, wait, wasted, remove]]];
    }
    if (((bitMaskA & kCharacterCategory) != 0 && (bitMaskB & kWaterObstacleCategory) != 0) ||
        ((bitMaskB & kCharacterCategory) != 0 && (bitMaskA & kWaterObstacleCategory) != 0)) {
        if([self.delegate respondsToSelector:@selector(eventWasted)]) {
            [self.delegate eventWasted];
        }
        [self.frog removeFromParent];
    }
}

- (void) createFloor {
    SKSpriteNode *water = [SKSpriteNode spriteNodeWithImageNamed:
                           [NSString stringWithFormat:@"Water-%i",
                            [[[self.delegate levelData] objectForKey: kLevelPrefix] intValue]]];
    water.position = CGPointMake(0.0, 20.0);
    [water setAnchorPoint: (CGPoint){0.0, 0.0}];
    [water setName:@"Water"];
    water.zPosition = 998;
    CGRect frame = water.frame;
    frame.size.height -= IS_IPAD() ? 50.0 : 40.0;
    [water setPhysicsBody: [SKPhysicsBody bodyWithEdgeLoopFromRect: frame]];
    water.physicsBody.dynamic = NO;
    water.physicsBody.categoryBitMask = kWaterCategory;
    water.physicsBody.collisionBitMask = kCharacterCategory;
    water.physicsBody.contactTestBitMask = 0x0;
    [self addChild: water];
    
    if (self.isFloor) {
        SKSpriteNode *floor = [SKSpriteNode spriteNodeWithImageNamed:
                               [NSString stringWithFormat: @"Floor-%i",
                                [[[self.delegate levelData] objectForKey: kLevelPrefix] intValue]]];
        floor.position = CGPointZero;
        [floor setAnchorPoint: (CGPoint){0.0, 0.0}];
        [floor setName: @"Floor"];
        floor.zPosition = 999;
        [floor setPhysicsBody: [SKPhysicsBody bodyWithEdgeLoopFromRect: floor.frame]];
        floor.physicsBody.dynamic = NO;
        floor.physicsBody.categoryBitMask = kFloorCategory;
        floor.physicsBody.collisionBitMask = 0x0;
        floor.physicsBody.contactTestBitMask = 0x0;
        [self addChild: floor];
    } else {
        CGPoint waterPosition = water.position;
        waterPosition.y = 0.0;
        water.position = waterPosition;
    }
    SKAction *moveFloorUp = [SKAction moveToY: IS_IPAD() ? - 25.0 : self.isFloor ? - 5.0 : - 15.0 duration: 2.0];
    SKAction *moveFloorDown = [SKAction moveToY: IS_IPAD() ? - 15.0 : self.isFloor ? 0.0 : - 10.0 duration: 2.0];
    SKAction *moveFloor = [SKAction sequence: @[moveFloorUp, moveFloorDown]];
    [water runAction: [SKAction repeatActionForever: moveFloor]];
    
    self.water = water;
}
- (void) createAward {
    SKSpriteNode *award = [SKSpriteNode spriteNodeWithImageNamed:
                           [NSString stringWithFormat: @"Award-%i",
                            [[[self.delegate levelData] objectForKey: kLevelPrefix] intValue]]];
    award.position = CGPointMake(self.size.width * 1.3, self.size.height * 0.5);
    [award setName: @"Award"];
    [award setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize: award.size]];
    award.physicsBody.affectedByGravity = NO;
    award.physicsBody.dynamic = YES;
    award.physicsBody.categoryBitMask = kAwardCategory;
    award.physicsBody.contactTestBitMask = kCharacterCategory;
    award.physicsBody.collisionBitMask = kWaterCategory;
    self.award = award;
}

- (void) updateAward: (NSTimeInterval) currentTime {
    if (![self childNodeWithName: @"Fly"]) {
        if (![self.award parent]) {
            [self addChild: self.award];
        } else {
            CGPoint position = self.award.position;
            if (position.x < self.frame.size.width * 0.5) {
                return;
            }
            CGFloat move = self.speed * 0.5;
            position.x = self.award.position.x - move;
            self.award.position = position;
            if (![self.delegate isMinimumScores]) {
                [self.award setTexture: [SKTexture textureWithImage: [UIImage imageNamed: @"TryAgain"]]];
            }
        }
    }
}
@end
