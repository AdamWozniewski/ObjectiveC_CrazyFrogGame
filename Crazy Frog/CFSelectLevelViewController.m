#import "CFSelectLevelViewController.h"
#import "CFGameViewController.h"
#import "CFLevelManager.h"

@interface CFSelectLevelViewController ()

@end

@implementation CFSelectLevelViewController


- (id)initWithNibName: (NSString*)nibNameOrNil bundle: (NSBundle*)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad {
    self.levelManager = [CFLevelManager instance];
    
    self.swampButton.tag = 1;
    self.poolButton.tag = 2;
    self.seaButton.tag = 3;
    self.swampStarButton.tag = 4;
    self.poolStarButton.tag = 5;
    self.seaStarButton.tag = 6;
    
    [super viewDidLoad];
}


- (void)viewWillAppear: (BOOL)animated {
    for (int i = 1; i <= 6; ++i) {
        UIButton* button = (UIButton*)[self.view viewWithTag: i];
//        if (![self.levelManager.levelsUnblocked containsObject:
//              [NSNumber numberWithInt: i]]) {
//            button.enabled = NO;
//        }
//        else {
//            button.enabled = YES;
//        }
    }
    [super viewWillAppear: animated];
}


- (IBAction)backButtonTapped
{
    // Back action
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)levelButtonTapped: (id)sender
{
    if (![sender isKindOfClass: [UIButton class]]) {
        return;
    }
    UIButton* button = (UIButton*)sender;
    CFGameViewController* viewController = [self.storyboard
                                            instantiateViewControllerWithIdentifier: @"gameViewController"];
    viewController.levelNumber = button.tag;
    [self.navigationController pushViewController: viewController animated: YES];
}
@end
