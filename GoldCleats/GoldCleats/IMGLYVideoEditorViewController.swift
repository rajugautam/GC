//
//  IMGLYVideoEditorViewController.swift
//  GoldCleats
//
//  Created by Raju Gautam on 10/12/15.
//  Copyright © 2015 Raju Gautam. All rights reserved.
//
    import UIKit

//    @objc public enum IMGLYEditorResult: Int {
//        case Done
//        case Cancel
//    }
//    
//    @objc public enum IMGLYMainMenuButtonType: Int {
//        case Magic
//        case Filter
//        case Stickers
//        case Orientation
//        case Focus
//        case Crop
//        case Brightness
//        case Contrast
//        case Saturation
//        case Noise
//        case Text
//        case Reset
//    }
//    
//    public typealias IMGLYVideoEditorCompletionBlock = (IMGLYEditorResult, UIImage?) -> Void
//    

    private let ButtonCollectionViewCellReuseIdentifier = "ButtonCollectionViewCell"
    private let ButtonCollectionViewCellSize = CGSize(width: 66, height: 90)
    private let BottomControlSize = CGSize(width: 47, height: 47)

    public class IMGLYVideoEditorViewController: IMGLYEditorViewController {
        
        // MARK: - Properties
        
        public lazy var actionButtons: [IMGLYActionButton] = {
            let bundle = NSBundle(forClass: self.dynamicType)
            var handlers = [IMGLYActionButton]()
            
            handlers.append(
                IMGLYActionButton(
                    title: NSLocalizedString("main-editor.button.magic", tableName: nil, bundle: bundle, value: "", comment: ""),
                    image: UIImage(named: "icon_option_magic", inBundle: bundle, compatibleWithTraitCollection: nil),
                    selectedImage: UIImage(named: "icon_option_magic_active", inBundle: bundle, compatibleWithTraitCollection: nil),
                    handler: { [unowned self] in self.subEditorButtonPressed(.Magic) },
                    showSelection: { [unowned self] in return self.fixedFilterStack.enhancementFilter.enabled }))
            
            handlers.append(
                IMGLYActionButton(
                    title: NSLocalizedString("main-editor.button.filter", tableName: nil, bundle: bundle, value: "", comment: ""),
                    image: UIImage(named: "icon_option_filters", inBundle: bundle, compatibleWithTraitCollection: nil),
                    handler: { [unowned self] in self.subEditorButtonPressed(.Filter) }))
            
            handlers.append(
                IMGLYActionButton(
                    title: NSLocalizedString("main-editor.button.stickers", tableName: nil, bundle: bundle, value: "", comment: ""),
                    image: UIImage(named: "icon_option_sticker", inBundle: bundle, compatibleWithTraitCollection: nil),
                    handler: { [unowned self] in self.subEditorButtonPressed(.Stickers) }))
            
            handlers.append(
                IMGLYActionButton(
                    title: NSLocalizedString("main-editor.button.orientation", tableName: nil, bundle: bundle, value: "", comment: ""),
                    image: UIImage(named: "icon_option_orientation", inBundle: bundle, compatibleWithTraitCollection: nil),
                    handler: { [unowned self] in self.subEditorButtonPressed(.Orientation) }))
            
            handlers.append(
                IMGLYActionButton(
                    title: NSLocalizedString("main-editor.button.focus", tableName: nil, bundle: bundle, value: "", comment: ""),
                    image: UIImage(named: "icon_option_focus", inBundle: bundle, compatibleWithTraitCollection: nil),
                    handler: { [unowned self] in self.subEditorButtonPressed(.Focus) }))
            
            handlers.append(
                IMGLYActionButton(
                    title: NSLocalizedString("main-editor.button.crop", tableName: nil, bundle: bundle, value: "", comment: ""),
                    image: UIImage(named: "icon_option_crop", inBundle: bundle, compatibleWithTraitCollection: nil),
                    handler: { [unowned self] in self.subEditorButtonPressed(.Crop) }))
            
            handlers.append(
                IMGLYActionButton(
                    title: NSLocalizedString("main-editor.button.brightness", tableName: nil, bundle: bundle, value: "", comment: ""),
                    image: UIImage(named: "icon_option_brightness", inBundle: bundle, compatibleWithTraitCollection: nil),
                    handler: { [unowned self] in self.subEditorButtonPressed(.Brightness) }))
            
            handlers.append(
                IMGLYActionButton(
                    title: NSLocalizedString("main-editor.button.contrast", tableName: nil, bundle: bundle, value: "", comment: ""),
                    image: UIImage(named: "icon_option_contrast", inBundle: bundle, compatibleWithTraitCollection: nil),
                    handler: { [unowned self] in self.subEditorButtonPressed(.Contrast) }))
            
            handlers.append(
                IMGLYActionButton(
                    title: NSLocalizedString("main-editor.button.saturation", tableName: nil, bundle: bundle, value: "", comment: ""),
                    image: UIImage(named: "icon_option_saturation", inBundle: bundle, compatibleWithTraitCollection: nil),
                    handler: { [unowned self] in self.subEditorButtonPressed(.Saturation) }))
            
            handlers.append(
                IMGLYActionButton(
                    title: NSLocalizedString("main-editor.button.text", tableName: nil, bundle: bundle, value: "", comment: ""),
                    image: UIImage(named: "icon_option_text", inBundle: bundle, compatibleWithTraitCollection: nil),
                    handler: { [unowned self] in self.subEditorButtonPressed(.Text) }))
            
            return handlers
            }()
        
        public private(set) lazy var cameraRollButton: UIButton = {
            let bundle = NSBundle(forClass: self.dynamicType)
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "nonePreview", inBundle: bundle, compatibleWithTraitCollection: nil), forState: .Normal)
            button.imageView?.contentMode = .ScaleAspectFill
            button.layer.cornerRadius = 3
            button.clipsToBounds = true
            button.addTarget(self, action: "showCameraRoll:", forControlEvents: .TouchUpInside)
            return button
            }()
        
        public private(set) lazy var actionButtonContainer: UIView = {
            let view = UIView()
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
            button.setImage(UIImage(named: "show_filter", inBundle: bundle, compatibleWithTraitCollection: nil), forState: .Normal)
            button.layer.cornerRadius = 3
            button.clipsToBounds = true
            button.addTarget(self, action: "toggleFilters:", forControlEvents: .TouchUpInside)
            button.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            return button
            }()
        
        public private(set) lazy var bottomControlsView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.blackColor()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
            }()

        
        public var completionBlock: IMGLYEditorCompletionBlock?
        public var initialFilterType = IMGLYFilterType.None
        public var initialFilterIntensity = NSNumber(double: 0.75)
        public private(set) var fixedFilterStack = IMGLYFixedFilterStack()
        
        private let maxLowResolutionSideLength = CGFloat(1600)
        public var highResolutionImage: UIImage? {
            didSet {
                generateLowResolutionImage()
            }
        }
        
        // MARK: - UIViewController
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            
            let bundle = NSBundle(forClass: self.dynamicType)
            navigationItem.title = NSLocalizedString("main-editor.title", tableName: nil, bundle: bundle, value: "", comment: "")
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelTapped:")
            
            navigationController?.delegate = self
            
            fixedFilterStack.effectFilter = IMGLYInstanceFactory.effectFilterWithType(initialFilterType)
            fixedFilterStack.effectFilter.inputIntensity = initialFilterIntensity
            
            updatePreviewImage()
            configureViewHierarchy()
            configureViewConstraints()
            configureMenuCollectionView()
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
//                
//                centerModeButtonConstraint = NSLayoutConstraint(item: recordingModeSelectionButtons[0], attribute: .CenterX, relatedBy: .Equal, toItem: actionButtonContainer, attribute: .CenterX, multiplier: 1, constant: 0)
//                bottomControlsView.addConstraint(centerModeButtonConstraint!)
//                bottomControlsView.addConstraint(NSLayoutConstraint(item: recordingModeSelectionButtons[0], attribute: .Bottom, relatedBy: .Equal, toItem: actionButtonContainer, attribute: .Top, multiplier: 1, constant: -5))
//                bottomControlsView.addConstraint(NSLayoutConstraint(item: bottomControlsView, attribute: .Top, relatedBy: .Equal, toItem: recordingModeSelectionButtons[0], attribute: .Top, multiplier: 1, constant: -5))
//            } else {
                bottomControlsView.addConstraint(NSLayoutConstraint(item: bottomControlsView, attribute: .Top, relatedBy: .Equal, toItem: actionButtonContainer, attribute: .Top, multiplier: 1, constant: -5))
