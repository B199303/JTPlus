//
//  ThemeNavigationController.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import UIKit

open class ThemeNavigationController: UINavigationController {

    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    private func commonInit() {
        navigationBar.prefersLargeTitles = false
        navigationBar.tintColor = .blue
    }

    override open var childForStatusBarStyle: UIViewController? {
        topViewController
    }

    override open var childForStatusBarHidden: UIViewController? {
        topViewController
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .lightContent
    }

    override open var prefersStatusBarHidden: Bool {
        topViewController?.prefersStatusBarHidden ?? false
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if navigationItem.searchController != nil {
            DispatchQueue.main.async {
                self.navigationBar.sizeToFit()
            }
        }
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    open override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if viewControllers.count > 1, let vc = viewControllers.last {
          vc.hidesBottomBarWhenPushed = true
        }
        super.setViewControllers(viewControllers, animated: animated)
      }
}

open class ThemeTabBarController: UITabBarController {

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        tabBar.shadowImage = UIImage()
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: 10000, height: 1 / UIScreen.main.scale))
        separator.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        tabBar.addSubview(separator)

        tabBar.barTintColor = .white
        
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .whiteColor


        tabBar.tintColor = .blackColor48
        tabBar.unselectedItemTintColor = .grayColor99
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.shadowImage = UIImage(color: .white)
            appearance.backgroundImage = UIImage(color: .white)
            appearance.shadowColor = .white
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .white

            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.grayColor99]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blackColor48]

            appearance.inlineLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0x778E99)!]
            appearance.inlineLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0xEE9922)!]

            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0x778E99)!]
            appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0xEE9922)!]

            tabBar.standardAppearance = appearance
//            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }

        updateUITheme()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBar.superview?.setNeedsLayout()
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateUITheme()
    }

    private func updateUITheme() {
        tabBar.backgroundImage = UIImage(color: UIColor.white)
        tabBar.shadowImage = UIImage(color: .white)
    }

}

open class
ThemeViewController: UIViewController {

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

}

open class CustomTableViewController: UITableViewController {

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

}
