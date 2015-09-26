//
//  NetManager.m
//  Lesson1
//
//  Created by Azat Almeev on 21.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "NetManager.h"

@implementation NetManager

+ (instancetype)sharedInstance {
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[self alloc] initSingleton];
    });
    return _singleton;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"You could not create an instance of this class" reason:@"This class is designed under the singleton pattern" userInfo:nil];
}

- (instancetype)initSingleton {
    self = [super init];
    if (!self)
        return nil;
    return self;
}

- (RACSignal *)signInWithLogin:(NSString *)login andPassword:(NSString *)password {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if ([login isEqualToString:@"login"] && [password isEqualToString:@"pwd"])
            [subscriber sendCompleted];
        else
            [subscriber sendError:[NSError errorWithDomain:@"Lesson1.NetManager" code:401 userInfo:@{ NSLocalizedDescriptionKey : @"Cannot let you in" }]];
        return nil;
    }];
}

- (RACSignal *)registerWithLogin:(NSString *)login password:(NSString *)password confiramtion:(NSString *)confirmation {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (login.length > 4  && password.length > 2 && [password isEqualToString:confirmation])
            [subscriber sendCompleted];
        else {
            if (![password isEqualToString:confirmation]) {
                [subscriber sendError:[NSError errorWithDomain:@"Lesson1.NetManager" code:401 userInfo:@{ NSLocalizedDescriptionKey : @"Password and confiramtion are not equal"}]];
            } else {
                [subscriber sendError:[NSError errorWithDomain:@"Lesson1.NetManager" code:401 userInfo:@{ NSLocalizedDescriptionKey : @"Invalid registration credetionals" }]];
            }
        }
        return nil;
    }];
}

@end
