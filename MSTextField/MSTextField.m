//
//  MSTextfield.m
//  Thirstie
//
//  Created by Mason Silber on 2/8/14.
//  Copyright (c) 2014 Mason Silber. All rights reserved.
//

#import "MSTextField.h"
#import <QuartzCore/QuartzCore.h>

#define MINIMUM_EMAIL_LENGTH_TO_VERIFY 7
#define MAX_PHONE_NUMBER_LENGTH 14
#define kMagicSubtractionNumber 48

#define AMEX_IMAGE [UIImage imageNamed:@"amex"]
#define DISCOVER_IMAGE [UIImage imageNamed:@"discover"]
#define MASTERCARD_IMAGE [UIImage imageNamed:@"mastercard"]
#define VISA_IMAGE [UIImage imageNamed:@"visa"]

@interface MSTextField  ()

@property (nonatomic) NSString *textFieldString;
@property (nonatomic) UIImageView *validInputImageView;
@property (nonatomic, readwrite) InputState inputState;

+(UIView *)paddingView;

@end

@implementation MSTextField

#pragma mark - Factory methods

+ (MSTextField *)phoneNumberFieldWithFrame:(CGRect)frame
{
    MSTextField *phoneNumberField = [[MSTextField alloc] initWithFrame:frame];
    phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberField.placeholder = @"Phone number";
    phoneNumberField.maxLengthOfInput = MAX_PHONE_NUMBER_LENGTH;
    phoneNumberField.formattingBlock = ^(MSTextField *textField, char newCharacter) {
        if (newCharacter == '\b') {
            if (textField.text.length == 1) {
                textField.text = @"";
            } else if (textField.text.length == 5) {
                textField.text = [textField.text substringToIndex:(textField.text.length - 2)];
            } else if (textField.text.length == 9) {
                textField.text = [textField.text substringToIndex:(textField.text.length - 1)];
            }
        } else {
            if (textField.text.length == 1) {
                textField.text = [NSString stringWithFormat:@"(%@", textField.text];
            } else if (textField.text.length == 4) {
                textField.text = [NSString stringWithFormat:@"%@) ", textField.text];
            } else if (textField.text.length == 9) {
                textField.text = [NSString stringWithFormat:@"%@-", textField.text];
            }
        }
    };
    phoneNumberField.verificationBlock = ^BOOL(NSString *text) {
        NSString *unformattedPhoneNumber = [[text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        return [unformattedPhoneNumber length] == 10 && [unformattedPhoneNumber rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet] options:0].location == NSNotFound;
    };
    return phoneNumberField;
}

+ (MSTextField *)emailAddressFieldWithFrame:(CGRect)frame
{
    MSTextField *emailField = [[MSTextField alloc] initWithFrame:frame];
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.placeholder = @"Email address";
    emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailField.minimumLengthToVerify = MINIMUM_EMAIL_LENGTH_TO_VERIFY;
    emailField.verificationBlock = ^BOOL(NSString *text) {
        NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
        NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger regExMatches = [regEx numberOfMatchesInString:text options:0 range:NSMakeRange(0, [text length])];
        if (regExMatches == 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    };
    return emailField;
}

+ (MSTextField *)creditCardNumberFieldWithFrame:(CGRect)frame
{
    MSTextField *creditCardField = [[MSTextField alloc] initWithFrame:frame];
    creditCardField.keyboardType = UIKeyboardTypeNumberPad;
    creditCardField.placeholder = @"Credit card number";
    creditCardField.maxLengthOfInput = 19;
    creditCardField.formattingBlock = ^(MSTextField *textField, char newCharacter) {
        if ([textField.text length] == 0) {
            return;
        }
        switch ([textField.text characterAtIndex:0]) {
            case '3':
                textField.validInputImage = [UIImage imageNamed:@"amex"];
                break;
            case '4':
                textField.validInputImage = [UIImage imageNamed:@"visa"];
                break;
            case '5':
                textField.validInputImage = [UIImage imageNamed:@"mastercard"];
                break;
            case '6':
                textField.validInputImage = [UIImage imageNamed:@"discover"];
                break;
            default:
                break;
        }
        if (newCharacter == '\b') {
            //American express
            if ([textField.text characterAtIndex:0] == '3') {
                if ([textField.text length] == 6 || [textField.text length] == 13) {
                    textField.text = [textField.text substringToIndex:(textField.text.length - 2)];
                }
            } else {
                if ([textField.text length] == 6 || [textField.text length] == 11 || [textField.text length] == 16) {
                    textField.text = [textField.text substringToIndex:(textField.text.length - 2)];
                }
            }
        } else {
            //American express
            if ([textField.text characterAtIndex:0] == '3') {
                if ([textField.text length] == 4 || [textField.text length] == 11) {
                    textField.text = [NSString stringWithFormat:@"%@-", textField.text];
                }
            } else {
                if ([textField.text length] == 4 || [textField.text length] == 9 || [textField.text length] == 14) {
                    textField.text = [NSString stringWithFormat:@"%@-", textField.text];
                }
            }
        }
    };
    creditCardField.verificationBlock = ^BOOL(NSString *text) {
        NSString *cardNumber = [[text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        int luhnNumber = 0;
        
		// I'm running through my string backwards
        for (int i=0; i<[cardNumber length]; i++) {
            NSUInteger count = [cardNumber length]-1; // Prevents Bounds Error and makes characterAtIndex easier to read
			int doubled = [[NSNumber numberWithUnsignedChar:[cardNumber characterAtIndex:count-i]] intValue] - kMagicSubtractionNumber;
            if (i % 2) {
                doubled = doubled*2;
            }
            
			NSString *double_digit = [NSString stringWithFormat:@"%d",doubled];
            
            if ([[NSString stringWithFormat:@"%d",doubled] length] > 1) {   luhnNumber = luhnNumber + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:0]] intValue]-kMagicSubtractionNumber;
                luhnNumber = luhnNumber + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:1]] intValue]-kMagicSubtractionNumber;
            } else {
                luhnNumber = luhnNumber + doubled;
            }
        }
        
        if (luhnNumber%10 == 0) {
            return YES;
        } else {
            return NO;
        }
    };
    return creditCardField;
}

