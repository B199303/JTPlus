//
//  WelcomeScreenViewController.swift
//  WorkerManage
//
//  Created by BL L on 2022/11/1.
//

import UIKit
import WebKit

class WelcomeScreenViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor
        
        playVideo()
    }
    
    func playVideo() {
        
        let gifView = WKWebView(frame: CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: CGFloat.screenHeight))
        let urlStr = URL(fileURLWithPath: Bundle.main.path(forResource: "welcome", ofType: "gif")!)
        var gifData : Data = Data()
        do{
            gifData = try Data(contentsOf: urlStr)
        }
        catch { }
        gifView.isUserInteractionEnabled = false
        gifView.load(gifData , mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: urlStr)
        view.addSubview(gifView)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) { 
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                if keyWindow.rootViewController is WelcomeScreenViewController {
                    debugPrint("keyWindow.set(newRootController: LaunchRouter.module())")
                    keyWindow.set(newRootController: LaunchRouter.module())
                    if let data = UserDefaults.standard.string(forKey: "token")  {
                        if data != ""{
                            keyWindow.set(newRootController: LaunchRouter.module())
                        }else{
                            keyWindow.set(newRootController: LoginViewController())
                        }
                    }else{
                        keyWindow.set(newRootController: LoginViewController())
                    }
                    
                }
            }
        }
        
    }
}
