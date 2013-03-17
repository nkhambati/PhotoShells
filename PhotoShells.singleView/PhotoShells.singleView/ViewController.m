#import "ViewController.h"

//@interface ViewController ()

//@end

@implementation ViewController

@synthesize getPics = _getPicks;
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

- (IBAction)appSwitch:(UISwitch *)sender
{
    if([sender isOn])
    {
        // Once app is turned on, sets to default settings.
    
        // Categorization frequency is set to daily
        catSettings = [[CategorizationSettings alloc] init];
        [catSettings setSeconds:(24)];
    
        // Timer is scheduled to run 'fetchPictures' at the specified interval
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                    target:self
                                                    selector:@selector(runFetchPictures)
                                                    userInfo:nil repeats:YES];
    }
    else
    {
        // Stopping timer. Pictures will no longer be fetched.
        [timer invalidate];
    }

}

-(void)runFetchPictures
{
    picManager = [[PictureManager alloc] init];
    [picManager fetchPictures];
}

@end

