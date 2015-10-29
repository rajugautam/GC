//
//  GCVideoProcessor.m
//  GoldCleats
//
//  Created by Raju Gautam on 10/29/15.
//  Copyright © 2015 Raju Gautam. All rights reserved.
//

#import "GCVideoProcessor.h"
#import <AVFoundation/AVFoundation.h>

@import AssetsLibrary;

@implementation GCVideoProcessor

- (void)processVideoAtPath:(NSURL*)url atScaleRate:(CGFloat)rate {
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
        
        NSLog(@"%@",videoInsertError);
        
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
            
            NSLog(@"success");
            
            [self writeAudioToPhotoLibrary:url atScaleRate:rate];
            
        } else {
            
            NSLog(@"error: %@", [exportSession error]);
            
            //error: Error Domain=AVFoundationErrorDomain Code=-11800 "The operation could not be completed" UserInfo=0x2023b720 {NSLocalizedDescription=The operation could not be completed, NSUnderlyingError=0x2023bb70 "The operation couldn’t be completed. (OSStatus error -12780.)", NSLocalizedFailureReason=An unknown error occurred (-12780)}
            
        }
        
    }];
}



- (void)writeAudioToPhotoLibrary:(NSURL *)url atScaleRate:(CGFloat)rate

{
    
    NSLog(@"%@",url);
    
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    
//    
//    
//    [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
//        
//        if (error) {
//            
//            NSLog(@"Video could not be saved");
//            
//        }else{
    
            
            
            //            NSString *outputSound = [[NSHomeDirectory() stringByAppendingString:@"/Documents/"] stringByAppendingString:@"outnew.aif"];
            
            //            inUrl = [url retain];
            
            //            outUrl = [NSURL fileURLWithPath:outputSound];
            
            //            reader = [[EAFRead alloc] init];
            
            //            writer = [[EAFWrite alloc] init];
            
            //
            
            //                // this thread does the processing
            
            //            [NSThread detachNewThreadSelector:@selector(processThread:) toTarget:self withObject:nil];
            
            
            
            AVAsset *videoAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
            
            
            
            //            AVAssetTrack *assetAudioTrack = nil;
            
            
            
            //            if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
            
            //                assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
            
            //            }
            
            
            
            
            
            //            NSString *audioURL = outputSound;
            
            //            NSLog(@"%@",audioURL);
            
            //            AVAsset *audioAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:audioURL] options:nil];
            
            
            
            //create mutable composition
            
            AVMutableComposition *mixComposition = [AVMutableComposition composition];
            
            
            
            AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                
                                                                                           preferredTrackID:kCMPersistentTrackID_Invalid];
            
            
            
            NSError *videoInsertError = nil;
            
            BOOL videoInsertResult = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                      
                                                                    ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                      
                                                                     atTime:kCMTimeZero
                                      
                                                                      error:&videoInsertError];
            
            
            
            
            
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
            
            
            
            
            
//            AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//            
//            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [audioAsset duration]) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:&error];
            
            
            
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
                    
                    //error: Error Domain=AVFoundationErrorDomain Code=-11800 "The operation could not be completed" UserInfo=0x2023b720 {NSLocalizedDescription=The operation could not be completed, NSUnderlyingError=0x2023bb70 "The operation couldn’t be completed. (OSStatus error -12780.)", NSLocalizedFailureReason=An unknown error occurred (-12780)}
                    
                }
                
            }];
            
            
            
            //            MPMoviePlayerViewController* theMovie =
            
            //            [[MPMoviePlayerViewController alloc] initWithContentURL: [info objectForKey:
            
            //                                                                      UIImagePickerControllerMediaURL]];
            
            //
            
            //            theMovie.moviePlayer.currentPlaybackRate = 0.25f;
            
            //
            
            //            theMovie.moviePlayer.fullscreen = YES;
            
            //            [theMovie.moviePlayer play];
            
            //            [self presentMoviePlayerViewControllerAnimated:theMovie];
            
            
            
//        }
//        
//    }];
    
}



//-(void)processThread:(id)param

//{

//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

//

//    long numChannels = 1;           // DIRAC LE allows mono only

//    float sampleRate = 44100.;

//

//        // open input file

//    [reader openFileForRead:inUrl sr:sampleRate channels:numChannels];

//

//        // create output file (overwrite if exists)

//    [writer openFileForWrite:outUrl sr:sampleRate channels:numChannels wordLength:16 type:kAudioFileAIFFType];

//

//        // DIRAC parameters

