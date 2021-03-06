//
//  IMGLYVideoEditorViewController.swift
//  GoldCleats
//
//  Created by Raju Gautam on 10/12/15.
//  Copyright © 2015 Raju Gautam. All rights reserved.
//
import UIKit
import MediaPlayer
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
private let SlowMoButtonSize = CGSize(width: 55, height: 90)
private let PointerControlSize = CGSize(width: 15, height: 9)
private let FilterSelectionViewHeight = 100

private let SpotLightControlViewHeight = 160

private var centerModeButtonConstraint: NSLayoutConstraint?
private var cameraPreviewContainerTopConstraint: NSLayoutConstraint?
private var cameraPreviewContainerBottomConstraint: NSLayoutConstraint?

public class IMGLYVideoEditorViewController: UIViewController, VideoRangeSliderDelegate, GCVideoProcessorDelegate{
    
    // MARK: - Properties
    
    public private(set) lazy var cameraPreviewContainer: UIView = {
        self.moviePlayer = MPMoviePlayerController(contentURL: self.videoURL)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("moviePlayingFinished"), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)

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
        
        
//        let asset_1 = AVAsset(URL: self.videoURL!) as AVAsset
//        let playerItem_1 = AVPlayerItem(asset: asset_1)
//        
//        let player_1 = AVPlayer(playerItem: playerItem_1)
//        
//        let playerLayer_1 = AVPlayerLayer(player: player_1)
//        
//        playerLayer_1.frame = CGRectMake(0, 0, self.view.frame.size.width, 150);
//        
//        self.view.layer.addSublayer(playerLayer_1)
//        player_1.con
//        player_1!.play()
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
    
