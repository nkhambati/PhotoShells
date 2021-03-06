#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
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
- (IBAction)appSwitch:(UISwitch *)sender;


-(IBAction)categorizeClicked:(id)sender;

@end