//            }
            
            // CameraRollButton
            cameraRollButton.addConstraint(NSLayoutConstraint(item: cameraRollButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.width))
            cameraRollButton.addConstraint(NSLayoutConstraint(item: cameraRollButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.height))
            bottomControlsView.addConstraint(NSLayoutConstraint(item: cameraRollButton, attribute: .CenterY, relatedBy: .Equal, toItem: actionButtonContainer, attribute: .CenterY, multiplier: 1, constant: 0))
            bottomControlsView.addConstraint(NSLayoutConstraint(item: cameraRollButton, attribute: .Left, relatedBy: .Equal, toItem: bottomControlsView, attribute: .Left, multiplier: 1, constant: 20))
            
            // ActionButtonContainer
            actionButtonContainer.addConstraint(NSLayoutConstraint(item: actionButtonContainer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 70))
            actionButtonContainer.addConstraint(NSLayoutConstraint(item: actionButtonContainer, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 70))
            bottomControlsView.addConstraint(NSLayoutConstraint(item: actionButtonContainer, attribute: .CenterX, relatedBy: .Equal, toItem: bottomControlsView, attribute: .CenterX, multiplier: 1, constant: 0))
            bottomControlsView.addConstraint(NSLayoutConstraint(item: bottomControlsView, attribute: .Bottom, relatedBy: .Equal, toItem: actionButtonContainer, attribute: .Bottom, multiplier: 1, constant: 10))
            
            // FilterSelectionButton
            filterSelectionButton.addConstraint(NSLayoutConstraint(item: filterSelectionButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.width))
            filterSelectionButton.addConstraint(NSLayoutConstraint(item: filterSelectionButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: BottomControlSize.height))
            bottomControlsView.addConstraint(NSLayoutConstraint(item: filterSelectionButton, attribute: .CenterY, relatedBy: .Equal, toItem: actionButtonContainer, attribute: .CenterY, multiplier: 1, constant: 0))
            bottomControlsView.addConstraint(NSLayoutConstraint(item: bottomControlsView, attribute: .Right, relatedBy: .Equal, toItem: filterSelectionButton, attribute: .Right, multiplier: 1, constant: 20))
        }
        
        private func configureViewHierarchy() {
            
            view.addSubview(bottomControlsView)
            
            
            
            bottomControlsView.addSubview(cameraRollButton)
            bottomControlsView.addSubview(actionButtonContainer)
            bottomControlsView.addSubview(filterSelectionButton)
            
        }

        
        private func configureViewConstraints() {
            let views: [String : AnyObject] = [
                "cameraRollButton" : cameraRollButton,
                "actionButtonContainer" : actionButtonContainer,
                "filterSelectionButton" : filterSelectionButton
            ]
            
            let metrics: [String : AnyObject] = [
//                "topControlsViewHeight" : 44,
//                "filterSelectionViewHeight" : FilterSelectionViewHeight,
//                "topControlMargin" : 20,
//                "topControlMinWidth" : 44,
                "filterIntensitySliderLeftRightMargin" : 10
            ]
            
            configureBottomControlsConstraintsWithMetrics(metrics, views: views)
        }
        
        // MARK: - Configuration
        
        private func configureMenuCollectionView() {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = ButtonCollectionViewCellSize
            flowLayout.scrollDirection = .Horizontal
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            
            let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.registerClass(IMGLYButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCellReuseIdentifier)
            
            let views = [ "collectionView" : collectionView ]
            bottomContainerView.addSubview(collectionView)
            bottomContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[collectionView]|", options: [], metrics: nil, views: views))
            bottomContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: [], metrics: nil, views: views))
        }
        
        // MARK: - Helpers
        
        private func subEditorButtonPressed(buttonType: IMGLYMainMenuButtonType) {
            if (buttonType == IMGLYMainMenuButtonType.Magic) {
                if !updating {
                    fixedFilterStack.enhancementFilter.enabled = !fixedFilterStack.enhancementFilter.enabled
                    updatePreviewImage()
                }
            } else {
                if let viewController = IMGLYInstanceFactory.viewControllerForButtonType(buttonType, withFixedFilterStack: fixedFilterStack) {
                    viewController.lowResolutionImage = lowResolutionImage
                    viewController.previewImageView.image = previewImageView.image
                    viewController.completionHandler = subEditorDidComplete
                    
                    showViewController(viewController, sender: self)
                }
            }
        }
        
        private func subEditorDidComplete(image: UIImage?, fixedFilterStack: IMGLYFixedFilterStack) {
            previewImageView.image = image
            self.fixedFilterStack = fixedFilterStack
        }
        
        private func generateLowResolutionImage() {
            if let highResolutionImage = self.highResolutionImage {
                if highResolutionImage.size.width > maxLowResolutionSideLength || highResolutionImage.size.height > maxLowResolutionSideLength  {
                    let scale: CGFloat
                    
                    if(highResolutionImage.size.width > highResolutionImage.size.height) {
                        scale = maxLowResolutionSideLength / highResolutionImage.size.width
                    } else {
                        scale = maxLowResolutionSideLength / highResolutionImage.size.height
                    }
                    
                    let newWidth  = CGFloat(roundf(Float(highResolutionImage.size.width) * Float(scale)))
                    let newHeight = CGFloat(roundf(Float(highResolutionImage.size.height) * Float(scale)))
                    lowResolutionImage = highResolutionImage.imgly_normalizedImageOfSize(CGSize(width: newWidth, height: newHeight))
                } else {
                    lowResolutionImage = highResolutionImage.imgly_normalizedImage
                }
            }
        }
        
        private func updatePreviewImage() {
            if let lowResolutionImage = self.lowResolutionImage {
                updating = true
                dispatch_async(PhotoProcessorQueue) {
                    let processedImage = IMGLYPhotoProcessor.processWithUIImage(lowResolutionImage, filters: self.fixedFilterStack.activeFilters)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.previewImageView.image = processedImage
                        self.updating = false
                    }
                }
            }
        }
        
        // MARK: - EditorViewController
        
        override public func tappedDone(sender: UIBarButtonItem?) {
            if let completionBlock = completionBlock {
                highResolutionImage = highResolutionImage?.imgly_normalizedImage
                var filteredHighResolutionImage: UIImage?
                
                if let highResolutionImage = self.highResolutionImage {
                    sender?.enabled = false
                    dispatch_async(PhotoProcessorQueue) {
                        filteredHighResolutionImage = IMGLYPhotoProcessor.processWithUIImage(highResolutionImage, filters: self.fixedFilterStack.activeFilters)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            completionBlock(.Done, filteredHighResolutionImage)
                            sender?.enabled = true
                        }
                    }
                } else {
                    completionBlock(.Done, filteredHighResolutionImage)
                }
            } else {
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        @objc private func cancelTapped(sender: UIBarButtonItem?) {
            if let completionBlock = completionBlock {
                completionBlock(.Cancel, nil)
            } else {
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        public override var enableZoomingInPreviewImage: Bool {
            return true
        }
    }
    
    extension IMGLYVideoEditorViewController: UICollectionViewDataSource {
        public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return actionButtons.count
        }
        
        public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ButtonCollectionViewCellReuseIdentifier, forIndexPath: indexPath)
            
            if let buttonCell = cell as? IMGLYButtonCollectionViewCell {
                let actionButton = actionButtons[indexPath.item]
                
                if let selectedImage = actionButton.selectedImage, let showSelectionBlock = actionButton.showSelection where showSelectionBlock() {
                    buttonCell.imageView.image = selectedImage
                } else {
                    buttonCell.imageView.image = actionButton.image
                }
                
                buttonCell.textLabel.text = actionButton.title
            }
            
            return cell
        }
    }
    
    extension IMGLYVideoEditorViewController: UICollectionViewDelegate {
        public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            let actionButton = actionButtons[indexPath.item]
            actionButton.handler()
            
            if actionButton.selectedImage != nil && actionButton.showSelection != nil {
                collectionView.reloadItemsAtIndexPaths([indexPath])
            }
        }
    }
    
    extension IMGLYVideoEditorViewController: UINavigationControllerDelegate {
        public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return IMGLYNavigationAnimationController()
        }
    }


