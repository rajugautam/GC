//
//  GCVideoProcessor.m
//  GoldCleats
//
//  Created by Raju Gautam on 10/29/15.
//  Copyright © 2015 Raju Gautam. All rights reserved.
//

#import "GCVideoProcessor.h"
#import <AVFoundation/AVFoundation.h>
#import "EAFRead.h"
#import "EAFWrite.h"
#import "Utilities.h"
#include <stdio.h>
#include <sys/time.h>
#import "Dirac.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "GoldCleats-Swift.h"

//@import AssetsLibrary;

@interface GCVideoProcessor ()

@property (nonatomic, retain) EAFRead *reader;
@property (nonatomic, retain) EAFWrite *writer;
@property (nonatomic, retain) NSURL *outUrl;
@property (nonatomic, retain) NSURL *inUrl;
@end

@implementation GCVideoProcessor

double gExecTimeTotal = 0.;

- (void)processVideoAtPath:(NSURL*)url atScaleRate:(CGFloat)rate {
    
//    [self exportVideoWithOverlayForURL:url];
//    
//    return;
    AVAsset *videoAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    
    
    
    //create mutable composition
    
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    
    
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                        
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                             
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    
    NSError *videoInsertError = nil;
    
    BOOL videoInsertResult = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                              
                                                            ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                              
                                                             atTime:kCMTimeZero
                              
                                                              error:&videoInsertError];
    
    
    
    
    
    if (!videoInsertResult || nil != videoInsertError) {
        
        //handle error
        
        NSLog(@"could not insert video frames::%@",videoInsertError);
        
        return;
        
    }
    
    
    
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
     
                                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
     
                                         atTime:kCMTimeZero error:nil];
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *outputURL = paths[0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    
    outputURL = [outputURL stringByAppendingPathComponent:@"output.aif"];
    
    //Remove Existing File
    
    [manager removeItemAtPath:outputURL error:nil];
    
    
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
    
    exportSession.outputURL = [NSURL fileURLWithPath:outputURL]; // output path;
    
    exportSession.outputFileType = AVFileTypeAppleM4A;
    
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
            
            NSLog(@"video session exported successfully");
            
            [self writeAudioToPhotoLibrary:[NSURL fileURLWithPath:outputURL] movieURL:url atScaleRate:rate];
            
        } else {
            
            NSLog(@"error: %@", [exportSession error]);
            
            //error: Error Domain=AVFoundationErrorDomain Code=-11800 "The operation could not be completed" UserInfo=0x2023b720 {NSLocalizedDescription=The operation could not be completed, NSUnderlyingError=0x2023bb70 "The operation couldn’t be completed. (OSStatus error -12780.)", NSLocalizedFailureReason=An unknown error occurred (-12780)}
            
        }
        
    }];
}

