//
//  IMGLYVideoEditorViewController.swift
//  GoldCleats
//
//  Created by Raju Gautam on 10/12/15.
//  Copyright © 2015 Raju Gautam. All rights reserved.
//
import UIKit
import MediaPlayer
import Photos
import AssetsLibrary
//    @objc public enum IMGLYEditorResult: Int {
//        case Done
//        case Cancel
//    }
//
@objc public enum IMGLYVideoMenuButtonType: Int {
    case Filter
    case Crop
    case Zoom
    case Sound
}
//
//    public typealias IMGLYVideoEditorCompletionBlock = (IMGLYEditorResult, UIImage?) -> Void
//

private let ButtonCollectionViewCellReuseIdentifier = "ButtonCollectionViewCell"
private let ButtonCollectionViewCellSize = CGSize(width: 66, height: 90)
private let BottomControlSize = CGSize(width: 47, height: 47)
private let FilterSelectionViewHeight = 100

private var centerModeButtonConstraint: NSLayoutConstraint?
private var cameraPreviewContainerTopConstraint: NSLayoutConstraint?
private var cameraPreviewContainerBottomConstraint: NSLayoutConstraint?

public class IMGLYVideoEditorViewController: UIViewController, VideoRangeSliderDelegate {
    
    // MARK: - Properties
    
    public private(set) lazy var cameraPreviewContainer: UIView = {
        self.moviePlayer = MPMoviePlayerController(contentURL: self.videoURL)
        if let player = self.moviePlayer {
            //player.view.frame = self.view.bounds
            player.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
            player.controlStyle = .None
            player.repeatMode = .One
            player.play()
            player.scalingMode = .AspectFill
        }
        let playerView : UIView = self.moviePlayer!.view
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.clipsToBounds = true
        return playerView
        }()
    
    public private(set) lazy var backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    
//    public lazy var actionButtons: [IMGLYActionButton] = {
//        let bundle = NSBundle(forClass: self.dynamicType)
//        var handlers = [IMGLYActionButton]()
//        
//        handlers.append(
//            IMGLYActionButton(
//                title: NSLocalizedString("main-editor.button.filter", tableName: nil, bundle: bundle, value: "", comment: ""),
//                image: UIImage(named: "icon_option_filters", inBundle: bundle, compatibleWithTraitCollection: nil),
//                handler: { [unowned self] in self.subEditorButtonPressed(.Filter) }))
//        
//        handlers.append(
//            IMGLYActionButton(
//                title: NSLocalizedString("main-editor.button.focus", tableName: nil, bundle: bundle, value: "", comment: ""),
//                image: UIImage(named: "icon_option_focus", inBundle: bundle, compatibleWithTraitCollection: nil),
//                handler: { [unowned self] in self.subEditorButtonPressed(.Focus) }))
//        
//        handlers.append(
//            IMGLYActionButton(
//                title: NSLocalizedString("main-editor.button.crop", tableName: nil, bundle: bundle, value: "", comment: ""),
//                image: UIImage(named: "icon_option_crop", inBundle: bundle, compatibleWithTraitCollection: nil),
//                handler: { [unowned self] in self.subEditorButtonPressed(.Crop) }))
//        
//        return handlers
//        }()
    
