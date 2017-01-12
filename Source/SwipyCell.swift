//
//  SwipyCell.swift
//  SwipyCell
//
//  Created by Moritz Sternemann on 17.01.16.
//  Copyright © 2016 Moritz Sternemann. All rights reserved.
//

import UIKit

public protocol SwipyCellDelegate {
  func swipeableTableViewCellDidStartSwiping(_ cell: SwipyCell)
  func swipeableTableViewCellDidEndSwiping(_ cell: SwipyCell)
  func swipeableTableViewCell(_ cell: SwipyCell, didSwipeWithPercentage percentage: CGFloat)
}

open class SwipyCell: UITableViewCell {
  
  fileprivate typealias `Self` = SwipyCell
  
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
  var animationDuration: TimeInterval!
  public var defaultColor: UIColor!
  var completionBlock1: MSSwipeCompletionBlock!
  var completionBlock2: MSSwipeCompletionBlock!
  var completionBlock3: MSSwipeCompletionBlock!
  var completionBlock4: MSSwipeCompletionBlock!
  var modeForState1: SwipyCellMode!
  var modeForState2: SwipyCellMode!
  var modeForState3: SwipyCellMode!
  var modeForState4: SwipyCellMode!
  public var color1: UIColor!
  public var color2: UIColor!
  public var color3: UIColor!
  public var color4: UIColor!
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
    
    panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwipyCell.handlePanGestureRecognizer(_:)))
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
    
    defaultColor = UIColor.white
    
    modeForState1 = .none
    modeForState2 = .none
    modeForState3 = .none
    modeForState4 = .none
    
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
  
  override open func prepareForReuse() {
    super.prepareForReuse()
    
    uninstallSwipingView()
    initDefaults()
  }
  
