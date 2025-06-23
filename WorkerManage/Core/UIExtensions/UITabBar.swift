//
//  UITabBar.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/29.
//

import UIKit

extension UITabBar {
    func setBadge(value: String?, at index: Int, withConfiguration configuration: TabBarBadgeConfiguration = TabBarBadgeConfiguration()) {
        let existingBadge = subviews.first { ($0 as? TabBarBadge)?.hasIdentifier(for: index) == true }
        existingBadge?.removeFromSuperview()

        guard let tabBarItems = items,
            let value = value else { return }

        let itemPosition = CGFloat(index + 1)
        let itemWidth = frame.width / CGFloat(tabBarItems.count)
        let itemHeight = frame.height

        let badge = TabBarBadge(for: index)
        badge.frame.size = configuration.size
//        badge.center = CGPoint(x: (itemWidth * itemPosition) - (0.5 * itemWidth) + configuration.centerOffset.x,
//                               y: (0.5 * itemHeight) + configuration.centerOffset.y)
        badge.center = CGPoint(x: (itemWidth * itemPosition) - (0.5 * itemWidth) + configuration.centerOffset.x,
                               y: 9.5)
        badge.layer.cornerRadius = 0.5 * configuration.size.height
        badge.clipsToBounds = true
        badge.textAlignment = .center
        badge.backgroundColor = configuration.backgroundColor
        badge.font = configuration.font
        badge.textColor = configuration.textColor
        badge.text = value

        addSubview(badge)
    }
}

class TabBarBadge: UILabel {
    var identifier: String = String(describing: TabBarBadge.self)

    private func identifier(for index: Int) -> String {
        return "\(String(describing: TabBarBadge.self))-\(index)"
    }

    convenience init(for index: Int) {
        self.init()
        identifier = identifier(for: index)
    }

    func hasIdentifier(for index: Int) -> Bool {
        let has = identifier == identifier(for: index)
        return has
    }
}

class TabBarBadgeConfiguration {
    var backgroundColor: UIColor = .redColor29
    var centerOffset: CGPoint = .init(x: 10, y: -15)
    var size: CGSize = .init(width: 14, height: 14)
    var textColor: UIColor = .white
    var font: UIFont! = .textFont_10_bold {
        didSet { font = font ?? .textFont_10_bold }
    }

    static func construct(_ block: (TabBarBadgeConfiguration) -> Void) -> TabBarBadgeConfiguration {
        let new = TabBarBadgeConfiguration()
        block(new)
        return new
    }
}
