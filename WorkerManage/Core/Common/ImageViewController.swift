//
//  ImageViewController.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/23.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    let touchView = UIView()
    let bgScroll = UIScrollView()
    let contentIma = UIImageView()
    var onDelete:(() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blackColor_40
        
        view.addSubview(touchView)
        touchView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchBg))
        touchView.addGestureRecognizer(tap)
        
        bgScroll.maximumZoomScale = 3.0
        bgScroll.minimumZoomScale = 1
        bgScroll.showsVerticalScrollIndicator = false
        bgScroll.showsHorizontalScrollIndicator = false
        bgScroll.delegate = self
        bgScroll.bounces = false
//        bgScroll.isUserInteractionEnabled = false
        view.addSubview(bgScroll)
        bgScroll.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalTo(CGFloat.screenWidth)
            $0.height.equalTo(CGFloat.screenWidth)
        }
        
        contentIma.isUserInteractionEnabled = true
        bgScroll.addSubview(contentIma)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(touchIma))
        tap2.numberOfTapsRequired = 2
//        tap2.numberOfTouchesRequired = 2
        contentIma.addGestureRecognizer(tap2)
        
        let pin = UIPinchGestureRecognizer(target: self, action: #selector(changeImaSize(recognizer:)))
        contentIma.addGestureRecognizer(pin)
        contentIma.snp.makeConstraints{
            $0.edges.equalTo(bgScroll)
            $0.width.equalTo(bgScroll)
            $0.height.equalTo(bgScroll)
        }
        
    }
    
    @objc func changeImaSize(recognizer: UIPinchGestureRecognizer){
        var w = recognizer.scale*CGFloat.screenWidth
        var h = recognizer.scale*CGFloat.screenWidth
        if w < CGFloat.screenWidth {w = CGFloat.screenWidth}
        if h < CGFloat.screenWidth {h = CGFloat.screenWidth}
        
        contentIma.snp.remakeConstraints{
            $0.leading.equalToSuperview()
            $0.width.equalTo(w)
            $0.height.equalTo(h)
        }
//        bgScroll.snp.remakeConstraints{
//            $0.center.equalToSuperview()
//            $0.width.equalTo(w)
//            $0.height.equalTo(h)
//        }
        self.bgScroll.contentSize = CGSize(width: w + 20, height: h + 20)
    }
    
    @objc func touchDelete(){
        self.onDelete?()
        self.dismiss(animated: false)
    }
    
    @objc func touchIma(){
        if self.bgScroll.zoomScale < 2{
            self.bgScroll.setZoomScale(2, animated:true)
        }else if self.bgScroll.zoomScale < 3{
            self.bgScroll.setZoomScale(3, animated:true)
        }else{
            self.bgScroll.setZoomScale(1, animated:true)
        }
        
    }
    
    @objc func touchBg(){
        self.contentIma.isHidden = true
        self.dismiss(animated: false)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.contentIma
    }

}

class CommonMethod: NSObject {
    public static func currentViewController() -> (UIViewController?) {
       var window = UIApplication.shared.keyWindow
       if window?.windowLevel != UIWindow.Level.normal{
         let windows = UIApplication.shared.windows
         for  windowTemp in windows{
           if windowTemp.windowLevel == UIWindow.Level.normal{
              window = windowTemp
              break
            }
          }
        }
       let vc = window?.rootViewController
       return currentViewController(vc)
    }
    
    public static func currentViewController(_ vc :UIViewController?) -> UIViewController? {
       if vc == nil {
          return nil
       }
       if let presentVC = vc?.presentedViewController {
          return currentViewController(presentVC)
       }
       else if let tabVC = vc as? UITabBarController {
          if let selectVC = tabVC.selectedViewController {
              return currentViewController(selectVC)
           }
           return nil
        }
        else if let naiVC = vc as? UINavigationController {
           return currentViewController(naiVC.visibleViewController)
        }
        else {
           return vc
        }
     }
}
