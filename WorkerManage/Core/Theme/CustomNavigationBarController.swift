//
//  CustomNavigationBarController.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import UIKit
import SnapKit
import Toast_Swift
import RxSwift

class CustomNavigationBarController: ThemeViewController {
    var navBar = NavigationBar()
    var isPopGestureEnable = true

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        view.addSubview(navBar)
        view.backgroundColor = .white
        
        
        navBar.snp.makeConstraints {
            $0.left.right.equalTo(view)
            $0.top.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
        navBar.backbuttonAction = { [weak self] _ in
            guard let `self` = self else { return }
            if self.isModal {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override var title: String? {
        didSet {
            navBar.titleLabel.text = title
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    deinit {
        print("\(self) \(#function)")
    }
    
    func applyGradientBackgroundColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: 0xD9D6FF).cgColor, UIColor(hex: 0xEBF4FF).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setStatusBarAppearanceUpdate(color: UIColor){
        if #available(iOS 13.0, *){
            let tag = 987654321
            let keyWindow = UIApplication.shared.connectedScenes.map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.first
            if let statusBar = keyWindow?.viewWithTag(tag) {
                statusBar.backgroundColor = color
            } else {
                let statusBar = UIView(frame: keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
                if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
                    statusBar.backgroundColor = color
                }
                statusBar.tag = tag
                keyWindow?.addSubview(statusBar)
            }
        }else{
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to: #selector(setter: UIView.backgroundColor)){
                statusBar.backgroundColor = color
            }
        }
    }
    
    
    
}

class NavigationBar: UIView {
    public var style = NavigationBarStyle()
    
//    public var rightStackView = UIStackView()
//    public var rightButton = NavBarButton()
    public var contentView = UIView()
    public var titleView = UIView()
    public var titleLabel = UILabel()
    public var backIma = UIImageView()
    public var backTitle = UILabel()
    public var backButton = UIButton()
    public var bottomLine = UIView()
    public var rightBtn = UIButton(type: .system)
    public var rightIma = UIImageView()
    public var rightTitle = UILabel()
    
    var backbuttonAction: ((UIButton) -> Void)?
    
    init(){
        super.init(frame: .zero)
        backgroundColor = .whiteColor
        contentView.backgroundColor = .clear
        self.addSubview(contentView)
        
        backIma.image = CommonIconFont.iconfontToImage(iconText: IconFontName.left.rawValue, fontSize: 20, fontColor: .blackColor33).image
        self.contentView.addSubview(backIma)
        
        backTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        backTitle.textColor = .black
        backTitle.textAlignment = .left
        self.contentView.addSubview(backTitle)
        
        backButton.addTarget(self, action: #selector(backAction(button:)), for: .touchUpInside)
        self.contentView.addSubview(backButton)
        
        self.contentView.addSubview(titleView)
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .blackColor
        titleLabel.textAlignment = .center
        titleView.addSubview(titleLabel)
        
        bottomLine.backgroundColor = .gray
        bottomLine.isHidden = true
        self.contentView.addSubview(bottomLine)
        
        
        self.rightBtn.isHidden = true
        self.contentView.addSubview(rightBtn)
        
        rightBtn.addSubview(rightIma)
        
        contentView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.height.equalTo(44)
        }
        
        backIma.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(16)
            maker.centerY.equalTo(contentView)
            maker.width.equalTo(18)
            maker.height.equalTo(18)
        }
        
        backTitle.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(40)
            maker.centerY.equalTo(backButton)
        }
        
        backButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(5)
            maker.bottom.top.equalToSuperview().offset(0)
            maker.width.equalTo(64)
        }
        
