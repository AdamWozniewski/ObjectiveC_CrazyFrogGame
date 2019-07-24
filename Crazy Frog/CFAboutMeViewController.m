//#import <iAd/iAd.h>
#import "CFAboutMeViewController.h"

@implementation CFAboutMeViewController
- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *)nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {}
    return self;
}
- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
}
@end
