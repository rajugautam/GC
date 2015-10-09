//
//  GCSplashViewController.m
//  GoldCleats
//
//  Created by Raju Gautam on 26/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import "GCSplashViewController.h"
#import "MMDrawerController.h"
#import "GCLoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface GCSplashViewController ()

@end

@implementation GCSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = FALSE;

    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([FBSDKAccessToken currentAccessToken] || [defaults boolForKey:@"nativeLogin"]) {
        [self performSelector:@selector(prepareNavigationStack) withObject:nil afterDelay:3.0f];
    } else {
        GCLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LOGIN_VIEW_CONTROLLER"];
        
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareNavigationStack {
    [self performSegueWithIdentifier:@"DRAWER_SEGUE" sender:self];
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([segue.identifier isEqualToString:@"DRAWER_SEGUE"]) {
 MMDrawerController *destinationViewController = (MMDrawerController *) segue.destinationViewController;
 [destinationViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
 
 // Instantitate and set the center view controller.
 UIViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HOME_VIEW_CONTROLLER"];
 NSLog(@"center View controller %@ and class %@", centerViewController, [centerViewController class]);
 [destinationViewController setCenterViewController:centerViewController];
 
 // Instantiate and set the left drawer controller.
 UIViewController *leftDrawerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SIDE_DRAWER_CONTROLLER"];
 NSLog(@"left View controller %@ and class %@", leftDrawerViewController, [leftDrawerViewController class]);
 [destinationViewController setLeftDrawerViewController:leftDrawerViewController];
 
 }
 }

@end
