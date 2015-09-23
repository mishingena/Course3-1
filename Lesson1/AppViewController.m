//
//  AppViewController.m
//  Lesson1
//
//  Created by Azat Almeev on 21.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "AppViewController.h"
#import <ReactiveCocoa.h>
#import <KVOMutableArray+ReactiveCocoaSupport.h>
#import <BlocksKit+UIKit.h>

@interface AppViewController ()
@property (nonatomic, readonly) KVOMutableArray *items;
@end

@implementation AppViewController
@synthesize items = _items;

- (KVOMutableArray *)items {
    if (!_items) {
        _items = [KVOMutableArray new];
        @weakify(self);
        [_items.changeSignal subscribeNext:^(RACTuple *tuple) {
            @strongify(self);
            self.title = [NSString stringWithFormat:@"Items count: %@", @([tuple.first count])];
            NSKeyValueChange change = [tuple.second[NSKeyValueChangeKindKey] integerValue];
            NSArray *indices = [tuple.second[NSKeyValueChangeIndexesKey] bk_mapIndex:^id(NSUInteger index) {
                return [NSIndexPath indexPathForItem:index inSection:0];
            }];
            switch (change) {
                case NSKeyValueChangeInsertion:
                    [self.tableView insertRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                case NSKeyValueChangeRemoval:
                    [self.tableView deleteRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                case NSKeyValueChangeReplacement:
                    [self.tableView reloadRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                default:
                    [self.tableView reloadData];
                    break;
            }
        }];
    }
    return _items;
}

- (IBAction)logoutDidPress:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonDidPress:(id)sender {
    [self.items addObject:@(self.items.count)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.items[indexPath.row]];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.items removeObjectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *number = self.items[indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change value" message:[NSString stringWithFormat:@"Enter new value for %@", number] preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *wAlert = alert;
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *input = wAlert.textFields.firstObject;
        NSNumber *value = @([input.text integerValue]);
        [self.items replaceObjectAtIndex:indexPath.row withObject:value];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"%@ deallocated", NSStringFromClass([self class]));
}

@end