- (void)mergeVideoAtPath:(NSURL*)video1 withVideoAtPath:(NSURL*)video2 {
    
    AVAsset *asset1 = [AVAsset assetWithURL:video1];
    AVAsset *asset2 = [AVAsset assetWithURL:video2];
    
    AVAsset *audioAsset = [[AVURLAsset alloc] initWithURL:video1 options:nil];
    
    AVMutableComposition *mutableComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack *videoCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *firstVideoAssetTrack = [[asset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVAssetTrack *secondVideoAssetTrack = [[asset2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstVideoAssetTrack.timeRange.duration) ofTrack:firstVideoAssetTrack atTime:kCMTimeZero error:nil];
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondVideoAssetTrack.timeRange.duration) ofTrack:secondVideoAssetTrack atTime:kCMTimeZero error:nil];
    
    [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstVideoAssetTrack.timeRange.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];

    BOOL isFirstVideoPortrait = NO;
    CGAffineTransform firstTransform = firstVideoAssetTrack.preferredTransform;
    // Check the first video track's preferred transform to determine if it was recorded in portrait mode.
    if (firstTransform.a == 0 && firstTransform.d == 0 && (firstTransform.b == 1.0 || firstTransform.b == -1.0) && (firstTransform.c == 1.0 || firstTransform.c == -1.0)) {
        isFirstVideoPortrait = YES;
    }
    BOOL isSecondVideoPortrait = NO;
    CGAffineTransform secondTransform = secondVideoAssetTrack.preferredTransform;
    // Check the second video track's preferred transform to determine if it was recorded in portrait mode.
    if (secondTransform.a == 0 && secondTransform.d == 0 && (secondTransform.b == 1.0 || secondTransform.b == -1.0) && (secondTransform.c == 1.0 || secondTransform.c == -1.0)) {
        isSecondVideoPortrait = YES;
    }
    if ((isFirstVideoPortrait && !isSecondVideoPortrait) || (!isFirstVideoPortrait && isSecondVideoPortrait)) {
        UIAlertView *incompatibleVideoOrientationAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Cannot combine a video shot in portrait mode with a video shot in landscape mode." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [incompatibleVideoOrientationAlert show];
        return;
    }
    
    AVMutableVideoCompositionInstruction *firstVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    // Set the time range of the first instruction to span the duration of the first video track.
    firstVideoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstVideoAssetTrack.timeRange.duration);
    AVMutableVideoCompositionInstruction * secondVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    // Set the time range of the second instruction to span the duration of the second video track.
    secondVideoCompositionInstruction.timeRange = CMTimeRangeMake(firstVideoAssetTrack.timeRange.duration, CMTimeAdd(firstVideoAssetTrack.timeRange.duration, secondVideoAssetTrack.timeRange.duration));
    AVMutableVideoCompositionLayerInstruction *firstVideoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
    // Set the transform of the first layer instruction to the preferred transform of the first video track.
    [firstVideoLayerInstruction setTransform:firstTransform atTime:kCMTimeZero];
    AVMutableVideoCompositionLayerInstruction *secondVideoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
    // Set the transform of the second layer instruction to the preferred transform of the second video track.
    [secondVideoLayerInstruction setTransform:secondTransform atTime:firstVideoAssetTrack.timeRange.duration];
    firstVideoCompositionInstruction.layerInstructions = @[firstVideoLayerInstruction];
    secondVideoCompositionInstruction.layerInstructions = @[secondVideoLayerInstruction];
    AVMutableVideoComposition *mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    
    mutableVideoComposition.instructions = @[firstVideoCompositionInstruction, secondVideoCompositionInstruction];
    
    CGSize naturalSizeFirst, naturalSizeSecond;
    // If the first video asset was shot in portrait mode, then so was the second one if we made it here.
    if (isFirstVideoPortrait) {
        // Invert the width and height for the video tracks to ensure that they display properly.
        naturalSizeFirst = CGSizeMake(firstVideoAssetTrack.naturalSize.height, firstVideoAssetTrack.naturalSize.width);
        naturalSizeSecond = CGSizeMake(secondVideoAssetTrack.naturalSize.height, secondVideoAssetTrack.naturalSize.width);
    }
    else {
        // If the videos weren't shot in portrait mode, we can just use their natural sizes.
        naturalSizeFirst = firstVideoAssetTrack.naturalSize;
        naturalSizeSecond = secondVideoAssetTrack.naturalSize;
    }
    float renderWidth, renderHeight;
    // Set the renderWidth and renderHeight to the max of the two videos widths and heights.
    if (naturalSizeFirst.width > naturalSizeSecond.width) {
        renderWidth = naturalSizeFirst.width;
    }
    else {
        renderWidth = naturalSizeSecond.width;
    }
    if (naturalSizeFirst.height > naturalSizeSecond.height) {
        renderHeight = naturalSizeFirst.height;
    }
    else {
        renderHeight = naturalSizeSecond.height;
    }
    mutableVideoComposition.renderSize = CGSizeMake(renderWidth, renderHeight);
    // Set the frame duration to an appropriate value (i.e. 30 frames per second for video).
    mutableVideoComposition.frameDuration = CMTimeMake(1,30);

    // Create a static date formatter so we only have to initialize it once.
    static NSDateFormatter *kDateFormatter;
    if (!kDateFormatter) {
        kDateFormatter = [[NSDateFormatter alloc] init];
        kDateFormatter.dateStyle = NSDateFormatterMediumStyle;
        kDateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    // Create the export session with the composition and set the preset to the highest quality.
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mutableComposition presetName:AVAssetExportPresetHighestQuality];
    // Set the desired output URL for the file created by the export process.
    exporter.outputURL = [[[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil] URLByAppendingPathComponent:[kDateFormatter stringFromDate:[NSDate date]]] URLByAppendingPathExtension:CFBridgingRelease(UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)AVFileTypeQuickTimeMovie, kUTTagClassFilenameExtension))];
    // Set the output file type to be a QuickTime movie.
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mutableVideoComposition;
    // Asynchronously export the composition to a video file and save this file to the camera roll once export completes.
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
                if ([assetsLibrary videoAtPathIsCompatibleWithSavedPhotosAlbum:exporter.outputURL]) {
                    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:exporter.outputURL completionBlock:NULL];
                }
            } else if (exporter.status == AVAssetExportSessionStatusFailed) {
                NSLog(@"export session failed");
            }
        });
    }];
}

