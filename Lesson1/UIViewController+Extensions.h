//
//  ExtendedViewController.h
//  Lesson1
//
//  Created by Azat Almeev on 21.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa.h>

@interface UIViewController (Extensions)

- (void)showError:(NSString *)message;

@end

@interface UIViewController (Keyboard)

@property (nonatomic, strong) RACSignal *keyboardSignal;

@end
