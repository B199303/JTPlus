//
//  LockScreenRouter.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

//import UIKit
//
//class LockScreenRouter: ILockScreenRouter {
//
//    func reloadAppInterface() {
//        UIApplication.shared.windows.first { $0.isKeyWindow }?.set(newRootController: MainModule.instance())
//    }
//
//}
//
//extension LockScreenRouter {
//
//    static func module(pinKit: IPinKit, appStart: Bool) -> UIViewController {
//        let router = LockScreenRouter()
//        let presenter = LockScreenPresenter(router: router, appStart: appStart)
//
//        let insets = UIEdgeInsets(top: 0, left: 0, bottom: .margin12x, right: 0)
//        let unlockController = pinKit.unlockPinModule(delegate: presenter, biometryUnlockMode: .auto, insets: insets, cancellable: false, autoDismiss: !appStart)
//
//        let viewController = LockScreenController(unlockViewController: unlockController)
//        viewController.modalTransitionStyle = .crossDissolve
//
//        return viewController
//    }
//
//}
//
//extension UIWindow {
//
//    public func set(newRootController: UIViewController) {
//        let transition = CATransition()
//        transition.type = CATransitionType.fade
//        transition.duration = 0.3
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
//
//        layer.add(transition, forKey: kCATransition)
//
//        let oldRootController = rootViewController
//
//        rootViewController = newRootController
//
//        oldRootController?.dismiss(animated: false) {
//            oldRootController?.view.removeFromSuperview()
//        }
//    }
//
//}