//        // Here we set our time an pitch manipulation values

//    float time      = 1.75;                 // 115% length

//    float pitch     = pow(2., 0./12.);     // pitch shift (0 semitones)

//    float formant   = pow(2., 0./12.);    // formant shift (0 semitones). Note formants are reciprocal to pitch in natural transposing

//

//        // First we set up DIRAC to process numChannels of audio at 44.1kHz

//        // N.b.: The fastest option is kDiracLambdaPreview / kDiracQualityPreview, best is kDiracLambda3, kDiracQualityBest

//        // The probably best *default* option for general purpose signals is kDiracLambda3 / kDiracQualityGood

//    void *dirac = DiracCreate(kDiracLambdaPreview, kDiracQualityPreview, numChannels, sampleRate, &myReadData, (void*)self);

//        //      void *dirac = DiracCreate(kDiracLambda3, kDiracQualityBest, numChannels, sampleRate, &myReadData);

//    if (!dirac) {

//        exit(-1);

//    }

//

//        // Pass the values to our DIRAC instance

//    DiracSetProperty(kDiracPropertyTimeFactor, time, dirac);

//    DiracSetProperty(kDiracPropertyPitchFactor, pitch, dirac);

//    DiracSetProperty(kDiracPropertyFormantFactor, formant, dirac);

//

//        // upshifting pitch will be slower, so in this case we'll enable constant CPU pitch shifting

//    if (pitch > 1.0)

//        DiracSetProperty(kDiracPropertyUseConstantCpuPitchShift, 1, dirac);

//

//        // Print our settings to the console

//    DiracPrintSettings(dirac);

//

//        // Get the number of frames from the file to display our simplistic progress bar

//    SInt64 numf = [reader fileNumFrames];

//    SInt64 outframes = 0;

//    SInt64 newOutframe = numf*time;

//    long lastPercent = -1;

//    percent = 0;

//

//        // This is an arbitrary number of frames per call. Change as you see fit

//    long numFrames = 8192;

//

//        // Allocate buffer for output

//    float **audio = AllocateAudioBuffer(numChannels, numFrames);

//

//    double bavg = 0;

//

//        // MAIN PROCESSING LOOP STARTS HERE

//    for(;;) {

//

//            // Display ASCII style "progress bar"

//        percent = 100.f*(double)outframes / (double)newOutframe;

//        long ipercent = percent;

//        if (lastPercent != percent) {

//                //                      [self performSelectorOnMainThread:@selector(updateBarOnMainThread:) withObject:self waitUntilDone:NO];

//

//            lastPercent = ipercent;

//            fflush(stdout);

//        }

//

//        DiracStartClock();                                                              // ............................. start timer ..........................................

//

//            // Call the DIRAC process function with current time and pitch settings

//            // Returns: the number of frames in audio

//        long ret = DiracProcess(audio, numFrames, dirac);

//        bavg += (numFrames/sampleRate);

//        gExecTimeTotal += DiracClockTimeSeconds();              // ............................. stop timer ..........................................

//        

//            // Process only as many frames as needed

//        long framesToWrite = numFrames;

//        unsigned long nextWrite = outframes + numFrames;

//        if (nextWrite > newOutframe) framesToWrite = numFrames - nextWrite + newOutframe;

//        if (framesToWrite < 0) framesToWrite = 0;

//        

//            // Write the data to the output file

//        [writer writeFloats:framesToWrite fromArray:audio];

//        

//            // Increase our counter for the progress bar

//        outframes += numFrames;

//        

//            // As soon as we've written enough frames we exit the main loop

//        if (ret <= 0) break;

//    }

//    

//    percent = 100;

//        //      [self performSelectorOnMainThread:@selector(updateBarOnMainThread:) withObject:self waitUntilDone:NO];

//    

//    

//        // Free buffer for output

//    DeallocateAudioBuffer(audio, numChannels);

//    

//        // destroy DIRAC instance

//    DiracDestroy( dirac );

//    

//    [reader release];

//    [writer release]; // important - flushes data to file

//    

//        // start playback on main thread

//        //      [self performSelectorOnMainThread:@selector(playOnMainThread:) withObject:self waitUntilDone:NO];

//    

//    [pool release];

//}



- (void)writeVideoToPhotoLibrary:(NSURL *)url

{
    
    NSLog(@"%@",url);
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    
    
    [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
        
        if (error) {
            
            NSLog(@"Video could not be saved");
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self.delegate processesdVideoURL:assetURL];
            });
            
        }
        
    }];
    
}

@end
