//
//  Item.m
//  Lesson1
//
//  Created by Gena on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "Item.h"

@implementation Item

- (instancetype)initWithNumber:(NSInteger)number text:(NSString *)text {
    self = [super init];
    if (self) {
        _number = number;
        _text = text;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    Item *item = [[[self class] allocWithZone:zone] init];
    item->_number = _number;
    item->_text = [_text copyWithZone:zone];
    return item;
}

@end