- (void)exportVideoWithOverlayForURL:(NSURL*) url withPointsArray:(NSArray *)points {
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] lastObject];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:clipVideoTrack
                                    atTime:kCMTimeZero
                                     error:nil];
    
    [compositionVideoTrack setPreferredTransform:clipVideoTrack.preferredTransform];
    
    CGSize videoSize = [clipVideoTrack naturalSize];
    
//    CALayer *overlayLayer = [CALayer layer];
//    [overlayLayer setContents:(id)_overlayView];
//    overlayLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
//    [overlayLayer setMasksToBounds:YES];
    
    
    UIImage *animationImage = [UIImage imageNamed:@"star.png"];;
    CALayer *overlayLayer1 = [CALayer layer];
    [overlayLayer1 setContents:(id)[animationImage CGImage]];
    overlayLayer1.frame = CGRectMake(64, 100, 128, 128);
    [overlayLayer1 setMasksToBounds:YES];
    
    GCSpotLightCircle *cropRectComponent = [[GCSpotLightCircle alloc] init];
    [UIView animateWithDuration:5.0  delay:0 options: UIViewAnimationOptionCurveLinear
                     animations:^  {
//                         overlayLayer1.frame = CGRectMake(74, 110, 128, 128);
//                         overlayLayer1.frame = CGRectMake(84, 115, 128, 128);
//                         overlayLayer1.frame = CGRectMake(94, 125, 128, 128);
//                         overlayLayer1.frame = CGRectMake(104, 135, 128, 128);
//                         overlayLayer1.frame = CGRectMake(114, 145, 128, 128);
//                         overlayLayer1.frame = CGRectMake(124, 155, 128, 128);
//                         overlayLayer1.frame = CGRectMake(134, 165, 128, 128);
//                         overlayLayer1.frame = CGRectMake(144, 175, 128, 128);
//                         overlayLayer1.frame = CGRectMake(154, 185, 128, 128);
//                         overlayLayer1.frame = CGRectMake(164, 195, 128, 128);
                         
                         
                         for (int i =0; i < [points count]; i ++) {
                             cropRectComponent.cropRect = [points[i] CGRectValue
                                                           cropRectComponent.layoutViewsForCropRect()
//
//                         
//                         CGRect bounds = CGRectMake(0, 0, _overlayView.frame.size.width,
//                                                    _overlayView.frame.size.height);
//                         
//                         CAShapeLayer *maskLayer = [CAShapeLayer layer];
//                         maskLayer.frame = bounds;
//                         maskLayer.fillColor = [UIColor blackColor].CGColor;
//                             //        let path = UIBezierPath(rect: cropRect)
//                             //        path.appendPath(UIBezierPath(rect: bounds))
//                             //        maskLayer.path = path.CGPath
//                             //        maskLayer.fillRule = kCAFillRuleEvenOdd
//                             //
//                             //        transparentView_!.layer.mask = maskLayer
//                         
//                         UIBezierPath *path = [UIBezierPath bezierPathWithRect:[points[i] CGRectValue]];//UIBezierPath(arcCenter: cropRect.!, radius: 60, startAngle: CGFloat(0), endAngle: CGFloat(2 * M_PI), clockwise: true);
////                         path.appendPath = [UIBezierPath bezierPathWithRect:CGRectMake(50, 50, 200, 300)];
////                         path.appendPath = [UIBezierPath bezierPathWithRect:CGRectMake(50, 50, 200, 300)];
//                         maskLayer.path = path.CGPath;
//                         maskLayer.fillRule = kCAFillRuleEvenOdd;
//                         _overlayView.layer.mask = maskLayer;
//                         }
                     }
                     completion:^ (BOOL finished) {
                         
                     }];
//    CABasicAnimation *animation =
//    [CABasicAnimation animationWithKeyPath:@"position"];
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
////    animation.duration=2.0;
////    animation.repeatCount=5;
////    animation.autoreverses=YES;
//    // rotate from 0 to 360
//    animation.fromValue=[NSValue valueWithCGPoint:CGPointMake(50, 100)];//[NSNumber numberWithFloat:0.0];
//    animation.toValue=[NSValue valueWithCGPoint:CGPointMake(150, 200)];
//    
//    CABasicAnimation *animation2 =
//    [CABasicAnimation animationWithKeyPath:@"position"];
//    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        //    animation.duration=2.0;
//        //    animation.repeatCount=5;
//        //    animation.autoreverses=YES;
//        // rotate from 0 to 360
//    animation2.fromValue=[NSValue valueWithCGPoint:CGPointMake(150, 200)];
//    
//    animation2.toValue=[NSValue valueWithCGPoint:CGPointMake(250, 250)];
//    
//    CABasicAnimation *animation3 =
//    [CABasicAnimation animationWithKeyPath:@"position"];
//    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        //    animation.duration=2.0;
//        //    animation.repeatCount=5;
//        //    animation.autoreverses=YES;
//        // rotate from 0 to 360
//    animation3.fromValue=[NSValue valueWithCGPoint:CGPointMake(250, 250)];
//    animation.toValue=[NSValue valueWithCGPoint:CGPointMake(50, 300)];
//    
//    CAAnimationGroup * group =[CAAnimationGroup animation];
//    group.removedOnCompletion=NO; group.fillMode=kCAFillModeForwards;
//    group.animations =[NSArray arrayWithObjects:animation, animation2, animation3, nil];
//    group.duration = 2.7;
//        //[NSNumber numberWithFloat:(2.0 * M_PI)];
////    animation.beginTime = AVCoreAnimationBeginTimeAtZero;
//    [overlayLayer1 addAnimation:group forKey:@"frame"];
    
    
    CALayer *parentLayer = [CALayer layer];
    
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer1];
    
    AVMutableVideoComposition* videoComp = [AVMutableVideoComposition videoComposition];
    videoComp.renderSize = [clipVideoTrack naturalSize];
    videoComp.frameDuration = CMTimeMake(1, 30);
    videoComp.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, mixComposition.duration);
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    videoComp.instructions = [NSArray arrayWithObject:instruction];
    
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    assetExport.videoComposition = videoComp;
    NSString *videoName = @"output.mov";
    
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingString:videoName];
    NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    assetExport.outputURL = exportURL;
    assetExport.shouldOptimizeForNetworkUse = YES;
    
    [assetExport exportAsynchronouslyWithCompletionHandler:^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self writeVideoToPhotoLibrary:assetExport.outputURL];
        });
    }];
}

