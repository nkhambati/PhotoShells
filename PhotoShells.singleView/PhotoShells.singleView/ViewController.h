#import <UIKit/UIKit.h>
#import "PictureManager.h"
#import "OCR.h"
#import "CategorizationSettings.h"

@interface ViewController : UIViewController
{
    NSArray *imgArray;
    PictureManager *picManager;
    CategorizationSettings *catSettings;
    NSTimer *timer;
    
    //IBOutlet UIButton *getPics;
    
}

@property (nonatomic, retain)UIButton *getPics;

//Home Page UI buttons
- (IBAction)imageProcessing:(id)sender;
- (IBAction)folderSettings:(id)sender;
- (IBAction)categorisationLogs:(id)sender;
- (IBAction)appSwitch:(UISwitch *)sender;

//Image Categorization
-(IBAction)selected;


-(IBAction)categorizeClicked:(id)sender;

@end

