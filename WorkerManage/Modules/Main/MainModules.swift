//
//  MainModules.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import Foundation
import UIKit

struct MainModule {
    enum Tab: Int {
        case first, mine
    }
    
    static func instance(selectedTab: Tab = .first) -> UIViewController {
        let service = MainService(
        )
        let badgeService = MainBadgeService(
        )
        let releaseNotesService = ReleaseNotesService(
           
        )
        let jailbreakService = JailbreakService(
        )

        let viewModel = MainViewModel(service: service, badgeService: badgeService, releaseNotesService: releaseNotesService, jailbreakService: jailbreakService)
        let viewController = MainViewController(viewModel: viewModel, selectedIndex: selectedTab.rawValue)

        return viewController
    }
}
