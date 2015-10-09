//
//  CDNavDrawerControllerTableViewController.m
//  CoronaDental
//
//  Created by Raju Gautam on 06/06/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import "CDNavDrawerControllerTableViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "GCProfileCell.h"
#import "GCCustomCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface CDNavDrawerControllerTableViewController ()

@end

@implementation CDNavDrawerControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //self.tableView.contentOffset = CGPointMake(0, 20.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"FLSignalCell";
        GCProfileCell *cell = (GCProfileCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[GCProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults boolForKey:@"nativeLogin"]) {
                cell.username.text = [defaults objectForKey:@"username"];
            }
        }
        
//        GCProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SideDrawerCell" forIndexPath:indexPath];
        return cell;
    } else {
    
    NSString *cellIdentifier = @"CustomCell";
    GCCustomCell *cell = (GCCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[GCCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...//110 110 112
    switch(indexPath.row) {
        case 1:
            cell.name.text = @"Profile";
            cell.score.text = @"90%";
            cell.ivProfile.image = [UIImage imageNamed:@"ic_my_profile"];
                //cell.backgroundColor = [UIColor yellowColor];
            break;
            
        case 2:
            cell.name.text = @"My Videos";
            cell.score.text = @"31%";
            cell.ivProfile.image = [UIImage imageNamed:@"ic_my_video"];
            break;
        
        case 3:
            cell.name.text = @"Evaluations";
            cell.score.text = @"78%";
            cell.ivProfile.image = [UIImage imageNamed:@"ic_evaluations"];
            break;
        case 4:
            cell.name.text = @"Skill Cards";
            cell.score.text = @"12%";
            cell.ivProfile.image = [UIImage imageNamed:@"ic_skill_card"];
            break;
        case 5:
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.name.text = @"Logout";
            cell.score.text = nil;
            cell.ivProfile.image = [UIImage imageNamed:@"ic_logout"];
            break;
            
    }
    return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.row) {
        case 0:
            return 155.0f;
            break;
            
            default:
            return 50.0f;
    }
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 5: {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:FALSE forKey:@"nativeLogin"];
            [defaults setObject:nil forKey:@"username"];
            [defaults setObject:nil forKey:@"password"];

            [FBSDKAccessToken setCurrentAccessToken:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGSize size = self.view.frame.size;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 64.0f)];
    headerView.backgroundColor = [UIColor colorWithRed:136.0f/255.0f green:167.0f/255.0f blue:57.0f/255.0f alpha:1.0f];
    
    return headerView;
    
}

//- (UIView *)profileView {
//    CGSize size = self.view.frame.size;
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 120.0f)];
//    [headerView setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:159.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
//    UIImageView *profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64, 40, 40)];
//    [profilePic setImage:[UIImage imageNamed:@"amar-singh-profimg1"]];
//    profilePic.layer.cornerRadius = 20;
//    profilePic.layer.masksToBounds = TRUE;
//    [headerView addSubview:profilePic];
//    
//    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 65, size.width - 70.0f, 20.0f)];
//    headerTitle.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
//    headerTitle.text = @"Dr. Amar Singh";
//    [headerTitle setTextAlignment:NSTextAlignmentLeft];
//    [headerTitle setTextColor:[UIColor whiteColor]/*[UIColor colorWithRed:30.0f/255.0f green:138.0f/255.0f blue:220.0f/255.0f alpha:1.0f]*/];
//    
//    [headerView addSubview:headerTitle];
//    
//    UILabel *headerTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 85, size.width - 70.0f, 20.0f)];
//    headerTitle2.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
//    headerTitle2.text = @"Preferred Customer: D000001A";
//    [headerTitle2 setTextAlignment:NSTextAlignmentLeft];
//    [headerTitle2 setTextColor:/*[UIColor colorWithRed:147.0f/255.0f
//                                               green:189.0f/255.0f
//                                                blue:19.0f/255.0f
//                                               alpha:1.0f]*/[UIColor whiteColor]];
//    [headerView addSubview:headerTitle2];
//    
//        //    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(65, headerView.frame.size.height - 0.5f, size.width - 70.0f, 0.5f)];
//        //    [separator setBackgroundColor:[UIColor lightGrayColor]];
//        //    [headerView addSubview:separator];
//    
//    return headerView;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
