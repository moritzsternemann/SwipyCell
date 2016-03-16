//
//  SwipyCell.swift
//  SwipyCell
//
//  Created by Moritz Sternemann on 17.01.16.
//  Copyright © 2016 Moritz Sternemann. All rights reserved.
//

import UIKit

public protocol SwipyCellDelegate {
  func swipeableTableViewCellDidStartSwiping(cell: SwipyCell)
  func swipeableTableViewCellDidEndSwiping(cell: SwipyCell)
  func swipeableTableViewCell(cell: SwipyCell, didSwipeWithPercentage percentage: CGFloat)
}

public class SwipyCell: UITableViewCell {
  
  private typealias `Self` = SwipyCell
  
  static let msStop1              = 0.25 // Percentage limit to trigger the first action
  static let msStop2              = 0.75 // Percentage limit to trigger the second action
  static let msBounceAmplitude    = 20.0 // Maximum bounce amplitude whe using the switch mode
  static let msDamping            = 0.6  // Damping of the spring animation
  static let msVelocity           = 0.9  // Velocity of the spring animation
  static let msAnimationDuration  = 0.4  // Duration of the animation
  static let msBounceDuration1    = 0.2  // Duration of the first part of the bounce animation
  static let msBounceDuration2    = 0.1  // Duration of the second part of the bounce animation
  static let msDurationLowLimit   = 0.25 // Lowest duration when swiping the cell because we try to simulate velocity
  static let msDurationHighLimit  = 0.1  // Highest duration when swiping the cell because we try to simulate velocity
  public typealias MSSwipeCompletionBlock = (SwipyCell, SwipyCellState, SwipyCellMode) -> ()
  
  public var delegate: SwipyCellDelegate?
  var direction: SwipyCellDirection!
  var currentPercentage: CGFloat!
  var isExited: Bool!
  var panGestureRecognizer: UIPanGestureRecognizer!
  var contentScreenshotView: UIImageView?
  var colorIndicatorView: UIView!
  var slidingView: UIView!
  var activeView: UIView!
  var dragging: Bool!
  var shouldDrag: Bool!
  public var shouldAnimateIcons: Bool!
  public var firstTrigger: CGFloat!
  public var secondTrigger: CGFloat!
  var damping: CGFloat!
  var velocity: CGFloat!
  var animationDuration: NSTimeInterval!
  public var defaultColor: UIColor!
  var completionBlock1: MSSwipeCompletionBlock!
  var completionBlock2: MSSwipeCompletionBlock!
  var completionBlock3: MSSwipeCompletionBlock!
  var completionBlock4: MSSwipeCompletionBlock!
  var modeForState1: SwipyCellMode!
  var modeForState2: SwipyCellMode!
  var modeForState3: SwipyCellMode!
  var modeForState4: SwipyCellMode!
  var color1: UIColor!
  var color2: UIColor!
  var color3: UIColor!
  var color4: UIColor!
  var view1: UIView!
  var view2: UIView!
  var view3: UIView!
  var view4: UIView!
  
// MARK: - Initialization
  
  override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initializer()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.initializer()
  }
  
  func initializer() {
    initDefaults()
    
    panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanGestureRecognizer:"))
    addGestureRecognizer(panGestureRecognizer)
    panGestureRecognizer.delegate = self
  }
  
  func initDefaults() {
    isExited = false
    dragging = false
    shouldDrag = true
    shouldAnimateIcons = true
    
    firstTrigger = CGFloat(Self.msStop1)
    secondTrigger = CGFloat(Self.msStop2)
    
    damping = CGFloat(Self.msDamping)
    velocity = CGFloat(Self.msVelocity)
    animationDuration = Self.msAnimationDuration
    
    defaultColor = UIColor.whiteColor()
    
    modeForState1 = .None
    modeForState2 = .None
    modeForState3 = .None
    modeForState4 = .None
    
    color1 = nil
    color2 = nil
    color3 = nil
    color4 = nil
    
    activeView = nil
    view1 = nil
    view2 = nil
    view3 = nil
    view4 = nil
  }
  
// MARK: - Prepare reuse
  
  override public func prepareForReuse() {
    super.prepareForReuse()
    
    uninstallSwipingView()
    initDefaults()
  }
  
