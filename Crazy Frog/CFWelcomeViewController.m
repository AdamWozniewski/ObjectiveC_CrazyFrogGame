#import "CFWelcomeViewController.h"
#import "SKTAudio.h"
#import <Social/Social.h>
#import "GameKitHelper.h"
static NSString *iTunesURL = @"https://itunes.apple.com/app/id863461572";
@interface CFWelcomeViewController ()
@end

@implementation CFWelcomeViewController
- (id)initWithNibName: (NSString*)nibNameOrNil bundle: (NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self){}
    return self;
}
- (void)viewDidLoad {
    self.audioManager = [SKTAudio sharedInstance];
    [self volumeButtonTapped];
    [self.audioManager playBackgroundMusic: @"Intro.m4a"];
    
    if (![SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter]) self.twitterButton.enabled = NO; // sprawdzanie czy nasz IOS jest połączony z Twitter
    if (![SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook]) self.facebookButton.enabled = NO;
    
//    [[NSNotificationCenter defaultCenter] addObserver: self
//                                             selector: @selector(showAuthenticationViewController)
//                                                 name: PresentAuthenticationViewController
//                                               object: nil];
    self.gameCenterButton.enabled = NO;
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayerWithCallbackBlock:^(BOOL isGameCenterEnabled) {
        if (isGameCenterEnabled) self.gameCenterButton.enabled = YES;
    }];
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}
- (void)dealloc {}
- (IBAction)twitterButtonTapped {
    if ([SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
        [tweetSheet setInitialText: @"Ta gra się udała"];
        [tweetSheet addURL: [NSURL URLWithString: iTunesURL]];
        [self presentViewController: tweetSheet animated: YES completion: nil];
    }
}
- (IBAction)facebookButtonTapped {
    if ([SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook]) {
        SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
        [fbSheet setInitialText: @"Ta gra się udała"];
        [fbSheet addURL: [NSURL URLWithString: iTunesURL]];
        [self presentViewController: fbSheet animated: YES completion: nil];
    }
}
- (IBAction)gameCenterButtonTapped {
    if ([GKLocalPlayer localPlayer].isAuthenticated) [[GameKitHelper sharedGameKitHelper] showGKGameCenterViewController: self];
    else self.gameCenterButton.enabled = NO;
}
- (IBAction)volumeButtonTapped {
    self.audioManager.isMusicOn = !self.audioManager.isMusicOn;
    [self checkVoluleButton];
}
- (void) checkVoluleButton {
    if (self.audioManager.isMusicOn) [self.volumeButton setImage: [UIImage imageNamed: @"VolumeOn"] forState: UIControlStateNormal];
    else [self.volumeButton setImage: [UIImage imageNamed: @"VolumeOff"] forState: UIControlStateNormal];
}
- (void) showAuthenticationViewController {
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [self presentViewController: gameKitHelper.authenticationViewControler
                         animated: YES
                       completion: nil];
}
@end
