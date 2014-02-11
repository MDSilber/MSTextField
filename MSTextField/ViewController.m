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
@property (nonatomic) MSTextField *currentTextField;
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

    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Phone", @"CC", @"Email", @"Date"]];
    segmentedControl.frame = CGRectMake(10, 30, 300, 35);
    [segmentedControl addTarget:self action:@selector(_toggleFieldType:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    [self _toggleFieldType:segmentedControl];
    [self.view addSubview:segmentedControl];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(_dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)_toggleFieldType:(UISegmentedControl *)sender
{
    [self _dismissKeyboard];
    [self.currentTextField removeFromSuperview];

    CGRect frame = CGRectMake(0, 100, 0, 0);
    switch (sender.selectedSegmentIndex) {
        case 0: {
            MSTextField *phoneNumberField = [MSTextField phoneNumberFieldWithFrame:frame];
            self.currentTextField = phoneNumberField;
            [self.view addSubview:phoneNumberField];
            break;
        }
        case 1: {
            MSTextField *creditCardField = [MSTextField creditCardNumberFieldWithFrame:frame];
            self.currentTextField = creditCardField;
            [self.view addSubview:creditCardField];
            break;
        }
        case 2: {
            MSTextField *emailField = [MSTextField emailAddressFieldWithFrame:frame];
            self.currentTextField = emailField;
            [self.view addSubview:emailField];
            break;
        }
        case 3: {
            MSTextField *dateField = [MSTextField dateFieldWithFrame:frame];
            self.currentTextField = dateField;
            [self.view addSubview:dateField];
            break;
        }
        default:
            break;
    }
}

- (void)_dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