//- (UIImage *) imageWithView:(UIView *)view
//{
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return img;
//}

- (void)writeAudioToPhotoLibrary:(NSURL *)url movieURL:(NSURL*)movieURL atScaleRate:(CGFloat)rate

{
    
    NSLog(@"%@",url);
    
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    
    
//    [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
//        
//        if (error) {
//            
//            NSLog(@"Video could not be saved");
//            
//        }else{
    
            
            
                        NSString *outputSound = [[NSHomeDirectory() stringByAppendingString:@"/Documents/"] stringByAppendingString:@"outnew.aif"];
            
                        self.inUrl = url;
    
                        self.outUrl = [NSURL fileURLWithPath:outputSound];
            
                        self.reader = [[EAFRead alloc] init];
            
                        self.writer = [[EAFWrite alloc] init];
            
            
            
            // this thread does the processing
            
            //[NSThread detachNewThreadSelector:@selector(processThread:) toTarget:self withObject:nil];
    
//            [self performSelector:@selector(processThread:) onThread:[NSThread new] withObject:nil waitUntilDone:YES];
        [self processThread:rate];
    
            AVAsset *videoAsset = [[AVURLAsset alloc] initWithURL:movieURL options:nil];
            
            
            
//            AVAssetTrack *assetAudioTrack = nil;
//
//
//
//            if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
//
//                assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
//
//            }

            NSString *audioURL = outputSound;

            NSLog(@"%@",audioURL);

            AVAsset *audioAsset = [[AVURLAsset alloc] initWithURL:self.outUrl options:nil];
            AVAsset *inAudioAsset = [[AVURLAsset alloc] initWithURL:self.inUrl options:nil];
    
            NSLog(@"audioAsset in duration %f", CMTimeGetSeconds([inAudioAsset duration]));
    
            NSLog(@"audioAsset duration %f", CMTimeGetSeconds([audioAsset duration]));
    
            //create mutable composition
            
            AVMutableComposition *mixComposition = [AVMutableComposition composition];
            
            
            
            AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                
                                                                                           preferredTrackID:kCMPersistentTrackID_Invalid];
            
            
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            NSError *videoInsertError = nil;
            
            BOOL videoInsertResult = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                      
                                                                    ofTrack: videoAssetTrack
                                      
                                                                     atTime:kCMTimeZero
                                      
                                                                      error:&videoInsertError];
            
            
            
    compositionVideoTrack.preferredTransform = videoAssetTrack.preferredTransform;
    
            if (!videoInsertResult || nil != videoInsertError) {
                
                //handle error
                
                NSLog(@"%@",videoInsertError);
                
                return;
                
            }
            
            
            
            //slow down whole video by 2.0
            
            double videoScaleFactor = rate;
            
            CMTime videoDuration = videoAsset.duration;
    
            [compositionVideoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
             
                                       toDuration:CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale)];
            
            
            
            
            
            AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSError *error;
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [audioAsset duration]) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:&error];
    
            
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *outputURL = paths[0];
            
            NSFileManager *manager = [NSFileManager defaultManager];
            
            [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
            
            outputURL = [outputURL stringByAppendingPathComponent:@"output.mov"];
            
            //Remove Existing File
            
            [manager removeItemAtPath:outputURL error:nil];
            
            
            
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
            
            exportSession.outputURL = [NSURL fileURLWithPath:outputURL]; // output path;
            
            exportSession.outputFileType = AVFileTypeQuickTimeMovie;
            
            exportSession.shouldOptimizeForNetworkUse = YES;
            
            
            
            [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
                
                if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                    
                    NSLog(@"success video saved");
                    
                    [self writeVideoToPhotoLibrary:[NSURL fileURLWithPath:outputURL]];
                    
                } else {
                    
                    NSLog(@"error: %@", [exportSession error]);
                    
                }
                
            }];
}



