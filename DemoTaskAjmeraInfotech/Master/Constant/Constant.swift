//
//  Constant.swift
//  DemoTaskAjmeraInfotech
//
//  Created by Shail Patel on 18/01/24.
//

import Foundation
import UIKit

let CUserDefaults = UserDefaults.standard

let CMainScreen = UIScreen.main
let CBounds = CMainScreen.bounds

let CScreenSize = CBounds.size
let CScreenWidth = CScreenSize.width
let CScreenHeight = CScreenSize.height

let CSharedApplication = UIApplication.shared
let appDelegate = CSharedApplication.delegate as! AppDelegate

let CCurrentDevice = UIDevice.current
let CUserInterfaceIdiom = CCurrentDevice.userInterfaceIdiom
let IS_iPhone = CUserInterfaceIdiom == .phone
let IS_iPad = CUserInterfaceIdiom == .pad
let COrietation = CCurrentDevice.orientation
let IS_Portrait = COrietation.isPortrait
let IS_Landscape = COrietation.isLandscape

let CGCDMainThread = DispatchQueue.main
let CGCDBackgroundThread = DispatchQueue.global(qos: .background)

func getAutoDimension(size: CGFloat) -> CGFloat {
    return ((CScreenWidth * size) / 375.0)
}