    public private(set) lazy var cameraRollButton: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon_option_filters", inBundle: bundle, compatibleWithTraitCollection: nil), forState: .Normal)
        button.imageView?.contentMode = .ScaleAspectFill
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.addTarget(self, action: "toggleFilters:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    public private(set) lazy var actionButtonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    
    public private(set) lazy var rightBarButtonItem: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button:UIButton = UIButton(frame: CGRectMake(0, 0, 50, 20))
        button.setTitle("Next", forState: .Normal)
        button.titleLabel?.textAlignment = .Right
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 17)
        button.setTitleColor(UIColor.init(red:52.0/255.0, green:125.0/255.0, blue:204.0/255.0, alpha:1.0), forState: .Normal)
        button.addTarget(self, action: "tappedDone:", forControlEvents: .TouchUpInside)
        return button
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .White)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    
    public private(set) lazy var recordingTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        label.textColor = UIColor.whiteColor()
        label.text = "00:00"
        return label
        }()
    
    public private(set) var actionButton: UIControl?
    
    public private(set) lazy var filterSelectionButton: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon_option_focus", inBundle: bundle, compatibleWithTraitCollection: nil), forState: .Normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.addTarget(self, action: "toggleFilters:", forControlEvents: .TouchUpInside)
        button.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        return button
        }()
    
    public private(set) lazy var cropSelectionButton: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon_option_crop", inBundle: bundle, compatibleWithTraitCollection: nil), forState: .Normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.addTarget(self, action: "cropVideo:", forControlEvents: .TouchUpInside)
        button.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        return button
        }()
    
    public private(set) lazy var bottomControlsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 27.0/255.0, green: 30.0/255.0, blue: 32.0/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    
    public private(set) lazy var bottomEditorView: VideoRangeSlider = {
        let view = VideoRangeSlider(frame: CGRectMake(10, 15, self.view.frame.size.width - 20, 70), videoUrl:self.videoURL)
        view.setPopoverBubbleSize(100, height:50)
        view.bubleText.font = UIFont.systemFontOfSize(12)
        view.backgroundColor = UIColor.blackColor()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
        }()
    
    public var completionBlock: IMGLYEditorCompletionBlock?
    public var initialFilterType = IMGLYFilterType.None
    public var initialFilterIntensity = NSNumber(double: 0.75)
    public private(set) var fixedFilterStack = IMGLYFixedFilterStack()
    public let filterSelectionController = IMGLYFilterSelectionController()
    private var filterSelectionViewConstraint: NSLayoutConstraint?
    private var cropSelectionViewConstraint: NSLayoutConstraint?
    var moviePlayer : MPMoviePlayerController?
    private let maxLowResolutionSideLength = CGFloat(1600)
    var videoURL: NSURL?
    var isFromLibrary:Bool?
    
    // MARK: - UIViewController
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        navigationItem.title = NSLocalizedString("main-editor.title", tableName: nil, bundle: bundle, value: "", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelTapped:")
//        let rightBtn1:UIBarButtonItem =
//        let rightBtn2:UIBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
//        
//        let barButtons:NSArray = [rightBtn1, rightBtn2]
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonItem)
        
        navigationController?.delegate = self
        
        fixedFilterStack.effectFilter = IMGLYInstanceFactory.effectFilterWithType(initialFilterType)
        fixedFilterStack.effectFilter.inputIntensity = initialFilterIntensity
        
        //updatePreviewImage()
        configureViewHierarchy()
        configureViewConstraints()
        //toggleFilters(filterSelectionButton)
        //updateConstraintsForRecordingMode()
        //configureMenuCollectionView()
    }
    
    
    private func configureViewHierarchy() {
        view.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(cameraPreviewContainer)
        
        
        view.addSubview(bottomControlsView)
        view.addSubview(bottomEditorView)
        
        
        addChildViewController(filterSelectionController)
        filterSelectionController.didMoveToParentViewController(self)
        view.addSubview(filterSelectionController.view)
        
        bottomControlsView.addSubview(cameraRollButton)
        bottomControlsView.addSubview(cropSelectionButton)
        bottomControlsView.addSubview(filterSelectionButton)
        
        // Add Video Crop control to bottomEditorView, here
        
    }
    
    
    private func configureViewConstraints() {
        let views: [String : AnyObject] = [
            "backgroundContainerView" : backgroundContainerView,
            "topLayoutGuide" : topLayoutGuide,
            "cameraPreviewContainer" : cameraPreviewContainer,
            "bottomControlsView" : bottomControlsView,
            "bottomEditorView" : bottomEditorView,
            "filterSelectionView" : filterSelectionController.view,
            "cameraRollButton" : cameraRollButton,
            "cropSelectionButton" : cropSelectionButton,
            "filterSelectionButton" : filterSelectionButton
        ]
        
        let metrics: [String : AnyObject] = [
            "topControlsViewHeight" : 64,
            "filterSelectionViewHeight" : FilterSelectionViewHeight,
            "topControlMargin" : 20,
            "topControlMinWidth" : 44
        ]
        
        configureSuperviewConstraintsWithMetrics(metrics, views: views)
        configureBottomControlsConstraintsWithMetrics(metrics, views: views)
    }
    
    private func configureSuperviewConstraintsWithMetrics(metrics: [String : AnyObject], views: [String : AnyObject]) {
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[backgroundContainerView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundContainerView]|", options: [], metrics: nil, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[cameraPreviewContainer]|", options: [], metrics: nil, views: views))
        //view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cameraPreviewContainer(>=150,<=320)]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[bottomControlsView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[bottomEditorView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[filterSelectionView]|", options: [], metrics: nil, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cameraPreviewContainer][bottomControlsView(==topControlsViewHeight)]", options: [], metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bottomControlsView][bottomEditorView(==filterSelectionViewHeight)]", options: [], metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bottomEditorView][filterSelectionView(==filterSelectionViewHeight)]", options: [], metrics: metrics, views: views))
        
        
        //            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bottomControlsView][bottomEditorView(==filterSelectionViewHeight)]", options: [], metrics: metrics, views: views))
        
        cameraPreviewContainerTopConstraint = NSLayoutConstraint(item: cameraPreviewContainer, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0)
        cameraPreviewContainerBottomConstraint = NSLayoutConstraint(item: cameraPreviewContainer, attribute: .Bottom, relatedBy: .Equal, toItem: bottomControlsView, attribute: .Top, multiplier: 1, constant: 0)
        
        view.addConstraints([cameraPreviewContainerTopConstraint!, cameraPreviewContainerBottomConstraint!])
        
        //            cropSelectionViewConstraint = NSLayoutConstraint(item: bottomEditorView, attribute: .Top, relatedBy: .Equal, toItem: bottomControlsView, attribute: .Bottom, multiplier: 1, constant: 0)
        //            view.addConstraint(cropSelectionViewConstraint!)
        
        filterSelectionViewConstraint = NSLayoutConstraint(item: filterSelectionController.view, attribute: .Top, relatedBy: .Equal, toItem: bottomLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(filterSelectionViewConstraint!)
    }
    
    
    private func configureBottomControlsConstraintsWithMetrics(metrics: [String : AnyObject], views: [String : AnyObject]) {
        //            if recordingModeSelectionButtons.count > 0 {
        //                // Mode Buttons
        //                for i in 0 ..< recordingModeSelectionButtons.count - 1 {
        //                    let leftButton = recordingModeSelectionButtons[i]
        //                    let rightButton = recordingModeSelectionButtons[i + 1]
        //
        //                    bottomControlsView.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .Right, relatedBy: .Equal, toItem: rightButton, attribute: .Left, multiplier: 1, constant: -20))
        //                    bottomControlsView.addConstraint(NSLayoutConstraint(item: leftButton, attribute: .Baseline, relatedBy: .Equal, toItem: rightButton, attribute: .Baseline, multiplier: 1, constant: 0))
        //                }
        
        //                centerModeButtonConstraint = NSLayoutConstraint(item: recordingModeSelectionButtons[0], attribute: .CenterX, relatedBy: .Equal, toItem: actionButtonContainer, attribute: .CenterX, multiplier: 1, constant: 0)
        //                bottomControlsView.addConstraint(centerModeButtonConstraint!)
        //                bottomControlsView.addConstraint(NSLayoutConstraint(item: recordingModeSelectionButtons[0], attribute: .Bottom, relatedBy: .Equal, toItem: actionButtonContainer, attribute: .Top, multiplier: 1, constant: -5))
        //                bottomControlsView.addConstraint(NSLayoutConstraint(item: bottomControlsView, attribute: .Top, relatedBy: .Equal, toItem: recordingModeSelectionButtons[0], attribute: .Top, multiplier: 1, constant: -5))
        //            } else {
        //                bottomControlsView.addConstraint(NSLayoutConstraint(item: bottomControlsView, attribute: .Top, relatedBy: .Equal, toItem: actionButtonContainer, attribute: .Top, multiplier: 1, constant: -5))
        //            }
        
        // CameraRollButton
        cameraRollButton.addConstraint(NSLayoutConstraint(item: cameraRollButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.width))
        cameraRollButton.addConstraint(NSLayoutConstraint(item: cameraRollButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.height))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: cameraRollButton, attribute: .CenterY, relatedBy: .Equal, toItem: bottomControlsView, attribute: .CenterY, multiplier: 1, constant: 0))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: cameraRollButton, attribute: .Left, relatedBy: .Equal, toItem: bottomControlsView, attribute: .Left, multiplier: 1, constant: 10))
        
        // CropSelectionButton
        cropSelectionButton.addConstraint(NSLayoutConstraint(item: cropSelectionButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.width))
        cropSelectionButton.addConstraint(NSLayoutConstraint(item: cropSelectionButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.height))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: cropSelectionButton, attribute: .CenterY, relatedBy: .Equal, toItem: bottomControlsView, attribute: .CenterY, multiplier: 1, constant: 0))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: cropSelectionButton, attribute: .CenterX, relatedBy: .Equal, toItem: bottomControlsView, attribute: .CenterX, multiplier: 1, constant: 0))
        
        //            // ActionButtonContainer
        //            cropSelectionButton.addConstraint(NSLayoutConstraint(item: actionButtonContainer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 70))
        //            actionButtonContainer.addConstraint(NSLayoutConstraint(item: actionButtonContainer, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 70))
        //            bottomControlsView.addConstraint(NSLayoutConstraint(item: actionButtonContainer, attribute: .CenterX, relatedBy: .Equal, toItem: bottomControlsView, attribute: .CenterX, multiplier: 1, constant: 0))
        //            bottomControlsView.addConstraint(NSLayoutConstraint(item: bottomControlsView, attribute: .Bottom, relatedBy: .Equal, toItem: bottomControlsView, attribute: .Bottom, multiplier: 1, constant: 10))
        
        // FilterSelectionButton
        filterSelectionButton.addConstraint(NSLayoutConstraint(item: filterSelectionButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.width))
        filterSelectionButton.addConstraint(NSLayoutConstraint(item: filterSelectionButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.height))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: filterSelectionButton, attribute: .CenterY, relatedBy: .Equal, toItem: bottomControlsView, attribute: .CenterY, multiplier: 1, constant: 0))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: filterSelectionButton, attribute: .Right, relatedBy: .Equal, toItem: bottomControlsView, attribute: .Right, multiplier: 1, constant: 0))
    }
    
    private func updateConstraintsForRecordingMode() {
        if let cameraPreviewContainerTopConstraint = cameraPreviewContainerTopConstraint {
            view.removeConstraint(cameraPreviewContainerTopConstraint)
        }
        
        if let cameraPreviewContainerBottomConstraint = cameraPreviewContainerBottomConstraint {
            view.removeConstraint(cameraPreviewContainerBottomConstraint)
        }
        
        
        cameraPreviewContainerTopConstraint = NSLayoutConstraint(item: cameraPreviewContainer, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0)
        cameraPreviewContainerBottomConstraint = NSLayoutConstraint(item: cameraPreviewContainer, attribute: .Bottom, relatedBy: .Equal, toItem: bottomControlsView, attribute: .Top, multiplier: 1, constant: 0)
        
        view.addConstraints([cameraPreviewContainerTopConstraint!, cameraPreviewContainerBottomConstraint!])
    }
    
    
    // MARK: - Video Slider delegate func
    @objc public func videoRange(slider:VideoRangeSlider?, didChangeLeftPosition:CGFloat, rightPosition:CGFloat) {
        print("slider values \(didChangeLeftPosition) and \(rightPosition)")
        //self.moviePlayer?.pause()
        self.moviePlayer?.initialPlaybackTime = Double(didChangeLeftPosition)
        self.moviePlayer?.endPlaybackTime = Double(rightPosition)
        self.moviePlayer?.play()
    }
    // MARK: - Targets
    public func toggleFilters(sender: UIButton?) {
        if let filterSelectionViewConstraint = self.filterSelectionViewConstraint {
            let animationDuration = NSTimeInterval(0.6)
            let dampingFactor = CGFloat(0.6)
            
            if filterSelectionViewConstraint.constant == 0 {
                // Expand
                filterSelectionController.beginAppearanceTransition(true, animated: true)
                filterSelectionViewConstraint.constant = -1 * CGFloat(FilterSelectionViewHeight)
                //                    self.cropSelectionViewConstraint!.constant = 1 * CGFloat(FilterSelectionViewHeight)
                UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: dampingFactor, initialSpringVelocity: 0, options: [], animations: {
                    sender?.transform = CGAffineTransformIdentity
                    //self.bottomEditorView.removeFromSuperview()
                    self.view.layoutIfNeeded()
                    }, completion: { finished in
                        self.filterSelectionController.endAppearanceTransition()
                })
            } else {
                // Close
                filterSelectionController.beginAppearanceTransition(false, animated: true)
                filterSelectionViewConstraint.constant = 0
                //                    self.cropSelectionViewConstraint!.constant = -1 * CGFloat(FilterSelectionViewHeight)
                UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: dampingFactor, initialSpringVelocity: 0, options: [], animations: {
                    sender?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                    //self.view.addSubview(self.bottomEditorView)
                    self.view.layoutIfNeeded()
                    }, completion: { finished in
                        self.filterSelectionController.endAppearanceTransition()
                })
            }
        }
    }
    
    public func cropVideo(sender:UIButton?) {
        
    }
    
    // MARK: - Configuration
    
    //        private func configureMenuCollectionView() {
    //            let flowLayout = UICollectionViewFlowLayout()
    //            flowLayout.itemSize = ButtonCollectionViewCellSize
    //            flowLayout.scrollDirection = .Horizontal
    //            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    //            flowLayout.minimumInteritemSpacing = 0
    //            flowLayout.minimumLineSpacing = 0
    //
    //            let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
    //            collectionView.translatesAutoresizingMaskIntoConstraints = false
    //            collectionView.dataSource = self
    //            collectionView.delegate = self
    //            collectionView.registerClass(IMGLYButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCellReuseIdentifier)
    //
    //            let views = [ "collectionView" : collectionView ]
    //            bottomContainerView.addSubview(collectionView)
    //            bottomContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[collectionView]|", options: [], metrics: nil, views: views))
    //            bottomContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: [], metrics: nil, views: views))
    //        }
    
    // MARK: - Helpers
    