-(void)processThread:(CGFloat)rate {
    @autoreleasepool {

        long numChannels = 1;           // DIRAC LE allows mono only

        float sampleRate = 44100.;

        // open input file

        [self.reader openFileForRead:self.inUrl sr:sampleRate channels:numChannels];

        // create output file (overwrite if exists)

        [self.writer openFileForWrite:self.outUrl sr:sampleRate channels:numChannels wordLength:16 type:kAudioFileAIFFType];

        // DIRAC parameters

        // Here we set our time an pitch manipulation values

        float time      = rate;                 // 115% length

        float pitch     = pow(2., 0./12.);     // pitch shift (0 semitones)

        float formant   = pow(2., 0./12.);    // formant shift (0 semitones). Note formants are reciprocal to pitch in natural transposing


        // First we set up DIRAC to process numChannels of audio at 44.1kHz

        // N.b.: The fastest option is kDiracLambdaPreview / kDiracQualityPreview, best is kDiracLambda3, kDiracQualityBest

        // The probably best *default* option for general purpose signals is kDiracLambda3 / kDiracQualityGood

        void *dirac = DiracCreate(kDiracLambdaPreview, kDiracQualityPreview, numChannels, sampleRate, &myReadData, (__bridge void*)self);

            //      void *dirac = DiracCreate(kDiracLambda3, kDiracQualityBest, numChannels, sampleRate, &myReadData);

        if (!dirac) {

            exit(-1);

        }

        // Pass the values to our DIRAC instance

        DiracSetProperty(kDiracPropertyTimeFactor, time, dirac);

        DiracSetProperty(kDiracPropertyPitchFactor, pitch, dirac);

        DiracSetProperty(kDiracPropertyFormantFactor, formant, dirac);

        // upshifting pitch will be slower, so in this case we'll enable constant CPU pitch shifting

        if (pitch > 1.0)

            DiracSetProperty(kDiracPropertyUseConstantCpuPitchShift, 1, dirac);

        // Print our settings to the console

        DiracPrintSettings(dirac);

        // Get the number of frames from the file to display our simplistic progress bar

        SInt64 numf = [self.reader fileNumFrames];

        SInt64 outframes = 0;

        SInt64 newOutframe = numf*time;

        long lastPercent = -1;
        
        long percent = 0;

        // This is an arbitrary number of frames per call. Change as you see fit

        long numFrames = 8192;

        // Allocate buffer for output

        float **audio = AllocateAudioBuffer(numChannels, numFrames);

        double bavg = 0;

            // MAIN PROCESSING LOOP STARTS HERE

        for(;;) {
            // Display ASCII style "progress bar"

            percent = 100.f*(double)outframes / (double)newOutframe;

            long ipercent = percent;

            if (lastPercent != percent) {

                lastPercent = ipercent;

                fflush(stdout);

            }
       DiracStartClock();                                                              // ............................. start timer ..........................................

                // Call the DIRAC process function with current time and pitch settings

                // Returns: the number of frames in audio

            long ret = DiracProcess(audio, numFrames, dirac);

            bavg += (numFrames/sampleRate);

            gExecTimeTotal += DiracClockTimeSeconds();              // ............................. stop timer ..........................................
            

                // Process only as many frames as needed

            long framesToWrite = numFrames;

            unsigned long nextWrite = outframes + numFrames;

            if (nextWrite > newOutframe) framesToWrite = numFrames - nextWrite + newOutframe;

            if (framesToWrite < 0) framesToWrite = 0;

            // Write the data to the output file

            [self.writer writeFloats:framesToWrite fromArray:audio];

            // Increase our counter for the progress bar

            outframes += numFrames;

                // As soon as we've written enough frames we exit the main loop

            if (ret <= 0) break;

        }
        percent = 100;

        // Free buffer for output

        DeallocateAudioBuffer(audio, numChannels);

        

            // destroy DIRAC instance

        DiracDestroy( dirac );

    
        
//    [reader release];
//
        [self.writer closeFile]; // important - flushes data to file
//
    }
}


