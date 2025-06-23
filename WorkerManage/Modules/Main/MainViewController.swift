//
//  MainViewController.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftEntryKit
import SwifterSwift
import SnapKit

class MainViewController: ThemeTabBarController {
    private let disposeBag = DisposeBag()
    private let viewModel: MainViewModel
    
    private let firstPage = ThemeNavigationController(rootViewController: MyDeviceMainViewController())
    private let mine = ThemeNavigationController(rootViewController: MineViewControllor())

    private var showAlerts = [(() -> ())]()

    init(viewModel: MainViewModel, selectedIndex: Int) {
        self.viewModel = viewModel

        super.init()

        self.selectedIndex = selectedIndex
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgGrayColor

        viewModel.onLoad()
        self.updateTab()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func backToLogin(){
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "account")
        UserDefaults.standard.removeObject(forKey: "pass")
        UserDefaults.standard.removeObject(forKey: "userInfo")
        App.shared.storage.deleteAllOrderRecords()
//        appDelegate.sessionManager.totalRemove()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                if keyWindow.rootViewController is MainViewController {
                    debugPrint("keyWindow.set(newRootController: LaunchRouter.module())")
                    keyWindow.set(newRootController: LoginViewController())
                }
            }
        }
    }
    

    private func updateTab() {
        viewControllers = [firstPage, mine]
        
        self.selectedIndex = 1
    }


}
