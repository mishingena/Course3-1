//
//  ViewController.m
//  Lesson1
//
//  Created by Azat Almeev on 20.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "LoginViewController.h"
#import "NetManager.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vOffsetConstraint;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [self.keyboardSignal subscribeNext:^(NSNumber *x) {
        [UIView animateWithDuration:.3 animations:^{
            @strongify(self);
            self.vOffsetConstraint.constant = [x floatValue] / -2;
            [self.view layoutIfNeeded];
        }];
    }];
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UITextField *tf = tuple.first;
        if (tf == self.loginTextField)
            [self.passwordTextField becomeFirstResponder];
        else {
            [tf resignFirstResponder];
            [self.signInButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }];
    RAC(self.signInButton, enabled) = [RACSignal combineLatest:@[ self.loginTextField.rac_textSignal, self.passwordTextField.rac_textSignal ] reduce:^(NSString *login, NSString *password){
        return @(login.length > 4 && password.length > 2);
    }];
    [[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] filter:^BOOL(UIButton *sender) {
        return sender.enabled;
    }] subscribeNext:^(id x) {
        @strongify(self);
        [[NetManager.sharedInstance signInWithLogin:self.loginTextField.text andPassword:self.passwordTextField.text] subscribeError:^(NSError *error) {
            [self showError:error.localizedDescription];
        } completed:^{
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AppVC"] animated:YES completion:nil];
//            [UIView transitionWithView:self.view.window duration:.6 options:UIViewAnimationOptionTransitionFlipFromRight animations:^(void) {
//                BOOL oldState = [UIView areAnimationsEnabled];
//                [UIView setAnimationsEnabled:NO];
//                [(AppDelegate *)UIApplication.sharedApplication.delegate window].rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AppVC"];
//                [UIView setAnimationsEnabled:oldState];
//            } completion:nil];
        }];
    }];
}

@end
