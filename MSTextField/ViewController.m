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
    
    MSTextField *textField = [[MSTextField alloc] initWithFrame:CGRectMake(0, 50, 0, 0)];
    textField.placeholder = @"Placeholder";
    // Date field test
    /*textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.formattingBlock = ^(MSTextField *textField, char newCharacter) {
        if ([textField.text length] > 5) {
            textField.text = [textField.text substringToIndex:([textField.text length] -1)];
        }
        if (newCharacter == '\b') {
            if ([textField.text length] == 4) {
                textField.text = [textField.text substringToIndex:2];
            }
        } else {
            if ([textField.text length] == 2) {
                textField.text = [NSString stringWithFormat:@"%@/", textField.text];
            }
        }
    };*/
    [self.view addSubview:textField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
