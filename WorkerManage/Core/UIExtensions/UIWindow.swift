//
//  UIWindow.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/4.
//

import UIKit

extension UIWindow {

    public func set(newRootController: UIViewController) {
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        layer.add(transition, forKey: kCATransition)

        let oldRootController = rootViewController

        rootViewController = newRootController

        oldRootController?.dismiss(animated: false) {
            oldRootController?.view.removeFromSuperview()
        }
    }

}
