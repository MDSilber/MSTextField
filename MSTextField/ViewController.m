//
//  ViewController.m
//  MSTextField
//
//  Created by Mason Silber on 2/8/14.
//  Copyright (c) 2014 MasonSilber. All rights reserved.
//

#import "ViewController.h"
#import "MSTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor darkTextColor];
    
    MSTextField *textField = [MSTextField emailAddressFieldWithFrame:CGRectMake(0, 50, 0, 0)];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:textField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
