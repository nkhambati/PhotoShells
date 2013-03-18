//
//  PickerViewController.h
//  PhotoShells.singleView
//
//  Created by Vrinda Vaish on 2013-03-14.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategorizationSettings.h"
#import "PictureManager.h"

@interface PickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    IBOutlet UIPickerView *picker;
    NSArray *inputArray;
    
}

@property (strong, nonatomic) IBOutlet UIView *picker;
@property(strong, nonatomic) NSArray *inputArray;
@end
