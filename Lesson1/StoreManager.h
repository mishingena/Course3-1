//
//  StoreManager.h
//  Lesson1
//
//  Created by Gena on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KVOMutableArray+ReactiveCocoaSupport.h>

@class Item;

@interface StoreManager : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic, readonly) KVOMutableArray *items;

- (Item *)itemAtIndex:(NSInteger)index;
- (void)saveItem:(Item *)item atIndex:(NSInteger)index;
- (void)addItem:(Item *)item;
- (void)deleteItemAtIndex:(NSInteger)index;

@end
