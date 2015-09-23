//
//  KeyboardViewController.h
//  Lesson1
//
//  Created by Azat Almeev on 20.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa.h>
#import "UIViewController+Extensions.h"

@interface KeyboardViewController : UIViewController
@property (nonatomic, strong) RACSignal *keyboardSignal;
@end
