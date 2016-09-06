//
//  RootTabBarViewController.swift
//  HomeAssistant
//
//  Created by Robbie Trencheny on 4/4/16.
//  Copyright © 2016 Robbie Trencheny. All rights reserved.
//

import UIKit
import MBProgressHUD
import Whisper
import ObjectMapper
import PermissionScope

class RootTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RootTabBarViewController.StateChangedSSEEvent(_:)), name:"sse.state_changed", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {

        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        self.delegate = self
        
        let tabBarIconColor = colorWithHexString("#44739E", alpha: 1)
        
        var tabViewControllers : [UIViewController] = []
        
        let firstGroupView = GroupViewController()
        firstGroupView.title = "Loading..."
        
        self.viewControllers = [firstGroupView]
        
        if HomeAssistantAPI.sharedInstance.baseAPIURL == "" {
            dispatch_async(dispatch_get_main_queue(), {
                let settingsView = SettingsViewController()
                settingsView.title = "Settings"
                let navController = UINavigationController(rootViewController: settingsView)
                self.presentViewController(navController, animated: true, completion: nil)
            })
        }
        
        let allGroups = realm.objects(Group.self).filter {
            var shouldReturn = true
            if prefs.boolForKey("allowAllGroups") == false {
                shouldReturn = !$0.Auto
                shouldReturn = !$0.Hidden
                shouldReturn = $0.View
            }
            // If all entities are a group, return false
            var groupCheck = [String]()
            for entity in $0.Entities {
                groupCheck.append(entity.Domain)
            }
            let uniqueCheck = Array(Set(groupCheck))
            if uniqueCheck.count == 1 && uniqueCheck[0] == "group" {
                shouldReturn = false
            }
            return shouldReturn
        }.sort {
            if $0.IsAllGroup == true {
                return false
            } else {
                if $0.Order.value != nil && $1.Order.value != nil {
                    return $0.Order.value < $1.Order.value
                } else {
                    return $0.FriendlyName < $1.FriendlyName
                }
            }
        }
        for (index, group) in allGroups.enumerate() {
            if group.Entities.count < 1 { continue }
            let groupView = GroupViewController()
            groupView.GroupID = String(group.ID)
            groupView.Order = group.Order.value
            groupView.title = group.Name
            groupView.tabBarItem.title = group.Name
            let firstEntity = group.Entities.first!
            var firstEntityIcon = firstEntity.StateIcon()
            if firstEntity.MobileIcon != nil { firstEntityIcon = firstEntity.MobileIcon! }
            if firstEntity.Icon != nil { firstEntityIcon = firstEntity.Icon! }
            let icon = getIconForIdentifier(firstEntityIcon, iconWidth: 30, iconHeight: 30, color: tabBarIconColor)
            groupView.tabBarItem = UITabBarItem(title: group.Name, image: icon, tag: index)
            
            if group.Order.value == nil {
                // Save the index now since it should be first time running
                try! realm.write {
                    group.Order.value = index
                }
            }
            
            if HomeAssistantAPI.sharedInstance.locationEnabled() {
                var rightBarItems : [UIBarButtonItem] = []
                
                let uploadIcon = getIconForIdentifier("mdi:upload", iconWidth: 30, iconHeight: 30, color: tabBarIconColor)
                
                rightBarItems.append(UIBarButtonItem(image: uploadIcon, style: .Plain, target: self, action: #selector(RootTabBarViewController.sendCurrentLocation(_:))))
                
                let mapIcon = getIconForIdentifier("mdi:map", iconWidth: 30, iconHeight: 30, color: tabBarIconColor)
                
                rightBarItems.append(UIBarButtonItem(image: mapIcon, style: .Plain, target: self, action: #selector(RootTabBarViewController.openMapView(_:))))
                
                groupView.navigationItem.setRightBarButtonItems(rightBarItems, animated: true)
            }
            
            let navController = UINavigationController(rootViewController: groupView)
            
            tabViewControllers.append(navController)
        }
        let settingsIcon = getIconForIdentifier("mdi:settings", iconWidth: 30, iconHeight: 30, color: tabBarIconColor)
        
        let settingsView = SettingsViewController()
        settingsView.title = "Settings"
        settingsView.tabBarItem = UITabBarItem(title: "Settings", image: settingsIcon, tag: 1)
        
        tabViewControllers.append(UINavigationController(rootViewController: settingsView))
        
        self.viewControllers = tabViewControllers
        
        tabViewControllers.removeLast()
        
        self.customizableViewControllers = tabViewControllers
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true;
    }
    
    func tabBarController(tabBarController: UITabBarController, willEndCustomizingViewControllers viewControllers: [UIViewController], changed: Bool) {
        
    }
    
    func tabBarController(tabBarController: UITabBarController, didEndCustomizingViewControllers viewControllers: [UIViewController], changed: Bool) {
        if (changed) {
            for (index, view) in viewControllers.enumerate() {
                if let groupView = (view as! UINavigationController).viewControllers[0] as? GroupViewController {
                    let update = ["ID": groupView.GroupID, "Order": index]
                    try! realm.write {
                        realm.create(Group.self, value: update, update: true)
                    }
                    print("\(index): \(groupView.tabBarItem.title!) New: \(index) Old: \(groupView.Order!)")
                } else {
                    print("Couldn't cast to a group, must be settings, skipping!")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func StateChangedSSEEvent(notification: NSNotification){
        if let userInfo = notification.userInfo {
            if let event = Mapper<StateChangedEvent>().map(userInfo["jsonObject"]) {
                let newState = event.NewState! as Entity
                let oldState = event.OldState! as Entity
                var subtitleString = "\(newState.FriendlyName!) is now \(newState.State). It was \(oldState.State)"
                if let newStateSensor = newState as? Sensor {
                    let oldStateSensor = oldState as! Sensor
                    subtitleString = "\(newStateSensor.State) \(newStateSensor.UnitOfMeasurement) . It was \(oldState.State) \(oldStateSensor.UnitOfMeasurement)"
                }
                show(whistle: Murmur(title: subtitleString), action: .Show(1))
            }
        }
    }

    func openMapView(sender: UIButton) {
        let devicesMapView = DevicesMapViewController()
        
        let navController = UINavigationController(rootViewController: devicesMapView)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func sendCurrentLocation(sender: UIButton) {
        HomeAssistantAPI.sharedInstance.sendOneshotLocation("One off location update requested").then { success -> Void in
            print("Did succeed?", success)
            let alert = UIAlertController(title: "Location updated", message: "Successfully sent a one shot location to the server", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }.error { error in
            let nserror = error as NSError
            let alert = UIAlertController(title: "Location failed to update", message: "Failed to send current location to server. The error was \(nserror.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
