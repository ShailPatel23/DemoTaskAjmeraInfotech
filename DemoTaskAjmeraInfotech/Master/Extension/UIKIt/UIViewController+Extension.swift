//
//  UIViewController+Extension.swift
//  DemoTaskAjmeraInfotech
//
//  Created by Shail Patel on 18/01/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiateFrom(appStoryboard: AppStoryboard<UIViewController>) -> Self? {
        return appStoryboard.viewController(viewControllerClass: self) as? Self
    }
}