// MARK: - View manipulation
  
  func setupSwipingView() {
    if contentScreenshotView != nil {
      return
    }
    
    let contentViewScreenshotImage = imageWithView(self)
    
    colorIndicatorView = UIView(frame: self.bounds)
    colorIndicatorView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    addSubview(colorIndicatorView)
    
    slidingView = UIView()
    slidingView.contentMode = .center
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
  
  func setViewOfSlidingView(_ slidingView: UIView) {
    let subviews = self.slidingView.subviews
    _ = subviews.map { view in
      view.removeFromSuperview()
    }
    
    self.slidingView.addSubview(slidingView)
  }
  
// MARK: - Swipe configuration
  
  public func setSwipeGesture(_ view: UIView, color: UIColor, mode: SwipyCellMode, state: SwipyCellState, completionHandler: @escaping MSSwipeCompletionBlock) {
    if state.contains(.state1) {
      completionBlock1 = completionHandler
      view1 = view
      color1 = color
      modeForState1 = mode
    }
    
    if state.contains(.state2) {
      completionBlock2 = completionHandler
      view2 = view
      color2 = color
      modeForState2 = mode
    }
    
    if state.contains(.state3) {
      completionBlock3 = completionHandler
      view3 = view
      color3 = color
      modeForState3 = mode
    }
    
    if state.contains(.state4) {
      completionBlock4 = completionHandler
      view4 = view
      color4 = color
      modeForState4 = mode
    }
  }
  
// MARK: - Handle gestures
  
  func handlePanGestureRecognizer(_ gesture: UIPanGestureRecognizer) {
    if (shouldDrag == false || isExited == true) {
      return
    }
    
    let state = gesture.state
    let translation = gesture.translation(in: self)
    let velocity = gesture.velocity(in: self)
    var percentage: CGFloat = 0.0
    if let contentScreenshotView = contentScreenshotView {
      percentage = percentageWithOffset(contentScreenshotView.frame.minX, relativeToWidth: self.bounds.width)
    }
    let animationDuration = animationDurationWithVelocity(velocity)
    direction = directionWithPercentage(percentage)
    
    if (state == .began || state == .changed) {
      dragging = true
      
      setupSwipingView()
      
      let center = CGPoint(x: contentScreenshotView!.center.x + translation.x, y: contentScreenshotView!.center.y)
      contentScreenshotView!.center = center
      animateWithOffset(contentScreenshotView!.frame.minX)
      gesture.setTranslation(CGPoint.zero, in: self)
      
      delegate?.swipeableTableViewCell(self, didSwipeWithPercentage: percentage)
    } else if (state == .ended || state == .cancelled) {
      dragging = false
      activeView = viewWithPercentage(percentage)
      currentPercentage = percentage
      
      let cellState = stateWithPercentage(percentage)
      var cellMode: SwipyCellMode = .none
      
      if (cellState == .state1 && modeForState1 != nil) {
        cellMode = modeForState1
      } else if (cellState == .state2 && modeForState2 != nil) {
        cellMode = modeForState2
      } else if (cellState == .state3 && modeForState3 != nil) {
        cellMode = modeForState3
      } else if (cellState == .state4 && modeForState4 != nil) {
        cellMode = modeForState4
      }
      
      if (cellMode == .exit && direction != .center) {
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
 
  override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let g = gestureRecognizer as? UIPanGestureRecognizer else { return false }
    
    let point = g.velocity(in: self)
    
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
  
  func offsetWithPercentage(_ percentage: CGFloat, relateiveToWidth width: CGFloat) -> CGFloat {
    var offset = percentage * width
    
    if (offset < -width) {
      offset = -width
    } else if (offset > width) {
      offset = width
    }
    
    return offset
  }
  
  func percentageWithOffset(_ offset: CGFloat, relativeToWidth width: CGFloat) -> CGFloat {
    var percentage = offset / width
    
    if (percentage < -1.0) {
      percentage = -1.0
    } else if (percentage > 1.0) {
      percentage = 1.0
    }
    
    return percentage
  }
  
  func animationDurationWithVelocity(_ velocity: CGPoint) -> TimeInterval {
    let width = bounds.width
    let animationDurationDiff = Self.msDurationHighLimit - Self.msDurationLowLimit
    var horizontalVelocity = velocity.x
    
    if horizontalVelocity < -width {
      horizontalVelocity = -width
    } else if horizontalVelocity > width {
      horizontalVelocity = width
    }
    
    return TimeInterval(Self.msDurationHighLimit + Self.msDurationLowLimit - fabs((Double(horizontalVelocity / width) * animationDurationDiff)))
  }
  
  func directionWithPercentage(_ percentage: CGFloat) -> SwipyCellDirection {
    if percentage < 0 {
      return .left
    } else if percentage > 0 {
      return .right
    } else {
      return .center
    }
  }
  
  func viewWithPercentage(_ percentage: CGFloat) -> UIView? {
    var view: UIView?
  
    if percentage >= 0 && modeForState1 != nil {
      view = view1
    }
    
    if percentage >= secondTrigger! && modeForState2 != nil {
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
  
  func alphaWithPercentage(_ percentage: CGFloat) -> CGFloat {
    var alpha: CGFloat = 1.0
    
    if percentage >= 0 && percentage < firstTrigger! {
      alpha = percentage / firstTrigger
    } else if percentage < 0 && percentage > -firstTrigger {
      alpha = fabs(percentage / firstTrigger)
    }
    
    return alpha
  }
  
  func colorWithPercentage(_ percentage: CGFloat) -> UIColor {
    var color = defaultColor ?? UIColor.clear
    
    if percentage > 0 && modeForState1 != nil {
      color = color1
    }
    
    if percentage > secondTrigger! && modeForState2 != nil {
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
  
  func stateWithPercentage(_ percentage: CGFloat) -> SwipyCellState {
    var state: SwipyCellState = .none
    
    if percentage >= firstTrigger! && modeForState1 != nil {
      state = .state1
    }
    
    if percentage >= secondTrigger! && modeForState2 != nil {
      state = .state2
    }
    
    if percentage <= -firstTrigger && modeForState3 != nil {
      state = .state3
    }
    
    if percentage <= -secondTrigger && modeForState4 != nil {
      state = .state4
    }
    
    return state
  }
  
// MARK: - Movement
  
  func animateWithOffset(_ offset: CGFloat) {
    let percentage = percentageWithOffset(offset, relativeToWidth: bounds.width)
    let view = viewWithPercentage(percentage)
    
    if let v = view {
      setViewOfSlidingView(v)
      slidingView.alpha = alphaWithPercentage(percentage)
      slideViewWithPercentage(percentage, view: v, isDragging: shouldAnimateIcons)
    }
    
    let color = colorWithPercentage(percentage)
    colorIndicatorView.backgroundColor = color
  }
  
  func slideViewWithPercentage(_ percentage: CGFloat, view: UIView?, isDragging: Bool) {
    guard let view = view else { return }
    
    var position = CGPoint.zero
    position.y = bounds.height / 2.0
    
    if isDragging {
      if percentage >= 0 && percentage < firstTrigger! {
        position.x = offsetWithPercentage((firstTrigger / 2), relateiveToWidth: bounds.width)
      } else if percentage >= firstTrigger! {
        position.x = offsetWithPercentage(percentage - (firstTrigger / 2), relateiveToWidth: bounds.width)
      } else if percentage < 0 && percentage >= -firstTrigger {
        position.x = bounds.width - offsetWithPercentage((firstTrigger / 2), relateiveToWidth: bounds.width)
      } else if percentage < -firstTrigger {
        position.x = bounds.width + offsetWithPercentage(percentage + (firstTrigger / 2), relateiveToWidth: bounds.width)
      }
    } else {
      if direction == .right {
        position.x = offsetWithPercentage((firstTrigger / 2.0), relateiveToWidth: bounds.width)
      } else if direction == .left {
        position.x = bounds.width - offsetWithPercentage((firstTrigger / 2.0), relateiveToWidth: bounds.width)
      } else {
        return
      }
    }
    
    let activeViewSize = view.bounds.size
    var activeViewFrame = CGRect(x: position.x - activeViewSize.width / 2.0,
                                 y: position.y - activeViewSize.height / 2.0,
                                 width: activeViewSize.width, height: activeViewSize.height)
    
    activeViewFrame = activeViewFrame.integral
    slidingView.frame = activeViewFrame
  }
  
  func moveWithDuration(_ duration: TimeInterval, direction: SwipyCellDirection) {
    isExited = true
    var origin: CGFloat = 0.0
    
    if direction == .left {
      origin = -bounds.width
    } else if direction == .right {
      origin = bounds.width
    }
    
    let percentage = percentageWithOffset(origin, relativeToWidth: bounds.width)
    var frame = contentScreenshotView!.frame
    frame.origin.x = origin
    
    let color = colorWithPercentage(currentPercentage)
    colorIndicatorView.backgroundColor = color
    
    UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
      self.contentScreenshotView!.frame = frame
      self.slidingView.alpha = 0
      self.slideViewWithPercentage(percentage, view: self.activeView, isDragging: self.shouldAnimateIcons)
      }, completion: { finished in
        self.executeCompletionBlock()
    })
  }
  
  open func swipeToOrigin(_ completionHandler: @escaping () -> ()) {
    UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions(), animations: {
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

  func imageWithView(_ view: UIView) -> UIImage {
    let scale = UIScreen.main.scale
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, scale)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
  
// MARK: - Completion block
  
  func executeCompletionBlock() {
    let state: SwipyCellState = stateWithPercentage(currentPercentage)
    var mode: SwipyCellMode = .none
    var completionBlock: MSSwipeCompletionBlock?
    
    if state == .state1 {
      mode = modeForState1
      completionBlock = completionBlock1
    } else if state == .state2 {
      mode = modeForState2
      completionBlock = completionBlock2
    } else if state == .state3 {
      mode = modeForState3
      completionBlock = completionBlock3
    } else if state == .state4 {
      mode = modeForState4
      completionBlock = completionBlock4
    }
    
    if completionBlock != nil {
      completionBlock!(self, state, mode)
    }
  }
}
