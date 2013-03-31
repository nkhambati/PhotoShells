//
//  PickerViewController.m
//  PhotoShells.singleView
//
//  Created by Vrinda Vaish on 2013-03-14.
//  Copyright (c) 2013 Vrinda Vaish. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()

@end


@implementation PickerViewController
@synthesize picker;
@synthesize inputArray = _inputArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {   
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //picker = [[UIPickerView alloc] init; // initWithFrame:CGRectMake(100, 2, 320, 200)];
    _inputArray = [[NSArray alloc] initWithObjects:@"Single", @"Hourly", @"Daily", @"Weekly", nil];
    
    
    picker.delegate = self;
    picker.dataSource = self;
	picker.showsSelectionIndicator = YES;
    
    [self.view addSubview:picker];
}

//******************************************
//Implementing required dataSource functions
//******************************************

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _inputArray.count;
}


//*************************
//Adding delegate methods
//*************************

//Adding data to the pickerView

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_inputArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // Change Categorization Settings according to row picked.
    if(row == 0) //hourly
    {
        [[CategorizationSettings sharedCatSettings] setSeconds:(1)];
    }
    else if(row == 1) //daily
    {
        [[CategorizationSettings sharedCatSettings] setSeconds:(24)];
    }
    else if(row == 2)//weekly
    {
        [[CategorizationSettings sharedCatSettings] setSeconds:(168)];
    }
    else
    {
        NSLog(@"Row is nil");
    }
    
    //TO DO: Uncomment later.
    //[[PictureManager sharedPicManager] invalidateTimer];
    //[[PictureManager sharedPicManager] setTimer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
