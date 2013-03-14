#import "ViewController.h"

//@interface ViewController ()

//@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)categorizeClicked:(id)sender
{
    picManager = [[PictureManager alloc] init];
    [picManager fetchPictures];
}

- (IBAction)imageProcessing:(id)sender {
}

- (IBAction)folderSettings:(id)sender {
}

- (IBAction)categorisationLogs:(id)sender {
}

- (IBAction)appSwitch:(id)sender
{
    // Once app is turned on, sets to default settings.
    
    // Categorization frequency is set to daily
    catSettings = [[CategorizationSettings alloc] init];
    [catSettings setSeconds:(24)];
}

@end

