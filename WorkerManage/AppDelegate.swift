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
import RxSwift


let appDelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate, BMKLocationAuthDelegate, BMKLocationManagerDelegate, XGPushDelegate {
    var window: UIWindow?
    var dataManager:SocketManager? = nil
//    let sessionManager = SessionManager("download", configuration: SessionConfiguration())
    let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        App.shared.appManager.didFinishLaunching()
        
        if let data = UserDefaults.standard.string(forKey: "token")  {
            if data != ""{
                connetSocket()
            }
        }
        
        if let dataManager = self.dataManager{
            subscribe(disposeBag, dataManager.tempDataDriver){ [weak self] data in
                if data.count > 0{
                    self?.messageAlert(data: data)
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(connetSocket), name: Notification.Name("socketConnect"), object: nil)
        
        return true
    }
    
    @objc func connetSocket(){
        let dataManager = SocketManager.init()
        self.dataManager = dataManager
    }
    
    func messageAlert(data:[SocketMessageData]){
        let alert = SocketMessageAlertView()
        if data.count > 1 {
            alert.sureLabel.text = "前往通知页查看详情"
            alert.contentLabel.text = "有多台设备故障告警，请及时处理。"
        }else if data.count == 1{
            alert.sureLabel.text = "现在处理"
            alert.contentLabel.text = data[0].message
        }
        alert.onTouch = {[weak self] index in
            guard let `self` = self else {return}
            self.dataManager?.tempDataRelay.accept([])
            if index == 1{
                NotificationCenter.default.post(name: Notification.Name("notice"),
                                                object: nil,
                                                userInfo: ["data": data])
            }
            
        }
        alert.show()
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




