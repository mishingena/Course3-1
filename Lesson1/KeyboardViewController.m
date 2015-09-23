//
//  KeyboardViewController.m
//  Lesson1
//
//  Created by Azat Almeev on 20.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()

@end

@implementation KeyboardViewController
@synthesize keyboardSignal = _keyboardSignal;

- (RACSignal *)keyboardSignal {
    if (!_keyboardSignal)
        _keyboardSignal = [[[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] merge:[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil]] map:^id(NSNotification *note) {
            id kbSize = note.userInfo[UIKeyboardFrameEndUserInfoKey];
            CGFloat kbHeight = [note.name isEqualToString:UIKeyboardWillShowNotification] ? [kbSize CGRectValue].size.height : 0;
            return @(kbHeight);
        }];
    return _keyboardSignal;
}

- (void)dealloc {
    NSLog(@"%@ deallocated", NSStringFromClass([self class]));
}

@end
