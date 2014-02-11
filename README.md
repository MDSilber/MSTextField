MSTextField
===========

MSTextField is a UITextField subclass that allows developers to pass in custom formatting and verification blocks as instance variables. It has a minimum length to verify parameter (so that your text field doesn't try to verify blank input) and max length parameter (to prevent a user from inputting something longer than desired). You may also set the validation image and the invalid input warning border color to be whatever you want (the defaults are a green checkmark and a darkish red respectively).

To use it, simply add `pod 'MSTextField'` to your podfile and run `pod install`. You can also just download the source and add it to your project.

Note: If you don't have CocoaPods integrated in your projects, you can find out how to add it at http://www.cocoapods.org

Here's an example of how it's used, taken from one of the factory methods that creates a text field to handle dates (month and day only):

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
        return NSLocationInRange([[text substringToIndex:2] intValue], NSMakeRange(1, 12));
    };

As seen above, the formatting block automatically adds a slash after the second character is typed, and the verification block checks to make sure that the string is the correct length and that the month component is a valid month. 

Additionally, with MSTextField comes a "subclass" of UITextFieldDelegate called MSTextFieldDelegate, which provides to additional optional delegate methods that you can implement:

    - (void)textFieldReceivedValidInput:(MSTextField *)textField;
    - (void)textFieldReceivedInvalidInput:(MSTextField *)textField;

It's that simple! MSTextField comes with class methods that generate date fields (like the one above), phone number fields, email address fields, and credit card fields. However, you can always create your own and use those methods as examples.

In the example folder is a very simple app with a UISegmentedControl which allows you to toggle between different example fields to play with. If you have any questions, feel free to email me at mdsilber1@gmail.com. Good luck!
