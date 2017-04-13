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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(SwipyCellViewController.reload))
        
        let backgroundView = UIView(frame: tableView.frame)
        backgroundView.backgroundColor = UIColor.white
        tableView.backgroundView = backgroundView
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipyCell
        cell.selectionStyle = .gray
        cell.contentView.backgroundColor = UIColor.white
        
        configureCell(cell, forRowAtIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: SwipyCell, forRowAtIndexPath indexPath: IndexPath) {
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
            
            cell.addSwipeTrigger(forState: .state(0, .left), withMode: .toggle, swipeView: checkView, swipeColor: greenColor, completion: { cell, state, mode in
                print("Did swipe \"Checkmark\" cell")
            })
            
            cell.addSwipeTrigger(forState: .state(1, .left), withMode: .toggle, swipeView: crossView, swipeColor: redColor, completion: { cell, state, mode in
                print("Did swipe \"Cross\" cell")
            })
            
            cell.addSwipeTrigger(forState: .state(0, .right), withMode: .toggle, swipeView: clockView, swipeColor: yellowColor, completion: { cell, state, mode in
                print("Did swipe \"Clock\" cell")
            })
            
            cell.addSwipeTrigger(forState: .state(1, .right), withMode: .toggle, swipeView: listView, swipeColor: brownColor, completion: { cell, state, mode in
                print("Did swipe \"List\" cell")
            })
        } else if indexPath.row % initialNumberItems == 1 {
            cell.textLabel?.text = "Exit Mode Cell"
            cell.detailTextLabel?.text = "Swipe to delete"
            
            cell.addSwipeTrigger(forState: .state(0, .left), withMode: .exit, swipeView: crossView, swipeColor: redColor, completion: { cell, state, mode in
                print("Did swipe \"Cross\" cell")
                
                self.deleteCell(cell)
            })
        } else if indexPath.row % initialNumberItems == 2 {
            cell.textLabel?.text = "Mixed Mode Cell"
            cell.detailTextLabel?.text = "Swipe to switch or delete"
            
            cell.addSwipeTrigger(forState: .state(0, .left), withMode: .toggle, swipeView: checkView, swipeColor: greenColor, completion: { cell, state, mode in
                print("Did swipe \"Checkmark\" cell")
            })
            
            cell.addSwipeTrigger(forState: .state(1, .left), withMode: .exit, swipeView: crossView, swipeColor: redColor, completion: { cell, state, mode in
                print("Did swipe \"Cross\" cell")
                
                self.deleteCell(cell)
            })
        } else if indexPath.row % initialNumberItems == 3 {
            cell.textLabel?.text = "Un-animated Icons"
            cell.detailTextLabel?.text = "Swipe"
            cell.shouldAnimateSwipeViews = false
            
            cell.addSwipeTrigger(forState: .state(0, .left), withMode: .toggle, swipeView: checkView, swipeColor: greenColor, completion: { cell, state, mode in
                print("Did swipe \"Checkmark\" cell")
            })
            
            cell.addSwipeTrigger(forState: .state(1, .left), withMode: .exit, swipeView: crossView, swipeColor: redColor, completion: { cell, state, mode in
                print("Did swipe \"Cross\" cell")
                
                self.deleteCell(cell)
            })
        } else if indexPath.row % initialNumberItems == 4 {
            cell.textLabel?.text = "Right swipe only"
            cell.detailTextLabel?.text = "Swipe"
            
            cell.addSwipeTrigger(forState: .state(0, .right), withMode: .toggle, swipeView: clockView, swipeColor: yellowColor, completion: { cell, state, mode in
                print("Did swipe \"Clock\" cell")
            })
            
            cell.addSwipeTrigger(forState: .state(1, .right), withMode: .toggle, swipeView: listView, swipeColor: brownColor, completion: { cell, state, mode in
                print("Did swipe \"List\" cell")
            })
        } else if indexPath.row % initialNumberItems == 5 {
            cell.textLabel?.text = "Small triggers"
            cell.detailTextLabel?.text = "Using 10% and 50%"
            cell.setTriggerPoints(points: [0.1, 0.5])
            
            cell.addSwipeTrigger(forState: .state(0, .left), withMode: .toggle, swipeView: checkView, swipeColor: greenColor, completion: { cell, state, mode in
                print("Did swipe \"Checkmark\" cell")
            })
            
            cell.addSwipeTrigger(forState: .state(1, .left), withMode: .exit, swipeView: crossView, swipeColor: redColor, completion: { cell, state, mode in
                print("Did swipe \"Cross\" cell")
                
                self.deleteCell(cell)
            })
        } else if indexPath.row % initialNumberItems == 6 {
            cell.textLabel?.text = "Exit Mode Cell + Confirmation"
            cell.detailTextLabel?.text = "Swipe to delete"
            
            cell.addSwipeTrigger(forState: .state(0, .left), withMode: .exit, swipeView: crossView, swipeColor: redColor, completion: { cell, state, mode in
                print("Did swipe \"Cross\" cell")
                
                self.cellToDelete = cell
                
                let alertController = UIAlertController(title: "Delete?", message: "Are you sure you want to delete the cell?", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    cell.swipeToOrigin {
                        print("Swiped back")
                    }
                })
                alertController.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                    self.numberItems -= 1
                    self.tableView.deleteRows(at: [self.tableView.indexPath(for: cell)!], with: .fade)
                })
                alertController.addAction(deleteAction)
                
                self.present(alertController, animated: true, completion: {})
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    // MARK: - SwipyCell Delegate
    
    // When the user starts swiping the cell this method is called
    func swipyCellDidStartSwiping(_ cell: SwipyCell) {
        
    }
    
    // When the user ends swiping the cell this method is called
    func swipyCellDidFinishSwiping(_ cell: SwipyCell) {
        
    }
    
    // When the user is dragging, this method is called with the percentage from the border
    func swipyCell(_ cell: SwipyCell, didSwipeWithPercentage percentage: CGFloat) {
        
    }
    
    // MARK: - Utils
    
    func reload() {
        numberItems = self.initialNumberItems
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
    func deleteCell(_ cell: SwipyCell) {
        numberItems -= 1
        
        let indexPath = tableView.indexPath(for: cell)
        tableView.deleteRows(at: [indexPath!], with: .fade)
    }
    
    func viewWithImageName(_ imageName: String) -> UIView {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        return imageView
    }
}
