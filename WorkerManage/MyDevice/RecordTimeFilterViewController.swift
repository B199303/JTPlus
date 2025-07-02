//
//  RecordTimeFilterViewController.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/26.
//

import UIKit
import RxSwift
import RxCocoa

class RecordTimeFilterViewController: UIViewController {
    var componentCount = 3
    var rowarr = [0,0,0,0,0]
    ///获取当前日期
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day],   from: Date())    //日期类型
    var backDate: ((Date,Date) -> Void)?
    var leftDate = DateTool.getCurrentTime(timeFormat: .YYYYMMDD)
    var rightDate = ""
    var selectType = 0 //0:开始 1:结束
    var onClear:(() -> ())?
    
    let container = UIView()
    let topView = TimeFilterTopView()
    let clearButton = UIButton()
    let cancelButton = UIButton()
    let sureButton = UIButton()
    let line = UIView()
    let pickerViewContainer = UIView()
    
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
        
        container.addSubview(pickerViewContainer)
        
        topView.addRoundedCorner(with: 6, at: [.topLeft, .topRight])
        topView.leftDate.text = leftDate
        topView.leftBg.addTarget(self, action: #selector(touch(button:)), for: .touchUpInside)
        topView.rightBg.addTarget(self, action: #selector(touch(button:)), for: .touchUpInside)
        topView.leftDate.textColor = .mainColor
        container.addSubview(topView)
        
        clearButton.backgroundColor = .whiteColor
        clearButton.setTitle("清除", for: .normal)
        clearButton.setTitleColor(.blackColor, for: .normal)
        clearButton.titleLabel?.font = .textFont_13_regular
        clearButton.cornerRadius = 15
        clearButton.rx.tap.subscribe(onNext: {
            self.onClear?()
            self.dismiss(animated: false, completion: nil)
        }).disposed(by: disposeBag)
        container.addSubview(clearButton)
        
        cancelButton.backgroundColor = .whiteColor
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.blackColor, for: .normal)
        cancelButton.titleLabel?.font = .textFont_13_regular
        cancelButton.cornerRadius = 15
        cancelButton.rx.tap.subscribe(onNext: {
            self.dismiss(animated: false, completion: nil)
        }).disposed(by: disposeBag)
        container.addSubview(cancelButton)
        
        sureButton.backgroundColor = .mainColor
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitleColor(.whiteColor, for: .normal)
        sureButton.titleLabel?.font = .textFont_13_regular
        sureButton.cornerRadius = 15
        sureButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.sureBtnTouch()
        }).disposed(by: disposeBag)
        container.addSubview(sureButton)
        
        line.backgroundColor = .blackColor_10
        container.addSubview(line)
        
        container.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        topView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        clearButton.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-9)
            $0.top.equalTo(topView.snp.bottom).offset(210)
            $0.leading.equalToSuperview().offset(12.5)
            $0.width.equalTo(90)
            $0.height.equalTo(30)
        }
        
        cancelButton.snp.makeConstraints{
            $0.centerY.equalTo(clearButton)
            $0.trailing.equalToSuperview().offset(-117)
            $0.width.equalTo(90)
            $0.height.equalTo(30)
        }
        
        sureButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalTo(clearButton)
            $0.width.equalTo(90)
            $0.height.equalTo(30)
        }
        
        pickerViewContainer.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.width.equalTo(CGFloat.screenWidth)
            $0.top.equalTo(topView.snp.bottom)
            $0.height.equalTo(200)
        }
        
        line.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.bottom.equalTo(clearButton.snp.top).offset(-10)
        }
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: 200))
        picker.backgroundColor = UIColor.clear
        picker.delegate = self
        picker.dataSource = self
        picker.clipsToBounds = true//如果子视图的范围超出了父视图的边界，那么超出的部分就会被裁剪掉。
        //创建日期选择器
        self.pickerViewContainer.addSubview(picker)
        
    }
    
    @objc func touch(button:UIButton){
        if button == topView.leftBg{
            self.selectType = 0
            topView.leftDate.textColor = .mainColor
            topView.rightDate.textColor = .grayColor80
        }else{
            self.selectType = 1
            topView.leftDate.textColor = .grayColor80
            topView.rightDate.textColor = .mainColor
            if self.rightDate == ""{
                self.rightDate = self.leftDate
                self.topView.rightDate.text = self.rightDate
            }
        }
    }
    
    func sureBtnTouch(){
        if self.rightDate == ""{
            self.rightDate = leftDate
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        /// 直接回调显示
        if self.backDate != nil {
            self.backDate!(dateFormatter.date(from: leftDate)!,dateFormatter.date(from: rightDate)!)
            self.selectType = 0
            topView.leftDate.textColor = .mainColor
            topView.rightDate.textColor = .grayColor80
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func dateChange(){
        let dateString = String(format: "%02ld-%02ld-%02ld", self.picker.selectedRow(inComponent: 0) + (self.currentDateCom.year!) - 2, self.picker.selectedRow(inComponent: 1) + 1, self.picker.selectedRow(inComponent: 2) + 1)
        if self.selectType == 0 {
            self.leftDate = dateString
            self.topView.leftDate.text = dateString
        }else{
            self.rightDate = dateString
            self.topView.rightDate.text = dateString
        }
    }

    //逆序情况下重新赋值
    func setDate(left:String, right:String){
        self.topView.leftDate.text = left
        self.topView.rightDate.text = right
        self.leftDate = left
        self.rightDate = right
    }
}

extension RecordTimeFilterViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return componentCount
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 5
        } else if component == 1 {
            return 12
        } else if component == 2 {
            let year: Int = pickerView.selectedRow(inComponent: 0) + currentDateCom.year!
            let month: Int = pickerView.selectedRow(inComponent: 1) + 1
            let days: Int = howManyDays(inThisYear: year, withMonth: month)
            return days
        } else if component == 3 {
            return 24
        } else {
            return 60
        }
    }
    private func howManyDays(inThisYear year: Int, withMonth month: Int) -> Int {
        if (month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12) {
            return 31
        }
        if (month == 4) || (month == 6) || (month == 9) || (month == 11) {
            return 30
        }
        if (year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3) {
            return 28
        }
        if year % 400 == 0 {
            return 29
        }
        if year % 100 == 0 {
            return 28
        }
        return 29
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return CGFloat.screenWidth / CGFloat(componentCount)
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if component == 0 {
            return "\((currentDateCom.year!) + row - 2)"
        } else if component == 1 {
            return "\(row + 1)"
        } else if component == 2 {
            return "\(row + 1)"
        } else {
            return "\(row)"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            pickerView.reloadComponent(2)
        }
        rowarr[component] = row
        picker.reloadAllComponents()
        self.dateChange()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var str = ""
        if component == 0 {
            str =  "\((currentDateCom.year!) + row - 2)"
        } else if component == 1 {
            str =  "\(row + 1)"
        } else if component == 2 {
            str =  "\(row + 1)"
        } else {
            str =  "\(row)"
        }
        if row == 2 {
            return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor.blackColor])
        }else if row == 1 || row == 3{
            return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor.blackColor])
        }else{
            return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor:UIColor.blackColor_80])
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        
        if row == rowarr[component] {
            label.textColor = UIColor.blackColor
        }else if (component - 1) >= 0 && (component + 1) < rowarr.count{
            if row == rowarr[component - 1] || row == rowarr[component + 1]{
                label.textColor = UIColor.blackColor
            }
            else{
                label.textColor = UIColor.blackColor_80
            }
        }else{
            label.textColor = UIColor.blackColor_80
        }
        label.font = UIFont.systemFont(ofSize: 18)
        
        if component == 0 {
            label.text = "\((currentDateCom.year!) + row - 2)年"
        } else if component == 1 {
            label.text = "\(row + 1)月"
        } else if component == 2 {
            label.text = "\(row + 1)日"
        } else {
            label.text = "\(row)"
        }
        
        return label
    }
}
