#import "ViewController.h"

//@interface ViewController ()

//@end

@implementation ViewController

//@synthesize getPics = _getPicks;
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
    NSLog(@"in categorizeClicked");
    [[PictureManager sharedPicManager] fetchPictures];
    //[[PictureManager sharedPicManager] SaveImage:@"Documents"];
}

- (IBAction)imageProcessing:(id)sender {
}

- (IBAction)folderSettings:(id)sender {
}

- (IBAction)categorisationLogs:(id)sender {
}

- (IBAction)appSwitch:(UISwitch *)sender
{
    if([sender isOn])
    {
        // Once app is turned on, sets to default settings.
    
        // Categorization frequency is set to hourly by default
        [[CategorizationSettings sharedCatSettings] setSeconds:(1)];
    
        // Set timer to run at specified interval in CategorizationSettings
        [[PictureManager sharedPicManager] setTimer];

    }
    else
    {
        // Stopping timer. Pictures will no longer be fetched.
        [[PictureManager sharedPicManager] invalidateTimer];
    }

}

-(void)runFetchPictures
{
    [[PictureManager sharedPicManager] fetchPictures];
}



@end