// MARK: - View manipulation
  
  func setupSwipingView() {
    if contentScreenshotView != nil {
      return
    }
    
    let isContentViewBackgroundClear = (contentView.backgroundColor != nil)
    if isContentViewBackgroundClear {
      let isBackgroundClear = (backgroundColor == UIColor.clearColor())
      contentView.backgroundColor = isBackgroundClear ? UIColor.whiteColor() : backgroundColor
    }
    
    let contentViewScreenshotImage = imageWithView(self)
    
    if isContentViewBackgroundClear {
      contentView.backgroundColor = nil
    }
    
    colorIndicatorView = UIView(frame: self.bounds)
    colorIndicatorView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    addSubview(colorIndicatorView)
    
    slidingView = UIView()
    slidingView.contentMode = .Center
    colorIndicatorView.addSubview(slidingView)
    
    contentScreenshotView = UIImageView(image: contentViewScreenshotImage)
    addSubview(contentScreenshotView!)
   }
  
  func uninstallSwipingView() {
    if contentScreenshotView == nil {
      return
    }
    
    slidingView.removeFromSuperview()
    slidingView = nil
    
    colorIndicatorView.removeFromSuperview()
    colorIndicatorView = nil
    
    contentScreenshotView!.removeFromSuperview()
    contentScreenshotView = nil
  }
  
  func setViewOfSlidingView(slidingView: UIView) {
    let subviews = self.slidingView.subviews
    _ = subviews.map { view in
      view.removeFromSuperview()
    }
    
    self.slidingView.addSubview(slidingView)
  }
  
// MARK: - Swipe configuration
  
  public func setSwipeGesture(view: UIView, color: UIColor, mode: SwipyCellMode, state: SwipyCellState, completionHandler: MSSwipeCompletionBlock) {
    if state.contains(.State1) {
      completionBlock1 = completionHandler
      view1 = view
      color1 = color
      modeForState1 = mode
    }
    
    if state.contains(.State2) {
      completionBlock2 = completionHandler
      view2 = view
      color2 = color
      modeForState2 = mode
    }
    
    if state.contains(.State3) {
      completionBlock3 = completionHandler
      view3 = view
      color3 = color
      modeForState3 = mode
    }
    
    if state.contains(.State4) {
      completionBlock4 = completionHandler
      view4 = view
      color4 = color
      modeForState4 = mode
    }
  }
  
// MARK: - Handle gestures
  
  func handlePanGestureRecognizer(gesture: UIPanGestureRecognizer) {
    if (shouldDrag == false || isExited == true) {
      return
    }
    
    let state = gesture.state
    let translation = gesture.translationInView(self)
    let velocity = gesture.velocityInView(self)
    var percentage: CGFloat = 0.0
    if let contentScreenshotView = contentScreenshotView {
      percentage = percentageWithOffset(CGRectGetMinX(contentScreenshotView.frame), relativeToWidth: CGRectGetWidth(self.bounds))
    }
    let animationDuration = animationDurationWithVelocity(velocity)
    direction = directionWithPercentage(percentage)
    
    if (state == .Began || state == .Changed) {
      dragging = true
      
      setupSwipingView()
      
      let center = CGPoint(x: contentScreenshotView!.center.x + translation.x, y: contentScreenshotView!.center.y)
      contentScreenshotView!.center = center
      animateWithOffset(CGRectGetMinX(contentScreenshotView!.frame))
      gesture.setTranslation(CGPointZero, inView: self)
      
      delegate?.swipeableTableViewCell(self, didSwipeWithPercentage: percentage)
    } else if (state == .Ended || state == .Cancelled) {
      dragging = false
      activeView = viewWithPercentage(percentage)
      currentPercentage = percentage
      
      let cellState = stateWithPercentage(percentage)
      var cellMode: SwipyCellMode = .None
      
      if (cellState == .State1 && modeForState1 != nil) {
        cellMode = modeForState1
      } else if (cellState == .State2 && modeForState2 != nil) {
        cellMode = modeForState2
      } else if (cellState == .State3 && modeForState3 != nil) {
        cellMode = modeForState3
      } else if (cellState == .State4 && modeForState4 != nil) {
        cellMode = modeForState4
      }
      
      if (cellMode == .Exit && direction != .Center) {
        moveWithDuration(animationDuration, direction: direction)
      } else {
        swipeToOrigin {
          self.executeCompletionBlock()
        }
      }
      
      delegate?.swipeableTableViewCellDidEndSwiping(self)
    }
  }
  