//    private func subEditorButtonPressed(buttonType: IMGLYMainMenuButtonType) {
//        if (buttonType == IMGLYMainMenuButtonType.Magic) {
//            if !updating {
//                fixedFilterStack.enhancementFilter.enabled = !fixedFilterStack.enhancementFilter.enabled
//                updatePreviewImage()
//            }
//        } else {
//            if let viewController = IMGLYInstanceFactory.viewControllerForButtonType(buttonType, withFixedFilterStack: fixedFilterStack) {
//                viewController.lowResolutionImage = lowResolutionImage
//                viewController.previewImageView.image = previewImageView.image
//                viewController.completionHandler = subEditorDidComplete
//                
//                showViewController(viewController, sender: self)
//            }
//        }
//    }
    
//    private func subEditorDidComplete(image: UIImage?, fixedFilterStack: IMGLYFixedFilterStack) {
//        previewImageView.image = image
//        self.fixedFilterStack = fixedFilterStack
//    }
    
    
//    private func updatePreviewImage() {
//        if let lowResolutionImage = self.lowResolutionImage {
//            updating = true
//            dispatch_async(PhotoProcessorQueue) {
//                let processedImage = IMGLYPhotoProcessor.processWithUIImage(lowResolutionImage, filters: self.fixedFilterStack.activeFilters)
//                
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.previewImageView.image = processedImage
//                    self.updating = false
//                }
//            }
//        }
//    }
    
    private func saveMovieWithMovieURLToAssets(movieURL: NSURL) {
        
        let library: ALAssetsLibrary = ALAssetsLibrary()
        let videoWriteCompletionBlock: ALAssetsLibraryWriteVideoCompletionBlock = {(newURL: NSURL!, error: NSError!) in
            if (error != nil) {
                print("Error writing image with metadata to Photo Library: \(error)")
            }
            else {
                self.pushShareScreenWithVideoUrl(newURL)
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(movieURL)
                } catch _ {
                }
            }
            
        }
        if library.videoAtPathIsCompatibleWithSavedPhotosAlbum(movieURL) {
            library.writeVideoAtPathToSavedPhotosAlbum(movieURL, completionBlock: videoWriteCompletionBlock)
        }
        
