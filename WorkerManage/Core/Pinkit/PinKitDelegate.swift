//
//  PinKitDelegate.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

//import Foundation
//import UIKit
//
//class PinKitDelegate {
//    var viewController: UIViewController?
//}
//
//extension PinKitDelegate: IPinKitDelegate {
//
//    func onLock(delegate: IUnlockDelegate) {
//        var controller = viewController
//
//        while let presentedController = controller?.presentedViewController {
//            controller = presentedController
//        }
//
//        controller?.present(LockScreenRouter.module(pinKit: App.shared.pinKit, appStart: false), animated: true)
//    }
//
//}
