//
//  RegisterViewModel.h
//  Lesson1
//
//  Created by Gena on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterViewModel : NSObject

@property (strong, nonatomic, readonly) NSString *code;

- (NSString *)generateCode;

@end