//        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
//            PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(movieURL)
//            }) { success, error in
//                if let error = error {
//                    dispatch_async(dispatch_get_main_queue()) {
//                        let bundle = NSBundle(forClass: self.dynamicType)
//                        
//                        let alertController = UIAlertController(title: NSLocalizedString("camera-view-controller.error-saving-video.title", tableName: nil, bundle: bundle, value: "", comment: ""), message: error.localizedDescription, preferredStyle: .Alert)
//                        let cancelAction = UIAlertAction(title: NSLocalizedString("camera-view-controller.error-saving-video.cancel", tableName: nil, bundle: bundle, value: "", comment: ""), style: .Cancel, handler: nil)
//                        
//                        alertController.addAction(cancelAction)
//                        
//                        self.presentViewController(alertController, animated: true, completion: nil)
//                    }
//                }
//                
//                do {
//                    try NSFileManager.defaultManager().removeItemAtURL(movieURL)
//                } catch _ {
//                }
//        }
    }
    // MARK: - EditorViewController
    
    public func tappedDone(sender: UIBarButtonItem?) {
        navigationItem.rightBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        activityIndicatorView.startAnimating()
        if !(isFromLibrary ?? true) {
            self.saveMovieWithMovieURLToAssets(videoURL!)
        } else {
            self.pushShareScreenWithVideoUrl(videoURL!)
        }
    }
    
    private func pushShareScreenWithVideoUrl(newVideoPath:NSURL) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let shareViewController : GCShareVideoViewController = storyboard.instantiateViewControllerWithIdentifier("SHARE_VIDEO_CONTROLLER") as! GCShareVideoViewController
        shareViewController.freshVideo = true
        shareViewController.videoUrl = newVideoPath
        //        let navigationController = UINavigationController(rootViewController: shareViewController)
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor() ]
        
        self.navigationController?.pushViewController(shareViewController, animated: true)
    }
    
    @objc private func cancelTapped(sender: UIBarButtonItem?) {
//        if let completionBlock = completionBlock {
//            completionBlock(.Cancel, nil)
//        } else {
            let viewControllers:NSArray = (self.navigationController?.viewControllers)!
        
        self.navigationController?.popToViewController(viewControllers[0] as! UIViewController, animated: true)
            self.navigationController?.popToRootViewControllerAnimated(true)
//        }
    }
    