// MARK: - UIGestureRecognizerDelegate
 
  override public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let g = gestureRecognizer as? UIPanGestureRecognizer else { return false }
    
    let point = g.velocityInView(self)
    
    if fabs(point.x) > fabs(point.y) {
      if point.x < 0 && modeForState3 == nil && modeForState4 == nil {
        return false
      }
      
      if point.x > 0 && modeForState1 == nil && modeForState2 == nil {
        return false
      }
      
      delegate?.swipeableTableViewCellDidStartSwiping(self)
      
      return true
    }
    
    return false
  }
  
// MARK: - Percentage
  
  func offsetWithPercentage(percentage: CGFloat, relateiveToWidth width: CGFloat) -> CGFloat {
    var offset = percentage * width
    
    if (offset < -width) {
      offset = -width
    } else if (offset > width) {
      offset = width
    }
    
    return offset
  }
  
  func percentageWithOffset(offset: CGFloat, relativeToWidth width: CGFloat) -> CGFloat {
    var percentage = offset / width
    
    if (percentage < -1.0) {
      percentage = -1.0
    } else if (percentage > 1.0) {
      percentage = 1.0
    }
    
    return percentage
  }
  
  func animationDurationWithVelocity(velocity: CGPoint) -> NSTimeInterval {
    let width = CGRectGetWidth(bounds)
    let animationDurationDiff = Self.msDurationHighLimit - Self.msDurationLowLimit
    var horizontalVelocity = velocity.x
    
    if horizontalVelocity < -width {
      horizontalVelocity = -width
    } else if horizontalVelocity > width {
      horizontalVelocity = width
    }
    
    return NSTimeInterval(Self.msDurationHighLimit + Self.msDurationLowLimit - fabs((Double(horizontalVelocity / width) * animationDurationDiff)))
  }
  
  func directionWithPercentage(percentage: CGFloat) -> SwipyCellDirection {
    if percentage < 0 {
      return .Left
    } else if percentage > 0 {
      return .Right
    } else {
      return .Center
    }
  }
  
  func viewWithPercentage(percentage: CGFloat) -> UIView? {
    var view: UIView?
  
    if percentage >= 0 && modeForState1 != nil {
      view = view1
    }
    
    if percentage >= secondTrigger && modeForState2 != nil {
      view = view2
    }
    
    if percentage < 0 && modeForState3 != nil {
      view = view3
    }
    
    if percentage <= -secondTrigger && modeForState4 != nil {
      view = view4
    }
    
    return view
  }
  
  func alphaWithPercentage(percentage: CGFloat) -> CGFloat {
    var alpha: CGFloat = 1.0
    
    if percentage >= 0 && percentage < firstTrigger {
      alpha = percentage / firstTrigger
    } else if percentage < 0 && percentage > -firstTrigger {
      alpha = fabs(percentage / firstTrigger)
    }
    
    return alpha
  }
  
  func colorWithPercentage(percentage: CGFloat) -> UIColor {
    var color = defaultColor ?? UIColor.clearColor()
    
    if percentage > 0 && modeForState1 != nil {
      color = color1
    }
    
    if percentage > secondTrigger && modeForState2 != nil {
      color = color2
    }
    
    if percentage < 0 && modeForState3 != nil {
      color = color3
    }
    
    if percentage <= -secondTrigger && modeForState4 != nil {
      color = color4
    }
    
    return color
  }
  
  func stateWithPercentage(percentage: CGFloat) -> SwipyCellState {
    var state: SwipyCellState = .None
    
    if percentage >= firstTrigger && modeForState1 != nil {
      state = .State1
    }
    
    if percentage >= secondTrigger && modeForState2 != nil {
      state = .State2
    }
    
    if percentage <= -firstTrigger && modeForState3 != nil {
      state = .State3
    }
    
    if percentage <= -secondTrigger && modeForState4 != nil {
      state = .State4
    }
    
    return state
  }
  
