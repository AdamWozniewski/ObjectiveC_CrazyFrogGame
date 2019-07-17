#import "CFWelcomeViewController.h"

@interface CFWelcomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton* twitterButton;
@property (weak, nonatomic) IBOutlet UIButton* facebookButton;
@property (weak, nonatomic) IBOutlet UIButton* gameCenterButton;
@property (weak, nonatomic) IBOutlet UIButton* volumeButton;

- (IBAction)twitterButtonTapped;
- (IBAction)facebookButtonTapped;
- (IBAction)gameCenterButtonTapped;
- (IBAction)volumeButtonTapped;

@end


@implementation CFWelcomeViewController


- (id)initWithNibName: (NSString*)nibNameOrNil bundle: (NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}


- (void)dealloc
{
}

- (IBAction)twitterButtonTapped
{
}


- (IBAction)facebookButtonTapped
{
}


- (IBAction)gameCenterButtonTapped
{
}


- (IBAction)volumeButtonTapped
{
}
@end
