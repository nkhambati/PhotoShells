#import <UIKit/UIKit.h>
#import "PictureManager.h"

@interface ViewController : UIViewController
{
    NSMutableArray *urlArray;

    IBOutlet UIButton *getPics;
}

@property (nonatomic, retain)UIButton *getPics;

-(IBAction)categorizeClicked:(id)sender;

@end
