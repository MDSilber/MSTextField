//
//  ThirstieTextField.h
//  Thirstie
//
//  Created by Mason Silber on 8/14/13.
//  Copyright (c) 2013 Digital-Liquor-Delivery. All rights reserved.
//

@class MSTextField;

@protocol MSTextFieldDelegate <UITextFieldDelegate>
@optional
- (void)textFieldReceivedValidInput:(MSTextField *)textField;
- (void)textFieldReceivedInvalidInput:(MSTextField *)textField;
@end


typedef BOOL(^TextFieldVerificationBlock)(NSString *text);
typedef void(^TextFieldFormattingBlock)(MSTextField *textField, char newCharacter);

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#import <UIKit/UIKit.h>

@interface MSTextField : UITextField
@property (nonatomic, weak) id<MSTextFieldDelegate> delegate;
@property (nonatomic, copy) TextFieldFormattingBlock formattingBlock;
@property (nonatomic, copy) TextFieldVerificationBlock verificationBlock;
@property (nonatomic) NSInteger minimumLengthToVerify;
@property (nonatomic) NSInteger maxLengthOfInput;

+ (MSTextField *)phoneNumberFieldWithFrame:(CGRect)frame;
+ (MSTextField *)emailAddressFieldWithFrame:(CGRect)frame;
+ (MSTextField *)creditCardNumberFieldWithFrame:(CGRect)frame;
+ (MSTextField *)dateFieldWithFrame:(CGRect)frame;


@end