    public private(set) lazy var filterSelectionButton: UIButton = {
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
    
    private(set) lazy var slowMoButton1: CustomButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = CustomButton()
        button.tag = 101
        button.setTitle("10%", forState: .Normal)
        button.titleLabel?.textAlignment = .Center
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_slowMo1"), forState: .Normal)
        button.setImage(UIImage(named: "ic_slowMo1_sel"), forState: .Selected)
        button.imageView?.contentMode = .ScaleAspectFill
        button.addTarget(self, action: "changeVideofps:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    private(set) lazy var slowMoButton2: CustomButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = CustomButton()
        button.tag = 102
        button.setTitle("25%", forState: .Normal)
        button.titleLabel?.textAlignment = .Center
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_slowMo2"), forState: .Normal)
        button.setImage(UIImage(named: "ic_slowMo2_sel"), forState: .Selected)
        button.imageView?.contentMode = .ScaleAspectFill
        button.addTarget(self, action: "changeVideofps:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    private(set) lazy var slowMoButton3: CustomButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = CustomButton()
        button.tag = 103
        button.setTitle("50%", forState: .Normal)
        button.titleLabel?.textAlignment = .Center
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_slowMo3"), forState: .Normal)
        button.setImage(UIImage(named: "ic_slowMo3_sel"), forState: .Selected)
        button.imageView?.contentMode = .ScaleAspectFill
        button.addTarget(self, action: "changeVideofps:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    private(set) lazy var slowMoButton4: CustomButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = CustomButton()
        button.tag = 104
        button.setTitle("1.5x", forState: .Normal)
        button.titleLabel?.textAlignment = .Center
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_slowMo4"), forState: .Normal)
        button.setImage(UIImage(named: "ic_slowMo4_sel"), forState: .Selected)
        button.imageView?.contentMode = .ScaleAspectFill
        button.addTarget(self, action: "changeVideofps:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    private(set) lazy var slowMoButton5: CustomButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = CustomButton()
        button.tag = 105
        button.setTitle("2.0x", forState: .Normal)
        button.titleLabel?.textAlignment = .Center
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_slowMo5"), forState: .Normal)
        button.setImage(UIImage(named: "ic_slowMo5_sel"), forState: .Selected)
        button.imageView?.contentMode = .ScaleAspectFill
        button.addTarget(self, action: "changeVideofps:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    private(set) lazy var finishSpotLightBtn: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_select_blue"), forState: .Normal)
        button.setImage(UIImage(named: "ic_select_blue"), forState: .Selected)
        button.imageView?.contentMode = .ScaleAspectFill
        button.addTarget(self, action: "processSpotLightVideo:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    private(set) lazy var cancelSpotLigthBtn: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_close_blue"), forState: .Normal)
        button.setImage(UIImage(named: "ic_close_blue"), forState: .Selected)
        button.imageView?.contentMode = .ScaleAspectFill
        button.addTarget(self, action: "dismissSpotLightControl:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    private(set) lazy var spotLight01: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = UIButton()
        button.tag = 201
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_spotlight01"), forState: .Normal)
        button.setImage(UIImage(named: "ic_spotlight01"), forState: .Selected)
        button.imageView?.contentMode = .ScaleAspectFill
        button.addTarget(self, action: "changeSpotlightRadius:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    
    private(set) lazy var spotLight02: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = UIButton()
        button.tag = 202
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_spotlight02"), forState: .Normal)
        button.setImage(UIImage(named: "ic_spotlight02"), forState: .Selected)
        button.imageView?.contentMode = .ScaleAspectFill
        button.addTarget(self, action: "changeSpotlightRadius:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    private(set) lazy var spotLight03: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = UIButton()
        button.tag = 203
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_spotlight03"), forState: .Normal)
        button.setImage(UIImage(named: "ic_spotlight03"), forState: .Selected)
        button.imageView?.contentMode = .ScaleAspectFill
        button.addTarget(self, action: "changeSpotlightRadius:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    private(set) lazy var spotLight04: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = UIButton()
        button.tag = 204
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_spotlight04"), forState: .Normal)
        button.setImage(UIImage(named: "ic_spotlight04"), forState: .Selected)
        button.imageView?.contentMode = .ScaleAspectFill
        button.addTarget(self, action: "changeSpotlightRadius:", forControlEvents: .TouchUpInside)
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
    
    public private(set) lazy var startSpotLightMsg: UILabel = {
        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.blackColor()
        label.layer.cornerRadius = 2
        label.textAlignment = .Center
        label.font = UIFont(name: "Helvetica-Medium", size: 14)
        label.layer.borderColor = UIColor.darkGrayColor().CGColor
        label.layer.borderWidth = 2
        label.backgroundColor = UIColor.whiteColor()
        label.text = "Hold Video to Apply"
        return label
        }()
    
    public private(set) lazy var spotLightTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 1
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.boldSystemFontOfSize(17)
        label.text = "SPOTLIGHT"
        return label
        }()
    
    public private(set) var actionButton: UIControl?
    
    public private(set) lazy var slowMoVideoButton: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setImage(UIImage(named: "icon_option_focus", inBundle: bundle, compatibleWithTraitCollection: nil), forState: .Normal)
        button.setImage(UIImage(named: "ic_turtle"), forState: .Normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.addTarget(self, action: "displaySlowMoControls:", forControlEvents: .TouchUpInside)

        return button
        }()
    
    public private(set) lazy var controlSelectionPointer:UIImageView = {
       let bundle = NSBundle(forClass: self.dynamicType)
        let pointer = UIImageView()
        pointer.image = UIImage.init(named: "ic_pointer")
        pointer.translatesAutoresizingMaskIntoConstraints = false
        return pointer
        
    }()
    
    public private(set) lazy var cropSelectionButton: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon_option_crop", inBundle: bundle, compatibleWithTraitCollection: nil), forState: .Normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.addTarget(self, action: "cropVideo:", forControlEvents: .TouchUpInside)
//        button.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        return button
        }()
    
    public private(set) lazy var spotLightSelectionButton: UIButton = {
        let bundle = NSBundle(forClass: self.dynamicType)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ic_spotlight04", inBundle: bundle, compatibleWithTraitCollection: nil), forState: .Normal)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.addTarget(self, action: "displaySpotlight:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    public private(set) lazy var bottomControlsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 27.0/255.0, green: 30.0/255.0, blue: 32.0/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    
    public private(set) lazy var bottomEditorView: VideoRangeSlider = {
        let view = VideoRangeSlider(frame: CGRectMake(0, 15, self.view.frame.size.width, 70), videoUrl:self.videoURL)
        view.setPopoverBubbleSize(120, height:60)
        view.bubleText.font = UIFont.systemFontOfSize(12)
        view.backgroundColor = UIColor.blackColor()
        view.delegate = self
        view.minGap = Int(VIDEORECORDMINLIMIT)
        view.maxGap = Int(VIDEORECORDMAXLIMIT)
//        view.minGap = 1
        view.topBorder.backgroundColor = UIColor.init(red: 0.945, green: 0.945, blue: 0.945, alpha: 1.0)
        view.bottomBorder.backgroundColor = UIColor.init(red: 0.806, green: 0.806, blue: 0.806, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
        }()
    
    public private(set) lazy var slowMotionControlView:UIView = {
       let view = UIView()
        //view.backgroundColor = UIColor.init(red: 27.0/255.0, green: 30.0/255.0, blue: 32.0/255, alpha: 1)
        view.backgroundColor = UIColor.blackColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public private(set) lazy var spotLightControlView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 27.0/255.0, green: 30.0/255.0, blue: 32.0/255, alpha: 1)
        //view.backgroundColor = UIColor.blackColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    
    private lazy var transparentRectView: UIView = {
        let view = UIView()
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    
    private let cropRectComponent = GCSpotlightCircle()
    private var dragOffset = CGPointZero
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
    var referenceURL: NSURL?
    var isFromLibrary:Bool?
    var shouldCropVideo:Bool = true
    var cropStartTime:CGFloat = 0.0
    var cropEndTime:CGFloat = 20.0
    var playbackRate:CGFloat = 1.0
    var videoScaleFactor:CGFloat = 1.0
    var startPlaybackTime:NSTimeInterval = 0.0
    var endPlaybackTime:NSTimeInterval = 0.0
    private var exportSession:AVAssetExportSession!
    private var tempVideoPath:NSURL!
    
    private var cropRecRadius:CGFloat = 150
    
    
    
    private var pathArray = [AnyObject]()
    
    // MARK: - UIViewController
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        navigationItem.title = NSLocalizedString("main-editor.title", tableName: nil, bundle: bundle, value: "", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelTapped:")

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonItem)
        
        fixedFilterStack.effectFilter = IMGLYInstanceFactory.effectFilterWithType(initialFilterType)
        fixedFilterStack.effectFilter.inputIntensity = initialFilterIntensity
        
        //updatePreviewImage()
        configureViewHierarchy()
        configureViewConstraints()

        
        tempVideoPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("tempMov.mov")
        print("temp directory \(tempVideoPath)")
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: "startComposingVideo:")
//        
        cameraPreviewContainer.addGestureRecognizer(longPressGesture)
        //toggleFilters(zoomVideoButton)
        //updateConstraintsForRecordingMode()
        //configureMenuCollectionView()
        
        
    }
    
    override public func viewDidDisappear(animated: Bool) {
        if self.moviePlayer?.playbackState == MPMoviePlaybackState.Playing {
            self.moviePlayer?.stop()
        }
    }
    
    override public func viewDidAppear(animated: Bool) {
        self.cropVideo(self.cropSelectionButton)
    }
    
    private func configureSpotLightRect() {
        transparentRectView.hidden = false
        cameraPreviewContainer.addSubview(transparentRectView)
        cropRectComponent.cropRect = CGRectMake((cameraPreviewContainer.frame.size.width/2  - cropRecRadius/2), (cameraPreviewContainer.frame.size.height/2 - cropRecRadius)/2, cropRecRadius, cropRecRadius)
        cropRectComponent.setup(transparentRectView, parentView: cameraPreviewContainer, showAnchors: false)
        addGestureRecognizerToTransparentView()
//        addGestureRecognizerToAnchors()
    }
    
    private func addGestureRecognizerToTransparentView() {
        transparentRectView.userInteractionEnabled = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        transparentRectView.addGestureRecognizer(panGestureRecognizer)
    }
    
    public func handlePan(recognizer:UIPanGestureRecognizer) {
        
        // Reset array assuming user wants to start again
        //pathArray = [AnyObject]()
        handlePanOnTransparentView(recognizer)
    }
    
    private func handlePanOnTransparentView(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Began {
            navigationItem.rightBarButtonItem?.enabled = false
            startPlaybackTime = (self.moviePlayer?.currentPlaybackTime)!
            // Reset array assuming user wants to start again
            pathArray = [AnyObject]()
            startSpotLightMsg.removeFromSuperview()
//            self.transparentRectView.alpha = 1.0
            shouldDisplaySpotLight()
        } else if recognizer.state == .Ended {
            endPlaybackTime = (self.moviePlayer?.currentPlaybackTime)!
            finishSpotLightBtn.hidden = false
            finishSpotLightBtn.enabled = true
            self.transparentRectView.removeFromSuperview()
        }
        
        let location = recognizer.locationInView(transparentRectView)
        //print("cropRectComponent rect \(cropRectComponent.cropRect) and location \(location)")
        if transparentRectView.frame.contains(location) {
        //if location.x + cropRecRadius > 0 && location.y + cropRecRadius > 0 && location.x + cropRecRadius < transparentRectView.frame.width && location.y + cropRecRadius < transparentRectView.frame.height {
            calculateDragOffsetOnNewDrag(recognizer:recognizer)
            let newLocation = clampedLocationToBounds(location)
            var rect = cropRectComponent.cropRect
            rect.origin.x = newLocation.x - dragOffset.x
            rect.origin.y = newLocation.y - dragOffset.y
            
//            var newRect = rect
//            newRect.origin.y = transparentRectView.frame.height - rect.origin.y
            pathArray.append(NSValue(CGRect: rect))
            cropRectComponent.cropRect = rect
            cropRectComponent.layoutViewsForCropRect()
        }
        
        //        print("after cropRectComponent rect \(cropRectComponent.cropRect)")
    }

    private func calculateDragOffsetOnNewDrag(recognizer recognizer: UIPanGestureRecognizer) {
        let location = recognizer.locationInView(transparentRectView)
        if recognizer.state == UIGestureRecognizerState.Began {
            dragOffset = CGPointMake(location.x - cropRectComponent.cropRect.origin.x, location.y - cropRectComponent.cropRect.origin.y)
        }
    }
    
    private func clampedLocationToBounds(location: CGPoint) -> CGPoint {
        let rect = cropRectComponent.cropRect
        var locationX = location.x
        var locationY = location.y
        let left = locationX - dragOffset.x
        let right = left + rect.size.width
        let top  = locationY - dragOffset.y
        let bottom = top + rect.size.height
        
//        if left < cropRectLeftBound {
//            locationX = cropRectLeftBound + dragOffset.x
//        }
//        if right > cropRectRightBound {
//            locationX = cropRectRightBound - cropRectComponent.cropRect.size.width  + dragOffset.x
//        }
//        if top < cropRectTopBound {
//            locationY = cropRectTopBound + dragOffset.y
//        }
//        if bottom > cropRectBottomBound {
//            locationY = cropRectBottomBound - cropRectComponent.cropRect.size.height + dragOffset.y
//        }
        return CGPointMake(locationX, locationY)
    }

//    public override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        transparentRectView.frame = view.convertRect(previewImageView.visibleImageFrame, fromView: previewImageView)
//        reCalculateCropRectBounds()
//    }
    
    private func configureViewHierarchy() {
        view.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(cameraPreviewContainer)
        
        view.addSubview(bottomControlsView)
        view.addSubview(bottomEditorView)
        view.addSubview(slowMotionControlView)
        view.addSubview(spotLightControlView);
        
        addChildViewController(filterSelectionController)
        filterSelectionController.didMoveToParentViewController(self)
        view.addSubview(filterSelectionController.view)
        
        bottomControlsView.addSubview(filterSelectionButton)
        bottomControlsView.addSubview(cropSelectionButton)
        bottomControlsView.addSubview(spotLightSelectionButton)
        bottomControlsView.addSubview(slowMoVideoButton)
        bottomControlsView.addSubview(controlSelectionPointer)
        
        // Add Slow Mo control to slowMotionControlView, here
        [slowMotionControlView .addSubview(slowMoButton1)]
        [slowMotionControlView .addSubview(slowMoButton2)]
        [slowMotionControlView .addSubview(slowMoButton3)]
        [slowMotionControlView .addSubview(slowMoButton4)]
        [slowMotionControlView .addSubview(slowMoButton5)]
        
        [spotLightControlView .addSubview(spotLight01)]
        [spotLightControlView .addSubview(spotLight02)]
        [spotLightControlView .addSubview(spotLight03)]
        [spotLightControlView .addSubview(spotLight04)]
        
        [spotLightControlView .addSubview(finishSpotLightBtn)];
        finishSpotLightBtn.hidden = true
        [spotLightControlView .addSubview(cancelSpotLigthBtn)];
        
        [spotLightControlView .addSubview(spotLightTitle)];
        
        
        slowMotionControlView.hidden = true
        
        spotLightControlView.hidden = true
    }
    
    
    private func configureViewConstraints() {
        let views: [String : AnyObject] = [
            "backgroundContainerView" : backgroundContainerView,
            "topLayoutGuide" : topLayoutGuide,
            "cameraPreviewContainer" : cameraPreviewContainer,
            "bottomControlsView" : bottomControlsView,
            "bottomEditorView" : bottomEditorView,
            "filterSelectionView" : filterSelectionController.view,
            "filterSelectionButton" : filterSelectionButton,
            "cropSelectionButton" : cropSelectionButton,
            "spotLightSelectionButton" : spotLightSelectionButton,
            "slowMotionControlView": slowMotionControlView,
            "spotLightControlView" : spotLightControlView,
            "slowMoVideoButton" : slowMoVideoButton,
            "controlSelectionPointer": controlSelectionPointer        ]
        
        let metrics: [String : AnyObject] = [
            "topControlsViewHeight" : 64,
            "filterSelectionViewHeight" : FilterSelectionViewHeight,
            "SptoLightControlViewHeight" : SpotLightControlViewHeight,
            "topControlMargin" : 20,
            "topControlMinWidth" : 44
        ]
        
        configureSuperviewConstraintsWithMetrics(metrics, views: views)
        configureBottomControlsConstraintsWithMetrics(metrics, views: views)
        configureSlowMoControlsConstraintsWithMetrics(metrics, views:views)
        configureSpotLightControlsConstraintsWithMetrics(metrics, views:views)
    }
    
    private func configureSuperviewConstraintsWithMetrics(metrics: [String : AnyObject], views: [String : AnyObject]) {
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[backgroundContainerView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundContainerView]|", options: [], metrics: nil, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[cameraPreviewContainer]|", options: [], metrics: nil, views: views))
        //view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cameraPreviewContainer(>=150,<=320)]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[bottomControlsView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[bottomEditorView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[slowMotionControlView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[spotLightControlView]|", options: [], metrics: nil, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[filterSelectionView]|", options: [], metrics: nil, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cameraPreviewContainer][bottomControlsView(==topControlsViewHeight)]", options: [], metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cameraPreviewContainer][spotLightControlView(==SptoLightControlViewHeight)]", options: [], metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bottomControlsView][bottomEditorView(==filterSelectionViewHeight)]", options: [], metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bottomControlsView][slowMotionControlView(==filterSelectionViewHeight)]", options: [], metrics: metrics, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bottomEditorView][filterSelectionView(==filterSelectionViewHeight)]", options: [], metrics: metrics, views: views))
        
        
        cameraPreviewContainerTopConstraint = NSLayoutConstraint(item: cameraPreviewContainer, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0)
        cameraPreviewContainerBottomConstraint = NSLayoutConstraint(item: cameraPreviewContainer, attribute: .Bottom, relatedBy: .Equal, toItem: bottomControlsView, attribute: .Top, multiplier: 1, constant: 0)
        
        view.addConstraints([cameraPreviewContainerTopConstraint!, cameraPreviewContainerBottomConstraint!])
        
        print("cameracontainer frames \(cameraPreviewContainer.frame)")
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
        
        let constant:CGFloat = (view.frame.width - BottomControlSize.width*4) / 5
        
        // filterSelectionButton
        filterSelectionButton.addConstraint(NSLayoutConstraint(item: filterSelectionButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.width))
        filterSelectionButton.addConstraint(NSLayoutConstraint(item: filterSelectionButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.height))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: filterSelectionButton, attribute: .CenterY, relatedBy: .Equal, toItem: bottomControlsView, attribute: .CenterY, multiplier: 1, constant: 0))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: filterSelectionButton, attribute: .Left, relatedBy: .Equal, toItem: bottomControlsView, attribute: .Left, multiplier: 1, constant: constant))
        
        // CropSelectionButton
        cropSelectionButton.addConstraint(NSLayoutConstraint(item: cropSelectionButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.width))
        cropSelectionButton.addConstraint(NSLayoutConstraint(item: cropSelectionButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.height))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: cropSelectionButton, attribute: .CenterY, relatedBy: .Equal, toItem: bottomControlsView, attribute: .CenterY, multiplier: 1, constant: 0))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: cropSelectionButton, attribute: .Left, relatedBy: .Equal, toItem: filterSelectionButton, attribute: .Right, multiplier: 1, constant: constant))
        
        spotLightSelectionButton.addConstraint(NSLayoutConstraint(item: spotLightSelectionButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.width))
        spotLightSelectionButton.addConstraint(NSLayoutConstraint(item: spotLightSelectionButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.height))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: spotLightSelectionButton, attribute: .CenterY, relatedBy: .Equal, toItem: bottomControlsView, attribute: .CenterY, multiplier: 1, constant: 0))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: spotLightSelectionButton, attribute: .Left, relatedBy: .Equal, toItem: cropSelectionButton, attribute: .Right, multiplier: 1, constant: constant))
        

        
        // slowMoVideoButton
        slowMoVideoButton.addConstraint(NSLayoutConstraint(item: slowMoVideoButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.width))
        slowMoVideoButton.addConstraint(NSLayoutConstraint(item: slowMoVideoButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.height))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: slowMoVideoButton, attribute: .CenterY, relatedBy: .Equal, toItem: bottomControlsView, attribute: .CenterY, multiplier: 1, constant: 0))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: slowMoVideoButton, attribute: .Left, relatedBy: .Equal, toItem: spotLightSelectionButton, attribute: .Right, multiplier: 1, constant: constant))
        
        
        
        controlSelectionPointer.addConstraint(NSLayoutConstraint(item: controlSelectionPointer, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: PointerControlSize.width))
        controlSelectionPointer.addConstraint(NSLayoutConstraint(item: controlSelectionPointer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: PointerControlSize.height))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: controlSelectionPointer, attribute: .Bottom, relatedBy: .Equal, toItem: bottomControlsView, attribute: .Bottom, multiplier: 1, constant: 0))
        bottomControlsView.addConstraint(NSLayoutConstraint(item: controlSelectionPointer, attribute: .CenterX, relatedBy: .Equal, toItem: filterSelectionButton, attribute: .CenterX, multiplier: 1, constant: 0))
    }
    
    private func configureSlowMoControlsConstraintsWithMetrics(metrics: [String : AnyObject], views: [String : AnyObject]) {
        
        let constant:CGFloat = (view.frame.width - SlowMoButtonSize.width*5) / 6
        // slowMoButton1
        slowMoButton1.addConstraint(NSLayoutConstraint(item: slowMoButton1, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.width))
        slowMoButton1.addConstraint(NSLayoutConstraint(item: slowMoButton1, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.height))
        slowMotionControlView.addConstraint(NSLayoutConstraint(item: slowMoButton1, attribute: .CenterY, relatedBy: .Equal, toItem: slowMotionControlView, attribute: .CenterY, multiplier: 1, constant: 0))
        slowMotionControlView.addConstraint(NSLayoutConstraint(item: slowMoButton1, attribute: .Left, relatedBy: .Equal, toItem: slowMotionControlView, attribute: .Left, multiplier: 1, constant: constant))
        
        // slowMoButton2
        slowMoButton2.addConstraint(NSLayoutConstraint(item: slowMoButton2, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.width))
        slowMoButton2.addConstraint(NSLayoutConstraint(item: slowMoButton2, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.height))
        slowMotionControlView.addConstraint(NSLayoutConstraint(item: slowMoButton2, attribute: .CenterY, relatedBy: .Equal, toItem: slowMotionControlView, attribute: .CenterY, multiplier: 1, constant: 0))
        slowMotionControlView.addConstraint(NSLayoutConstraint(item: slowMoButton2, attribute: .Left, relatedBy: .Equal, toItem: slowMoButton1, attribute: .Right, multiplier: 1, constant: constant))
        
        // slowMoButton3
        slowMoButton3.addConstraint(NSLayoutConstraint(item: slowMoButton3, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.width))
        slowMoButton3.addConstraint(NSLayoutConstraint(item: slowMoButton3, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.height))
        slowMotionControlView.addConstraint(NSLayoutConstraint(item: slowMoButton3, attribute: .CenterY, relatedBy: .Equal, toItem: slowMotionControlView, attribute: .CenterY, multiplier: 1, constant: 0))
        slowMotionControlView.addConstraint(NSLayoutConstraint(item: slowMoButton3, attribute: .Left, relatedBy: .Equal, toItem: slowMoButton2, attribute: .Right, multiplier: 1, constant: constant))
        
        // slowMoButton4
        slowMoButton4.addConstraint(NSLayoutConstraint(item: slowMoButton4, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.width))
        slowMoButton4.addConstraint(NSLayoutConstraint(item: slowMoButton4, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.height))
        slowMotionControlView.addConstraint(NSLayoutConstraint(item: slowMoButton4, attribute: .CenterY, relatedBy: .Equal, toItem: slowMotionControlView, attribute: .CenterY, multiplier: 1, constant: 0))
        slowMotionControlView.addConstraint(NSLayoutConstraint(item: slowMoButton4, attribute: .Left, relatedBy: .Equal, toItem: slowMoButton3, attribute: .Right, multiplier: 1, constant: constant))
        
        // slowMoButton5
        slowMoButton5.addConstraint(NSLayoutConstraint(item: slowMoButton5, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.width))
        slowMoButton5.addConstraint(NSLayoutConstraint(item: slowMoButton5, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.height))
        slowMotionControlView.addConstraint(NSLayoutConstraint(item: slowMoButton5, attribute: .CenterY, relatedBy: .Equal, toItem: slowMotionControlView, attribute: .CenterY, multiplier: 1, constant: 0))
        slowMotionControlView.addConstraint(NSLayoutConstraint(item: slowMoButton5, attribute: .Left, relatedBy: .Equal, toItem: slowMoButton4, attribute: .Right, multiplier: 1, constant: constant))
    }
    
    private func configureSpotLightControlsConstraintsWithMetrics(metrics: [String : AnyObject], views: [String : AnyObject]) {
        
        let constant:CGFloat = (view.frame.width - SlowMoButtonSize.width*4) / 5
        
        spotLightTitle.addConstraint(NSLayoutConstraint(item: spotLightTitle, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 120))
        spotLightTitle.addConstraint(NSLayoutConstraint(item: spotLightTitle, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: spotLightTitle, attribute: .Top, relatedBy: .Equal, toItem: spotLightControlView, attribute: .Top, multiplier: 1, constant: constant))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: spotLightTitle, attribute: .CenterX, relatedBy: .Equal, toItem: spotLightControlView, attribute: .CenterX, multiplier: 1, constant: 0))
        
        cancelSpotLigthBtn.addConstraint(NSLayoutConstraint(item: cancelSpotLigthBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 35))
        cancelSpotLigthBtn.addConstraint(NSLayoutConstraint(item: cancelSpotLigthBtn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 35))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: cancelSpotLigthBtn, attribute: .Top, relatedBy: .Equal, toItem: spotLightControlView, attribute: .Top, multiplier: 1, constant: constant))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: cancelSpotLigthBtn, attribute: .Left, relatedBy: .Equal, toItem: spotLightControlView, attribute: .Left, multiplier: 1, constant: constant))
        
        finishSpotLightBtn.addConstraint(NSLayoutConstraint(item: finishSpotLightBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 35))
        finishSpotLightBtn.addConstraint(NSLayoutConstraint(item: finishSpotLightBtn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 35))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: finishSpotLightBtn, attribute: .Top, relatedBy: .Equal, toItem: spotLightControlView, attribute: .Top, multiplier: 1, constant: constant))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: finishSpotLightBtn, attribute: .Right, relatedBy: .Equal, toItem: spotLightControlView, attribute: .Right, multiplier: 1, constant: -constant))
        
        
        // slowMoButton1
        spotLight01.addConstraint(NSLayoutConstraint(item: spotLight01, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.width))
        spotLight01.addConstraint(NSLayoutConstraint(item: spotLight01, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.height))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: spotLight01, attribute: .Bottom, relatedBy: .Equal, toItem: spotLightControlView, attribute: .Bottom, multiplier: 1, constant: 0))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: spotLight01, attribute: .Left, relatedBy: .Equal, toItem: spotLightControlView, attribute: .Left, multiplier: 1, constant: constant))
        
        // slowMoButton2
        spotLight02.addConstraint(NSLayoutConstraint(item: spotLight02, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.width))
        spotLight02.addConstraint(NSLayoutConstraint(item: spotLight02, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.height))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: spotLight02, attribute: .Bottom, relatedBy: .Equal, toItem: spotLightControlView, attribute: .Bottom, multiplier: 1, constant: 0))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: spotLight02, attribute: .Left, relatedBy: .Equal, toItem: spotLight01, attribute: .Right, multiplier: 1, constant: constant))
        
        // slowMoButton3
        spotLight03.addConstraint(NSLayoutConstraint(item: spotLight03, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.width))
        spotLight03.addConstraint(NSLayoutConstraint(item: spotLight03, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.height))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: spotLight03, attribute: .Bottom, relatedBy: .Equal, toItem: spotLightControlView, attribute: .Bottom, multiplier: 1, constant: 0))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: spotLight03, attribute: .Left, relatedBy: .Equal, toItem: spotLight02, attribute: .Right, multiplier: 1, constant: constant))
        
        // slowMoButton4
        spotLight04.addConstraint(NSLayoutConstraint(item: spotLight04, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.width))
        spotLight04.addConstraint(NSLayoutConstraint(item: spotLight04, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SlowMoButtonSize.height))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: spotLight04, attribute: .Bottom, relatedBy: .Equal, toItem: spotLightControlView, attribute: .Bottom, multiplier: 1, constant: 0))
        spotLightControlView.addConstraint(NSLayoutConstraint(item: spotLight04, attribute: .Left, relatedBy: .Equal, toItem: spotLight03, attribute: .Right, multiplier: 1, constant: constant))
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
    
    
    // MARK: MoviePlayer delegate
    
    private func moviePlayingFinished() {
        startPlaybackTime = 0.0
    }
    
    // MARK: - Video Slider delegate func
    @objc public func videoRange(slider:VideoRangeSlider?, didChangeLeftPosition:CGFloat, rightPosition:CGFloat) {
        self.shouldCropVideo = true
        self.cropStartTime = didChangeLeftPosition
        self.cropEndTime = rightPosition
//        print("slider values \(didChangeLeftPosition) and \(rightPosition) \(self.videoURL) and \(self.referenceURL) ")
        //self.moviePlayer?.stop()
        //        self.moviePlayer?.contentURL = self.referenceURL
//        self.moviePlayer?.initialPlaybackTime = Double(didChangeLeftPosition)
//        self.moviePlayer?.endPlaybackTime = Double(rightPosition)
//        self.moviePlayer?.play()
    }
    
    // Mark: - Video Processor Delegate
    @objc public func processesdVideoURL(finalURL: NSURL!, isSavedToPhotoLibrary:Bool) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

        navigationItem.rightBarButtonItem?.enabled = true
        if !isSavedToPhotoLibrary {
            self.transparentRectView.removeFromSuperview()
            finishSpotLightBtn.enabled = false
            //spotLightControlView.hidden = true
            self.videoURL = finalURL
            tempVideoPath = finalURL
            self.referenceURL = finalURL
            self.moviePlayer?.stop()
            self.moviePlayer?.contentURL = self.videoURL
            self.moviePlayer?.play()
        } else {
        dispatch_async(dispatch_get_main_queue()){
            self.pushShareScreenWithVideoUrl(finalURL)
            };
        }
    }
    
    // Mark: SpotLight Video Targets
    public func processSpotLightVideo(sender:UIButton) {
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Applying..."
        
        let videoProcessor = GCVideoProcessor()
        videoProcessor.delegate = self
        videoProcessor.overlayView = transparentRectView
        //videoProcessor.processVideoAtPath(url, atScaleRate:videoScaleFactor)
        videoProcessor.exportVideoWithOverlayForURL(self.videoURL, withPointsArray: pathArray, circleRadius:cropRecRadius, startPlaybackTime:startPlaybackTime)
    }
    
    public func dismissSpotLightControl(sender:UIButton?) {
        navigationItem.rightBarButtonItem?.enabled = true
        self.transparentRectView.removeFromSuperview()
        self.cropVideo(self.cropSelectionButton)
        spotLightControlView.hidden = true
    }
    
    public func changeSpotlightRadius(sender:UIButton) {
        startSpotLightMsg.frame = CGRectMake((self.view.frame.size.width - 150)/2, (self.view.frame.size.height - 45)/2, 180, 45)

        self.view.addSubview(startSpotLightMsg)
        
        switch(sender.tag) {
        case 201:
            cropRecRadius = 60
            break
            
        case 202:
            cropRecRadius = 150
            break
            
        case 203:
            cropRecRadius = 200
            break
            
        case 204:
            cropRecRadius = 280
            break
            
        default:
            
            break
        }
        
        spotLight01.imageView!.layer.borderColor = nil
        spotLight01.imageView!.layer.borderWidth = 0
        
        spotLight02.imageView!.layer.borderColor = nil
        spotLight02.imageView!.layer.borderWidth = 0
        
        spotLight03.imageView!.layer.borderColor = nil
        spotLight03.imageView!.layer.borderWidth = 0
        
        spotLight04.imageView!.layer.borderColor = nil
        spotLight04.imageView!.layer.borderWidth = 0
        
//        self.transparentRectView.removeFromSuperview()
//        view.addSubview(transparentRectView)
        
        shouldDisplaySpotLight()
        
        cropRectComponent.cropRect = CGRectMake((cameraPreviewContainer.frame.size.width - cropRecRadius)/2 , (cameraPreviewContainer.frame.size.height - cropRecRadius)/2, cropRecRadius, cropRecRadius)
        cropRectComponent.layoutViewsForCropRect()
        
        sender.imageView!.layer.borderColor = UIColor.yellowColor().CGColor
        sender.imageView!.layer.cornerRadius = 3
        sender.imageView!.layer.borderWidth = 2
        self.transparentRectView.alpha = 1.0
//        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.6 * Double(NSEC_PER_SEC)))
//        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
//            UIView .animateWithDuration(0.3, animations: {
//                self.transparentRectView.alpha = 0.05
////                self.transparentRectView.removeFromSuperview()
//                
//            })
//            })
    }
    
    public func shouldDisplaySpotLight() {
        view.addSubview(transparentRectView)
        configureSpotLightRect()
//        spotLightControlView.hidden = false
        cropRectComponent.present()
    }
    
    public func displaySpotlight(sender:UIButton) {
        spotLightControlView.hidden = false
        bottomEditorView.hidden = true
        slowMotionControlView.hidden = true
        //self.toggleFilters(self.filterSelectionButton)
        let animationDuration = NSTimeInterval(0.6)
        let dampingFactor = CGFloat(0.6)
        
        let filterSelectionViewConstraint = self.filterSelectionViewConstraint
        filterSelectionController.beginAppearanceTransition(false, animated: true)
        filterSelectionViewConstraint!.constant = 0
        //                    self.cropSelectionViewConstraint!.constant = -1 * CGFloat(FilterSelectionViewHeight)
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: dampingFactor, initialSpringVelocity: 0, options: [], animations: {
            //sender?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            //self.view.addSubview(self.bottomEditorView)
            self.view.layoutIfNeeded()
            }, completion: { finished in
                self.filterSelectionController.endAppearanceTransition()
        })
        self.animatePointer(sender)
    }
    
    // MARK: - Targets
    
    public func startComposingVideo(gesture:UILongPressGestureRecognizer) {
        print("long press detected")
    }
    
    public func toggleFilters(sender: UIButton?) {
        if let filterSelectionViewConstraint = self.filterSelectionViewConstraint {
            let animationDuration = NSTimeInterval(0.6)
            let dampingFactor = CGFloat(0.6)
            if filterSelectionViewConstraint.constant == 0 {
                // Expand
                self.animatePointer(sender)
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
    
    private func animatePointer(sender:UIButton?) {
        
        UIView.animateWithDuration(0.3, animations: {
            var frame:CGRect = self.controlSelectionPointer.frame
            frame.origin.x = (sender?.frame.origin.x)! + (sender?.frame.size.width)! / 2 - 8
            self.controlSelectionPointer.frame = frame
        })
    }
    
    public func displaySlowMoControls(sender:UIButton?) {
        bottomEditorView.hidden = true
        slowMotionControlView.hidden = false
        //self.toggleFilters(self.filterSelectionButton)
        let animationDuration = NSTimeInterval(0.6)
        let dampingFactor = CGFloat(0.6)
        
        let filterSelectionViewConstraint = self.filterSelectionViewConstraint
        filterSelectionController.beginAppearanceTransition(false, animated: true)
        filterSelectionViewConstraint!.constant = 0
        //                    self.cropSelectionViewConstraint!.constant = -1 * CGFloat(FilterSelectionViewHeight)
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: dampingFactor, initialSpringVelocity: 0, options: [], animations: {
            //sender?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            //self.view.addSubview(self.bottomEditorView)
            self.view.layoutIfNeeded()
            }, completion: { finished in
                self.filterSelectionController.endAppearanceTransition()
        })
        self.animatePointer(sender)
    }
    
    public func cropVideo(sender:UIButton?) {
        bottomEditorView.hidden = false
        slowMotionControlView.hidden = true
        //self.toggleFilters(self.filterSelectionButton)
        let animationDuration = NSTimeInterval(0.6)
        let dampingFactor = CGFloat(0.6)

        let filterSelectionViewConstraint = self.filterSelectionViewConstraint
        filterSelectionController.beginAppearanceTransition(false, animated: true)
        filterSelectionViewConstraint!.constant = 0
        //                    self.cropSelectionViewConstraint!.constant = -1 * CGFloat(FilterSelectionViewHeight)
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: dampingFactor, initialSpringVelocity: 0, options: [], animations: {
            sender?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            //self.view.addSubview(self.bottomEditorView)
            self.view.layoutIfNeeded()
            }, completion: { finished in
                self.filterSelectionController.endAppearanceTransition()
        })
        self.animatePointer(sender)
    }
    
    public func changeVideofps(sender:UIButton) {
        let tag = sender.tag
        switch tag {
        case 101:
            playbackRate = 0.1
            videoScaleFactor = 10
            break
            
        case 102:
            playbackRate = 0.25
            videoScaleFactor = 4
            break
        case 103:
            playbackRate = 0.5
            videoScaleFactor = 2
            break
            
        case 104:
            playbackRate = 1.5
            videoScaleFactor = 0.75
            break
        case 105:
            playbackRate = 2.0
            videoScaleFactor = 0.5
            break
            
        default:
            playbackRate = 1.0
            break
        }
        slowMoButton1.imageView!.layer.borderColor = nil
        slowMoButton1.imageView!.layer.borderWidth = 0
        
        slowMoButton2.imageView!.layer.borderColor = nil
        slowMoButton2.imageView!.layer.borderWidth = 0
        
        slowMoButton3.imageView!.layer.borderColor = nil
        slowMoButton3.imageView!.layer.borderWidth = 0
        
        slowMoButton4.imageView!.layer.borderColor = nil
        slowMoButton4.imageView!.layer.borderWidth = 0
        
        slowMoButton5.imageView!.layer.borderColor = nil
        slowMoButton5.imageView!.layer.borderWidth = 0
        
        sender.imageView!.layer.borderColor = UIColor.yellowColor().CGColor
        sender.imageView!.layer.cornerRadius = 3
        sender.imageView!.layer.borderWidth = 2
        //self.moviePlayer?.stop()
        self.moviePlayer?.currentPlaybackRate = Float(playbackRate)
        //self.moviePlayer?.play()
        
    }
    
    public func exportEditedVideo() {
        deleteTempVideoFile()
        
        let asset:AVAsset = AVAsset.init(URL: videoURL!)
        let compatiblePresets = AVAssetExportSession.exportPresetsCompatibleWithAsset(asset)
        
        if compatiblePresets.contains(AVAssetExportPresetMediumQuality) {
            
            self.exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetPassthrough)!
            
            self.exportSession.outputURL = tempVideoPath
            self.exportSession.outputFileType = AVFileTypeQuickTimeMovie
            
            if self.cropEndTime > CGFloat(CMTimeGetSeconds(asset.duration)) {
                self.cropEndTime = CGFloat(CMTimeGetSeconds(asset.duration))
            }
            let start:CMTime = CMTimeMakeWithSeconds(Double(self.cropStartTime), asset.duration.timescale)
            let duration:CMTime = CMTimeMakeWithSeconds((Double(self.cropEndTime) - Double(self.cropStartTime)), asset.duration.timescale)
            let timeRange:CMTimeRange = CMTimeRangeMake(start, duration)
            self.exportSession.timeRange = timeRange
            print("\(start) duration \(duration) diff \((Double(self.cropEndTime) - Double(self.cropStartTime))) and  crop time values in order \(self.cropEndTime), \(self.cropStartTime), \(timeRange)")
            
            self.exportSession.exportAsynchronouslyWithCompletionHandler( {
                
                switch self.exportSession.status {
                case .Failed:
                    print("cropping failed \(self.exportSession.error?.description)")
//                    if !(self.isFromLibrary ?? true) {
//                        self.saveMovieWithMovieURLToAssets(self.videoURL!)
//                    } else {
//                        if self.videoScaleFactor != 1 {
//                            self.processSlowMoVideoAtRefURL(self.videoURL!)
//                        } else {
//                            dispatch_async(dispatch_get_main_queue()){
//                                self.pushShareScreenWithVideoUrl(self.referenceURL!)
//                            };
//                        }
//                    }
                    break
                    
                case .Cancelled:
                    print("cropping canceled")
                    break
                    
                case .Completed:
                    //self.saveMovieWithMovieURLToAssets(self.tempVideoPath)
//                    if !(self.isFromLibrary ?? true) {
//                        self.saveMovieWithMovieURLToAssets(self.tempVideoPath!)
//                    } else {
                        if self.videoScaleFactor != 1 {
                            self.processSlowMoVideoAtRefURL(self.tempVideoPath!)
                        } else {
                            dispatch_async(dispatch_get_main_queue()){
                                self.saveMovieWithMovieURLToAssets(self.tempVideoPath!)
                            };
//                        }
                    }
                    break
                    
                default:
                    
                    break
                }
            })
            
        }
        
    }
    
    private func deleteTempVideoFile() {
        let fm:NSFileManager = NSFileManager.defaultManager()
        print("tempVideoPath \(tempVideoPath) and \(tempVideoPath.path)")
        let exist:Bool = fm.fileExistsAtPath(tempVideoPath.path!)
        
        if exist {
            do {
                try fm.removeItemAtURL(tempVideoPath)
            } catch {
                print("unable to delete temp video \(error)")
            }
        }
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
                dispatch_async(dispatch_get_main_queue()){
                    self.pushShareScreenWithVideoUrl(newURL)
                }
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(movieURL)
                } catch _ {
                }
            }
            
        }
        if library.videoAtPathIsCompatibleWithSavedPhotosAlbum(movieURL) {
            if videoScaleFactor != 1 {
                processSlowMoVideoAtRefURL(movieURL)
            } else {
                library.writeVideoAtPathToSavedPhotosAlbum(movieURL, completionBlock: videoWriteCompletionBlock)
            }
        }
    }
    
    public func processSlowMoVideoAtRefURL(url:NSURL) {
        
        let videoProcessor = GCVideoProcessor()
        videoProcessor.delegate = self
        videoProcessor.overlayView = transparentRectView
        videoProcessor.processVideoAtPath(url, atScaleRate:videoScaleFactor)
        //videoProcessor.exportVideoWithOverlayForURL(url, withPointsArray: pathArray)
    }
    
    // MARK: - EditorViewController
    
    public func tappedDone(sender: UIBarButtonItem?) {
        navigationItem.rightBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        activityIndicatorView.startAnimating()
        if shouldCropVideo {
            self.exportEditedVideo()
        }
    }
    
    private func pushShareScreenWithVideoUrl(newVideoPath:NSURL) {
        do {
            try NSFileManager.defaultManager().removeItemAtURL(self.videoURL!)
        } catch _ {
        }
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let shareViewController : GCShareVideoViewController = storyboard.instantiateViewControllerWithIdentifier("SHARE_VIDEO_CONTROLLER") as! GCShareVideoViewController
        shareViewController.freshVideo = true
        shareViewController.referenceUrl = newVideoPath
        shareViewController.videoUrl = newVideoPath
        shareViewController.mediaType = MediaType.KTypeVideo;
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

//extension IMGLYVideoEditorViewController: UINavigationControllerDelegate {
//    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return IMGLYNavigationAnimationController()
//    }
//}

