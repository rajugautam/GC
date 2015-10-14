//
//  GCHomeViewController.m
//  GoldCleats
//
//  Created by Raju Gautam on 21/09/15.
//  Copyright (c) 2015 Raju Gautam. All rights reserved.
//

#import "GCHomeViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "VideoData.h"
#import "YouTubeGetUploads.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
//#import "UploadController.h"
#import "VideoPlayerViewController.h"
//#import "VideoListViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Utils.h"
#import "HomeViewCell.h"
#import "GCShareVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GCShareVideoViewController.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import "GoldCleats-Swift.h"

@import AssetsLibrary;
//@import imglyKit;

#define CDDRAWERACTION @"CDDrawerAction"

@interface GCHomeViewController ()<YouTubeGetUploadsDelegate>

@property(nonatomic, strong) NSArray *videos;
@property(nonatomic, strong) YouTubeGetUploads *getUploads;
@property(nonatomic, retain) GTLServiceYouTube *youtubeService;
@property(nonatomic, retain) UIButton *floatingButton;

@end
@implementation GCHomeViewController

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftMenuButton];
    
    [self.tableView setBackgroundView:[self updateTableViewBackgroundViewForMessage:@"Please wait, we are preparing you Playlist..."]];
    _getUploads = [[YouTubeGetUploads alloc] init];
    _getUploads.delegate = self;
    _videos = [[NSArray alloc] init];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"AvenirNext-Medium" size:17], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                nil];
    
    self.navigationController.navigationBar.titleTextAttributes = attributes;
        //self.navigationController.hidesBarsOnSwipe = YES;
    
    CGRect rect = self.view.frame;
    _floatingButton = [[UIButton alloc] initWithFrame:CGRectMake(rect.size.width/2 - 30, rect.size.height - 230, 70.0, 70.0)];
    [_floatingButton setImage:[UIImage imageNamed:@"add_video"] forState:UIControlStateNormal];
        //[_floatingButton setImage:[UIImage imageNamed:@"add_video_golder"] forState:UIControlStateNormal];
    [_floatingButton addTarget:self action:@selector(showCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_floatingButton];
    
        // Initialize the youtube service & load existing credentials from the keychain if available
    self.youtubeService = [[GTLServiceYouTube alloc] init];
    self.youtubeService.authorizer =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                          clientID:kClientID
                                                      clientSecret:kClientSecret];
    if (![self isAuthorized]) {
            // Not yet authorized, request authorization and push the login UI onto the navigation stack.
        [[self navigationController] pushViewController:[self createAuthController] animated:YES];
    }
    
    /**
     
      Get Filters Information(Just for knowledge)
     
     **/
    
//    NSArray * filters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
//    NSLog(@"Filter list %@", filters);
//    
//    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
//    
//    NSLog(@"Filter attributes %@", [filter attributes]);
}

- (UIView *)updateTableViewBackgroundViewForMessage:(NSString *)message {
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, self.view.frame.size.width - 60, 100)];
    label.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
    [label setTextColor:[UIColor colorWithRed:65.0f/255.0f green:64.0f/255.0f blue:66.0f/255.0f alpha:1.0f]];
    [label setText:message];
    [label setNumberOfLines:2];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:label];
    return view;
}

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)showShareView {

}

    // Helper to check if user is authorized
- (BOOL)isAuthorized {
    return [((GTMOAuth2Authentication *)self.youtubeService.authorizer) canAuthorize];
}

    // Creates the auth controller for authorizing access to YouTube.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;
    
    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeYouTube
                                                                clientID:kClientID
                                                            clientSecret:kClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

    // Handle completion of the authorization process, and updates the YouTube service
    // with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    if (error != nil) {
        [Utils showAlert:@"Authentication Error" message:error.localizedDescription];
        self.youtubeService.authorizer = nil;
    } else {
        self.youtubeService.authorizer = authResult;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        // Always display the camera UI.
    [self showList];
}

- (void)showList {
    // initiate youtube video fetch request
    [self.getUploads getYouTubeUploadsWithService:self.youtubeService];
//    VideoListViewController *listUI = [[VideoListViewController alloc] init];
//    listUI.youtubeService = self.youtubeService;
//    [[self navigationController] pushViewController:listUI animated:YES];
}

#pragma mark - YouTubeGetUploadsDelegate methods

