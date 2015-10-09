//
//  GCSignUpViewController.m
//  GoldCleats
//
//  Created by Raju Gautam on 9/29/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import "GCSignUpViewController.h"

@interface GCSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *signupView;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (nonatomic, retain) UILabel *warningLabel;

- (IBAction)signupCancelled:(id)sender;
- (IBAction)signupRequested:(id)sender;
@end

@implementation GCSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:self.navView];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:162/255 green:162/255 blue:162/255 alpha:1.0f] CGColor], nil];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    // Do any additional setup after loading the view.
    
    self.emailTF.text = self.emailId;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.emailTF resignFirstResponder];
    [self.usernameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

#pragma mark - TextView delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.emailTF) {
        [self.usernameTF becomeFirstResponder];
        return YES;
    }
    if(textField == self.usernameTF) {
        [self.passwordTF becomeFirstResponder];
        return YES;
    }
    [textField resignFirstResponder];
    return TRUE;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField == self.sEmailField) {
//        self.sResetBtn.hidden = FALSE;
//        [self.signupNext setHidden:FALSE];
//        [self.fbButton setHidden:TRUE];
//    }
//    if (textField == self.lPasswordField) {
//        self.navigationBtn.hidden = FALSE;
//    }
//    return TRUE;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.emailTF) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect =  self.signupView.frame;
        rect.origin.y -= 45.0f;
        self.signupView.frame = rect;
        [UIView commitAnimations];
    } else if (textField == self.usernameTF) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect =  self.signupView.frame;
        rect.origin.y -= 65.0f;
        self.signupView.frame = rect;
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect =  self.signupView.frame;
        rect.origin.y -= 75.0f;
        self.signupView.frame = rect;
        [UIView commitAnimations];

    }
    //    if (textField == self.lPasswordField) {
    //        self.navigationBtn.hidden = FALSE;
    //    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.emailTF) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect =  self.signupView.frame;
        rect.origin.y += 45.0f;
        self.signupView.frame = rect;
        [UIView commitAnimations];
    } else if (textField == self.usernameTF) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect =  self.signupView.frame;
        rect.origin.y += 65.0f;
        self.signupView.frame = rect;
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect =  self.signupView.frame;
        rect.origin.y += 75.0f;
        self.signupView.frame = rect;
        [UIView commitAnimations];
        
    }
    
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}


- (IBAction)signupCancelled:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)signupRequested:(id)sender {
    
    if([self.emailTF.text length] == 0 || [self.usernameTF.text length] == 0 || [self.passwordTF.text length] == 0) {
        [self addWarningLabel];
        [self performSelector:@selector(removeNetworkMessage) withObject:nil afterDelay:3.0];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:TRUE forKey:@"nativeLogin"];
    [defaults setObject:_emailTF.text forKey:@"email"];
    [defaults setObject:_usernameTF.text forKey:@"username"];
    [defaults setObject:_passwordTF.text forKey:@"password"];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KDISMISSVIEW object:nil];
}

- (void)removeNetworkMessage {
    [UIView animateWithDuration:0.5  delay:0 options: UIViewAnimationOptionAllowUserInteraction
                     animations:^  { self.warningLabel.frame = CGRectMake(0, -self.warningLabel.frame.size.height, self.warningLabel.frame.size.width, self.warningLabel.frame.size.height); }
                     completion:^ (BOOL finished) {
                         [self.warningLabel removeFromSuperview];
                     }];
    
}

-(void)addWarningLabel {
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, self.view.bounds.size.width, 44.0)];
    [messageLabel setText:@"Please provide us complete information, somthing is missing."];
    messageLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
    [messageLabel setBackgroundColor:[UIColor colorWithRed:136.0f/255.0f green:167.0f/255.0f blue:57.0f/255.0f alpha:1.0f]];
    [messageLabel setTextColor:[UIColor whiteColor]];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setNumberOfLines:2];
    self.warningLabel = messageLabel;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [self.warningLabel.layer addAnimation:transition forKey:nil];
    
    [self.view addSubview:messageLabel];
    //[self.view bringSubviewToFront:warningLabel];
}

@end
