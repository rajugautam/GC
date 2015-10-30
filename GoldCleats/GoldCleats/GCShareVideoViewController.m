//
//  GCShareVideoViewController.m
//  GoldCleats
//
//  Created by Raju Gautam on 21/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import "GCShareVideoViewController.h"
#import "GCShareCell.h"
#import "GCVideoShareDescCell.h"
#import "VideoData.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "GCHomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XCDYouTubeVideoPlayerViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <TwitterKit/TwitterKit.h>

@interface GCShareVideoViewController ()
@property (nonatomic, retain) UIImageView *previewImageView;
@end

@implementation GCShareVideoViewController

- (void)viewDidLoad {
    
    _uploadVideo = [[YouTubeUploadVideo alloc] init];
    _uploadVideo.delegate = self;
    
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:136.0f/255.0f green:167.0f/255.0f blue:57.0f/255.0f alpha:1.0f]];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(takeMeToHome:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.subView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(-30, 0, 0, 0);

    UITapGestureRecognizer *gestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSubViews)];
    
    [self.subView addGestureRecognizer:gestureRec];
    
    if (_freshVideo) {
        _thumbnail = [self generateImage];
    }
}

- (void)takeMeToHome : (id)sender {
    NSArray *viewControllers = [self.navigationController viewControllers];
    if ([viewControllers count] > 0 && [viewControllers[0] isKindOfClass:[GCHomeViewController class]]) {
        [self.navigationController popToViewController:viewControllers[0] animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)dismissSubViews {
    [self.player stop];
//    [self.subView setBounds:self.view.bounds];
//        //[self.subView setCenter:point];
//    [self.subView setTransform:CGAffineTransformIdentity];
//    
//    [UIView animateWithDuration:0.4 animations:^{
//        [self.subView setCenter:CGPointMake(50, 50)];
//        [self.player.view setCenter:CGPointMake(50, 50)];
//        [self.subView setTransform:CGAffineTransformMakeScale(0, 0)];
//        [self.subView setAlpha:0.0];
//        [self.player.view removeFromSuperview];
//        [self.subView removeFromSuperview];
//    }];
    [self.player.view removeFromSuperview];
    if (_previewImageView) {
        [_previewImageView removeFromSuperview];
    }
    [self.subView removeFromSuperview];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
}


-(UIImage *)generateImage
{
    AVAsset *asset = [AVAsset assetWithURL:_videoUrl];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbnail;
    
}
//- (void)dismissPlayer {
//    for (id view in [self.navigationController.view subviews]) {
//        if ([view isKindOfClass:[UIView class]]) {
//            UIView *subView = (UIView*)view;
//            if (subView.tag == 101) {
//                [subView removeFromSuperview];
//                self.tableView.userInteractionEnabled = TRUE;
//                self.navigationController.view.alpha = 1.0f;
//            }
//        }
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            static NSString *cellIdentifier = @"GCVideoShareDescCell";
            GCVideoShareDescCell *cell = (GCVideoShareDescCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[GCVideoShareDescCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [cell setCallBack:^(NSString *string){
                    [self updateText:string];
                }];
            }
            
            switch (_mediaType) {
                case kTypeImage:
                    cell.videoThumbnail.image = _thumbnail;
                    cell.playVideo.hidden = TRUE;
                    break;
                case KTypeVideo:
                    if (_freshVideo) {
                        cell.videoThumbnail.image = _thumbnail;
                    } else {
                        cell.videoThumbnail.image = _videoData.thumbnail;
                    }
                    break;
                default:
                    break;
            }
            
            return cell;
        }
            break;
            
        case 1:
        {
            static NSString *cellIdentifier = @"ShareCell";
            GCShareCell *cell = (GCShareCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[GCShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
        
        if (!_freshVideo) {
            cell.youtube.hidden = TRUE;
        }
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 100.0f;
            break;
        case 1:
            return 80.0f;
            break;
        default:
            break;
    }
    return 10.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row ==0) {
        switch (_mediaType) {
            case kTypeImage:
                [self startPreviewingImage];
                break;
                
            case KTypeVideo:
                [self startPreviewingVideo];
                break;
                
            default:
                break;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView youtubeBtnPressed:(NSIndexPath*)indexPath {
    [self uploadVideoToYouTube:self];
    
}

- (void)tableView:(UITableView *)tableView instagramBtnPressed:(NSIndexPath*)indexPath {
    [self uploadVideoToInstagram:self];
    
}

- (void)tableView:(UITableView *)tableView twitterBtnPressed:(NSIndexPath*)indexPath {
    [self uploadVideoToTwitter:self];
    
}

- (void)tableView:(UITableView *)tableView facebookBtnPressed:(NSIndexPath*)indexPath {
    [self uploadVideoToFacebook:self];
    
}

- (void)updateText : (NSString *)string {
    self.videoDescription = string;
}

- (void)startPreviewingImage {
    _previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
//    _previewImageView.center = self.view.center;
    _previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_previewImageView setImage:_thumbnail];
    [self.subView addSubview:_previewImageView];
    
    //[self displayPlayerView:self.subView fromPoint:CGPointMake(10, 20)];
    
    [self displayImageView:_previewImageView withInView:self.subView fromPoint:CGPointMake(10, 20)];
}

- (void)startPreviewingVideo {
    if (_freshVideo) {
        self.player = [[MPMoviePlayerController alloc] initWithContentURL:_videoUrl];
        
    } else {
        XCDYouTubeVideoPlayerViewController * videoPlayer = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:_videoData.getYouTubeId];
        self.player = videoPlayer.moviePlayer;
    }
    self.player.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
    
    self.player.fullscreen = TRUE;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.repeatMode = MPMovieRepeatModeOne;
    self.player.scalingMode = MPMovieScalingModeAspectFill;
    
    [self.subView addSubview:self.player.view];
    
    [self displayPlayerView:self.subView fromPoint:CGPointMake(10, 20)];
   
}

- (void)tableView:(UITableView *)tableView playButtonPressedAtIndex:(NSIndexPath*)indexPath {
    
//    [self startPreviewingVideo];
    
}

- (void) displayPlayerView: (UIView *) view fromPoint: (CGPoint) point
{
    [view setBounds:self.navigationController.view.bounds];
    [view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    [view setCenter:point];
    [view setAlpha:0.0];
    [self.navigationController.view addSubview:view];
    [view setTransform:CGAffineTransformMakeScale(0, 0)];
    
    [UIView animateWithDuration:0.5 animations:^{
        [view setCenter:self.navigationController.view.center];
        [self.player.view setCenter:self.navigationController.view.center];
        [view setTransform:CGAffineTransformIdentity];
        [view setAlpha:1.0];
        [self.player play];
    }];
}

- (void) displayImageView: (UIImageView *)imageView withInView:(UIView *) view fromPoint: (CGPoint) point
{
    [view setBounds:self.view.bounds];
    [view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    [view setCenter:point];
    [view setAlpha:0.0];
    [self.navigationController.view addSubview:view];
    [view setTransform:CGAffineTransformMakeScale(0, 0)];
    
    [UIView animateWithDuration:0.5 animations:^{
        [view setCenter:self.view.center];
        [imageView setCenter:self.view.center];
        [view setTransform:CGAffineTransformIdentity];
        [view setAlpha:1.0];
    }];
}

#pragma mark Upload video to YouTube
-(void)uploadVideoToYouTube: (id)sender {
    NSData *fileData = [NSData dataWithContentsOfURL:_videoUrl];
    NSString *title = @"GoldCleats";//titleField.text;
    
    if (fileData == nil) return;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    GTLServiceYouTube *youtubeService = delegate.youtubeService;
//    if ([title isEqualToString:@""]) {
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"'Direct Lite Uploaded File ('EEEE MMMM d, YYYY h:mm a, zzz')"];
//        title = [dateFormat stringFromDate:[NSDate date]];
//    }
//    if ([description isEqualToString:@""]) {
//        description = @"Uploaded from ";
//    }
    
    [self.uploadVideo uploadYouTubeVideoWithService:youtubeService
                                           fileData:fileData
                                              title:self.title
                                        description:self.videoDescription];

}

#pragma mark - uploadYouTubeVideo

- (void)uploadYouTubeVideo:(YouTubeUploadVideo *)uploadVideo
      didFinishWithResults:(GTLYouTubeVideo *)video {
    
    [Utils showAlert:@"Video Uploaded" message:video.identifier];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark Upload video to Instagram
-(void)uploadVideoToInstagram: (id)sender {
    if (_freshVideo) {
        NSString *escapedString   = [_referenceUrl.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        NSString *escapedCaption  = _videoDescription;
        NSURL *instagramURL       = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=%@", escapedString, escapedCaption]];
        
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            [[UIApplication sharedApplication] openURL:instagramURL];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GoldCleats" message:@"You need to install Instagram in order to share video on it." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
            [alert show];
        }
    }
}


#pragma mark Upload video to Instagram
-(void)uploadVideoToTwitter: (id)sender {
    [self getTwitterAccountInfo];
}

#pragma mark Upload video to Instagram
-(void)uploadVideoToFacebook: (id)sender {
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
            // TODO: publish content.
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions", @"publish_stream"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                //TODO: process error or result.
        }];
    }
    if (_freshVideo) {
    FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
    video.videoURL = _referenceUrl;
    FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
    content.video = video;
    //content.description = self.description;
    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
        
        NSLog(@"can it show dialog? %d",[shareDialog canShow]);
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:self];
    }
    else {
        NSURL *videoURL =[NSURL URLWithString: _videoData.getWatchUri];
        
        FBSDKShareLinkContent *shareLinkContent = [[FBSDKShareLinkContent alloc] init];
        shareLinkContent.contentURL = videoURL;
        
        [FBSDKShareDialog showFromViewController:self
                                     withContent:shareLinkContent
                                        delegate:self];
    }
}


- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"hghgh %@",error);
}


