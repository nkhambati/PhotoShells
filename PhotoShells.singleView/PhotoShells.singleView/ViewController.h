//
//  ViewController.h
//  PhotoShells.singleView
//
//  Created by Vrinda Vaish on 2013-01-23.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

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