/*
 This is the callback function that supplies data from the input stream/file whenever needed.
 It should be implemented in your software by a routine that gets data from the input/buffers.
 The read requests are *always* consecutive, ie. the routine will never have to supply data out
 of order.
 */
long myReadData(float **chdata, long numFrames, void *userData)
{
    // The userData parameter can be used to pass information about the caller (for example, "self") to
    // the callback so it can manage its audio streams.
    if (!chdata)	return 0;
    
    GCVideoProcessor *Self = (__bridge GCVideoProcessor*)userData;
    if (!Self)	return 0;
    
    // we want to exclude the time it takes to read in the data from disk or memory, so we stop the clock until
    // we've read in the requested amount of data
    gExecTimeTotal += DiracClockTimeSeconds(); 		// ............................. stop timer ..........................................
    
    OSStatus err = [Self.reader readFloatsConsecutive:numFrames intoArray:chdata];
    
    DiracStartClock();								// ............................. start timer ..........................................
    
    return err;
    
}

- (void)writeVideoToPhotoLibrary:(NSURL *)url

{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    
    
    [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
        
        if (error) {
            
            NSLog(@"Video could not be saved");
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(){
                NSLog(@"assetURL %@", assetURL);
                [self.delegate processesdVideoURL:assetURL];
            });
            
        }
        
    }];
    
}

@end