- (void) getTwitterAccountInfo
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                // Check if the users has setup at least one Twitter account
                if (accounts.count > 0)
                    {
                        ACAccount *twitterAccount = [accounts objectAtIndex:0];
                        // Creating a request to get the info about a user on Twitter
                        SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:nil];
                            [twitterInfoRequest setAccount:twitterAccount];
                    
                    
                        [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        // Check if we reached the reate limit
                                    if ([urlResponse statusCode] == 429) {
                                        NSLog(@"Rate limit reached");
                                        return;
                                        }
                                    if (error) {
                                        NSLog(@"Error: %@", error.localizedDescription);
                                        return;
                                    }
                                    
                                    if (responseData) {
                                        NSError *error = nil;
                                        NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                                            // Filter the preferred data
                                        NSString *screen_name = [(NSDictionary *)TWData objectForKey:@"screen_name"];
                                        NSString *name = [(NSDictionary *)TWData objectForKey:@"name"];
                                        
                                        int followers = [[(NSDictionary *)TWData objectForKey:@"followers_count"] integerValue];

                                        int following = [[(NSDictionary *)TWData objectForKey:@"friends_count"] integerValue];
                                        int tweets = [[(NSDictionary *)TWData objectForKey:@"statuses_count"] integerValue];
                                        
                                        NSString *profileImageStringURL = [(NSDictionary *)TWData objectForKey:@"profile_image_url_https"];
                                        
                                        NSString *bannerImageStringURL =[(NSDictionary *)TWData objectForKey:@"profile_banner_url"];
                                    }
                                });
                        }];
                         }
        }
    }];
}


@end
