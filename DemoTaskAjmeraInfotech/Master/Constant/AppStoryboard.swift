//
//  AppStoryboard.swift
//  DemoTaskAjmeraInfotech
//
//  Created by Shail Patel on 18/01/24.
//

import Foundation
import UIKit

enum AppStoryboard<T: UIViewController>: String {
    
    case Main = "Main"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController(viewControllerClass: T.Type) -> T? {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        if #available(iOS 13.0, *) {
            if let controller = instance.instantiateViewController(identifier: storyboardID) as? T {
                return controller
            }
        } else {
            if let controller = instance.instantiateViewController(withIdentifier: storyboardID) as? T {
                return controller
            }
        }
        return nil
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
