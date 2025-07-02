//
//  AlarmWebViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/26.
//

import UIKit
import WebKit

class AlarmWebViewController: CustomNavigationBarController {
    var webView: WKWebView!
    var url:URL?
    
    init(url:URL? = nil) {
        super.init()
        self.url = url
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        view.addSubview(webView)
        webView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview().inset(10)
            $0.top.equalTo(navBar.snp.bottom).offset(10)
        }
        
        if let url = url{
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func openWith(url:URL) {
        
        let docVC = UIDocumentInteractionController(url: url)
        docVC.delegate = self
        if !docVC.presentPreview(animated: true){
            docVC.presentOptionsMenu(from: CGRect(x: 0, y: 300, width: CGFloat.screenWidth, height: 300), in: self.view, animated: true)
        }

    }
}

extension AlarmWebViewController: UIDocumentInteractionControllerDelegate, UINavigationControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return CGRect(x: 0, y: 100, width: CGFloat.screenWidth, height: CGFloat.screenHeight)
    }
    
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    
}
