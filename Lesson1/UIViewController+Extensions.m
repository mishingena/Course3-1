//
//  ExtendedViewController.m
//  Lesson1
//
//  Created by Azat Almeev on 21.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "UIViewController+Extensions.h"
#import <objc/runtime.h>

static void *KeyboardSignalKey = &KeyboardSignalKey;

@implementation UIViewController (Extensions)

- (void)showError:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

@implementation UIViewController (Keyboard)

@dynamic keyboardSignal;

- (RACSignal *)keyboardSignal {
    RACSignal *signal = objc_getAssociatedObject(self, KeyboardSignalKey);
    if (signal == nil) {
        signal = [[[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] merge:[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil]] map:^id(NSNotification *note) {
                id kbSize = note.userInfo[UIKeyboardFrameEndUserInfoKey];
                CGFloat kbHeight = [note.name isEqualToString:UIKeyboardWillShowNotification] ? [kbSize CGRectValue].size.height : 0;
                return @(kbHeight);
            }];
        objc_setAssociatedObject(self, KeyboardSignalKey, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return signal;
}

@end
