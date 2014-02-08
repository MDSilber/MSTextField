//
//  ThirstieTextField.h
//  Thirstie
//
//  Created by Mason Silber on 8/14/13.
//  Copyright (c) 2013 Digital-Liquor-Delivery. All rights reserved.
//

@class MSTextField;

typedef enum InputState {
    ThirstieTextFieldInvalidInput = 0,
    ThirstieTextFieldUnknownInput = 1,
    ThirstieTextFieldValidInput = 2
} InputState;

typedef BOOL(^VerificationBlock)(void);
typedef void(^FormattingBlock)(MSTextField *textField);

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#import <UIKit/UIKit.h>

@interface MSTextField : UITextField
@property (nonatomic) BOOL isValid;
@property (nonatomic) InputState inputState;
@property (nonatomic, copy) FormattingBlock formattingBlock;
@property (nonatomic, copy) VerificationBlock verificationBlock;
@end
