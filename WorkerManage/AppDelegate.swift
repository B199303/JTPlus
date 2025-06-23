//
//  AppDelegate.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import UIKit
import IQKeyboardManagerSwift
import AlamofireImage
import BMKLocationKit
import Bugly
import Tiercel


let appDelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate, BMKLocationAuthDelegate, BMKLocationManagerDelegate, XGPushDelegate {
    var window: UIWindow?
    
//    let sessionManager = SessionManager("download", configuration: SessionConfiguration())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        App.shared.appManager.didFinishLaunching()
        
        return true
    }
    
    func setBMKMapManager(){
        let mapManager = BMKMapManager()
        // 启动引擎并设置AK并设置delegate
        if !(mapManager.start("Uk8whgoq4myAYUGcPbrKG9DkpMbegdXM", generalDelegate: self)) {
            NSLog("启动引擎失败")
        }
        if BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORD_TYPE.COORDTYPE_BD09LL) {
            NSLog("经纬度类型设置成功")
        } else {
            NSLog("经纬度类型设置失败")
        }
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}




