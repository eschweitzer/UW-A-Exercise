//
//  AppDelegate.swift
//  UW&A Exercise
//
//  Created by Eric Schweitzer on 7/11/20.
//  Copyright © 2020 Eric Schweitzer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let splitViewController = self.window?.rootViewController as? UISplitViewController else {
          fatalError("Missing SplitViewController")
        }
        
        splitViewController.preferredDisplayMode = .allVisible
        let controllers = splitViewController.viewControllers
        if let masterViewController = (controllers.first as? UINavigationController)?.topViewController as? MasterViewController {
            splitViewController.delegate = masterViewController
        }
        return true
    }

}