+ (MSTextField *)dateFieldWithFrame:(CGRect)frame
{
    MSTextField *dateField = [[MSTextField alloc] initWithFrame:frame];
    dateField.placeholder = @"Enter date";
    dateField.keyboardType = UIKeyboardTypeNumberPad;
    dateField.maxLengthOfInput = 5;
    dateField.formattingBlock = ^(MSTextField *textField, char newCharacter) {
        if (newCharacter == '\b') {
            if ([textField.text length] == 3) {
                textField.text = [textField.text substringToIndex:2];
            }
        } else {
            if ([textField.text length] == 2) {
                textField.text = [NSString stringWithFormat:@"%@/", textField.text];
            }
        }
    };
    dateField.verificationBlock = ^BOOL(NSString *text) {
        
        if ([text length] != 5) {
            return NO;
        }
        return NSLocationInRange([[text substringToIndex:2] intValue], NSMakeRange(0, 12));
    };
    return dateField;
}

#pragma mark - Class and instance methods

+(UIView *)paddingView
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    return paddingView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(10, frame.origin.y, 300, 50);
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:UIColorFromRGB(0xdedede)];
        [self setTextColor:[UIColor blackColor]];
        [self setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]];
        [self setClearButtonMode:UITextFieldViewModeWhileEditing];
        [[self layer] setCornerRadius:3.5f];
        [self setLeftView:[MSTextField paddingView]];
        [self setLeftViewMode:UITextFieldViewModeAlways];
        [self setTextAlignment:NSTextAlignmentLeft];
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        self.invalidInputBorderColor = UIColorFromRGB(0xB50000);
        self.inputState = MSTextFieldUnknownInput;
        self.minimumLengthToVerify = 1;
        self.maxLengthOfInput = MAX_INPUT;

        self.validInputImage = [UIImage imageNamed:@"green-checkmark"];
        self.validInputImageView = [[UIImageView alloc] initWithImage:_validInputImage];
        self.validInputImageView.frame = CGRectMake(self.frame.size.width - _validInputImage.size.width - 10, floorf((self.frame.size.height - _validInputImage.size.height)/2.0f), _validInputImage.size.width, _validInputImage.size.height);
        self.validInputImageView.hidden = YES;
        [self addSubview:self.validInputImageView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)drawPlaceholderInRect:(CGRect)rect
{
    if (IS_IOS7) {
        CGSize placeHolderSize = [self.placeholder boundingRectWithSize:self.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12.0f]} context:nil].size;
        rect.origin.y = (self.frame.size.height - placeHolderSize.height)/2;
        rect.size.height = placeHolderSize.height;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    [self.placeholder drawInRect:rect withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:12.0f], NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: UIColorFromRGB(0x787878)}];
}

- (void)setInputState:(InputState)inputState
{
    if (self.inputState == inputState) {
        return;
    }
    _inputState = inputState;
    if (_inputState == MSTextFieldInvalidInput) {
        self.layer.borderWidth = 2.0f;
        self.validInputImageView.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(textFieldReceivedInvalidInput:)]) {
            [self.delegate textFieldReceivedInvalidInput:self];
        }
    } else {
        self.layer.borderWidth = 0.0f;
        if (_inputState == MSTextFieldValidInput) {
            self.validInputImageView.hidden = NO;
            if ([self.delegate respondsToSelector:@selector(textFieldReceivedValidInput:)]) {
                [self.delegate textFieldReceivedValidInput:self];
            }
        } else {
            self.validInputImageView.hidden = YES;
        }
    }
}

- (void)setValidInputImage:(UIImage *)validInputImage
{
    if (_validInputImage != validInputImage) {
        _validInputImage = validInputImage;
        _validInputImageView.image = _validInputImage;
        _validInputImageView.frame = CGRectMake(self.frame.size.width - _validInputImage.size.width - 10, floorf((self.frame.size.height - _validInputImage.size.height)/2.0f), _validInputImage.size.width, _validInputImage.size.height);
    }
}

- (void)setInvalidInputBorderColor:(UIColor *)invalidInputBorderColor
{
    if (_invalidInputBorderColor != invalidInputBorderColor) {
        _invalidInputBorderColor = invalidInputBorderColor;
        self.layer.borderColor = invalidInputBorderColor.CGColor;
    }
}

#pragma mark - Text field handling methods

- (void)textDidChange:(NSNotification *)notification
{
    if ([((UITextField *)(notification.object)).text length] > self.maxLengthOfInput) {
        ((UITextField *)(notification.object)).text = self.textFieldString;
    } else {
        char newCharacter = ([self.text length] > [self.textFieldString length]) ? [self.text characterAtIndex:([self.text length] -1)] : '\b';
        if (_formattingBlock) {
            _formattingBlock(self, newCharacter);
        }
        self.textFieldString = ((UITextField *)(notification.object)).text;
    }
}

- (BOOL)becomeFirstResponder
{
    self.inputState = MSTextFieldUnknownInput;
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    if (_verificationBlock && [self.text length] >= self.minimumLengthToVerify) {
        if (_verificationBlock(self.text)) {
            self.inputState = MSTextFieldValidInput;
        } else {
            self.inputState = MSTextFieldInvalidInput;
        }
    }
    return [super resignFirstResponder];
}

@end