//    public override var enableZoomingInPreviewImage: Bool {
//        return true
//    }
}

//    extension IMGLYVideoEditorViewController: UICollectionViewDataSource {
//        public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return actionButtons.count
//        }
//
//        public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ButtonCollectionViewCellReuseIdentifier, forIndexPath: indexPath)
//
//            if let buttonCell = cell as? IMGLYButtonCollectionViewCell {
//                let actionButton = actionButtons[indexPath.item]
//
//                if let selectedImage = actionButton.selectedImage, let showSelectionBlock = actionButton.showSelection where showSelectionBlock() {
//                    buttonCell.imageView.image = selectedImage
//                } else {
//                    buttonCell.imageView.image = actionButton.image
//                }
//
//                buttonCell.textLabel.text = actionButton.title
//            }
//
//            return cell
//        }
//    }
//
//    extension IMGLYVideoEditorViewController: UICollectionViewDelegate {
//        public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//            let actionButton = actionButtons[indexPath.item]
//            actionButton.handler()
//
//            if actionButton.selectedImage != nil && actionButton.showSelection != nil {
//                collectionView.reloadItemsAtIndexPaths([indexPath])
//            }
//        }
//    }

extension IMGLYVideoEditorViewController: UINavigationControllerDelegate {
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return IMGLYNavigationAnimationController()
    }
}

