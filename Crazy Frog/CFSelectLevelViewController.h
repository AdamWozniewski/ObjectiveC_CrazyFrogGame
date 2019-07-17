#import <UIKit/UIKit.h>
#import "CFLevelManager.h"

@interface CFSelectLevelViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton* swampButton;
@property (weak, nonatomic) IBOutlet UIButton* poolButton;
@property (weak, nonatomic) IBOutlet UIButton* seaButton;
@property (weak, nonatomic) IBOutlet UIButton* swampStarButton;
@property (weak, nonatomic) IBOutlet UIButton* poolStarButton;
@property (weak, nonatomic) IBOutlet UIButton* seaStarButton;

- (IBAction)backButtonTapped;
- (IBAction)levelButtonTapped: (id)sender;
@property (nonatomic, strong) CFLevelManager *levelManager;

@end