- (void)getYouTubeUploads:(YouTubeGetUploads *)getUploads didFinishWithResults:(NSArray *)results {
    NSLog(@"getUploads request finished with result %@", results);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.videos = results;
    if([results count] > 0) {
        [self.tableView setBackgroundView:nil];
        [self.tableView reloadData];
    } else {
        [self.tableView setBackgroundView:[self updateTableViewBackgroundViewForMessage:@"No Video from you yet. Please start adding..."]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

//- (IBAction)startOAuthFlow:(id)sender {
//    GTMOAuth2ViewControllerTouch *viewController;
//    
//    viewController = [[GTMOAuth2ViewControllerTouch alloc]
//                      initWithScope:kGTLAuthScopeYouTube
//                      clientID:kClientID
//                      clientSecret:kClientSecret
//                      keychainItemName:kKeychainItemName
//                      delegate:self
//                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
//    
//    [[self navigationController] pushViewController:viewController animated:YES];
//}

#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.videos count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HomeViewCell";
    HomeViewCell *cell = (HomeViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HomeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    VideoData *vidData = [self.videos objectAtIndex:indexPath.row];
    cell.videoThumbnail.image = vidData.fullImage;
    cell.description.text = [vidData getTitle];//@"This video was uploaded as a test. and some of the description was expected to be returned from youtube!!!";//[vidData getTitle];
    [cell.contentView bringSubviewToFront:cell.playButton];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ -- %@ views",
    //                           [Utils humanReadableFromYouTubeTime:vidData.getDuration],
    //                           vidData.getViews];

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat offset = 235;
    
    VideoData *vidData = [self.videos objectAtIndex:indexPath.row];
    
    CGSize size = [[vidData getTitle] sizeWithFont:[UIFont fontWithName:@"AvenirNext-Regular" size:15] constrainedToSize:CGSizeMake(self.tableView.bounds.size.width - 10.0f, 17000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    return MAX(245.0f, offset + size.height);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoData *selectedVideo = [_videos objectAtIndex:indexPath.row];

    [self playVideoInMediaPlayerForURL:selectedVideo.getYouTubeId];
    
    return;
    VideoPlayerViewController *videoController = [[VideoPlayerViewController alloc] init];
    videoController.videoData = selectedVideo;
    videoController.youtubeService = self.youtubeService;
    
    [[self navigationController] pushViewController:videoController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)tableView:(UITableView *)tableView shareButtonPressedAtIndex:(NSIndexPath*)indexPath {
    [self pushShareViewControllerWithData:[self.videos objectAtIndex:indexPath.row] localURL:nil referenceUrl:nil forYouTubeServices:nil freshVideo:NO];
    
}

- (void)pushShareViewControllerWithData : (VideoData *)videoData localURL:(NSURL *)videoUrl referenceUrl:(NSURL *)refUrl forYouTubeServices:(GTLServiceYouTube *)youTubeService freshVideo:(BOOL)isFreshVideo {
    
    GCShareVideoViewController *shareViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SHARE_VIDEO_CONTROLLER"];
    shareViewController.videoData = videoData;
    shareViewController.youtubeService = youTubeService;
    shareViewController.videoUrl = videoUrl;
    shareViewController.referenceUrl = refUrl;
    shareViewController.freshVideo = isFreshVideo;
    [self.navigationController pushViewController:shareViewController animated:YES];
}

#pragma mark UIScrollView delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.floatingButton.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - self.floatingButton.frame.size.height;
    self.floatingButton.frame = frame;
    
    [self.view bringSubviewToFront:self.floatingButton];
}

- (void)showCamera {
    _floatingButton.transform = CGAffineTransformMakeScale(0.1, 0.1);
    //_floatingButton.transform = CGAffineTransformMakeRotation(90);
    
    [UIView animateWithDuration:2.0 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:6.0 options:UIViewAnimationOptionAllowUserInteraction animations: ^{_floatingButton.transform = CGAffineTransformIdentity;} completion:nil];
    
    IMGLYCameraViewController *cameraView = [[IMGLYCameraViewController alloc] init];
    cameraView.squareMode = TRUE;
    cameraView.maximumVideoLength = 20;
    cameraView.completionBlock = ^(UIImage *image, NSURL *url) {
        NSLog(@"recording done %@", url);
        [self saveVideoToPhoneFrom:url];
    };
[self presentViewController:cameraView animated:YES completion:nil];
}

- (void)showVideoLibrary {
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
        // In case we're running the iPhone simulator, fall back on the photo library instead.
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [Utils showAlert:@"Error" message:@"Sorry, iPad Simulator not supported!"];
        return;
    }
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    [self presentViewController:cameraUI animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (CFStringCompare((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        
        [self saveVideoToPhoneFrom:videoUrl];
        
//        VideoUploadViewController *uploadController = [[VideoUploadViewController alloc] init];
//        uploadController.videoUrl = videoUrl;
//        uploadController.youtubeService = self.youtubeService;
//        
//        [[self navigationController] pushViewController:uploadController animated:YES];
    }
    
    
}

- (void)saveVideoToPhoneFrom : (NSURL *)initialUrl {
    //__block NSURL *newURl;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    ALAssetsLibraryWriteVideoCompletionBlock videoWriteCompletionBlock =
//    ^(NSURL *url, NSError *error) {
//        if (error) {
//            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
//        } else {
//            NSLog( @"Wrote image with metadata to Photo Library %@", url.absoluteString);
//            newURl = url;
//        }
//    };
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:initialUrl])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:initialUrl
                                    completionBlock:^(NSURL *url, NSError *error) {
                                        if (error) {
                                            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
                                        } else {
                                            NSLog( @"Wrote image with metadata to Photo Library %@", url.absoluteString);
                                            //newURl = url;
                                            [self pushShareViewControllerWithData:nil localURL:initialUrl referenceUrl:url forYouTubeServices:self.youtubeService freshVideo:YES];
                                            
                                            [self dismissViewControllerAnimated:YES completion:nil];

                                        }
                                    }];
    }
}

- (void)playVideoInMediaPlayerForURL:(NSString *)videoId {
    XCDYouTubeVideoPlayerViewController * videoPlayer = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoId];
//    videoPlayer.moviePlayer.fullscreen=YES;
    videoPlayer.moviePlayer.shouldAutoplay=YES;
    [self presentMoviePlayerViewControllerAnimated:videoPlayer];

}
@end
