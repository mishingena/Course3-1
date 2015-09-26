//
//  RegisterViewModel.m
//  Lesson1
//
//  Created by Gena on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "RegisterViewModel.h"

static int const MaxValue = 1001;

@interface RegisterViewModel ()

@property (strong, nonatomic, readwrite) NSString *code;

@end

@implementation RegisterViewModel

- (NSString *)generateCode {
    int value = arc4random_uniform(MaxValue);
    self.code = [@(value) stringValue];
    return self.code;
}

- (NSString *)code {
    if (!_code) {
        [self generateCode];
    }
    return _code;
}

@end
