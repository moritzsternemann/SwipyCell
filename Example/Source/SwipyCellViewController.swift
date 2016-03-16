//
//  ViewController.swift
//  SwipyCellExample
//
//  Created by Moritz Sternemann on 15.03.16.
//  Copyright © 2016 Moritz Sternemann. All rights reserved.
//

import UIKit
import SwipyCell

class SwipyCellViewController: UITableViewController, SwipyCellDelegate {
  
  let initialNumberItems = 7
  var numberItems: Int = 0
  var cellToDelete: SwipyCell? = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    numberItems = self.initialNumberItems

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: Selector("reload"))
    
    let backgroundView = UIView(frame: tableView.frame)
    backgroundView.backgroundColor = UIColor.whiteColor()
    tableView.backgroundView = backgroundView
    tableView.tableFooterView = UIView()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
// MARK: - Table View Data Source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberItems
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: SwipyCell?// = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? MSSwipeableTableViewCell
    
    if (cell == nil) {
      cell = SwipyCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
      cell?.selectionStyle = .Gray
      cell?.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    configureCell(cell!, forRowAtIndexPath: indexPath)
    
    return cell!
  }

  func configureCell(cell: SwipyCell, forRowAtIndexPath indexPath: NSIndexPath) {
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
    
    if indexPath.row % initialNumberItems == 0 {
      cell.textLabel?.text = "Switch Mode Cell"
      cell.detailTextLabel?.text = "Swipe to switch"
      
      cell.setSwipeGesture(checkView, color: greenColor, mode: .Switch, state: .State1, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Checkmark\" cell")
      })
      
      cell.setSwipeGesture(crossView, color: redColor, mode: .Switch, state: .State2, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Cross\" cell")
      })
      
      cell.setSwipeGesture(clockView, color: yellowColor, mode: .Switch, state: .State3, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Clock\" cell")
      })
      
      cell.setSwipeGesture(listView, color: brownColor, mode: .Switch, state: .State4, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"List\" cell")
      })
    } else if indexPath.row % initialNumberItems == 1 {
      cell.textLabel?.text = "Exit Mode Cell"
      cell.detailTextLabel?.text = "Swipe to delete"
      
      cell.setSwipeGesture(crossView, color: redColor, mode: .Exit, state: .State1, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Cross\" cell")
        
        self.deleteCell(cell)
      })
    } else if indexPath.row % initialNumberItems == 2 {
      cell.textLabel?.text = "Mixed Mode Cell"
      cell.detailTextLabel?.text = "Swipe to switch or delete"
      
      cell.setSwipeGesture(checkView, color: greenColor, mode: .Switch, state: .State1, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Checkmark\" cell")
      })
      
      cell.setSwipeGesture(crossView, color: redColor, mode: .Exit, state: .State2, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Cross\" cell")
        
        self.deleteCell(cell)
      })
    } else if indexPath.row % initialNumberItems == 3 {
      cell.textLabel?.text = "Un-animated Icons"
      cell.detailTextLabel?.text = "Swipe"
      cell.shouldAnimateIcons = false
      
      cell.setSwipeGesture(checkView, color: greenColor, mode: .Switch, state: .State1, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Checkmark\" cell")
      })
      
      cell.setSwipeGesture(crossView, color: redColor, mode: .Exit, state: .State2, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Cross\" cell")
        
        self.deleteCell(cell)
      })
    } else if indexPath.row % initialNumberItems == 4 {
      cell.textLabel?.text = "Right swipe only"
      cell.detailTextLabel?.text = "Swipe"
      
      cell.setSwipeGesture(clockView, color: yellowColor, mode: .Switch, state: .State3, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Clock\" cell")
      })
      
      cell.setSwipeGesture(listView, color: brownColor, mode: .Switch, state: .State4, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"List\" cell")
      })
    } else if indexPath.row % initialNumberItems == 5 {
      cell.textLabel?.text = "Small triggers"
      cell.detailTextLabel?.text = "Using 10% and 50%"
      cell.firstTrigger = 0.1
      cell.secondTrigger = 0.5
      
      cell.setSwipeGesture(checkView, color: greenColor, mode: .Switch, state: .State1, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Checkmark\" cell")
      })
      
      cell.setSwipeGesture(crossView, color: redColor, mode: .Exit, state: .State2, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Cross\" cell")
        
        self.deleteCell(cell)
      })
    } else if indexPath.row % initialNumberItems == 6 {
      cell.textLabel?.text = "Exit Mode Cell + Confirmation"
      cell.detailTextLabel?.text = "Swipe to delete"
      
      cell.setSwipeGesture(crossView, color: redColor, mode: .Exit, state: .State1, completionHandler: { (cell: SwipyCell, state: SwipyCellState, mode: SwipyCellMode) in
        print("Did swipe \"Cross\" cell")
        
        self.cellToDelete = cell
        
        let alertController = UIAlertController(title: "Delete?", message: "Are you sure you want to delete the cell?", preferredStyle: .Alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
          cell.swipeToOrigin {
            print("Swiped back")
          }
        })
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) in
          self.numberItems--
          self.tableView.deleteRowsAtIndexPaths([self.tableView.indexPathForCell(cell)!], withRowAnimation: .Fade)
        })
        alertController.addAction(deleteAction)
        
        self.presentViewController(alertController, animated: true, completion: {})
      })
    }
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 70.0
  }
  
// MARK: - Table View Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let tableViewController = SwipyCellViewController()
    self.navigationController?.pushViewController(tableViewController, animated: true)
  }
  
// MARK: - SwipyCell Delegate
  
  // When the user starts swiping the cell this method is called
  func swipeableTableViewCellDidStartSwiping(cell: SwipyCell) {
    
  }
  
  // When the user ends swiping the cell this method is called
  func swipeableTableViewCellDidEndSwiping(cell: SwipyCell) {
    
  }
  
  // When the user is dragging, this method is called with the percentage from the border
  func swipeableTableViewCell(cell: SwipyCell, didSwipeWithPercentage percentage: CGFloat) {
    
  }
  
// MARK: - Utils
  
  func reload() {
    numberItems = self.initialNumberItems
    tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
  }
  
  func deleteCell(cell: SwipyCell) {
    numberItems--
    
    let indexPath = tableView.indexPathForCell(cell)
    tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
  }
  
  func viewWithImageName(imageName: String) -> UIView {
    let image = UIImage(named: imageName)
    let imageView = UIImageView(image: image)
    imageView.contentMode = .Center
    return imageView
  }
}
