//
//  NetManager.h
//  Lesson1
//
//  Created by Azat Almeev on 21.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface NetManager : NSObject

+ (NetManager *)sharedInstance;
- (RACSignal *)signInWithLogin:(NSString *)login andPassword:(NSString *)password;
- (RACSignal *)registerWithLogin:(NSString *)login password:(NSString *)password confiramtion:(NSString *)confirmation;

@end
