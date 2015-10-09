//
//  GCLoginViewController.m
//  GoldCleats
//
//  Created by Raju Gautam on 27/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import "GCLoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "GCSplashViewController.h"
#import "GCSignUpViewController.h"

@interface GCLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *signUpView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *pointerView;
@property (weak, nonatomic) IBOutlet UITextField *sEmailField;
@property (weak, nonatomic) IBOutlet UITextField *lUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *lPasswordField;
@property (nonatomic, retain) UILabel *warningLabel;
//@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *signupNext;
@property (weak, nonatomic) IBOutlet UIButton *sResetBtn;
@property (weak, nonatomic) IBOutlet UIButton *navigationBtn;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIView *navView;

- (IBAction)resetSignupView:(id)sender;
- (IBAction)signUpBtnPressed:(id)sender;
- (IBAction)processLogin:(id)sender;
- (IBAction)loginBtnPressed:(id)sender;
- (IBAction)fbLoginPressed:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)processSignUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@end

@implementation GCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = TRUE;
    
    
    //self.headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_gradient3"]];
    //self.navigationController.view.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:162/255 green:162/255 blue:162/255 alpha:1.0f] CGColor], nil];
    [self.headerView.layer insertSublayer:gradient atIndex:0];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoginCallback:) name:FBSDKAccessTokenDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissView:) name:KDISMISSVIEW object:nil];
    //[self.view bringSubviewToFront:self.navView];
}

- (void)dismissView:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)facebookLoginCallback:(NSNotification *)userInfo {
    NSLog(@"userInfo %@ and profile %@", userInfo, [FBSDKProfile currentProfile]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.sEmailField resignFirstResponder];
    [self.lUsernameField resignFirstResponder];
    [self.lPasswordField resignFirstResponder];
}

#pragma mark - TextView delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.lUsernameField) {
        [self.lPasswordField becomeFirstResponder];
        return YES;
    }
    [textField resignFirstResponder];
    return TRUE;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.sEmailField) {
        self.sResetBtn.hidden = FALSE;
        [self.signupNext setHidden:FALSE];
        [self.fbButton setHidden:TRUE];
    }
    if (textField == self.lPasswordField) {
        self.navigationBtn.hidden = FALSE;
    }
    return TRUE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.sEmailField) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect =  self.containerView.frame;
        rect.origin.y -= 105.0f;
        self.containerView.frame = rect;
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect =  self.containerView.frame;
        rect.origin.y -= 105.0f;
        self.containerView.frame = rect;
        [UIView commitAnimations];
    }
//    if (textField == self.lPasswordField) {
//        self.navigationBtn.hidden = FALSE;
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect =  self.containerView.frame;
        rect.origin.y += 105.0f;
        self.containerView.frame = rect;
        [UIView commitAnimations];
    if (textField == self.sEmailField) {
        if ([self.sEmailField.text length] == 0) {
        self.sResetBtn.hidden = TRUE;
        [self.signupNext setHidden:TRUE];
        [self.fbButton setHidden:FALSE];
        }
    }
    if (textField == self.lPasswordField) {
        if ([self.sEmailField.text length] > 0) {
            self.navigationBtn.hidden = FALSE;
        }
    }

}


- (IBAction)resetSignupView:(id)sender {
    self.sResetBtn.hidden = TRUE;
    [self.signupNext setHidden:TRUE];
    [self.fbButton setHidden:FALSE];
    //Enable fb button
    [self.sEmailField setText:nil];
}

- (IBAction)signUpBtnPressed:(id)sender {
    [self.loginView setHidden:TRUE];
    [self.signUpView setHidden:FALSE];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGRect rect =  self.pointerView.frame;
    rect.origin.x = self.signupBtn.frame.origin.x + self.signupBtn.frame.size.width / 2 - 8;
    self.pointerView.frame = rect;
    //self.pointerView.center = self.signUpView.center;
    [UIView commitAnimations];
}

- (IBAction)processLogin:(id)sender {
    if([_lUsernameField.text length] == 0 || [_lPasswordField.text length] == 0) {
        [self addWarningLabel];
        [self performSelector:@selector(removeNetworkMessage) withObject:nil afterDelay:3.0];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:TRUE forKey:@"nativeLogin"];
    [defaults setObject:_lUsernameField.text forKey:@"username"];
    [defaults setObject:_lPasswordField.text forKey:@"password"];
    
    [self dismissViewControllerAnimated:NO completion:nil];
//    GCSplashViewController *splashViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SPLASH_VIEW_CONTROLLER"];
//    
//    [self.navigationController pushViewController:splashViewController animated:YES];
    
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
    [messageLabel setText:@"Username/Password can not be left blank!"];
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

- (IBAction)loginBtnPressed:(id)sender {
    [self.signUpView setHidden:TRUE];
    [self.loginView setHidden:FALSE];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect =  self.pointerView.frame;
    rect.origin.x = self.loginBtn.frame.origin.x + self.loginBtn.frame.size.width / 2 -8;
    self.pointerView.frame = rect;
    [UIView commitAnimations];
}

- (IBAction)fbLoginPressed:(id)sender {
    
    FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
    [manager logInWithReadPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Process error %@", error);
        } else if (result.isCancelled) {
            NSLog(@"cancelled");
        } else {
            NSLog(@"Logged In");
        }
        
    }];
}

- (IBAction)dismissKeyboard:(id)sender {
}

- (IBAction)processSignUp:(id)sender {
    
    GCSignUpViewController *signViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SIGN_UP_VIEW_CONTROLLER"];
    signViewController.emailId = _sEmailField.text;
    [self presentViewController:signViewController animated:NO completion:nil];
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

@end
