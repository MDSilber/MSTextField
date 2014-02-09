//
//  ThirstieTextField.h
//  Thirstie
//
//  Created by Mason Silber on 8/14/13.
//  Copyright (c) 2013 Digital-Liquor-Delivery. All rights reserved.
//


@protocol MSTextFieldDelegate <UITextFieldDelegate>
@optional
- (void)textFieldReceivedValidInput;
- (void)textFieldReceivedInvalidInput;
@end

@class MSTextField;

typedef enum InputState {
    MSTextFieldInvalidInput = 0,
    MSTextFieldUnknownInput = 1,
    MSTextFieldValidInput = 2
} InputState;

typedef BOOL(^TextFieldVerificationBlock)(void);
typedef void(^TextFieldFormattingBlock)(MSTextField *textField);

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#import <UIKit/UIKit.h>

@interface MSTextField : UITextField
@property (nonatomic, weak) id<MSTextFieldDelegate> delegate;
@property (nonatomic) InputState inputState;
@property (nonatomic, copy) TextFieldFormattingBlock formattingBlock;
@property (nonatomic, copy) TextFieldVerificationBlock verificationBlock;
@end
