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

@end
