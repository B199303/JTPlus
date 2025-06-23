//
//  BaseFilterViewController.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/16.
//

import UIKit
import RxSwift
import RxCocoa
import DeviceKit

class BaseFilterViewController: UIViewController {
    let container = UIView()
    let topView = UIView()
    let cancelButton = UIButton()
    let sureButton = UIButton()
    let pickerViewContainer = UIView()
    
    var pickerWidth = CGFloat.screenWidth
    
    var backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    var picker: UIPickerView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        
        self.view.backgroundColor = .blackColor_25
        self.view.insertSubview(self.backgroundView, at: 0)
        self.modalPresentationStyle = .custom//viewcontroller弹出后之前控制器页面不隐藏 .custom代表自定义
        
        container.backgroundColor = .bgGrayColor
        container.addRoundedCorner(with: 6, at: [.topLeft, .topRight])
        view.addSubview(container)
        
        topView.addRoundedCorner(with: 6, at: [.topLeft, .topRight])
        topView.borderWidth = 0.5
        topView.borderColor = .blackColor_10
        container.addSubview(topView)
        
        cancelButton.backgroundColor = .whiteColor
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.blackColor, for: .normal)
        cancelButton.titleLabel?.font = .textFont_13_regular
        cancelButton.cornerRadius = 15*CGFloat.widthSize()
        cancelButton.rx.tap.subscribe(onNext: {
            self.dismiss(animated: false, completion: nil)
        }).disposed(by: disposeBag)
        container.addSubview(cancelButton)
        
        sureButton.backgroundColor = .blueColor48
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitleColor(.whiteColor, for: .normal)
        sureButton.titleLabel?.font = .textFont_13_regular
        sureButton.cornerRadius = 15*CGFloat.widthSize()
        sureButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.sureBtnTouch()
        }).disposed(by: disposeBag)
        container.addSubview(sureButton)
        
        container.addSubview(pickerViewContainer)
        
        container.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(300*CGFloat.widthSize())
        }
        
        topView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(50*CGFloat.widthSize())
        }
        
        cancelButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(22.5*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(10*CGFloat.widthSize())
            $0.width.equalTo(90*CGFloat.widthSize())
            $0.height.equalTo(30*CGFloat.widthSize())
        }
        
        sureButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-12*CGFloat.widthSize())
            $0.top.equalTo(cancelButton)
            $0.width.equalTo(90*CGFloat.widthSize())
            $0.height.equalTo(30*CGFloat.widthSize())
        }
        
        pickerViewContainer.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom).offset(0.5*CGFloat.widthSize())
        }
        
        picker = UIPickerView()
        picker.backgroundColor = UIColor.clear
        picker.clipsToBounds = true//如果子视图的范围超出了父视图的边界，那么超出的部分就会被裁剪掉。
        //创建日期选择器
        self.pickerViewContainer.addSubview(picker)
        picker.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(250*CGFloat.widthSize())
        }
        
    }
    
    func reloadUI(){
        sureButton.titleLabel?.font = .textFont_13_regular
        cancelButton.titleLabel?.font = .textFont_13_regular
        if self.view.subviews.contains(container){
            container.snp.remakeConstraints{
                $0.leading.equalToSuperview()
                $0.trailing.bottom.equalToSuperview()
                $0.height.equalTo(300*CGFloat.widthSize())
            }
            
            topView.snp.remakeConstraints{
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(50*CGFloat.widthSize())
            }
            
            cancelButton.snp.remakeConstraints{
                $0.leading.equalToSuperview().offset(22.5*CGFloat.widthSize())
                $0.top.equalToSuperview().offset(10*CGFloat.widthSize())
                $0.width.equalTo(90*CGFloat.widthSize())
                $0.height.equalTo(30*CGFloat.widthSize())
            }
            
            sureButton.snp.remakeConstraints{
                $0.trailing.equalToSuperview().offset(-12*CGFloat.widthSize())
                $0.top.equalTo(cancelButton)
                $0.width.equalTo(90*CGFloat.widthSize())
                $0.height.equalTo(30*CGFloat.widthSize())
            }
            
            pickerViewContainer.snp.remakeConstraints{
                $0.leading.trailing.bottom.equalToSuperview()
                $0.top.equalTo(topView.snp.bottom).offset(0.5*CGFloat.widthSize())
            }
            
            picker.snp.remakeConstraints{
                $0.leading.trailing.top.equalToSuperview()
                $0.height.equalTo(250*CGFloat.widthSize())
            }
        }
        
        
        
    }
    
    func sureBtnTouch(){
        
    }

}
