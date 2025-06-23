//
//  PlatformOrderFilterViewController.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/16.
//  筛选

import UIKit

class PlatformOrderFilterViewController: BaseFilterViewController {
    var data:[String] = []
    var showData:[String] = []
    var backData: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showData = data
        picker.delegate = self
        picker.dataSource = self
    }
    
    override func sureBtnTouch() {
        if data.count > 0{
            let dataStr = showData[self.picker.selectedRow(inComponent: 0)]
            self.dismiss(animated: true, completion: nil)
            self.backData?(dataStr)
        }
        
    }
    
    func setContent(backgroundColor:UIColor){
        self.pickerViewContainer.backgroundColor = backgroundColor
        self.topView.backgroundColor = backgroundColor
    }
}

extension PlatformOrderFilterViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return showData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        let str = showData[row]
        label.text = str
        label.font = .textFont_15_medium
        return label
    }
}
