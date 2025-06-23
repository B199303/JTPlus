//
//  SceneDelegate.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import UIKit
import Tiercel
import ObjectMapper
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let disposeBag = DisposeBag()
    
    var alertList:[AlarmAlertView] = []
//    let mqtt = CocoaMQTT5(clientID: "CocoaMQTT5-" + String(ProcessInfo().processIdentifier), host: "192.168.172.228", port: 1883)
    var dataManager:SocketManager? = nil

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let windowScene = scene as? UIWindowScene
        self.window = UIWindow.init(windowScene: windowScene!)
        self.window?.frame = UIScreen.main.bounds
//        window?.rootViewController = WelcomeScreenViewController()
//        self.window?.rootViewController = LoginViewController()
        
//        self.window?.rootViewController = LaunchRouter.module()
        if let data = UserDefaults.standard.string(forKey: "token")  {
            if data != ""{
                self.window?.rootViewController = LaunchRouter.module()
            }else{
                self.window?.rootViewController = LoginViewController()
            }
        }else{
           self.window?.rootViewController = LoginViewController()
        }
        
        self.window?.makeKeyAndVisible()
        
//        mqttSetUp()
        let dataManager = SocketManager.init()
        self.dataManager = dataManager
        
        
        
        if let dataManager = self.dataManager{
            subscribe(disposeBag, dataManager.tempDataDriver){ [weak self] data in
                if data.count > 0{
                    self?.messageAlert(data: data)
                }
            }
        }
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

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        NotificationCenter.default.post(name: Notification.Name("reloadMap"),
                                        object: nil,
                                        userInfo: nil)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}



