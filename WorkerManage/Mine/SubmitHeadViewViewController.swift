//
//  SubmitHeadViewViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/15.
//

import UIKit
import RxSwift

class SubmitHeadViewViewController: CustomNavigationBarController {
    let headView = UIImageView()
    let submitButton = UIButton()
    
    let disposeBag = DisposeBag()
    var image:UIImage?
    let viewModel = SubmitHeadViewModel()
    var data:UserInfoData?

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        
        subscribe(disposeBag, self.viewModel.updataResultDriver){[weak self] result in
            if let result = result{
                guard let `self` = self else {return}
                self.view.makeToast(result.msg, duration: 1.5, position: .center)
                if result.code == 20000{
                    if let data = self.data{
                        data.avatar = self.viewModel.imaStr
                        let dataDic:[String:Any] = data.toJSON()
                        UserDefaults.standard.setValue(dataDic, forKey: "userInfo")
                        NotificationCenter.default.post(name: Notification.Name("reloadUserInfo"),
                                                        object: nil,
                                                        userInfo: nil)
                    }
                }
            }
            
        }
    }
    

    func initUI(){
        self.title = "头像"
        navBar.isHidden = false
        self.navBar.bottomLine.isHidden = false
        self.navBar.bottomLine.backgroundColor = .grayColorEF
        
        headView.backgroundColor = .blue
        headView.cornerRadius = 36*CGFloat.widthSize()
        if let data = data {
            let url = URL(string: "\(data.avatar)")
            headView.kf.setImage(with: url)
        }
        view.addSubview(headView)
        
        submitButton.backgroundColor = .blueColor48
        submitButton.setTitle("上传头像", for: .normal)
        submitButton.setTitleColor(.whiteColor, for: .normal)
        submitButton.titleLabel?.font = .textFont_16_bold
        submitButton.cornerRadius = 4*CGFloat.widthSize()
        submitButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.submitBtnTouch()
        }).disposed(by: disposeBag)
        view.addSubview(submitButton)
        
        headView.snp.makeConstraints{
            $0.top.equalTo(navBar.snp.bottom).offset(42*CGFloat.widthSize())
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(72*CGFloat.widthSize())
        }
        
        submitButton.snp.makeConstraints{
            $0.top.equalTo(headView.snp.bottom).offset(42*CGFloat.widthSize())
            $0.height.equalTo(48*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview().inset(20*CGFloat.widthSize())
        }
    }
    
    func submitBtnTouch(){
        let orderPicker = PlatformOrderFilterViewController()
        let data = ["拍照", "相册"]
        orderPicker.data = data
        orderPicker.view.backgroundColor = .clear
        orderPicker.view.frame = CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: CGFloat.screenHeight)
        self.present(orderPicker, animated: true) {
            orderPicker.picker.selectRow(0, inComponent: 0, animated: false)
        }
        
        orderPicker.backData = {[weak self] data in
            if data == "拍照"{
                self?.takePhoto()
            }else{
                self?.selectIma()
            }
        }
    }

    
    func selectIma(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(pickerVC, animated: true, completion: nil)
        }
    }
    
    func takePhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let pickerVC = UIImagePickerController()
            pickerVC.delegate = self
            pickerVC.sourceType = UIImagePickerController.SourceType.camera
            pickerVC.allowsEditing = true
            self.present(pickerVC, animated: true, completion: nil)
        }
    }
}

extension SubmitHeadViewViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage, let compressedData = image.jpegData(compressionQuality: 0.5) {
            // 使用压缩后的数据创建图片
            if let compressedImage = UIImage(data: compressedData){
                self.image = compressedImage
                self.headView.image = compressedImage
                self.viewModel.submitImage(image: compressedImage)
                picker.dismiss(animated: true)
            }
        }
    }
    
}