// MARK: - Movement
  
  func animateWithOffset(offset: CGFloat) {
    let percentage = percentageWithOffset(offset, relativeToWidth: CGRectGetWidth(bounds))
    let view = viewWithPercentage(percentage)
    
    if let v = view {
      setViewOfSlidingView(v)
      slidingView.alpha = alphaWithPercentage(percentage)
      slideViewWithPercentage(percentage, view: v, isDragging: shouldAnimateIcons)
    }
    
    let color = colorWithPercentage(percentage)
    colorIndicatorView.backgroundColor = color
  }
  
  func slideViewWithPercentage(percentage: CGFloat, view: UIView?, isDragging: Bool) {
    guard let view = view else { return }
    
    var position = CGPointZero
    position.y = CGRectGetHeight(bounds) / 2.0
    
    if isDragging {
      if percentage >= 0 && percentage < firstTrigger {
        position.x = offsetWithPercentage((firstTrigger / 2), relateiveToWidth: CGRectGetWidth(bounds))
      } else if percentage >= firstTrigger {
        position.x = offsetWithPercentage(percentage - (firstTrigger / 2), relateiveToWidth: CGRectGetWidth(bounds))
      } else if percentage < 0 && percentage >= -firstTrigger {
        position.x = CGRectGetWidth(bounds) - offsetWithPercentage((firstTrigger / 2), relateiveToWidth: CGRectGetWidth(bounds))
      } else if percentage < -firstTrigger {
        position.x = CGRectGetWidth(bounds) + offsetWithPercentage(percentage + (firstTrigger / 2), relateiveToWidth: CGRectGetWidth(bounds))
      }
    } else {
      if direction == .Right {
        position.x = offsetWithPercentage((firstTrigger / 2.0), relateiveToWidth: CGRectGetWidth(bounds))
      } else if direction == .Left {
        position.x = CGRectGetWidth(bounds) - offsetWithPercentage((firstTrigger / 2.0), relateiveToWidth: CGRectGetWidth(bounds))
      } else {
        return
      }
    }
    
    let activeViewSize = view.bounds.size
    var activeViewFrame = CGRect(x: position.x - activeViewSize.width / 2.0,
                                 y: position.y - activeViewSize.height / 2.0,
                                 width: activeViewSize.width, height: activeViewSize.height)
    
    activeViewFrame = CGRectIntegral(activeViewFrame)
    slidingView.frame = activeViewFrame
  }
  
  func moveWithDuration(duration: NSTimeInterval, direction: SwipyCellDirection) {
    isExited = true
    var origin: CGFloat = 0.0
    
    if direction == .Left {
      origin = -CGRectGetWidth(bounds)
    } else if direction == .Right {
      origin = CGRectGetWidth(bounds)
    }
    
    let percentage = percentageWithOffset(origin, relativeToWidth: CGRectGetWidth(bounds))
    var frame = contentScreenshotView!.frame
    frame.origin.x = origin
    
    let color = colorWithPercentage(currentPercentage)
    colorIndicatorView.backgroundColor = color
    
    UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseOut, .AllowUserInteraction], animations: {
      self.contentScreenshotView!.frame = frame
      self.slidingView.alpha = 0
      self.slideViewWithPercentage(percentage, view: self.activeView, isDragging: self.shouldAnimateIcons)
      }, completion: { finished in
        self.executeCompletionBlock()
    })
  }
  
  public func swipeToOrigin(completionHandler: () -> ()) {
    UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: {
      var frame = self.contentScreenshotView!.frame
      frame.origin.x = 0
      self.contentScreenshotView!.frame = frame
      
      self.colorIndicatorView.backgroundColor = self.defaultColor
      
      self.slidingView.alpha = 0
      self.slideViewWithPercentage(0, view: self.activeView, isDragging: false)
      }, completion: { finished in
      self.isExited = false
        self.uninstallSwipingView()
        
        if finished {
          completionHandler()
        }
    })
  }
  
  
// MARK: - Utilities

  func imageWithView(view: UIView) -> UIImage {
    let scale = UIScreen.mainScreen().scale
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, scale)
    view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
// MARK: - Completion block
  
  func executeCompletionBlock() {
    let state: SwipyCellState = stateWithPercentage(currentPercentage)
    var mode: SwipyCellMode = .None
    var completionBlock: MSSwipeCompletionBlock?
    
    if state == .State1 {
      mode = modeForState1
      completionBlock = completionBlock1
    } else if state == .State2 {
      mode = modeForState2
      completionBlock = completionBlock2
    } else if state == .State3 {
      mode = modeForState3
      completionBlock = completionBlock3
    } else if state == .State4 {
      mode = modeForState4
      completionBlock = completionBlock4
    }
    
    if completionBlock != nil {
      completionBlock!(self, state, mode)
    }
  }
}
