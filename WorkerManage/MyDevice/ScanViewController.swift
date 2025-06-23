//
//  ScanViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/23.
//

import UIKit
import swiftScan

class ScanViewController: LBXScanViewController {

    /**
    @brief  扫码区域上方提示文字
    */
    var topTitle: UILabel?

    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash: Bool = false

// MARK: - 底部几个功能：开启闪光灯、相册、我的二维码

    //底部显示的功能项
    var bottomItemsView: UIView?

    //相册
    var btnPhoto: UIButton = UIButton()

    //闪光灯
    var btnFlash: UIButton = UIButton()

    //我的二维码
    var btnMyQR: UIButton = UIButton()
    
    var backBtn = ExpandedTouchAreaButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)

        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10
    }
    
    @objc func backTolast(){
        self.navigationController?.popViewController()
    }
    

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        drawBottomItems()
    }
    

    override func handleCodeResult(arrayResult: [LBXScanResult]) {

        for result: LBXScanResult in arrayResult {
            if let str = result.strScanned {
                print(str)
            }
        }

        let result: LBXScanResult = arrayResult[0]
        print(result)
        if let str = result.strScanned{
            NotificationCenter.default.post(name: Notification.Name("scanResult"),
                                            object: nil,
                                            userInfo: ["urlstr": str])
        }
        self.navigationController?.popViewController()
//        let vc = ScanResultController()
//        vc.codeResult = result
//        navigationController?.pushViewController(vc, animated: true)
    }

    func drawBottomItems() {
        if (bottomItemsView != nil) {

            return
        }

        let yMax = self.view.frame.maxY - self.view.frame.minY

        bottomItemsView = UIView(frame: CGRect(x: 0.0, y: yMax-100, width: self.view.frame.size.width, height: 100 ) )

        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)

        self.view .addSubview(bottomItemsView!)

        let size = CGSize(width: 65, height: 87)

        self.btnFlash = UIButton()
        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/2, y: bottomItemsView!.frame.height/2)

        btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)
        btnFlash.addTarget(self, action: #selector(openOrCloseFlash), for: UIControl.Event.touchUpInside)
        

        self.btnPhoto = UIButton()
        btnPhoto.bounds = btnFlash.bounds
        btnPhoto.center = CGPoint(x: bottomItemsView!.frame.width/4, y: bottomItemsView!.frame.height/2)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_nor"), for: UIControl.State.normal)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_down"), for: UIControl.State.highlighted)
//        btnPhoto.addTarget(self, action: Selector(("openPhotoAlbum")), for: UIControlEvents.touchUpInside)

        btnPhoto.addTarget(self, action: #selector(openPhotoAlbum), for: UIControl.Event.touchUpInside)
        
        self.btnMyQR = UIButton()
        btnMyQR.bounds = btnFlash.bounds;
        btnMyQR.center = CGPoint(x: bottomItemsView!.frame.width * 3/4, y: bottomItemsView!.frame.height/2);
        btnMyQR.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"), for: UIControl.State.normal)
        btnMyQR.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_myqrcode_down"), for: UIControl.State.highlighted)
        btnMyQR.addTarget(self, action: #selector(myCode), for: UIControl.Event.touchUpInside)
        

        bottomItemsView?.addSubview(btnFlash)
        bottomItemsView?.addSubview(btnPhoto)
        bottomItemsView?.addSubview(btnMyQR)

        view.addSubview(bottomItemsView!)
        
        backBtn.addTarget(self, action: #selector(backTolast), for: .touchUpInside)
        backBtn.setImage(CommonIconFont.iconfontToImage(iconText: IconFontName.close.rawValue, fontSize: 20, fontColor: .grayColor99).image, for: .normal)
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(36*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(72*CGFloat.widthSize())
            $0.height.width.equalTo(20*CGFloat.widthSize())
        }
    }
    
    //开关闪光灯
    @objc func openOrCloseFlash() {
        scanObj?.changeTorch()

        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down"), for:UIControl.State.normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControl.State.normal)

        }
    }

    @objc func myCode() {
//        let vc = MyCodeViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }

}
