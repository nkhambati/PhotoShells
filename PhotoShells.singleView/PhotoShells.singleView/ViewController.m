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
    [self runOCR];
}

-(void)runOCR
{
    NSLog(@"IN runOCR");

    imgArray = [picManager getUIImage];
    OCR *ocr = [[OCR alloc] init];
    NSString *extractedText = [[NSString alloc] init];
    extractedText = [ocr extractText:imgArray];
}

- (IBAction)imageProcessing:(id)sender {
}

- (IBAction)folderSettings:(id)sender {
}

- (IBAction)categorisationLogs:(id)sender {
}

- (IBAction)appSwitch:(id)sender {
}

@end
