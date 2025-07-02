//
//  MyDeviceManageViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/12.
//

import UIKit
import RxSwift

class MyDeviceManageViewController: CustomNavigationBarController {
    let nameView = MyDeviceManageContentView()
    let localView = MyDeviceManageContentView()
    
    let saveBtn = UIButton()
    
    var detailData:DeviceDetailData?
    let viewModel = MyDeviceManageViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        
        subscribe(disposeBag, self.viewModel.changeResultDriver){ [weak self] result in
            if let result = result{
                self?.view.makeToast(result.msg, duration: 1.5, position: .center)
                if result.code == 20000{
                    NotificationCenter.default.post(name: Notification.Name("reloadDeviceDetail"),
                                                    object: nil,
                                                    userInfo: nil)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
                        guard let `self` = self else {return}
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
        subscribe(disposeBag, self.viewModel.unbindResultDriver){ [weak self] result in
            if let result = result{
                self?.view.makeToast(result.msg, duration: 1.5, position: .center)
                if result.code == 20000{
                    NotificationCenter.default.post(name: Notification.Name("reloadDeviceList"),
                                                    object: nil,
                                                    userInfo: nil)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
                        guard let `self` = self else {return}
                        self.navigationController?.popToRootViewController(animated: false)
                    }
                }
            }
        }
    }
    
    @objc func unBind(){
        let alert = UnbindDeviceAlertView()
        alert.onTouch = {[weak self] in
            guard let `self` = self else {return}
            if let deviceId = detailData?.deviceId{
                self.viewModel.unbindDevice(deviceId: deviceId)
            }
        }
        alert.show()
    }
    
    @objc func touch(button:UIButton){
        if button.tag == 1{
            self.navigationController?.popViewController()
        }else{
            if self.nameView.inputTextField.text == "" || self.nameView.inputTextField.text == nil{
                self.view.makeToast("请输入设备名称", duration: 1.5, position: .center)
                return
            }
            if self.localView.inputTextField.text == "" || self.localView.inputTextField.text == nil{
                self.view.makeToast("请输入设备位置", duration: 1.5, position: .center)
                return
            }
            if let data = self.detailData{
                self.viewModel.changeMessage(deviceId: data.deviceId, deviceName: self.nameView.inputTextField.text ?? "", deviceLocation: self.localView.inputTextField.text ?? "")
            }
        }
    }
    
    func initUI(){
        self.title = "设备管理"
        navBar.isHidden = false
        self.navBar.bottomLine.isHidden = false
        self.navBar.bottomLine.backgroundColor = .grayColorEF
        
        let unBindButton = ExpandedTouchAreaButton()
        unBindButton.setImage(CommonIconFont.iconfontToImage(iconText: IconFontName.unlink.rawValue, fontSize: 20, fontColor: .blackColor33).image, for: .normal)
        unBindButton.addTarget(self, action: #selector(unBind), for: .touchUpInside)
        view.addSubview(unBindButton)
        unBindButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-12*CGFloat.widthSize())
            $0.centerY.equalTo(self.navBar.titleView)
            $0.width.height.equalTo(20*CGFloat.widthSize())
        }
        
        nameView.inputTextField.placeholder = "请输入设备名称"
        nameView.inputTextField.text = self.detailData?.deviceName
        nameView.title.text = "设备名称"
        nameView.limitNum = 15
        view.addSubview(nameView)
        
        localView.inputTextField.placeholder = "请输入设备位置"
        localView.title.text = "设备位置"
        localView.inputTextField.text = self.detailData?.deviceLocation
        localView.limitNum = 25
        view.addSubview(localView)
        
        nameView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navBar.snp.bottom).offset(20*CGFloat.widthSize())
        }
        
        localView.snp.makeConstraints{
            $0.top.equalTo(nameView.snp.bottom).offset(20*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview()
        }
        
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.titleLabel?.font = .textFont_16_bold
        saveBtn.cornerRadius = 8*CGFloat.widthSize()
        saveBtn.setTitleColor(.whiteColor, for: .normal)
        saveBtn.backgroundColor = .blueColor48
        saveBtn.tag = 2
        saveBtn.addTarget(self, action: #selector(touch(button:)), for: .touchUpInside)
        view.addSubview(saveBtn)
        
        saveBtn.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-20*CGFloat.widthSize())
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.height.equalTo(48*CGFloat.widthSize())
            $0.bottom.equalToSuperview().offset(-100*CGFloat.widthSize())
        }
    }
}
