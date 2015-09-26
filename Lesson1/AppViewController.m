//
//  AppViewController.m
//  Lesson1
//
//  Created by Azat Almeev on 21.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "AppViewController.h"
#import <ReactiveCocoa.h>
#import <BlocksKit+UIKit.h>
#import "EditViewController.h"
#import "StoreManager.h"
#import "Item.h"

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    [[StoreManager sharedInstance].items.changeSignal subscribeNext:^(RACTuple *tuple) {
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

- (IBAction)logoutDidPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonDidPress:(id)sender {
    [self performSegueWithIdentifier:@"edit" sender:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [StoreManager sharedInstance].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    Item *item = [[StoreManager sharedInstance] itemAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", item.number];
    cell.detailTextLabel.text = item.text;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[StoreManager sharedInstance] deleteItemAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"edit" sender:indexPath];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"edit"]) {
        EditViewController *vc = segue.destinationViewController;
        if (sender) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            vc.isNewElement = NO;
            vc.index = indexPath.row;
        } else {
            vc.isNewElement = YES;
        }
    }
}

@end
