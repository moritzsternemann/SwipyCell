SwipyCell
---------
[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)
[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Build Status](https://travis-ci.org/moritzsternemann/SwipyCell.svg)](https://travis-ci.org/moritzsternemann/SwipyCell)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwipyCell.svg)](https://github.com/moritzsternemann/SwipyCell)
[![Platform](https://img.shields.io/cocoapods/p/SwipyCell.svg)](https://github.com/moritzsternemann/SwipyCell)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/moritzsternemann/SwipyCell/master/LICENSE)
[![Twitter](https://img.shields.io/badge/twitter-@iMoritzS-blue.svg?style=flat)](https://twitter.com/iMoritzS)

*Swipeable UITableViewCell inspired by the popular [Mailbox App](http://mailboxapp.com), implemented in [Swift](https://github.com/apple/swift).*

<p align="center"><img src="https://raw.githubusercontent.com/moritzsternemann/SwipyCell/master/github-assets/swipycell-hero.png?raw=true" width="50%"/></p>

## Preview
### Exit Mode
The `.exit` mode is the original behavior, known from the Mailbox app.
<p align="center"><img src="https://raw.githubusercontent.com/moritzsternemann/SwipyCell/master/github-assets/swipycell-exit.gif?raw=true" width="50%"/></p>

### Exit Mode
The `.switch` is another behavior where the cell will bounce back after swiping it.
<p align="center"><img src="https://raw.githubusercontent.com/moritzsternemann/SwipyCell/master/github-assets/swipycell-switch.gif?raw=true" width="50%"/></p>

You can also implement a second trigger (shown in the [Example](#Usage) below).

## Installation
### CocoaPods
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects.
```
$ gem install cocoapods
```
To integrate SwipyCell into your project using CocoaPods, add it to your `Podfile`:
```
pod 'SwipyCell', '~> 2.0.0'
```
Then run the following command:
```
$ pod install
```

### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

Carthage can be installed with [Homebrew](http://brew.sh) using the following commands:
```
$ brew update
$ brew install carthage
```

To integrate SwipyCell into your project using Carthage, add it to your `Cartfile`:
```
github "moritzsternemann/SwipyCell" >= 2.0.0
```

### Manual
Of course you can also add SwipyCell to your project by hand.
To do this clone the repo to your computer and drag the `SwipyCell.xcodeproj` intp your project in Xcode. Then you have to add the `SwipyCell.framework` to your `Embedded Binaries` inside of your project's properties.

## Usage
A complete example is available in the `Example` directory.
The following code is a very basic example:
```swift
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipyCell
    cell.selectionStyle = .gray
    cell.contentView.backgroundColor = UIColor.white

    let checkView = viewWithImageName("check")
    let greenColor = UIColor(red: 85.0 / 255.0, green: 213.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)

    let crossView = viewWithImageName("cross")
    let redColor = UIColor(red: 232.0 / 255.0, green: 61.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)

    let clockView = viewWithImageName("clock")
    let yellowColor = UIColor(red: 254.0 / 255.0, green: 217.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0)

    let listView = viewWithImageName("list")
    let brownColor = UIColor(red: 206.0 / 255.0, green: 149.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)

    cell.defaultColor = tableView.backgroundView?.backgroundColor
    cell.delegate = self

    cell.textLabel?.text = "Switch Mode Cell"
    cell.detailTextLabel?.text = "Swipe to switch"

    cell.setSwipeGesture(checkView, color: greenColor, mode: .switch, state: .state1, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Checkmark\" cell")
    })

    cell.setSwipeGesture(crossView, color: redColor, mode: .switch, state: .state2, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Cross\" cell")
    })

    cell.setSwipeGesture(clockView, color: yellowColor, mode: .switch, state: .state3, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Clock\" cell")
    })

    cell.setSwipeGesture(listView, color: brownColor, mode: .switch, state: .state4, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"List\" cell")
    })
        
    return cell
}
```

## Delegate
SwipyCell provides three delegate methods in order to track the users behaviors.
```swift
// MARK: - SwipyCell Delegate

  // When the user starts swiping the cell this method is called
  func swipeableTableViewCellDidStartSwiping(cell: SwipyCell) {}

  // When the user ends swiping the cell this method is called
  func swipeableTableViewCellDidEndSwiping(cell: SwipyCell) {}

  // When the user is dragging, this method is called with the percentage from the border
  func swipeableTableViewCell(cell: SwipyCell, didSwipeWithPercentage percentage: CGFloat) {}
```

## Changing trigger percentages
If the default trigger values do not fit your taste you can change them like shown in the following lines
```swift
cell.firstTrigger  = 0.1  // Default: 25% (0.25)
cell.secondTrigger = 0.5  // Default: 75% (0.75)
```

## Resetting the cell position
You can animate the cell back to it's default position when using `.exit` mode using the `swipeToOrigin(_:)` method. This could be useful if your app asks the user for confirmation and the user want's to cancel the action.
```swift
cell.swipeToOrigin {
  print("Swiped back")
}
```

## License
SwipyCell is available under the MIT license. See LICENSE file for more info.
