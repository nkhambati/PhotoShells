#import <UIKit/UIKit.h>
#import "PictureManager.h"
#import "OCR.h"

@interface ViewController : UIViewController
{
    NSArray *imgArray;
    PictureManager *picManager;

    IBOutlet UIButton *getPics;
}

@property (nonatomic, retain)UIButton *getPics;

-(IBAction)categorizeClicked:(id)sender;
-(void)runOCR;

//UI buttons - Vrinda
- (IBAction)imageProcessing:(id)sender;
- (IBAction)folderSettings:(id)sender;
- (IBAction)categorisationLogs:(id)sender;
- (IBAction)appSwitch:(id)sender;


@end