        titleView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.equalTo(UIScreen.main.bounds.size.width - 140)
            maker.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        bottomLine.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.height.equalTo(0.5)
        }
        
        rightBtn.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().offset(-5)
            maker.bottom.top.equalToSuperview().offset(0)
            maker.width.equalTo(64)
        }
        
    }
    
    public func setBackButtonHidden(isHide:Bool){
        self.backIma.isHidden = isHide
        self.backTitle.isHidden = isHide
        self.backButton.isHidden = isHide
    }
    
    @objc func backAction(button:UIButton) {
        backbuttonAction?(button)
    }
    
    public func addRightBtn(title:String? = nil, image:UIImage? = nil, action:Selector, target:Any?){
        self.rightBtn.addTarget(target, action: action, for: .touchUpInside)
        if let title = title, let image = image{
            rightTitle.textColor = .whiteColor
            rightTitle.font = .systemFont(ofSize: 12, weight: .regular)
            rightTitle.textAlignment = .right
            rightTitle.text = title
            self.rightBtn.addSubview(rightTitle)
            
            let rightIma = UIImageView()
            rightIma.image = image
            self.rightBtn.addSubview(rightIma)
            
            self.rightBtn.isUserInteractionEnabled = true
            
            rightTitle.snp.makeConstraints{
                $0.trailing.equalToSuperview().offset(-25)
                $0.centerY.equalTo(self.backIma)
            }
            
            rightIma.snp.makeConstraints{
                $0.trailing.equalToSuperview().offset(-5.5)
                $0.width.equalTo(12)
                $0.height.equalTo(10)
                $0.centerY.equalTo(self.backIma)
            }
            
            rightBtn.snp.remakeConstraints{
                $0.trailing.equalToSuperview().offset(-5)
                $0.bottom.top.equalToSuperview().offset(0)
                $0.width.equalTo(100)
            }
        }else if let image = image{
            self.rightBtn.isHidden = false
            let rightIma = UIImageView()
            rightIma.image = image
            self.rightBtn.addSubview(rightIma)
            rightIma.snp.makeConstraints{
                $0.trailing.equalToSuperview().offset(-5)
                $0.centerY.equalTo(self.backIma)
                $0.width.height.equalTo(18)
            }
        }else if let title = title{
            rightTitle.textColor = .whiteColor
            rightTitle.font = .systemFont(ofSize: 12, weight: .regular)
            rightTitle.textAlignment = .right
            rightTitle.text = title
            self.rightBtn.addSubview(rightTitle)
            self.rightBtn.isHidden = false
            rightTitle.snp.makeConstraints { maker in
                maker.trailing.equalToSuperview().offset(-7)
                maker.centerY.equalTo(backIma)
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NavBarButton: UIButton {
    var intrinsicWidth: CGFloat = 35
    override var intrinsicContentSize: CGSize {
        return CGSize(width: intrinsicWidth, height: 40)
    }
}

struct NavigationBarStyle {
    var titleColor: UIColor
    var titleFont: UIFont
    var backgroundColor: UIColor
    
    init(titleColor: UIColor = .black,
         titleFont: UIFont = .systemFont(ofSize: 16, weight: .semibold),
         backgroundColor: UIColor = .white) {
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.backgroundColor = backgroundColor
    }
}

extension UIViewController {
    @objc var isModal: Bool {
        return presentingViewController != nil ||
            navigationController?.presentingViewController?.presentedViewController === navigationController ||
            tabBarController?.presentingViewController is UITabBarController
    }
    
    @objc static func topViewController(_ viewController: UIViewController? = nil) -> UIViewController? {
        let viewController = viewController ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = viewController as? UINavigationController,
            !navigationController.viewControllers.isEmpty
        {
            return self.topViewController(navigationController.viewControllers.last)
            
        } else if let tabBarController = viewController as? UITabBarController,
            let selectedController = tabBarController.selectedViewController
        {
            return self.topViewController(selectedController)
            
        } else if let presentedController = viewController?.presentedViewController {
            return self.topViewController(presentedController)
            
        }
        
        return viewController
    }
    
    @objc static func getTopViewControllerInAlert(_ viewController: UIViewController? = nil) -> UIViewController? {
        let windows = UIApplication.shared.windows
//        if let keyWindow = windows.first(where: { $0.isKeyWindow }) {
        let keyWindow = windows[0]
            let viewController = viewController ?? keyWindow.rootViewController
            
            if let navigationController = viewController as? UINavigationController,
                !navigationController.viewControllers.isEmpty
            {
                return self.topViewController(navigationController.viewControllers.last)
                
            } else if let tabBarController = viewController as? UITabBarController,
                let selectedController = tabBarController.selectedViewController
            {
                return self.topViewController(selectedController)
                
            } else if let presentedController = viewController?.presentedViewController {
                return self.topViewController(presentedController)
             }
        
        return viewController
    }
}

extension CustomNavigationBarController: UIGestureRecognizerDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func popGestureClose(){
        if let ges = self.navigationController?.interactivePopGestureRecognizer?.view?.gestureRecognizers{
            for item in ges{
                item.isEnabled = false
            }
        }
    }
}

