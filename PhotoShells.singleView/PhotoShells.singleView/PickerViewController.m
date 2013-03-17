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
    _inputArray = [[NSArray alloc] initWithObjects:@"Daily", @"Hourly", @"Weekly", @"Biweekly", @"Monthly", nil];
    
    
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
    //Add code here to respond to the selected value in the pickerView
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
