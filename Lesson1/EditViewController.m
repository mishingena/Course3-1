//
//  EditViewController.m
//  Lesson1
//
//  Created by Gena on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "EditViewController.h"
#import "StoreManager.h"
#import "Item.h"
#import <ReactiveCocoa.h>

static NSInteger const DefaultNumber = 0;
static float const MaxSliderValue = 20.0;

@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Item *item;
    
    if (self.isNewElement) {
        item = [[Item alloc] initWithNumber:DefaultNumber text:@""];
    } else {
        item = [[StoreManager sharedInstance] itemAtIndex:self.index];
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld", item.number];
    float value = item.number / MaxSliderValue;
    [self.slider setValue:value];
    self.textField.text = item.text;
    
    @weakify(self);
    [[self.slider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISlider *slider) {
        @strongify(self);
        item.number = slider.value * MaxSliderValue;
        self.countLabel.text = [NSString stringWithFormat:@"%ld", item.number];
    }];
    
    RAC(self.saveButton, enabled) = [RACSignal combineLatest:@[self.textField.rac_textSignal, RACObserve(item, number)] reduce:^id(NSString *text, NSNumber *number){
        NSInteger value = [number integerValue];
        return @(text.length == value);
    }];
    
    [[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        item.text = self.textField.text;
        
        if (self.isNewElement) {
            [[StoreManager sharedInstance] addItem:item];
        } else {
            [[StoreManager sharedInstance] saveItem:item atIndex:self.index];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}



@end
