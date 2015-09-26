//
//  StoreManager.m
//  Lesson1
//
//  Created by Gena on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "StoreManager.h"
#import "Item.h"

@interface StoreManager ()

@property (strong, nonatomic, readwrite) KVOMutableArray *items;

@end

@implementation StoreManager

+ (instancetype)sharedInstance {
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [KVOMutableArray new];
    }
    return self;
}

- (Item *)itemAtIndex:(NSInteger)index {
    return self.items[index];
}

- (void)saveItem:(Item *)item atIndex:(NSInteger)index {
    self.items[index] = item;
}

- (void)addItem:(Item *)item {
    [self.items addObject:item];
}

- (void)deleteItemAtIndex:(NSInteger)index {
    [self.items removeObjectAtIndex:index];
}

@end
