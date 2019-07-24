#import <UIKit/UIKit.h>
#import "SKTAudio.h"

@interface CFWelcomeViewController : UIViewController
@property (nonatomic, strong) SKTAudio *audioManager;
@property (weak, nonatomic) IBOutlet UIButton* twitterButton;
@property (weak, nonatomic) IBOutlet UIButton* facebookButton;
@property (weak, nonatomic) IBOutlet UIButton* gameCenterButton;
@property (weak, nonatomic) IBOutlet UIButton *volumeButton;
- (IBAction) twitterButtonTapped;
- (IBAction) facebookButtonTapped;
- (IBAction) gameCenterButtonTapped;
- (IBAction) volumeButtonTapped;
- (void) checkVoluleButton;
- (IBAction) aboutMeButtonTapped;
- (IBAction) closeApp;
@end
