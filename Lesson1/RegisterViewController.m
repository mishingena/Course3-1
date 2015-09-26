//
//  RegisterViewController.m
//  Lesson1
//
//  Created by Gena on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterViewModel.h"
#import "UIViewController+Extensions.h"
#import "NetManager.h"
#import "AppDelegate.h"

@interface RegisterViewController ()

@property (strong, nonatomic) RegisterViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [RegisterViewModel new];
    self.navigationItem.title = @"Registration";
    self.scrollView.scrollEnabled = NO;
    
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    @weakify(self);
    [[self.refreshButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self setUpCode];
    }];
    
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.keyboardSignal subscribeNext:^(NSNumber *x) {
        @strongify(self);
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height, 0.0, [x floatValue], 0.0);
        self.scrollView.scrollEnabled = [x intValue] > 0;
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];
    
    RAC(self.registerButton, enabled) = [RACSignal combineLatest:@[self.loginTextField.rac_textSignal, self.passwordTextField.rac_textSignal, self.passwordConfirmTextField.rac_textSignal, self.codeTextField.rac_textSignal, RACObserve(self.viewModel, code)] reduce:^(NSString *login, NSString *password, NSString *confiramtion, NSString *code, NSString *validCode){
        return @(login.length > 4 && password.length > 2 && [password isEqualToString:confiramtion] && [code isEqualToString:validCode]);
    }];
    
    [[[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] filter:^BOOL(UIButton *sender) {
        return sender.enabled;
    }] subscribeNext:^(id x) {
        @strongify(self);
        [[[NetManager sharedInstance] registerWithLogin:self.loginTextField.text password:self.passwordTextField.text confiramtion:self.passwordConfirmTextField.text] subscribeError:^(NSError *error) {
            [self showError:error.localizedDescription];
        } completed:^{
            UINavigationController *navController = self.navigationController;
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AppVC"] animated:YES completion:nil];
            [navController popViewControllerAnimated:NO];
        }];
    }];
    
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UITextField *tf = tuple.first;
        if (tf == self.loginTextField) {
            [self.passwordTextField becomeFirstResponder];
        } else if (tf == self.passwordTextField) {
            [self.passwordConfirmTextField becomeFirstResponder];
        } else if (tf == self.passwordConfirmTextField) {
            [self.codeTextField becomeFirstResponder];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpCode];
}

- (void)setUpCode {
    NSString *code = [self.viewModel generateCode];
    self.codeLabel.text = [NSString stringWithFormat:@"Code: %@", code];
}

@end
